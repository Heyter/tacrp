// spawnable
SWEP.Spawnable = false
SWEP.AdminOnly = false

// names and stuff
SWEP.PrintName = "Arctic's Tactical RP Base"
SWEP.Category = "Tactical RP" // "Tactical RP (Arctic)"

SWEP.Description = ""

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.ViewModelFOV = 65

SWEP.NoRanger = false
SWEP.NoStatBox = false

SWEP.NPCUsable = true

SWEP.Slot = 1

SWEP.RenderGroup = RENDERGROUP_BOTH

SWEP.BalanceStats = {} // replacement stats for each TacRP.BALANCE_ enum

// What weapon this will replace in TTT if enabled. Use TacRP.TTTReplacePreset presets or define your own
SWEP.TTTReplace = nil // {["weapon_ttt_glock"] = 1} // key is weapon to replace, value is relative weight.

// "ballistics"

SWEP.Damage_Max = 30 // damage at minimum range
SWEP.Damage_Min = 20 // damage at maximum range
SWEP.Range_Min = 256 // distance for which to maintain maximum damage
SWEP.Range_Max = 1024 // distance at which we drop to minimum damage
SWEP.Penetration = 0 // units of metal this weapon can penetrate

SWEP.ShootEnt = false
SWEP.ShootEntForce = 10000

SWEP.Num = 1
SWEP.TracerNum = 1
SWEP.BodyDamageMultipliers = {
    [HITGROUP_HEAD] = 1.25,
    [HITGROUP_CHEST] = 1,
    [HITGROUP_STOMACH] = 1,
    [HITGROUP_LEFTARM] = 1,
    [HITGROUP_RIGHTARM] = 1,
    [HITGROUP_LEFTLEG] = 0.9,
    [HITGROUP_RIGHTLEG] = 0.9,
    [HITGROUP_GEAR] = 0.9
}

SWEP.MuzzleVelocity = 30000

SWEP.ExplosiveEffect = nil
SWEP.ExplosiveDamage = 0
SWEP.ExplosiveRadius = 0

// misc. shooting

// Firemode system works just like ArcCW
// 2 = full auto
// 1 = semi auto
// 0 = safe
// negative numbers = burst
SWEP.Firemode = 2

SWEP.Firemodes = nil // {1, 2, 0} ...

SWEP.RunawayBurst = false // continue firing until burst is completely expended
SWEP.PostBurstDelay = 0 // only applies to runaway burst guns
SWEP.AutoBurst = false // hold the trigger to keep firing burst after burst

SWEP.RPM = 600

SWEP.Spread = 0.01

SWEP.ShootTimeMult = 1

SWEP.ShootChance = 1
SWEP.JamWaitTime = 0.5

// Spread penalties are in spread units and are additive
SWEP.MoveSpreadPenalty = 0 // spread penalty while travelling at max. 250 u/s
SWEP.MidAirSpreadPenalty = 0.1 // spread penalty for being in the air
SWEP.HipFireSpreadPenalty = 0.02 // spread penalty for not being scoped in
SWEP.ScopedSpreadPenalty = 0 // spread penalty for... being scoped in?
SWEP.BlindFireSpreadPenalty = 0 // spread penalty for blind firing
SWEP.CrouchSpreadPenalty = 0
SWEP.PeekPenaltyFraction = 0.3 // percentage of hipfire penalty to use while peeking in sights

SWEP.RecoilPerShot = 1
SWEP.RecoilMaximum = 10
SWEP.RecoilResetTime = 0 // time after you stop shooting for recoil to start dissipating
SWEP.RecoilDissipationRate = 2
SWEP.RecoilFirstShotMult = 1 // multiplier for the first shot's recoil amount

SWEP.RecoilCrouchMult = 0.85 // multiplier for when crouched

SWEP.RecoilVisualKick = 0.1

SWEP.RecoilKick = 0.25

SWEP.RecoilSpreadPenalty = 0.001 // extra spread per one unit of recoil

SWEP.ShotgunPelletSpread = 0 // per-pellet spread for shotguns (if enabled). Otherwise just adds to spread

SWEP.CanBlindFire = true

// handling

SWEP.MoveSpeedMult = 0.99
SWEP.ShootingSpeedMult = 1 // slow down applied while shooting
SWEP.SightedSpeedMult = 0.5
SWEP.MeleeSpeedMult = 0.85
SWEP.MeleeSpeedMultTime = 1 // seconds to apply slow down for
SWEP.ReloadSpeedMult = 1
SWEP.ReloadSpeedMultTime = 0.5 // duration for slowdown to fade out for AFTER RELOAD FINISHES


