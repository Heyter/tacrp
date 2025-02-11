SWEP.Base = "tacrp_base"
SWEP.Spawnable = true

AddCSLuaFile()
DEFINE_BASECLASS( "tacrp_base" )

// names and stuff
SWEP.PrintName = "Riot Shield"
SWEP.Category = "Tactical RP" // "Tactical RP (Arctic)"

SWEP.SubCatTier = "9Special"
SWEP.SubCatType = "8Melee Weapon"

SWEP.Description = "Metal-framed plastic shield, capable of stopping all incoming bullets, no matter how big. Somehow."

SWEP.ViewModel = "models/weapons/tacint/v_riot_shield-2.mdl"
SWEP.WorldModel = "models/weapons/tacint/w_riot_shield_2.mdl"

SWEP.NoRanger = true
SWEP.NoStatBox = true

SWEP.NPCUsable = false


SWEP.ArcadeStats = {
    MoveSpeedMult = 0.85,
    ShootingSpeedMult = 1,
    SightedSpeedMult = 1,
    MeleeSpeedMult = 0.9,
}

SWEP.Slot = 2
SWEP.SlotAlt = 0

// misc. shooting

SWEP.Ammo = ""
SWEP.ClipSize = -1

// handling

SWEP.MoveSpeedMult = 0.5

SWEP.MeleeSpeedMultTime = 2 // seconds to apply slow down for

SWEP.SprintToFireTime = 0.25

SWEP.Scope = false

SWEP.FreeAim = false

SWEP.QuickNadeTimeMult = 1.5

// hold types

SWEP.HoldType = "melee2"
SWEP.HoldTypeSprint = "melee2"

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_PISTOL
SWEP.GestureBash = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE

SWEP.PassiveAng = Angle(0, 0, 0)
SWEP.PassivePos = Vector(0, 0, 0)

SWEP.SprintAng = Angle(0, -25, -10)
SWEP.SprintPos = Vector(3, 0, -2)

SWEP.SprintMidPoint = {
    Pos = Vector(0.25, 2, 1),
    Ang = Angle(0, -5, 10)
}

SWEP.HolsterVisible = true
SWEP.HolsterSlot = TacRP.HOLSTER_SLOT_BACK
SWEP.HolsterPos = Vector(2, -30, 0)
SWEP.HolsterAng = Angle(-90, 0, -90)

SWEP.AnimationTranslationTable = {
    ["deploy"] = "draw",
    ["melee"] = "melee"
}

SWEP.NoHolsterAnimation = true

SWEP.ShieldProps = {
    {
        Model = "models/weapons/tacint/w_riot_shield_2.mdl",
        Pos = Vector(5, -5, 30),
        Ang = Angle(0, 0, 180 - 15),
        Resistance = 1000
    }
}

// attachments

SWEP.Attachments = {
    [1] = {
        PrintName = "Perk",
        Category = {"perk_melee", "perk_throw"},
        AttachSound = "TacRP/weapons/flashlight_on.wav",
        DetachSound = "TacRP/weapons/flashlight_off.wav",
    }
}

function SWEP:PrimaryAttack()
    self.Primary.Automatic = true
    self:Melee()
end

function SWEP:DrawWorldModel()
    if !IsValid(self:GetOwner()) then
        self:DrawModel()
    end
end

function SWEP:DrawWorldModelTranslucent()
    if IsValid(self:GetOwner()) then
        self:DrawCustomModel(true)
    end
end

function SWEP:SetBaseSettings()
    if SERVER then
        self:SetupShields()
    end
end

function SWEP:Holster(wep)
    if SERVER then
        self:KillShields()
    end

    return BaseClass.Holster(self, wep)
end

