ATT.PrintName = "+P"
ATT.FullName = "Overpressured Rounds"
ATT.Icon = Material("entities/tacrp_att_acc_plusp.png", "mips smooth")
ATT.Description = "Bullets that maintain close range power better, but have higher recoil."
ATT.Pros = {"Minimum Range", "Muzzle Velocity"}
ATT.Cons = {"Recoil Kick", "Spread"}

ATT.Category = {"ammo_pistol", "ammo_rifle"}

ATT.SortOrder = 5

ATT.Add_RecoilKick = 0.5
ATT.Mult_RecoilKick = 1.15
ATT.Mult_Spread = 1.25
ATT.Mult_MuzzleVelocity = 1.2
ATT.Mult_Range_Min = 1.5