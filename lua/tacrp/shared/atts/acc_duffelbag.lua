ATT.PrintName = "Gun Bag"
ATT.Icon = Material("entities/tacrp_dufflebag.png", "mips smooth")
ATT.Description = "Hide the gun in a bag so you don't cause mass panic."
ATT.Pros = {"Conceal weapon in bag"}
// ATT.Cons = {"Slower draw speed"}

ATT.Category = "acc_duffle"

ATT.SortOrder = 8

ATT.Override_HolsterVisible = true
ATT.HolsterModel = "models/jessev92/payday2/item_bag_loot.mdl"
ATT.HolsterSlot = TacRP.HOLSTER_SLOT_BACK
ATT.HolsterPos = Vector(7, -2, 0)
ATT.HolsterAng = Angle(10, 90, 90)

// ATT.Mult_DeployTimeMult = 1.25

ATT.Ignore = true