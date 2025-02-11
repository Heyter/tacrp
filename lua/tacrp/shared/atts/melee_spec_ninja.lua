ATT.PrintName = "Ninja"
ATT.Icon = Material("entities/tacrp_att_melee_spec_ninja.png", "mips smooth")
ATT.Description = "Disrupt your enemies and strike with the element of surprise."
ATT.Pros = {"RELOAD: Palm Strike / Climb", "RELOAD (Mid-air + Crouch): Dive Kick","RELOAD (Ground + Crouch): Smokescreen", "Silent Footsteps"}

ATT.Category = {"melee_spec"}

ATT.SortOrder = 2

ATT.SilentFootstep = true

local smokedelay = 18

local function makehitsound(ent)
    if TacRP.ShouldWeFunny() then
        ent:EmitSound("tacrp/slap.mp3", 75, 100)
    else
        ent:EmitSound("tacrp/weapons/melee_body_hit-" .. math.random(1, 5) .. ".wav", 75, 100, 1, CHAN_ITEM)
    end
end

local function makesmokesound(ent, pitch)
    if TacRP.ShouldWeFunny() then
        ent:EmitSound("tacrp/fart-with-reverb.mp3", 75, pitch)
    else
        ent:EmitSound("TacRP/weapons/grenade/smoke_explode-1.wav", 75, pitch)
    end
end

ATT.Hook_PreReload = function(wep)
    local ply = wep:GetOwner()
    if !ply:KeyPressed(IN_RELOAD) then return end

    if ply:IsOnGround() and ply:Crouching() then
        if ply:GetNWFloat("TacRPNinjaSmoke", 0) > CurTime() or ply:GetNWFloat("TacRPDiveTime", 0) + 1 > CurTime() then return true end
        if SERVER then
            makesmokesound(ply, 110)
            local cloud = ents.Create( "tacrp_smoke_cloud_ninja" )
            if !IsValid(cloud) then return end
            cloud:SetPos(ply:GetPos())
            cloud:SetOwner(ply)
            cloud:Spawn()
        end
        ply:SetNWFloat("TacRPNinjaSmoke", CurTime() + smokedelay)
        local ang = ply:GetAngles()
        if ang.p >= -15 then
            ang.p = math.Clamp(ang.p, 45, 180 - 45)
            ply:SetVelocity(ang:Forward() * -500)
        end
    elseif !ply:IsOnGround() and ply:Crouching() then
        if ply:GetMoveType() != MOVETYPE_NOCLIP and !ply:GetNWBool("TacRPNinjaDive") and ply:GetNWFloat("TacRPDiveTime", 0) + 1 < CurTime() and ply:EyeAngles():Forward():Dot(Vector(0, 0, 1)) < -0.25 then
            ply:SetNWBool("TacRPNinjaDive", true)
            ply:SetNWFloat("TacRPDiveTime", CurTime())
            ply:SetNWVector("TacRPDiveDir", ply:EyeAngles():Forward())
            wep:EmitSound("weapons/mortar/mortar_fire1.wav", 65, 120, 0.5)
        end
    elseif !wep:StillWaiting() then
        if (wep.NextPalmPunch or 0) > CurTime() then return end
        wep.NextPalmPunch = CurTime() + 1
        wep:SetNextSecondaryFire(CurTime() + 0.25)
        wep:PlayAnimation("halt", 0.4, false, true)
        -- wep:EmitSound("ambient/energy/weld2.wav", 75, 110, 0.5)
        wep:GetOwner():DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)
        wep:EmitSound("npc/fast_zombie/claw_miss1.wav", 75, 90, 1)

        local dmg = 20
        local range = 64
        local filter = {wep:GetOwner()}

        local start = wep:GetOwner():GetShootPos()
        local dir = wep:GetOwner():GetAimVector()
        local tr = util.TraceLine({
            start = start,
            endpos = start + dir * range,
            filter = filter,
            mask = MASK_SHOT_HULL,
        })

        -- weapon_hl2mpbasebasebludgeon.cpp: do a hull trace if not hit
        if tr.Fraction == 1 or !IsValid(tr.Entity) then
            local dim = 32
            local pos2 = tr.HitPos - dir * (dim * 1.732)
            local tr2 = util.TraceHull({
                start = start,
                endpos = pos2,
                filter = filter,
                mask = MASK_SHOT_HULL,
                mins = Vector(-dim, -dim, -dim),
                maxs = Vector(dim, dim, dim)
            })
            if tr2.Fraction < 1 and IsValid(tr2.Entity) then
                local dot = (tr2.Entity:GetPos() - start):GetNormalized():Dot(dir)
                if dot >= 0 then
                    tr = tr2
                end
            end
        end

        local dmginfo = DamageInfo()
        dmginfo:SetDamage(dmg)
        dmginfo:SetDamageForce(dir * dmg * 1000)
        dmginfo:SetDamagePosition(tr.HitPos)
        dmginfo:SetDamageType(DMG_CLUB + DMG_SONIC)
        dmginfo:SetAttacker(wep:GetOwner())
        dmginfo:SetInflictor(wep)

        if tr.Fraction < 1 then

            TacRP.CancelBodyDamage(tr.Entity, dmginfo, tr.HitGroup)

            if tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:IsNextBot() then
                makehitsound(wep)
                tr.Entity.PalmPunched = true
            else
                local vel = ply:GetVelocity():Length()
                wep:EmitSound("tacrp/weapons/melee_hit-" .. math.random(1, 2) .. ".wav", 75, 100, 1, CHAN_ITEM)
                if ply:IsOnGround() and math.abs(tr.HitNormal:Dot(Vector(0, 0, 1))) <= 0.25 and (tr.Normal:Dot(ply:GetAimVector())) >= 0.5 and vel <= 250 then
                    ply:SetVelocity(Vector(0, 0, Lerp(vel / 250, 500, 250)))
                end
            end

            if IsValid(tr.Entity) and !tr.HitWorld then
                --tr.Entity:TakeDamageInfo(dmginfo)
                tr.Entity:DispatchTraceAttack(dmginfo, tr)
            end
        end

        -- local dir = ply:EyeAngles():Forward()
        -- for _, ent in pairs(ents.FindInSphere(ply:EyePos() + dir * 64, 256)) do
        --     if ent == ply or !IsValid(ent:GetPhysicsObject()) then continue end
        --     ent:GetPhysicsObject():SetVelocityInstantaneous(3000 * dir)
        -- end
    end

    return true
