SWEP.Base = "tacrp_base"
SWEP.Spawnable = true

AddCSLuaFile()

// names and stuff
SWEP.PrintName = "Colt M1911"
SWEP.Category = "Tactical RP" // "Tactical RP (Extras)"

SWEP.SubCatTier = "4Common"
SWEP.SubCatType = "1Sidearm"

SWEP.Description = "Surplus pistol from an era before tactical attachments and pistol optics, yet still hits quite hard."

SWEP.ViewModel = "models/weapons/tacint_extras/v_m1911.mdl"
SWEP.WorldModel = "models/weapons/tacint_extras/w_m1911.mdl"

SWEP.Slot = 1

SWEP.BalanceStats = {
    [TacRP.BALANCE_SBOX] = {
        Damage_Max = 30,
        Damage_Min = 8,

        MoveSpeedMult = 1,
        ShootingSpeedMult = 1,
        SightedSpeedMult = 1,
        MeleeSpeedMult = 1,
        ReloadSpeedMult = 1,
    },
    [TacRP.BALANCE_TTT] = {
        Damage_Max = 30,
        Damage_Min = 9,
        Range_Min = 250,
        Range_Max = 1500,
        RPM = 200,

        RecoilMaximum = 3,
        RecoilResetTime = 0.25,
        RecoilDissipationRate = 5,
        RecoilFirstShotMult = 0.8,
        RecoilSpreadPenalty = 0.015,

        BodyDamageMultipliers = {
            [HITGROUP_HEAD] = 2.5,
            [HITGROUP_CHEST] = 1.25,
            [HITGROUP_STOMACH] = 1,
            [HITGROUP_LEFTARM] = 0.9,
            [HITGROUP_RIGHTARM] = 0.9,
            [HITGROUP_LEFTLEG] = 0.75,
            [HITGROUP_RIGHTLEG] = 0.75,
            [HITGROUP_GEAR] = 0.9
        },

        ReloadTimeMult = 1.25,

        MoveSpeedMult = 1,
        ShootingSpeedMult = 1,
        MeleeSpeedMult = 1,
        SightedSpeedMult = 0.75,
        ReloadSpeedMult = 0.9,
    },
}

SWEP.TTTReplace = TacRP.TTTReplacePreset.Pistol

// "ballistics"

SWEP.Damage_Max = 18
SWEP.Damage_Min = 5
SWEP.Range_Min = 400
SWEP.Range_Max = 3000
SWEP.Penetration = 3 // units of metal this weapon can penetrate

SWEP.MuzzleVelocity = 8000

SWEP.BodyDamageMultipliers = {
    [HITGROUP_HEAD] = 2.5,
    [HITGROUP_CHEST] = 1.25,
    [HITGROUP_STOMACH] = 1,
    [HITGROUP_LEFTARM] = 1,
    [HITGROUP_RIGHTARM] = 1,
    [HITGROUP_LEFTLEG] = 0.75,
    [HITGROUP_RIGHTLEG] = 0.75,
    [HITGROUP_GEAR] = 0.9
}

// misc. shooting

SWEP.Firemode = 1

SWEP.RPM = 420

SWEP.Spread = 0.007
SWEP.RecoilSpreadPenalty = 0.006
SWEP.HipFireSpreadPenalty = 0.01

SWEP.ShootTimeMult = 0.5

SWEP.RecoilPerShot = 1
SWEP.RecoilMaximum = 4
SWEP.RecoilResetTime = 0.15
SWEP.RecoilDissipationRate = 8
SWEP.RecoilFirstShotMult = 0.6

SWEP.RecoilVisualKick = 3

SWEP.RecoilKick = 7

SWEP.CanBlindFire = true

// handling

SWEP.MoveSpeedMult = 0.9
SWEP.ShootingSpeedMult = 0.6
SWEP.SightedSpeedMult = 0.5

SWEP.ReloadSpeedMult = 0.75

SWEP.AimDownSightsTime = 0.25
SWEP.SprintToFireTime = 0.25

SWEP.Sway = 1
SWEP.ScopedSway = 0.5

// hold types

SWEP.HoldType = "revolver"
SWEP.HoldTypeSprint = "normal"
SWEP.HoldTypeBlindFire = "pistol"

SWEP.GestureShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
SWEP.GestureReload = ACT_HL2MP_GESTURE_RELOAD_PISTOL

SWEP.PassiveAng = Angle(0, 0, 0)
SWEP.PassivePos = Vector(0, -2, -5)

SWEP.BlindFireAng = Angle(0, 5, 0)
SWEP.BlindFirePos = Vector(0, -2, -5)

SWEP.BlindFireSuicideAng = Angle(-125, 0, 45)
SWEP.BlindFireSuicidePos = Vector(25, 14, -5.5)

SWEP.SprintAng = Angle(0, 30, 0)
SWEP.SprintPos = Vector(2, 0, -12)

SWEP.SightAng = Angle(0, -0.1, 0)
SWEP.SightPos = Vector(-3.25, 0, -3.77)