SWEP.ShootWhileSprint = false

SWEP.AimDownSightsTime = 0.25
SWEP.SprintToFireTime = 0.25 // how long it takes to go from sprinting to shooting

// hold types

SWEP.HoldType = "ar2"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeBlindFire = false
SWEP.HoldTypeCustomize = "slam"
SWEP.HoldTypeNPC = nil
SWEP.HoldTypeSuicide = "pistol"

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_AR2
SWEP.GestureBash = ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND

SWEP.PassiveAng = Angle(0, 0, 0)
SWEP.PassivePos = Vector(0, 0, 0)

SWEP.SprintAng = Angle(0, 45, 0)
SWEP.SprintPos = Vector(0, 0, 0)

SWEP.BlindFireAng = Angle(0, 15, 0)
SWEP.BlindFirePos = Vector(0, 0, -6)

SWEP.BlindFireLeftAng = Angle(75, 0, 0)
SWEP.BlindFireLeftPos = Vector(8, 10, -12)

SWEP.BlindFireRightAng = Angle(-75, 0, 0)
SWEP.BlindFireRightPos = Vector(-10, 10, -12)

SWEP.BlindFireSuicideAng = Angle(0, 145, 130)
SWEP.BlindFireSuicidePos = Vector(-6, 32, -26)

SWEP.CustomizeAng = Angle(30, 15, 0)
SWEP.CustomizePos = Vector(5, 0, -6)

SWEP.SightAng = Angle(0, 0, 0)
SWEP.SightPos = Vector(0, 1, 1)

SWEP.PeekAng = Angle(0, 0, -7)
SWEP.PeekPos = Vector(3, 2, -1.5)

SWEP.HolsterVisible = false
SWEP.HolsterSlot = TacRP.HOLSTER_SLOT_BACK
SWEP.HolsterPos = Vector(0, 0, 0)
SWEP.HolsterAng = Angle(0, 0, 0)

SWEP.HolsterModel = nil // string, model.

SWEP.SightMidPoint = {
    Pos = Vector(-1, 15, -6),
    Ang = Angle(0, 0, -45)
}

SWEP.SprintMidPoint = {
    Pos = Vector(4, 10, 2),
    Ang = Angle(0, -10, -45)
}

// scope

SWEP.Scope = true
SWEP.ScopeOverlay = nil // Material("path/to/overlay")
SWEP.ScopeFOV = 90 / 1.1
SWEP.ScopeLevels = 1 // 2 = like CS:S
SWEP.ScopeHideWeapon = false

SWEP.QuickScopeSpreadPenalty = 0.05
SWEP.QuickScopeTime = 0.25 // amount of time over which to fade out the quickscope spread penalty

// sway

SWEP.Sway = 1
SWEP.ScopedSway = 0.1
SWEP.BlindFireSway = 2
SWEP.SwayCrouchMult = 0.75

SWEP.FreeAim = true
SWEP.FreeAimMaxAngle = 7.5

// quicknade

SWEP.CanQuickNade = true
SWEP.QuickNadeTimeMult = 1

// melee

SWEP.CanMeleeAttack = true
SWEP.MeleeDamage = 25
SWEP.MeleeAttackTime = 0.7 // time between swings
SWEP.MeleeRange = 96
SWEP.MeleeDamageType = DMG_GENERIC

// reload

SWEP.AmmoPerShot = 1
SWEP.ClipSize = 30
SWEP.Ammo = "pistol"

SWEP.InfiniteAmmo = false // do not consume reserve ammo

SWEP.SupplyAmmoAmount = false // overrides clipsize/ammo for ammo pickups
SWEP.SupplyLimit = 1 // Multiplier for supply ammo

SWEP.TryUnholster = false // if we have an "unholster" animation use it instead of "deploy"

SWEP.ShotgunReload = false
SWEP.ShotgunThreeload = true // use those stupid 3 shot reload animations
SWEP.ShotgunReloadCompleteStart = false // do not interrupt reload_start and instead wait for it to finish first. used on FP6 animations
SWEP.ReloadTimeMult = 1
SWEP.DeployTimeMult = 1
SWEP.HolsterTimeMult = 1
SWEP.DropMagazineModel = false
SWEP.DropMagazineImpact = "pistol" // available: "pistol", "plastic", "metal", "bullet", "shotgun"
SWEP.DropMagazineAmount = 1
SWEP.MidReload = false // allow guns with "midreload" animation to continue reload after holster

