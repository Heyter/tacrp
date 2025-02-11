local function addsound(name, spath)
    sound.Add({
        name = name,
        channel = 16,
        volume = 1.0,
        sound = spath
    })
end

-- addsound("Grenade.PullPin", {
--     "TacRP/weapons/grenade/pullpin-1.wav",
--     "TacRP/weapons/grenade/pullpin-2.wav"
-- })

addsound("Grenade.PullPin", "common/null.wav")

addsound("Grenade.Throw", {
    "TacRP/weapons/grenade/throw-1.wav",
    "TacRP/weapons/grenade/throw-2.wav"
})

addsound("TacInt_genericrifle.jingle", {
    "TacRP/weapons/rifle_jingle-1.wav",
    "TacRP/weapons/rifle_jingle-2.wav",
    "TacRP/weapons/rifle_jingle-3.wav",
    "TacRP/weapons/rifle_jingle-4.wav",
    "TacRP/weapons/rifle_jingle-5.wav",
    "TacRP/weapons/rifle_jingle-6.wav",
})

addsound("weapon.swing", {
    "TacRP/weapons/swing_rifle-1.wav",
    "TacRP/weapons/swing_rifle-2.wav"
})

addsound("weapon.thrust", {
    "TacRP/weapons/thrust_rifle-1.wav",
    "TacRP/weapons/thrust_rifle-2.wav"
})

addsound("TacInt_genericpistol.holster", {
    "TacRP/weapons/pistol_holster-1.wav",
    "TacRP/weapons/pistol_holster-2.wav",
    "TacRP/weapons/pistol_holster-3.wav",
    "TacRP/weapons/pistol_holster-4.wav",
})

addsound("TacInt_genericpistol.unholster", {
    "TacRP/weapons/pistol_unholster-1.wav",
    "TacRP/weapons/pistol_unholster-2.wav",
    "TacRP/weapons/pistol_unholster-3.wav",
    "TacRP/weapons/pistol_unholster-4.wav",
})

addsound("Weapon.Pistol_Clip_Scrape_Metal", {
    "TacRP/weapons/pistol_clip_scrape_metal-1.wav",
    "TacRP/weapons/pistol_clip_scrape_metal-2.wav",
    "TacRP/weapons/pistol_clip_scrape_metal-3.wav",
    "TacRP/weapons/pistol_clip_scrape_metal-4.wav",
})

addsound("Weapon.Pistol_Clip_Scrape_plastic", {
    "TacRP/weapons/pistol_clip_scrape_plastic-1.wav",
    "TacRP/weapons/pistol_clip_scrape_plastic-2.wav",
    "TacRP/weapons/pistol_clip_scrape_plastic-3.wav",
})