SWEP.HolsterVisible = true
SWEP.HolsterSlot = TacRP.HOLSTER_SLOT_PISTOL
SWEP.HolsterPos = Vector(0, 3, -4)
SWEP.HolsterAng = Angle(90, 0, 0)

// reload

SWEP.ClipSize = 7
SWEP.Ammo = "pistol"

SWEP.ReloadTimeMult = 1

SWEP.DropMagazineModel = "models/weapons/tacint/magazines/gsr1911.mdl"
SWEP.DropMagazineImpact = "pistol"

// sounds

local path = "tacrp_extras/m1911/"
local path2 = "TacRP/weapons/gsr1911/gsr1911_"

SWEP.Sound_Shoot = "^" .. path .. "fire-1.wav"
SWEP.Sound_Shoot_Silenced = path2 .. "fire_silenced-1.wav"

SWEP.Vol_Shoot = 130
SWEP.ShootPitchVariance = 2.5 // amount to vary pitch by each shot

// effects

// the .qc attachment for the muzzle
SWEP.QCA_Muzzle = 4

SWEP.MuzzleEffect = "muzzleflash_pistol"

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
    ["deploy"] = "draw",
    ["fire"] = {"shoot1", "shoot2", "shoot3"},
    ["blind_fire"] = {"blind_shoot1", "blind_shoot2", "blind_shoot3"},
    ["melee"] = {"melee1", "melee2"}
}

SWEP.ProceduralIronFire = {
    vm_pos = Vector(0, -0.5, -0.6),
    vm_ang = Angle(0, 2, 0),
    t = 0.2,
    tmax = 0.2,
    bones = {
        {
            bone = "ValveBiped.slide",
            pos = Vector(0, 0, -3),
            t0 = 0,
            t1 = 0.1,
        },
        {
            bone = "ValveBiped.hammer",
            ang = Angle(-15, 0, 0),
            t0 = 0,
            t1 = 0.15,
        },
        {
            bone = "ValveBiped.Bip01_R_Finger1",
            ang = Angle(0, -15, 0),
            t0 = 0,
            t1 = 0.2,
        },
        {
            bone = "ValveBiped.Bip01_R_Finger11",
            ang = Angle(-35, 0, 0),
            t0 = 0,
            t1 = 0.15,
        },
    },
}

SWEP.LastShot = true

// attachments

SWEP.Attachments = {
    [1] = {
        PrintName = "Muzzle",
        Category = {"silencer"},
        Bone = "ValveBiped.barrel",
        WMBone = "Box01",
        AttachSound = "TacRP/weapons/silencer_on.wav",
        DetachSound = "TacRP/weapons/silencer_off.wav",
        VMScale = 0.5,
        WMScale = 0.5,
        Pos_VM = Vector(-0.76, 0.7, 7.5),
        Ang_VM = Angle(90, 0, 0),
        Pos_WM = Vector(0, 9.25, -1.5),
        Ang_WM = Angle(0, -90, 0),
    },
    [2] = {
        PrintName = "Accessory",
        Category = {"acc", "acc_extmag_pistol2", "acc_holster", "acc_brace"},
        AttachSound = "TacRP/weapons/flashlight_on.wav",
        DetachSound = "TacRP/weapons/flashlight_off.wav",
    },
    [3] = {
        PrintName = "Bolt",
        Category = {"bolt_automatic"},
        AttachSound = "TacRP/weapons/flashlight_on.wav",
        DetachSound = "TacRP/weapons/flashlight_off.wav",
    },
    [4] = {
        PrintName = "Trigger",
        Category = {"trigger_semi"},
        AttachSound = "TacRP/weapons/flashlight_on.wav",
        DetachSound = "TacRP/weapons/flashlight_off.wav",
    },
    [5] = {
        PrintName = "Ammo",
        Category = {"ammo_pistol"},
        AttachSound = "TacRP/weapons/flashlight_on.wav",
        DetachSound = "TacRP/weapons/flashlight_off.wav",
    },
    [6] = {
        PrintName = "Perk",
        Category = {"perk", "perk_melee", "perk_shooting", "perk_reload"},
        AttachSound = "tacrp/weapons/flashlight_on.wav",
        DetachSound = "tacrp/weapons/flashlight_off.wav",
    },
}

local function addsound(name, spath)
    sound.Add({
        name = name,
        channel = 16,
        volume = 1.0,
        sound = spath
    })
end

addsound("tacint_extras_m1911.clip_in", path .. "clipin.mp3")
addsound("tacint_extras_m1911.clip_in-mid", path2 .. "clip_in-mid.wav")
addsound("tacint_extras_m1911.clip_out", path .. "clipout.mp3")
addsound("tacint_extras_m1911.slide_action", path2 .. "slide_action.wav")
addsound("tacint_extras_m1911.slide_shut", path2 .. "slide_shut.wav")
addsound("tacint_extras_m1911.cock_hammer", path2 .. "cockhammer.wav")