end

local smokeicon = Material("TacRP/grenades/smoke.png", "mips smooth")
function ATT.TacticalDraw(self)
    local scrw = ScrW()
    local scrh = ScrH()

    local w = ScreenScale(16)
    local h = ScreenScale(16)

    local x = (scrw - w) / 2
    local y = (scrh - h) - ScreenScale(8)

    surface.SetDrawColor(0, 0, 0, 200)
    TacRP.DrawCorneredBox(x, y, w, h)

    local c = math.Clamp((self:GetOwner():GetNWFloat("TacRPNinjaSmoke", 0) - CurTime()) / smokedelay, 0, 1)
    surface.SetDrawColor(150, 150, 150, 75)
    surface.DrawRect(x, y + h * (1 - c), w, h * c)

    local clr = c > 0 and 200 or 255
    surface.SetDrawColor(clr, clr, clr, 255)
    surface.SetMaterial(smokeicon)
    surface.DrawTexturedRect(x, y, w, h)
end


hook.Add("FinishMove", "TacRP_Ninja", function(ply, mv)
    if ply:GetNWBool("TacRPNinjaDive") then
        if ply:IsOnGround() and !ply.TacRPNinjaGroundTime then
            ply.TacRPNinjaGroundTime = CurTime()
        end
        if (ply:IsOnGround() and ply.TacRPNinjaGroundTime + engine.TickInterval() < CurTime()) or !ply:Alive() or ply:GetMoveType() == MOVETYPE_NOCLIP then
            ply:SetNWBool("TacRPNinjaDive", false)
            mv:SetVelocity(mv:GetAngles():Forward() * mv:GetVelocity():Length() * 2)
            ply.TacRPNinjaGroundTime = nil
        elseif ply:GetNWFloat("TacRPDiveTime", 0) + 0.1 > CurTime() then
            mv:SetVelocity(ply:GetNWVector("TacRPDiveDir") * 50000 * FrameTime())

            -- do it here to get around reload not called clientside in SP
            if (ply.TacRPDiveEffect or 0) != ply:GetNWFloat("TacRPDiveTime", -1) then
                ply.TacRPDiveEffect = CurTime()
                local eff = EffectData()
                eff:SetOrigin(ply:GetPos())
                eff:SetNormal(ply:GetNWVector("TacRPDiveDir", ply:EyeAngles():Forward()))
                eff:SetEntity(ply)
                util.Effect("tacrp_divesmoke", eff)
            end
        end
    end
end)

