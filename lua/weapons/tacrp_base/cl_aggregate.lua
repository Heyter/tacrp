function SWEP:GetReloadTime(base)
    local vm = self:GetVM()
    local valfunc = base and self.GetBaseValue or self.GetValue

    if !valfunc(self, "ShotgunReload") then
        local seq = vm:LookupSequence(self:TranslateSequence("reload"))
        local basetime = vm:SequenceDuration(seq)
        local mult = valfunc(self, "ReloadTimeMult")

        return basetime * mult
    else
        local seq1 = vm:LookupSequence(self:TranslateSequence("reload_start"))
        local seq2 = vm:LookupSequence(self:TranslateSequence("reload"))
        local seq3 = vm:LookupSequence(self:TranslateSequence("reload_finish"))

        local time_1 = vm:SequenceDuration(seq1)
        local time_2 = vm:SequenceDuration(seq2)
        local time_3 = vm:SequenceDuration(seq3)

        local mult = valfunc(self, "ReloadTimeMult")

        local basetime = time_1 + (time_2 * valfunc(self, "ClipSize")) + time_3

        if valfunc(self, "ShotgunThreeload") then
            basetime = time_1 + (time_2 * valfunc(self, "ClipSize") / 3) + time_3
        end

        return basetime * mult
    end
end

function SWEP:GetDeployTime(base)
    local vm = self:GetVM()
    local valfunc = base and self.GetBaseValue or self.GetValue

    local anim = "deploy"
    local mult = valfunc(self, "DeployTimeMult")

    if valfunc(self, "TryUnholster") then
        anim = "unholster"
    end

    local seq = vm:LookupSequence(self:TranslateSequence(anim))
    local basetime = vm:SequenceDuration(seq)

    return basetime * mult
end

function SWEP:GetMuzzleVelocity(base)
    local valfunc = base and self.GetBaseValue or self.GetValue

    local basetime = valfunc(self, "MuzzleVelocity")

    if valfunc(self, "ShootEnt") then
        basetime = valfunc(self, "ShootEntForce")
    end

    return math.ceil(0.3048 * basetime / 12)
end

function SWEP:GetMeanShotsToFail(base)
    local valfunc = base and self.GetBaseValue or self.GetValue
    local shootchance = valfunc(self, "ShootChance")

    return 1 / (1 - shootchance)
end

function SWEP:GetBestFiremode(base)
    local valfunc = base and self.GetBaseValue or self.GetValue

    if valfunc(self, "Firemodes") then
        local bfm, bfm_i
        for k, v in pairs(valfunc(self, "Firemodes")) do
            if !bfm or v == 2 or (bfm <= 1 and v < bfm) then
                bfm = v
                bfm_i = k
            end
        end
        return bfm, bfm_i
    else
        return valfunc(self, "Firemode") or 0, 1
    end
end

local hitgroups = {
    [HITGROUP_HEAD] = 0.1,
    [HITGROUP_CHEST] = 0.2,
    [HITGROUP_STOMACH] = 0.3,
    [HITGROUP_LEFTARM] = 0.2,
    [HITGROUP_LEFTLEG] = 0.2,
}

local mssd_scoring = {
    [HITGROUP_HEAD]    = {0.15, 0.5,  {1, 0.6,  0.3, 0.15, 0.05}},
    [HITGROUP_CHEST]   = {0.25, 0.75, {1, 0.75, 0.4, 0.2,  0.1}},
    [HITGROUP_STOMACH] = {0.25, 0.8,  {1, 0.8,  0.5, 0.25, 0.15, 0.05}},
    [HITGROUP_LEFTARM] = {0.2,  0.5,  {1, 0.85, 0.6, 0.3,  0.2,  0.1, 0.05}},
    [HITGROUP_LEFTLEG] = {0.15, 0.5,  {1, 0.9,  0.7, 0.4,  0.25, 0.15, 0.1}},
}