function SWEP:SetupShields()
    self:KillShields()

    if !IsValid(self:GetOwner()) then return end

    for i, k in pairs(self.ShieldProps or {}) do
        if !k then continue end
        if !k.Model then continue end

        local correctang, correctpos

        local bonename = k.Bone or "ValveBiped.Bip01_R_Hand"
        local boneindex = self:GetOwner():LookupBone(bonename)
        if !boneindex then
            bonename = "ValveBiped.Anim_Attachment_RH"
            boneindex = self:GetOwner():LookupBone(bonename)
            if !boneindex then
                boneindex = 0 // just give up
                if !self:GetOwner().ShieldPosWarn then
                    self:GetOwner().ShieldPosWarn = true
                    self:GetOwner():ChatPrint("[TacRP] Your playermodel does not have the right hand bone or attachment bone.")
                    self:GetOwner():ChatPrint("[TacRP] The shield will not be able to position itself correctly!")
                end
            else
                // this should be close enough for most models
                correctang = Angle(-90, 90, 0)
                correctpos = Vector(0, -25, -28)
            end
        end

        local bpos, bang = self:GetOwner():GetBonePosition(boneindex)

        local pos = k.Pos or Vector(0, 0, 0)
        local ang = k.Ang or Angle(0, 0, 0)
        if correctang and correctpos then
            ang = ang + correctang
            pos = pos + correctpos
        end

        local apos = LocalToWorld(pos, ang, bpos or Vector(), bang or Angle())

        local shield = ents.Create("physics_prop")
        if !shield then
            print("!!! Unable to spawn shield!")
            continue
        end

        shield.mmRHAe = k.Resistance
        shield.Impenetrable = true

        shield:SetModel( k.Model )
        shield:FollowBone( self:GetOwner(), boneindex )
        shield:SetPos( apos )
        shield:SetAngles( self:GetOwner():GetAngles() + ang )
        shield:SetOwner(self:GetOwner())
        shield:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        -- shield:SetModelScale(1.1, 0.00001)
        shield.Weapon = self
        if GetConVar("developer"):GetBool() then
            shield:SetColor( Color(0, 0, 0, 255) )
            shield:SetMaterial("models/wireframe")
        else
            shield:SetColor( Color(0, 0, 0, 0) )
            shield:SetRenderMode(RENDERMODE_NONE)
        end
        table.insert(self.Shields, shield)
        shield:Spawn()
        shield:Activate()
        shield:DrawShadow(false)

        table.insert(TacRP.ShieldPropPile, {Weapon = self, Model = shield})

        timer.Simple(0.5, function()
            if !IsValid(self) or !IsValid(shield) then return end
            net.Start("tacrp_addshieldmodel")
                net.WriteEntity(self)
                net.WriteEntity(shield)
            net.SendPVS(shield:GetPos())
        end)

        local phys = shield:GetPhysicsObject()

        phys:SetMass(1000)
    end
end

function SWEP:KillShields()
    for i, k in pairs(self.Shields) do
        SafeRemoveEntity(k)
    end
    self.Shields = {}
end

function SWEP:SetupModel(wm)
    self:KillModel()

    if !wm and !IsValid(self:GetOwner()) then return end
    if !wm then return end

    self.WModel = {}

    local csmodel = ClientsideModel(self.WorldModel)

    if !IsValid(csmodel) then return end

    csmodel.WMBase = true
    csmodel.Pos = Vector(5, 5, 30)
    csmodel.Ang = Angle(0, 0, 180 - 15)
    csmodel.Bone = "ValveBiped.Bip01_R_Hand"
    csmodel.Weapon = self
    csmodel.NoDraw = true
    csmodel.RenderOverride = function(self2)
        if !IsValid(self2.Weapon) then self2:Remove() return end
        if !IsValid(self2.Weapon:GetOwner()) then self2:Remove() return end
        if self2.Weapon != self2.Weapon:GetOwner():GetActiveWeapon() then self2:Remove() return end
        self2:DrawModel()
    end

    if !self:GetOwner():LookupBone(csmodel.Bone) then
        csmodel.Bone = "ValveBiped.Anim_Attachment_RH"
        if !self:GetOwner():LookupBone(csmodel.Bone) then
            csmodel.Bone = self:GetOwner():GetBoneName(0) // give up
        end
        csmodel.Ang = csmodel.Ang + Angle(90, 0, 90)
        csmodel.Pos = csmodel.Pos + Vector(-1, 25, -28)
    end

    local tbl = {
        Model = csmodel,
        Weapon = self
    }

    table.insert(TacRP.CSModelPile, tbl)

    table.insert(self.WModel, 1, csmodel)
end

function SWEP:ThinkSprint()
end

hook.Add("EntityTakeDamage", "TacRP_RiotShield", function(ent, dmginfo)
    if !IsValid(dmginfo:GetAttacker()) or !ent:IsPlayer() then return end
    local wep = ent:GetActiveWeapon()

    if !IsValid(wep) or wep:GetClass() != "tacrp_riot_shield" then return end
    if (dmginfo:GetAttacker():GetPos() - ent:EyePos()):GetNormalized():Dot(ent:EyeAngles():Forward()) < 0.5
    and ((dmginfo:GetDamagePosition() - ent:EyePos()):GetNormalized():Dot(ent:EyeAngles():Forward()) < 0.5) then return end
    if dmginfo:IsExplosionDamage() or dmginfo:GetInflictor():GetClass() == "entityflame" then return end

    -- block melee... kind of
    if dmginfo:IsDamageType(DMG_GENERIC) or dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_CRUSH) or dmginfo:IsDamageType(DMG_SLASH) or dmginfo:GetDamageType() == 0 then
        return true
    end

    dmginfo:ScaleDamage(0.5)
end)

SWEP.AutoSpawnable = false