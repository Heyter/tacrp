SWEP.SmoothedMagnification = 1

function SWEP:CalcView(ply, pos, ang, fov)
    local rec = (self:GetLastRecoilTime() + self:GetValue("RecoilResetTime")) - CurTime()

    rec = math.max(rec, 0)

    rec = rec * (self:GetValue("RecoilKick") + 1) * (self:GetRecoilAmount() / self:GetValue("RecoilMaximum")) ^ 0.75

    if !game.SinglePlayer() then
        rec = rec * 0.5 -- ???????????????
    end

    if rec > 0 then
        ang.r = ang.r + (math.sin(CurTime() * 70.151) * rec)
    end

    local mag = self:GetMagnification()

    local diff = math.abs(self.SmoothedMagnification - mag)

    self.SmoothedMagnification = math.Approach(self.SmoothedMagnification, mag, FrameTime() * diff * (self.SmoothedMagnification > mag and 10 or 5))

    fov = fov / self.SmoothedMagnification

    self.TacRPLastFOV = fov

    fov = fov - rec

    return pos, ang, fov
end