local mssd_scoring_ttt = {
    [HITGROUP_HEAD]    = {0.25, 0.5,  {1, 0.75, 0.50, 0.25, 0.15, 0.10, 0.05, 0.025}},
    [HITGROUP_CHEST]   = {0.25, 0.75, {1, 0.90, 0.75, 0.55, 0.45, 0.35, 0.25, 0.15, 0.10, 0.05}},
    [HITGROUP_STOMACH] = {0.25, 1,    {1, 1.00, 0.90, 0.80, 0.60, 0.40, 0.30, 0.20, 0.15, 0.10, 0.05}},
    [HITGROUP_LEFTARM] = {0.15, 1,    {1, 1.00, 0.80, 0.70, 0.50, 0.30, 0.25, 0.15, 0.10, 0.05, 0.025}},
    [HITGROUP_LEFTLEG] = {0.10, 1,    {1, 1.00, 0.90, 0.75, 0.60, 0.50, 0.40, 0.30, 0.25, 0.20, 0.15, 0.10, 0.05}},
}


SWEP.StatGroupGrades = {
    {90, "S", Color(230, 60, 60)},
    {77, "A", Color(230, 180, 60)},
    {60, "B", Color(230, 230, 60)},
    {40, "C", Color(60, 230, 60)},
    {20, "D", Color(60, 60, 230)},
    { 0, "F", Color(150, 150, 150)},
}

