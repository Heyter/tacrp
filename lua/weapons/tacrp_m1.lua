SWEP.Base = "tacrp_base"
SWEP.Spawnable = true

AddCSLuaFile()

// names and stuff
SWEP.PrintName = "Ruger Mini-14"
SWEP.Category = "Tactical RP" // "Tactical RP (Arctic)"

SWEP.SubCatTier = "4Common"
SWEP.SubCatType = "6Precision Rifle"

SWEP.Description = "Lightweight rifle with no stock or optic mount.\nGood hip-fire accuracy among rifles, but range is low."

SWEP.ViewModel = "models/weapons/tacint/v_m1.mdl"
SWEP.WorldModel = "models/weapons/tacint/w_m1.mdl"

SWEP.Slot = 2

SWEP.BalanceStats = {
    [TacRP.BALANCE_SBOX] = {
        Damage_Max = 22,
        Damage_Min = 12,

        RPM = 600,
        RecoilSpreadPenalty = 0.003,
        HipFireSpreadPenalty = 0.008,

        MoveSpeedMult = 0.95,
        ShootingSpeedMult = 0.85,
        SightedSpeedMult = 0.9,
        MeleeSpeedMult = 1,
        ReloadSpeedMult = 1,
    },
    [TacRP.BALANCE_TTT] = {

        Damage_Max = 18,
        Damage_Min = 12,
        Range_Min = 600,
        Range_Max = 1500,
        RPM = 300,

        Spread = 0.0075,
        HipFireSpreadPenalty = 0.005,
        RecoilSpreadPenalty = 0.005,
        RecoilDissipationRate = 6,

        BodyDamageMultipliers = {
            [HITGROUP_HEAD] = 3,
            [HITGROUP_CHEST] = 1.25,
            [HITGROUP_STOMACH] = 1,
            [HITGROUP_LEFTARM] = 0.9,
            [HITGROUP_RIGHTARM] = 0.9,
            [HITGROUP_LEFTLEG] = 0.75,
            [HITGROUP_RIGHTLEG] = 0.75,
            [HITGROUP_GEAR] = 0.9
        },

        ReloadTimeMult = 1.25,

        MoveSpeedMult = 0.9,
        ShootingSpeedMult = 0.8,
        MeleeSpeedMult = 1,
        SightedSpeedMult = 0.65,
        ReloadSpeedMult = 0.65,
    },
}

SWEP.TTTReplace = TacRP.TTTReplacePreset.AssaultRifle

// "ballistics"

SWEP.Damage_Max = 18
SWEP.Damage_Min = 8
SWEP.Range_Min = 800 // distance for which to maintain maximum damage
SWEP.Range_Max = 4000 // distance at which we drop to minimum damage
SWEP.Penetration = 7 // units of metal this weapon can penetrate

SWEP.BodyDamageMultipliers = {
    [HITGROUP_HEAD] = 2,
    [HITGROUP_CHEST] = 1.25,
    [HITGROUP_STOMACH] = 1,
    [HITGROUP_LEFTARM] = 1,
    [HITGROUP_RIGHTARM] = 1,
    [HITGROUP_LEFTLEG] = 0.9,
    [HITGROUP_RIGHTLEG] = 0.9,
    [HITGROUP_GEAR] = 0.9
}

SWEP.MuzzleVelocity = 22000

// misc. shooting

SWEP.Firemode = 1

SWEP.RPM = 400

SWEP.Spread = 0.0035
SWEP.HipFireSpreadPenalty = 0.0065

SWEP.RecoilPerShot = 1
SWEP.RecoilMaximum = 6
SWEP.RecoilResetTime = 0.12 // time after you stop shooting for recoil to start dissipating
SWEP.RecoilDissipationRate = 10
SWEP.RecoilFirstShotMult = 0.8

SWEP.RecoilVisualKick = 1

SWEP.RecoilKick = 5


SWEP.RecoilSpreadPenalty = 0.003 // extra spread per one unit of recoil

SWEP.CanBlindFire = true

// handling

SWEP.MoveSpeedMult = 0.85
SWEP.ShootingSpeedMult = 0.5
SWEP.SightedSpeedMult = 0.35

SWEP.ReloadSpeedMult = 0.5

SWEP.AimDownSightsTime = 0.28
SWEP.SprintToFireTime = 0.32

SWEP.Sway = 1
SWEP.ScopedSway = 0.25

// hold types

SWEP.HoldType = "ar2"
SWEP.HoldTypeSprint = "passive"
SWEP.HoldTypeBlindFire = false

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.PassiveAng = Angle(0, 0, 0)
SWEP.PassivePos = Vector(0, -2, -4)

