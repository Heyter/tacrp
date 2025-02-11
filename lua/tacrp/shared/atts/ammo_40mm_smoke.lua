ATT.PrintName = "Smoke"
ATT.FullName = "40mm Smoke Grenades"

ATT.Icon = Material("entities/tacrp_att_ammo_40mm_smoke.png", "mips smooth")
ATT.Description = "Grenade that produces a concealing smokescreen on impact."
ATT.Pros = {"Smokescreen"}
ATT.Cons = {"No damage"}

ATT.Category = "ammo_40mm"

ATT.SortOrder = 4

ATT.ShootEnt = "tacrp_proj_40mm_smoke"

ATT.InstalledElements = {"smoke"}

if engine.ActiveGamemode() == "terrortown" then
    ATT.Free = true
end