SWEP.StatGroups = {
    {
        Name = "Lethality",
        Description = {"How easily and quickly the weapon can take out a single target.", "Affected by Damage and RPM."},
        RatingFunction = function(self, base)
            -- local score = 0
            local valfunc = base and self.GetBaseValue or self.GetValue

            local bfm = self:GetBestFiremode(base)
            local rrpm = valfunc(self, "RPM")
            local pbd = valfunc(self, "PostBurstDelay")
            local ttt = TacRP.GetBalanceMode() == TacRP.BALANCE_TTT

            local num = valfunc(self, "Num")
            local bdm = self:GetBodyDamageMultipliers(base)
            local bdm_add = 0
            for k, v in pairs(hitgroups) do
                bdm_add = bdm_add + bdm[k] * v
            end

            local d_max, d_min = valfunc(self, "Damage_Max"), valfunc(self, "Damage_Min")
            local dmg_max = math.max(d_max, d_min)
            local dmg_avg = Lerp(0.2, math.max(d_max, d_min), math.min(d_max, d_min)) * bdm_add

            -- max single shot damage
            local mssd = 0
            for k, v in pairs(ttt and mssd_scoring_ttt or mssd_scoring) do
                local stk = math.ceil(100 / (dmg_max * (bdm[k] or 1) * (1 + (num - 1) * v[2])))
                mssd = mssd + (v[3][stk] or 0) * v[1]
                -- print(bdm[k], stk, (mssd_scoring[k][stk] or 0))
            end
            mssd = ttt and mssd ^ 0.75 or mssd

            -- avg time to kill
            local stk = math.ceil(100 / (dmg_avg * num))
            local ttk_s
            if stk == 1 then
                ttk_s = math.Clamp(rrpm / 120, 0, 1) ^ 0.75
            else
                local ttk = (stk - 1) * (60 / rrpm)
                if bfm < 0 then
                    ttk = ttk + math.floor(ttk / -bfm) * pbd
                end
                ttk_s = math.Clamp(1 - ttk / (ttt and 2 or 1.5), 0, 1) ^ (ttt and 2 or 1.5)
            end

            local scores = {mssd, ttk_s}
            table.sort(scores)

            return scores[2] * 70 + scores[1] * 30

        end,
    },
    {
        Name = "Suppression",
        Description = {"How much damage the weapon can output over a long period of time.", "Affected by Damage, RPM, Capacity and Reload Time."},
        RatingFunction = function(self, base)
            local valfunc = base and self.GetBaseValue or self.GetValue

            local bfm = self:GetBestFiremode(base)
            local rrpm = valfunc(self, "RPM")
            local erpm = rrpm
            local pbd = valfunc(self, "PostBurstDelay")
            local ttt = TacRP.GetBalanceMode() == TacRP.BALANCE_TTT

            if bfm == 1 then
                erpm = math.min(rrpm, 600) + math.max(rrpm - 600, 0) ^ 0.75 -- you can't click *that* fast
            elseif bfm < 0 then
                erpm = rrpm - 60 / (-bfm / pbd)
            end

            local num = valfunc(self, "Num")
            local bdm = self:GetBodyDamageMultipliers(base)
            local bdm_add = 0
            for k, v in pairs(hitgroups) do
                bdm_add = bdm_add + bdm[k] * v
            end

            local d_max, d_min = valfunc(self, "Damage_Max"), valfunc(self, "Damage_Min")
            -- local dmg_max = math.max(d_max, d_min)
            local dmg_avg = Lerp(0.2, math.max(d_max, d_min), math.min(d_max, d_min)) * bdm_add

            -- raw dps
            local dps = dmg_avg * num * erpm / 60
            local tttm = ttt and 0.5 or 1
            local dps_s = math.Clamp((dps - 50 * tttm) / (400 * tttm), 0, 1) ^ (ttt and 1 or 0.9)

            -- average dps over time
            local dot = dmg_avg * num / (60 / erpm + self:GetReloadTime(base) / valfunc(self, "ClipSize"))
            local dot_s = math.Clamp((dot - 20 * tttm) / (200 * tttm), 0, 1) ^ (ttt and 1 or 0.9)

            return dps_s * 30 + dot_s * 70
        end,
    },
    {
        Name = "Range",
        Description = {"How well the weapon gains or loses damage over long distances.", "Affected by Minimum Range, Maximum Range, and damage falloff."},
        RatingFunction = function(self, base)
            local score = 0
            local valfunc = base and self.GetBaseValue or self.GetValue

            local d_max, d_min = valfunc(self, "Damage_Max"), valfunc(self, "Damage_Min")
            local r_min, r_max = self:GetMinMaxRange(base)
            local ttt = TacRP.GetBalanceMode() == TacRP.BALANCE_TTT

            local r_mid = r_min + (r_max - r_min) / 2
            local d_diff = math.abs(d_max - d_min) / math.max(d_max, d_min)
            if d_max > d_min then
                -- [50] 50% damage falloff range
                score = score + math.Clamp((r_mid - (ttt and 750 or 1000)) / (ttt and 2000 or 4000), 0, 1) * 50

                -- [50] damage reduction from range
                score = score + math.Clamp(1 - d_diff, 0, 1) ^ 0.8 * 50
            else
                -- [40] free points
                -- [40] 50% damage rampup range
                score = score + 40 + math.Clamp(r_mid / (ttt and 2500 or 5000), 0, 1) * 40
                -- print(r_mid, math.Clamp(1 - r_mid / 5000, 0, 1))

                -- [20] damage reduction from range
                score = score + math.Clamp(1 - d_diff, 0, 1) * 20
            end

            return score
        end,
    },
    {
        Name = "Precision",
        Description = {"How accurate the weapon is when firing single shots or short bursts.", "Affected by Spread and various Recoil stats."},
        RatingFunction = function(self, base)
            local score = 0
            local valfunc = base and self.GetBaseValue or self.GetValue

            local bfm = self:GetBestFiremode(base)
            local rpm = valfunc(self, "RPM")

            local num = valfunc(self, "Num")
            local spread = valfunc(self, "Spread")
            local delay = 60 / rpm
            local rps = valfunc(self, "RecoilPerShot")
            local rsp = valfunc(self, "RecoilSpreadPenalty")
            local rrt = valfunc(self, "RecoilResetTime")
            local rdr = valfunc(self, "RecoilDissipationRate")
            local dt = math.max(0, delay - rrt)
            local rbs = dt * rdr -- amount of recoil we can recover between shots even if fired ASAP

            -- [50] base spread
            local tgt = 0.015
            if num > 2 then tgt = 0.04 end
            score = score + math.Clamp(1 - spread / tgt, 0, 1) * 50

            -- [25] first shot spread
            local fss = valfunc(self, "RecoilFirstShotMult") * rps
            score = score + math.Clamp(1 - (spread + fss * rsp - rbs) / tgt, 0, 1) * 25

            -- [25] spread over 0.3s (or one burst)
            local shots = math.min(math.ceil(rpm / 60 * 0.3), math.floor(self:GetBaseValue("ClipSize") * 0.5))
            if bfm < 0 then
                shots = -bfm
            end
            if rbs <= fss then
                local so1 = (fss - rbs + shots * (rps - rbs)) * rsp
                score = score + math.Clamp(1 - so1 / 0.03, 0, 1) ^ 1.25 * 25
            else
                -- delay is so long we always get first shot
                score = score + 25
            end

            -- recoil reset time
            -- score = score + math.Clamp(1 - math.max(0, rrt - delay) / 0.25, 0, 1) * 10

            return score
        end,
    },
    {
        Name = "Control",
        Description = {"How managable the weapon's recoil and spread is under sustained fire.", "Affected by RPM and various Recoil stats."},
        RatingFunction = function(self, base)
            local score = 0
            local valfunc = base and self.GetBaseValue or self.GetValue

            local bfm = self:GetBestFiremode(base)
            local erpm = valfunc(self, "RPM")
            local pbd = valfunc(self, "AutoBurst") and valfunc(self, "PostBurstDelay") or math.max(0.15, valfunc(self, "PostBurstDelay"))
            if bfm == 1 then
                erpm = math.min(erpm, 600) -- you can't click *that* fast
            elseif bfm < 0 then
                erpm = 60 / ((60 / erpm) + pbd / -bfm)
            end
            local delay = 60 / valfunc(self, "RPM")
            local rps = valfunc(self, "RecoilPerShot")
            local rsp = valfunc(self, "RecoilSpreadPenalty")
            local rrt = valfunc(self, "RecoilResetTime")
            local rdr = valfunc(self, "RecoilDissipationRate")
            local dt = math.max(0, delay - rrt)
            local rbs = dt * rdr -- amount of recoil we can recover between shots even if fired ASAP
            local fss = valfunc(self, "RecoilFirstShotMult") * rps
            local rmax = valfunc(self, "RecoilMaximum")

            local rk = math.abs(valfunc(self, "RecoilKick"))

            if rbs > fss or rsp == 0 then
                -- judge solely on recoil kick and reset time, as spread is not a factor
                return math.Clamp(1 - rk * rrt / 4, 0, 1) * 100
            end

            -- recoil recovery
            local rrec_s = math.Clamp(rdr / rps / 30, 0, 1) ^ 0.9
            -- print("rrec", rdr / rps, math.Clamp(math.max(0, (rdr / rps) - 4) / 16, 0, 1) * 30)

            -- maximum spread
            local mspr_s = math.Clamp(1 - rmax * rsp / 0.1, 0, 1) ^ 0.9
            -- score = score + math.Clamp(1 - rmax * rsp / 0.1, 0, 1) * 15

            -- 40 scaled between max spread and recovery
            score = score + math.max(rrec_s, mspr_s) * 30 + math.min(rrec_s, mspr_s) * 10
            -- print(rrec_s, mspr_s)

            -- [30] recoil kick over 1s
            local shots = math.ceil(erpm / 60 * 1)
            score = score + math.Clamp(1 - rk * shots * rrt / 15, 0, 1) * 30
            --print("rk1", rk * shots * rrt, math.Clamp(1 - rk * shots * rrt / 15, 0, 1) * 25)

            -- [30] spread over 1s (or 2 bursts)
            local score_sg = 30
            if bfm < 0 then
                local rbb = math.max(0, pbd - rrt) * rdr -- recovery between bursts
                local rpb = -bfm * rps - (-bfm - 1) * rbs - rbb -- recoil per full burst
                score = score + math.Clamp(1 - (rpb * rsp * 2) / 0.04, 0, 1) ^ 0.75 * score_sg
                --print("spb", rpb * rsp, math.Clamp(1 - (rpb * rsp * 3) / 0.04, 0, 1) ^ 2 * score_sg)
            else
                local sg = math.min(shots, math.ceil(rmax / rsp))
                local sot = math.min(rmax, fss - rbs + sg * (rps - rbs)) * rsp
                --print("sot", sot, math.Clamp(1 - sot / 0.04, 0, 1) ^ 2 * score_sg)
                score = score + math.Clamp(1 - sot / 0.04, 0, 1) ^ 0.75 * score_sg
            end

            return score
        end,
    },
    {
        Name = "Handling",
        Description = {"How quickly this weapon readies from sprinting, aiming and deploying.", "Affected by Aim Down Sights Time, Sprint To Fire Time, and Deploy Time."},
        RatingFunction = function(self, base)
            local score = 0
            local valfunc = base and self.GetBaseValue or self.GetValue

            -- [40] sprint
            score = score + math.Clamp(1 - (valfunc(self, "SprintToFireTime") - 0.2) / 0.6, 0, 1) * 40

            -- [40] ads
            score = score + math.Clamp(1 - (valfunc(self, "AimDownSightsTime") - 0.2) / 0.6, 0, 1) * 40

            -- [20] deploy
            score = score + math.Clamp(1 - (self:GetDeployTime(base) - 0.5) / 1.5, 0, 1) * 20

            return score
        end,
    },
    {
        Name = "Maneuvering",
        Description = {"How well the weapon performs while moving around and not aiming.", "Affected by Hipfire, Moving and Mid-air Spread, as well as Peeking Penalty.", "If Free Aim or Sway is enabled, they will also be scored."},
        RatingFunction = function(self, base)
            local score = 0
            local valfunc = base and self.GetBaseValue or self.GetValue

            -- [25] free aim + sway (if both are disabled, score goes to other 2)
            local bonus = 30
            local freeaim_s = 1
            if GetConVar("tacrp_freeaim"):GetBool() then
                if valfunc(self, "FreeAim") then
                    freeaim_s = math.Clamp(1 - (valfunc(self, "FreeAimMaxAngle") - 5) / 5, 0, 1)
                end
                bonus = 0
            end
            local sway_s = 1
            if GetConVar("tacrp_sway"):GetBool() then
                sway_s = math.Clamp(1 - (valfunc(self, "Sway") ) / 4, 0, 1) ^ 0.6
                bonus = 0
            end
            if bonus == 0 then
                score = score + math.max(freeaim_s, sway_s) * 22 + math.min(freeaim_s, sway_s) * 8
            end

            local diff = valfunc(self, "HipFireSpreadPenalty") / math.Clamp(self:GetBaseValue("Spread"), 0.015, 0.03)

            -- [20] peeking
            score = score + math.Clamp(1 - (diff * valfunc(self, "PeekPenaltyFraction")) / 1.5, 0, 1) * (20 + bonus * 0.25)

            -- [40] hip spread
            score = score + math.Clamp(1 - (diff - 1) / 4, 0, 1) ^ 0.9 * (40 + bonus * 0.5)

            -- [15] mid-air/moving spread
            score = score + math.Clamp(1 - (valfunc(self, "MidAirSpreadPenalty") * 0.3 + valfunc(self, "MoveSpreadPenalty") * 0.7) / 0.15, 0, 1) * (15 + bonus * 0.25)

            return score
        end,
    },
    {
        Name = "Mobility",
        Description = {"How fast the user can move while using this weapon.", "Affected by various Speed stats, such as Sighted Speed."},
        RatingFunction = function(self, base)
            local score = 0
            local valfunc = base and self.GetBaseValue or self.GetValue
            local ttt = TacRP.GetBalanceMode() == TacRP.BALANCE_TTT

            if ttt then
                -- [30] move
                score = score + math.Clamp((valfunc(self, "MoveSpeedMult") - 0.6) / 0.4, 0, 1) * 30

                -- [25] sighted
                score = score + math.Clamp((valfunc(self, "SightedSpeedMult") - 0.2) / 0.8, 0, 1) * 25

                -- [25] shooting
                score = score + math.Clamp((valfunc(self, "ShootingSpeedMult") - 0.2) / 0.8, 0, 1) * 25

                -- [20] reload
                score = score + math.Clamp((valfunc(self, "ReloadSpeedMult") - 0.4) / 0.6, 0, 1) * 20
            else
                -- [40] move
                score = score + math.Clamp((valfunc(self, "MoveSpeedMult") - 0.4) / 0.6, 0, 1) * 40

                -- [30] sighted
                score = score + math.Clamp((valfunc(self, "SightedSpeedMult") - 0.2) / 0.8, 0, 1) * 30

                -- [30] shooting
                score = score + math.Clamp((valfunc(self, "ShootingSpeedMult") - 0.2) / 0.8, 0, 1) * 30

                -- [-20] reload
                score = score - math.Clamp(1 - (valfunc(self, "ReloadSpeedMult") - 0.4) / 0.6, 0, 1) * 20
            end


            return score
        end,
    },
    {
        Name = "Stability",
        Description = {"How much the weapon's point of aim will move around.", "Affected by various Sway stats.", "NOTE: No difference if Sway is disabled in the options."},
        RatingFunction = function(self, base)
            local score = 0
            local valfunc = base and self.GetBaseValue or self.GetValue

            -- [30] sway
            score = score + math.Clamp(1 - valfunc(self, "Sway") / 5, 0, 1) ^ 0.75 * 30

            -- [60] sighted sway
            score = score + math.Clamp(1 - valfunc(self, "ScopedSway") / 2, 0, 1) ^ 1.5 * 60

            -- [10] blindfire sway
            score = score + math.Clamp(1 - valfunc(self, "BlindFireSway") / 2, 0, 1) * 10

            return score
        end,
    },
}