SWEP.DefaultBodygroups = "0000000"
SWEP.DefaultWMBodygroups = "0000000"
SWEP.DefaultSkin = 0
SWEP.BulletBodygroups = nil

/*
{
    [1] = {5, 1}
}
*/
SWEP.LoadInTime = 0.25 // how long to replenish the visible "belt" of ammo

// sounds

SWEP.Sound_Shoot = "^"
SWEP.Sound_Shoot_Silenced = ""

SWEP.Vol_Shoot = 130
SWEP.Pitch_Shoot = 100
SWEP.Loudness_Shoot = 1
SWEP.ShootPitchVariance = 2.5 // amount to vary pitch by each shot

SWEP.Sound_ScopeIn = ""
SWEP.Sound_MeleeAttack = ""
SWEP.Sound_DryFire = "TacRP/weapons/dryfire_pistol-1.wav"
SWEP.Sound_Jam = "TacRP/malfunction.wav"

SWEP.Sound_MeleeSwing = ""

// effects

// the .qc attachment for the muzzle
SWEP.QCA_Muzzle = 1
// ditto for shell
SWEP.QCA_Eject = 2

SWEP.MuzzleEffect = "muzzleflash_pistol"

SWEP.EjectEffect = 1 // 1 = pistol, 2 = rifle, 3 = shotgun
SWEP.EjectDelay = 0

// anims

// VM:
// idle
// fire
// fire1, fire2...
// dryfire
// melee
// reload
// midreload
// prime_grenade
// throw_grenade
// throw_grenade_underhand
// deploy
// blind_idle
// blind_fire
// blind_fire1, blind_fire2...
// blind_dryfire

// WM:
// attack1
SWEP.AnimationTranslationTable = {
    ["melee"] = {"melee1", "melee2"},
    ["jam"] = "midreload"
} // translates ["fire"] = "shoot"; key = translates from, value = translates to
// e.g. you have a "shoot1" sequence and need "fire"
// so ["fire"] = "shoot1"
// can be ["fire"] = {"list", "of", "values"}

SWEP.ProceduralIronFire = nil // procedurally animate the viewmodel and bones when using ironsights
// {
//     vm_pos = Vector(0, -0.5, -0.6),
//     vm_ang = Angle(0, 2, 0),
//     t = 0.2, // duration of vm pos/ang
//     tmax = 0.2, // clean up after this time has passed
//     bones = {
//         {
//             bone = "ValveBiped.slide",
//             pos = Vector(0, 0, -3), // optional
//             ang = Angle(0, 0, 0), // optional
//             t0 = 0.05, // duration to reach full movement
//             t1 = 0.2, // duration to reset
//         },
//     },
// }

SWEP.NoHolsterAnimation = false // Will play draw reversed instead
SWEP.LastShot = false
SWEP.Akimbo = false

// attachments

SWEP.AttachmentElements = {
    ["bg_name"] = {
        BGs_VM = {
            {1, 1}
        },
        BGs_WM = {
            {1, 1}
        },
    }
}

SWEP.Attachments = nil
// {
//     [1] = {
//         Installed = nil,
//         Default = nil, // install this attachment by default
//         InstalledElements = "", // single or list of elements to activate when something is installed here
//         UnInstalledElements = "",
//         Integral = false, // cannot be removed
//         Category = "", // single or {"list", "of", "values"}
//         Bone = "",
//         WMBone = "",
//         Pos_VM = Vector(0, 0, 0),
//         Pos_WM = Vector(0, 0, 0),
//         Ang_VM = Angle(0, 0, 0),
//         Ang_WM = Angle(0, 0, 0),
//         CapacityMult = 1, // multiply the amount of Capacity this attachment occupies
//     }
// }

// boilerplate

SWEP.FreeAim = true

SWEP.ArcticTacRP = true
SWEP.DrawCrosshair = true
SWEP.AccurateCrosshair = true
SWEP.DrawWeaponInfoBox = false
SWEP.UseHands = true

SWEP.Shields = {}

SWEP.CurrentAnimation = ""

SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 0
SWEP.Primary.Ammo = ""
SWEP.Primary.DefaultClip = 0

SWEP.Secondary.Automatic = true
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Ammo = ""

SWEP.GaveDefaultAmmo = false

SWEP.BounceWeaponIcon = false

SWEP.SwayScale = 1
SWEP.BobScale = 1