hook.Add("GetFallDamage", "TacRP_Ninja", function(ply, speed)
    if ply:GetNWBool("TacRPNinjaDive") then
        if ply:GetNWFloat("TacRPDiveTime", 0) + 0.2 <= CurTime() then
            ply:EmitSound("physics/concrete/boulder_impact_hard" .. math.random(1, 4) .. ".wav")
            local eff = EffectData()
            eff:SetOrigin(ply:GetPos())
            eff:SetScale(128)
            eff:SetEntity(ply)
            util.Effect("ThumperDust", eff)

            local dmginfo = DamageInfo()
            dmginfo:SetDamage(math.Clamp((speed - 300) / 30, 20, 70))
            dmginfo:SetDamageForce(Vector(0, 0, 3000))
            dmginfo:SetDamagePosition(ply:GetPos())
            dmginfo:SetDamageType(DMG_CRUSH)
            dmginfo:SetAttacker(ply)
            dmginfo:SetInflictor(ply)

            for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 256)) do
                if ent == ply or !IsValid(ent:GetPhysicsObject()) then continue end
                if ent:IsPlayer() or ent:IsNPC() then
                    ent:SetVelocity(Vector(0, 0, math.Clamp(speed / 4, 250, 1000)))
                else
                    ent:GetPhysicsObject():ApplyTorqueCenter(VectorRand() * speed ^ 0.5)
                    ent:GetPhysicsObject():ApplyForceOffset(Vector(0, 0, speed) * (ent:GetPhysicsObject():GetMass() ^ 0.5), ply:GetPos())
                end
                ent:TakeDamageInfo(dmginfo)
            end

            if IsValid(ply:GetGroundEntity()) and (ply:GetGroundEntity():IsPlayer() or ply:GetGroundEntity():IsNPC() or ply:GetGroundEntity():IsNextBot()) then
                ply:SetVelocity(Vector(0, 0, 300))
                ply:GetGroundEntity().GoombaStomped = true
                dmginfo:SetDamage(999)
                dmginfo:SetDamageType(DMG_CRUSH + DMG_NEVERGIB)
                dmginfo:SetDamageForce(Vector(0, 0, math.min(speed / 10, 500)))
                dmginfo:SetDamagePosition(ply:GetPos())
                ply:GetGroundEntity():TakeDamageInfo(dmginfo)
                ply:EmitSound("tacrp/mario_coin.wav", 80, 100, 0.2)
            end

            ply:SetNWBool("TacRPNinjaDive", false)
            ply.TacRPNinjaGroundTime = nil
        end
        return 0
    end
end)

hook.Add("PlayerFootstep", "TacRP_Ninja", function(ply)
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and wep.ArcticTacRP and wep:GetValue("SilentFootstep") then
        return true
    end
end)

hook.Add("PostEntityTakeDamage", "TacRP_GoombaStomp", function(ent, dmginfo, took)
    if took and ent.GoombaStomped == true and dmginfo:GetDamageType() == DMG_CRUSH + DMG_NEVERGIB then
        if ent:Health() < 0 then
            ent:EmitSound("tacrp/mario_death.wav", 100, 100, 0.5)
        end
        ent.GoombaStomped = false
    end

    if took and ent.PalmPunched and dmginfo:GetDamageType() == DMG_CLUB + DMG_SONIC then
        ent.PalmPunched = false
        if ent:IsPlayer() then
            ent:SetNWFloat("TacRPLastBashed", CurTime())
            net.Start("tacrp_flashbang")
                net.WriteFloat(0.5)
            net.Send(ent)
            ent:SetVelocity(Vector(0, 0, 250))
        else
            local dir = dmginfo:GetAttacker():EyeAngles():Forward()
            dir.z = 0
            dir:Normalize()
            ent:SetVelocity(dir * 500 + Vector(0, 0, 250))
        end
    end
end)