SWEP.BlindFireAng = Angle(0, 5, 0)
SWEP.BlindFirePos = Vector(3, -2, -5)

SWEP.SprintAng = Angle(30, -15, 0)
SWEP.SprintPos = Vector(5, 0, -2)

SWEP.SightAng = Angle(0, -0.9, 0)
SWEP.SightPos = Vector(-5.381, -9, -1.99)

SWEP.HolsterVisible = true
SWEP.HolsterSlot = TacRP.HOLSTER_SLOT_BACK
SWEP.HolsterPos = Vector(5, -8, -6)
SWEP.HolsterAng = Angle(0, 0, 0)

// reload

SWEP.ClipSize = 20
SWEP.Ammo = "smg1"

SWEP.ReloadTimeMult = 1
SWEP.DropMagazineModel = "models/weapons/tacint/magazines/m4.mdl"
SWEP.DropMagazineImpact = "metal"

// sounds

local path = "tacrp/weapons/m1/"

SWEP.Sound_Shoot = "^" .. path .. "fire-1.wav"
SWEP.Sound_Shoot_Silenced = path .. "fire_silenced-1.wav"

SWEP.Vol_Shoot = 130
SWEP.ShootPitchVariance = 2.5 // amount to vary pitch by each shot

// effects

// the .qc attachment for the muzzle
SWEP.QCA_Muzzle = 1
// ditto for shell
SWEP.QCA_Eject = 2

SWEP.MuzzleEffect = "muzzleflash_ak47"
SWEP.EjectEffect = 2

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
    ["fire1"] = "fire1_M",
    ["fire2"] = "fire2_M",
    ["fire3"] = "fire3_M",
    ["fire4"] = "fire4_M",
    ["fire5"] = "fire5_M",
    ["melee"] = {"melee1", "melee2"}
}

// attachments

SWEP.AttachmentElements = {
    ["foldstock"] = {
        BGs_VM = {
            {1, 1}
        },
        BGs_WM = {
            {1, 1}
        }
    },
    ["tactical"] = {
        BGs_VM = {
            {2, 1}
        },
    },
}


SWEP.Attachments = {
    [1] = {
        PrintName = "Muzzle",
        Category = "silencer",
        Bone = "m1_root",
        WMBone = "Box01",
        AttachSound = "tacrp/weapons/silencer_on.wav",
        DetachSound = "tacrp/weapons/silencer_off.wav",
        Pos_VM = Vector(5, 0.075, 33.5),
        Pos_WM = Vector(0.1, 29, -0.1),
        Ang_VM = Angle(90, 0, 0),
        Ang_WM = Angle(0, -90, 0),
    },
    [2] = {
        PrintName = "Tactical",
        Category = "tactical",
        Bone = "m1_root",
        WMBone = "Box01",
        AttachSound = "tacrp/weapons/flashlight_on.wav",
        DetachSound = "tacrp/weapons/flashlight_off.wav",
        InstalledElements = {"tactical"},
        Pos_VM = Vector(4, 0.75, 24),
        Pos_WM = Vector(0.9, 17, -1),
        Ang_VM = Angle(90, 0, 90),
        Ang_WM = Angle(-70, -90, 0),
    },
    [3] = {
        PrintName = "Accessory",
        Category = {"acc", "perk_extendedmag", "acc_sling", "acc_duffle"},
        AttachSound = "tacrp/weapons/flashlight_on.wav",
        DetachSound = "tacrp/weapons/flashlight_off.wav",
    },
    [4] = {
        PrintName = "Bolt",
        Category = {"bolt_automatic"},
        AttachSound = "TacRP/weapons/flashlight_on.wav",
        DetachSound = "TacRP/weapons/flashlight_off.wav",
    },
    [5] = {
        PrintName = "Trigger",
        Category = {"trigger_semi"},
        AttachSound = "TacRP/weapons/flashlight_on.wav",
        DetachSound = "TacRP/weapons/flashlight_off.wav",
    },
    [6] = {
        PrintName = "Ammo",
        Category = {"ammo_rifle"},
        AttachSound = "TacRP/weapons/flashlight_on.wav",
        DetachSound = "TacRP/weapons/flashlight_off.wav",
    },
    [7] = {
        PrintName = "Perk",
        Category = {"perk", "perk_melee", "perk_shooting", "perk_reload"},
        AttachSound = "tacrp/weapons/flashlight_on.wav",
        DetachSound = "tacrp/weapons/flashlight_off.wav",
    },
}