SWEP.StatDisplay = {
    -- {
    --     Name = "",
    --     Value = "",
    --     LowerIsBetter = false,
    --     AggregateFunction = nil,
    --     Unit = ""
    -- }
    {
        Name = "Spread",
        Description = "Base accuracy of the weapon.",
        AggregateFunction = function(self, base, val)
            return math.Round(math.deg(val), 2)
        end,
        Unit = "°",
        Value = "Spread",
        LowerIsBetter = true,
    },
    {
        Name = "RPM",
        Description = "Rate of fire of the weapon.",
        Value = "RPM"
    },
    {
        Name = "Capacity",
        Description = "Amount of ammo this weapon can spend before reloading.",

        Value = "ClipSize",
    },
    {
        Name = "Sprint To Fire",
        Description = "Time required to transition from fully sprinting to being able to fire.",

        Value = "SprintToFireTime",
        Unit = "s",
        LowerIsBetter = true,
    },
    {
        Name = "Aim Down Sights",
        Description = "Time required to transition from hipfiring to aiming.",
        Value = "AimDownSightsTime",
        Unit = "s",
        LowerIsBetter = true,
        ValueCheck = "Scope",
    },
    {
        Name = "Muzzle Velocity",
        Description = "How fast the bullet travels in the world.",
        AggregateFunction = function(self, base, val)
            return math.Round(self:GetMuzzleVelocity(base), 2)
        end,
        ConVarCheck = "tacrp_physbullet",
        Value = "MuzzleVelocity",
        LowerIsBetter = false,
        Unit = "m/s"
    },
    {
        Name = "Recoil Kick",
        Description = "Strength of \"felt recoil\" that throws off your aim.",
        Value = "RecoilKick",
        LowerIsBetter = true,
    },
    {
        Name = "Recoil Spread",
        Description = {"Inaccuracy per unit of recoil. Larger value means the weapon becomes",
        "inaccurate faster while continuous firing."},
        AggregateFunction = function(self, base, val)
            return math.Round(math.deg(val), 3)
        end,
        Unit = "°",
        Value = "RecoilSpreadPenalty",
        LowerIsBetter = true,
    },
    {
        Name = "Recoil Recovery",
        Description = {"Rate at which accumulated recoil disspiates, in shots per second.",
        "Larger value means the effects of recoil disappear faster",
        "after the reset time."},
        AggregateFunction = function(self, base, val)
            return math.Round(val, 2)
            --return math.Round(math.deg(val * (base and self:GetTable().RecoilSpreadPenalty or self:GetValue("RecoilSpreadPenalty"))), 1)
        end,
        Unit = "/s",
        Value = "RecoilDissipationRate",
    },
    {
        Name = "Recoil Reset Time",
        Description = {"Duration of delay before recoil can start to dissipate.",
        "Larger value means you must wait longer between shots until recoil can",
        "go down."},
        Value = "RecoilResetTime",
        LowerIsBetter = true,
    },
    {
        Name = "Maximum Recoil",
        Description = "Maximum amount of inaccuracy from continuous firing.",
        Value = "RecoilMaximum",
        LowerIsBetter = true,
        HideIfSame = true,
    },
    {
        Name = "First Shot Recoil",
        Description = {"Recoil multiplier on the first shot, reset after the reset time has passed.",
        "Does not affect recoil kick."},
        Value = "RecoilFirstShotMult",
        LowerIsBetter = true,
        HideIfSame = true,
    },
    {
        Name = "Crouching Recoil",
        Description = "Recoil multiplier when crouched and not moving.",
        AggregateFunction = function(self, base, val)
            return math.min(100, math.Round(val * 100, 0))
        end,
        Unit = "%",
        Value = "RecoilCrouchMult",
        LowerIsBetter = true,
        HideIfSame = true,
    },
    {
        Name = "Move Speed",
        Description = {"Speed multiplier while the weapon is held up.",
        "Has no effect when weapon is in safety."},
        AggregateFunction = function(self, base, val)
            return math.min(100, math.Round(val * 100, 0))
        end,
        Unit = "%",
        Value = "MoveSpeedMult"
    },
    {
        Name = "Shooting Speed",
        Description = {"Speed multiplier from firing the weapon.",
        "Accumulating recoil increases slowdown intensity."},
        AggregateFunction = function(self, base, val)
            return math.min(100, math.Round(val * 100, 0))
        end,
        Unit = "%",
        Value = "ShootingSpeedMult"
    },
    {
        Name = "Sighted Speed",
        Description = "Speed multiplier while the weapon is aiming.",
        AggregateFunction = function(self, base, val)
            return math.min(100, math.Round(val * 100, 0))
        end,
        Unit = "%",
        Value = "SightedSpeedMult",
        ValueCheck = "Scope",
    },
    {
        Name = "Reload Speed",
        Description = "Speed multiplier while reloading.",
        AggregateFunction = function(self, base, val)
            return math.min(100, math.Round(val * 100, 0))
        end,
        Unit = "%",
        Value = "ReloadSpeedMult",
    },
    {
        Name = "Reload Time",
        Description = "Amount of time required to perform a reload.",
        AggregateFunction = function(self, base, val)
            return math.Round(self:GetReloadTime(base), 2)
        end,
        Value = "ReloadTimeMult",
        LowerIsBetter = true,
        Unit = "s"
    },
    {
        Name = "Deploy Time",
        Description = "Amount of time required to bring up the weapon. Holstering is instant.",
        AggregateFunction = function(self, base, val)
            return math.Round(self:GetDeployTime(base), 2)
        end,
        Value = "DeployTimeMult",
        LowerIsBetter = true,
        HideIfSame = true,
        Unit = "s"
    },
    {
        Name = "Penetration",
        Description = {"Thickness of metal this weapon can penetrate.",
        "Actual penetration is material-dependent."},
        Value = "Penetration",
        Unit = "\""
    },
    {
        Name = "Sway",
        Description = {"Amount of sway in hipfire. Sway affects your firing direction",
        "without changing your aiming direction."},

        Value = "Sway",
        LowerIsBetter = true,
        ConVarCheck = "tacrp_sway",
    },
    {
        Name = "Sway In Sights",
        Description = {"Amount of sway while aiming. Sway affects your firing direction",
        "without changing your aiming direction."},
        Value = "ScopedSway",
        LowerIsBetter = true,
        ConVarCheck = "tacrp_sway",
        ValueCheck = "Scope",
    },
    {
        Name = "Crouching Sway",
        Description = "Sway multiplier when crouched and not moving.",
        Value = "SwayCrouchMult",
        AggregateFunction = function(self, base, val)
            return math.min(100, math.Round(val * 100, 0))
        end,
        Unit = "%",
        LowerIsBetter = true,
        HideIfSame = true,
        ConVarCheck = "tacrp_sway",
    },
    {
        Name = "Mid-Air Spread",
        Description = {"Amount of inaccuracy caused by not standing on solid ground.", "Applied at half intensity while swimming and climbing ladders."},
        AggregateFunction = function(self, base, val)
            return math.Round(math.deg(val), 2)
        end,
        Unit = "°",
        Value = "MidAirSpreadPenalty",
        LowerIsBetter = true,
        HideIfSame = true,
    },
    {
        Name = "Hipfire Spread",
        Description = "Amount of additional inaccuracy while hipfiring.",
        AggregateFunction = function(self, base, val)
            return math.Round(math.deg(val), 2)
        end,
        Unit = "°",
        Value = "HipFireSpreadPenalty",
        LowerIsBetter = true,
        HideIfSame = true,
    },
    {
        Name = "Melee Damage",
        Description = "Damage dealt when bashing.",
        Value = "MeleeDamage",
        HideIfSame = true,
    },
    {
        Name = "Firemode",
        Description = "The weapon's firing capabilities.",
        AggregateFunction = function(self, base, val)
            if !val then
                val = {base and self:GetTable()["Firemode"] or self:GetValue("Firemode")}
            end
            if #val == 1 then
                if val[1] == 2 then
                    return "Auto"
                elseif val[1] == 1 then
                    return "Semi"
                elseif val[1] < 0 then
                    return val[1] .. "-Burst"
                end
            else
                local tbl = table.Copy(val)
                table.sort(tbl, function(a, b)
                    if a == 2 then
                        return b == 2
                    elseif b == 2 then
                        return a != 2
                    end
                    return math.abs(a) <= math.abs(b)
                end)
                local str = "S-"
                for i = 1, #tbl do
                    str = str .. (tbl[i] == 2 and "F" or math.abs(tbl[i])) .. (i < #tbl and "-" or "")
                end
                return str
            end
            return table.ToString(val)
        end,
        BetterFunction = function(self, old, new)
            if !old then
                old = {self:GetBaseValue("Firemode")}
            end
            if !new then
                new = {self:GetValue("Firemode")}
            end
            local oldbest, newbest = 0, 0
            for i = 1, #old do
                local v = math.abs(old[i])
                if v > oldbest or v == 2 then
                    oldbest = (v == 2 and math.huge) or v
                end
            end
            for i = 1, #new do
                local v = math.abs(new[i])
                if v > newbest or v == 2 then
                    newbest = (v == 2 and math.huge) or v
                end
            end
            if oldbest == newbest then
                return #old != #new , #old < #new
            else
                return true, oldbest < newbest
            end
        end,
        DifferenceFunction = function(self, orig, value)
            if !orig then
                orig = {self:GetBaseValue("Firemode")}
            end
            if !value then
                value = {self:GetValue("Firemode")}
            end
            local old_best = self:GetBestFiremode(true)
            local new_best = self:GetBestFiremode(false)
            if old_best == new_best then return end
            if new_best == 2 then
                return "+Auto"
            elseif old_best == 2 then
                return "-Auto"
            elseif new_best < 0 then
                return "+Burst"
            end
        end,
        Value = "Firemodes",
        HideIfSame = true,
    },
    {
        Name = "Free Aim Angle",
        Description = "Maximum amount of deviation from the aim direction while hipfiring.",
        Unit = "°",
        Value = "FreeAimMaxAngle",
        LowerIsBetter = true,
        HideIfSame = true,
        ConVarCheck = "tacrp_freeaim",
    },
    {
        Name = "Mean Shots To Fail",
        Description = "The average number of shots that will be fired before the weapon jams.",
        AggregateFunction = function(self, base, val)
            return math.Round(self:GetMeanShotsToFail(base), 0)
        end,
        DisplayFunction = function(self, base, val)
            if val == 1 then return "∞" end
            return math.Round(self:GetMeanShotsToFail(base), 0)
        end,
        HideIfSame = true,
        Value = "ShootChance",
    },
}