function SWEP:Attach(slot, att, silent)
    local slottbl = self.Attachments[slot]
    if slottbl.Installed then return end

    if !self:CanAttach(slot, att) then return end

    local atttbl = TacRP.GetAttTable(att)

    if !atttbl then return end
    if TacRP:PlayerGetAtts(self:GetOwner(), att) <= 0 then return end

    local inf_old = self:GetValue("InfiniteAmmo")

    slottbl.Installed = att

    TacRP:PlayerTakeAtt(self:GetOwner(), att, 1)

    if CLIENT then
        local attid = atttbl.ID

        net.Start("TacRP_attach")
        net.WriteEntity(self)
        net.WriteBool(true)
        net.WriteUInt(slot, 8)
        net.WriteUInt(attid, TacRP.Attachments_Bits)
        net.SendToServer()

        self:SetupModel(true)
        self:SetupModel(false)

        if !silent then
            surface.PlaySound(slottbl.AttachSound or "")
        end
    else
        self:NetworkWeapon()

        TacRP:PlayerSendAttInv(self:GetOwner())
    end

    self:InvalidateCache()

    self:SetBaseSettings()

    if atttbl.CanToggle then
        self:SetTactical(true)
    end

    if self:GetCurrentFiremode() == 0 then
        self:SetFiremode(1)
    end

    local inf_new = self:GetValue("InfiniteAmmo")
    if SERVER then
        if inf_old and !inf_new then
            self:SetClip1(0)
        elseif inf_new and !inf_old then
            self:Unload()
        end
    end
end

function SWEP:Detach(slot, silent)
    local slottbl = self.Attachments[slot]
    if !slottbl.Installed then return end

    if !self:CanDetach(slot) then return end

    TacRP:PlayerGiveAtt(self:GetOwner(), slottbl.Installed, 1)

    local inf_old = self:GetValue("InfiniteAmmo")

    slottbl.Installed = nil

    if CLIENT then
        net.Start("TacRP_attach")
        net.WriteEntity(self)
        net.WriteBool(false)
        net.WriteUInt(slot, 8)
        net.SendToServer()

        self:SetupModel(true)
        self:SetupModel(false)

        if !silent then
            surface.PlaySound(slottbl.DetachSound or "")
        end
    else
        self:NetworkWeapon()

        TacRP:PlayerSendAttInv(self:GetOwner())
    end

    self:InvalidateCache()

    self:SetBaseSettings()

    local nade = self:GetGrenade()
    if (nade.AdminOnly and self:GetOwner():GetAmmoCount(nade.Ammo) <= 0) or (nade.RequireStat and !self:GetValue(nade.RequireStat)) then
        self:SelectGrenade()
    end

    local inf_new = self:GetValue("InfiniteAmmo")
    if SERVER then
        if inf_old and !inf_new then
            self:SetClip1(0)
        elseif inf_new and !inf_old then
            self:Unload()
        end
    end
end

function SWEP:ToggleCustomize(on)
    if on == self:GetCustomize() or (self:GetValue("RunawayBurst") and self:GetBurstCount() > 0) then return end

    self:ScopeToggle(0)
    self:ToggleBlindFire(TacRP.BLINDFIRE_NONE)

    self:SetCustomize(on)

    self:SetShouldHoldType()
end

function SWEP:CanAttach(slot, att)
    local atttbl = TacRP.GetAttTable(att)

    local slottbl = self.Attachments[slot]

    local cat = slottbl.Category

    if !istable(cat) then
        cat = {cat}
    end

    local attcat = atttbl.Category

    if !istable(attcat) then
        attcat = {attcat}
    end

    if !TacRP.CanCustomize(self:GetOwner(), self, att, slot) then return false end

    for _, c in pairs(attcat) do
        if table.HasValue(cat, c) then
            return true
        end
    end

    return false
end

function SWEP:CanDetach(slot)
    local slottbl = self.Attachments[slot]

    if slottbl.Integral then return false end

    if !TacRP.CanCustomize(self:GetOwner(), self, att, slot) then return false end

    return true
end