SWEP.ActiveEffects = {}

AddCSLuaFile()

local searchdir = "weapons/tacrp_base"

local function autoinclude(dir)
    local files, dirs = file.Find(searchdir .. "/*.lua", "LUA")

    for _, filename in pairs(files) do
        if filename == "shared.lua" then continue end
        local luatype = string.sub(filename, 1, 2)

        if luatype == "sv" then
            if SERVER then
                include(dir .. "/" .. filename)
            end
        elseif luatype == "cl" then
            AddCSLuaFile(dir .. "/" .. filename)
            if CLIENT then
                include(dir .. "/" .. filename)
            end
        else
            AddCSLuaFile(dir .. "/" .. filename)
            include(dir .. "/" .. filename)
        end
    end

    for _, path in pairs(dirs) do
        autoinclude(dir .. "/" .. path)
    end
end

autoinclude(searchdir)

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "RecoilAmount")
    self:NetworkVar("Float", 1, "AnimLockTime")
    self:NetworkVar("Float", 2, "NextIdle")
    self:NetworkVar("Float", 3, "LastRecoilTime")
    self:NetworkVar("Float", 4, "RecoilDirection")
    self:NetworkVar("Float", 5, "NWSprintAmount")
    self:NetworkVar("Float", 6, "SprintLockTime")
    self:NetworkVar("Float", 7, "LastScopeTime")
    self:NetworkVar("Float", 8, "LastMeleeTime")
    self:NetworkVar("Float", 9, "PrimedGrenadeTime")
    self:NetworkVar("Float", 10, "StartPrimedGrenadeTime")
    self:NetworkVar("Float", 11, "ReloadFinishTime")
    self:NetworkVar("Float", 12, "NWSightAmount")
    self:NetworkVar("Float", 13, "BlindFireFinishTime")
    self:NetworkVar("Float", 14, "HolsterTime")
    self:NetworkVar("Float", 15, "NWLastProceduralFireTime")

    self:NetworkVar("Int", 0, "BurstCount")
    self:NetworkVar("Int", 1, "ScopeLevel")
    self:NetworkVar("Int", 2, "NthShot")
    self:NetworkVar("Int", 3, "LoadedRounds")
    self:NetworkVar("Int", 4, "Firemode")

    self:NetworkVar("Bool", 0, "Customize")
    self:NetworkVar("Bool", 1, "Reloading")
    self:NetworkVar("Bool", 2, "BlindFire")
    self:NetworkVar("Bool", 3, "EndReload")
    self:NetworkVar("Bool", 4, "PrimedGrenade")
    self:NetworkVar("Bool", 5, "Safe")
    self:NetworkVar("Bool", 6, "BlindFireLeft")
    self:NetworkVar("Bool", 7, "NWTactical")
    self:NetworkVar("Bool", 8, "Charge")
    self:NetworkVar("Bool", 9, "Peeking")
    self:NetworkVar("Bool", 10, "BlindFireRight") // bleh, but actually less networking load than using an integer (32 bit)
    self:NetworkVar("Bool", 11, "Jammed")

    self:NetworkVar("Angle", 0, "FreeAimAngle")
    self:NetworkVar("Angle", 1, "LastAimAngle")

    self:NetworkVar("Entity", 0, "HolsterEntity")

    self:SetFreeAimAngle(Angle(0, 0, 0))
    self:SetLastAimAngle(Angle(0, 0, 0))
    self:SetFiremode(1)
    self:SetTactical(true)
end

function SWEP:SecondaryAttack()
    self:RunHook("Hook_SecondaryAttack")
    return
end

local function clunpredictvar(tbl, name, varname, default)
    local clvar = "CL_" .. name

    tbl[clvar] = default

    tbl["Set" .. name] = function(self, v)
        if (!game.SinglePlayer() and CLIENT and self:GetOwner() == LocalPlayer()) then self[clvar] = v end
        self["Set" .. varname](self, v)
    end

    tbl["Get" .. name] = function(self)
        if (!game.SinglePlayer() and CLIENT and self:GetOwner() == LocalPlayer()) then return self[clvar] end
        return self["Get" .. varname](self)
    end
end

clunpredictvar(SWEP, "Tactical", "NWTactical", true)
clunpredictvar(SWEP, "SightAmount", "NWSightAmount", 0)
clunpredictvar(SWEP, "SprintAmount", "NWSprintAmount", 0)
clunpredictvar(SWEP, "LastProceduralFireTime", "NWLastProceduralFireTime", 0)