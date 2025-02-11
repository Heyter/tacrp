function TacRP:PlayerGetAtts(ply, att)
    if !IsValid(ply) then return 0 end
    if GetConVar("TacRP_free_atts"):GetBool() then return 999 end

    if att == "" then return 999 end

    local atttbl = TacRP.GetAttTable(att)

    if !atttbl then return 0 end

    if atttbl.Free then return 999 end

    if !IsValid(ply) then return 0 end

    if !ply:IsAdmin() and atttbl.AdminOnly then
        return 0
    end

    if atttbl.InvAtt then att = atttbl.InvAtt end

    if !ply.TacRP_AttInv then return 0 end

    if !ply.TacRP_AttInv[att] then return 0 end

    return ply.TacRP_AttInv[att]
end

function TacRP:PlayerGiveAtt(ply, att, amt)
    amt = amt or 1

    if !IsValid(ply) then return end

    if !ply.TacRP_AttInv then
        ply.TacRP_AttInv = {}
    end

    local atttbl = TacRP.GetAttTable(att)

    if !atttbl then print("Invalid att " .. att) return end
    if atttbl.Free then return end -- You can't give a free attachment, silly
    if atttbl.AdminOnly and !(ply:IsPlayer() and ply:IsAdmin()) then return false end

    if atttbl.InvAtt then att = atttbl.InvAtt end

    if GetConVar("TacRP_lock_atts"):GetBool() then
        if ply.TacRP_AttInv[att] == 1 then return end
        ply.TacRP_AttInv[att] = 1
    else
        ply.TacRP_AttInv[att] = (ply.TacRP_AttInv[att] or 0) + amt
    end
end


function TacRP:PlayerTakeAtt(ply, att, amt)
    amt = amt or 1

    if GetConVar("TacRP_lock_atts"):GetBool() then return end

    if !IsValid(ply) then return end

    if !ply.TacRP_AttInv then
        ply.TacRP_AttInv = {}
    end

    local atttbl = TacRP.GetAttTable(att)
    if !atttbl or atttbl.Free then return end

    if atttbl.InvAtt then att = atttbl.InvAtt end

    ply.TacRP_AttInv[att] = ply.TacRP_AttInv[att] or 0

    if ply.TacRP_AttInv[att] < amt then
        return false
    end

    ply.TacRP_AttInv[att] = ply.TacRP_AttInv[att] - amt
    if ply.TacRP_AttInv[att] <= 0 then
        ply.TacRP_AttInv[att] = nil
    end
    return true
end

if CLIENT then

net.Receive("TacRP_sendattinv", function(len, ply)
    LocalPlayer().TacRP_AttInv = {}

    local count = net.ReadUInt(32)

    for i = 1, count do
        local attid = net.ReadUInt(TacRP.Attachments_Bits)
        local acount = net.ReadUInt(32)

        local att = TacRP.Attachments_Index[attid]

        LocalPlayer().TacRP_AttInv[att] = acount
    end
end)

elseif SERVER then

hook.Add("PlayerDeath", "TacRP_DeathAttInv", function(ply)
    -- if GetConVar("TacRP_loseattsondie"):GetBool() then
    --     ply.TacRP_AttInv = ply.TacRP_AttInv or {}
    -- end
    -- if table.Count(ply.TacRP_AttInv) > 0
    --         and GetConVar("TacRP_attinv_loseondie"):GetInt() >= 2
    --         and !GetConVar("TacRP_free_atts"):GetBool() then
    --     local boxEnt = ents.Create("TacRP_att_dropped")
    --     boxEnt:SetPos(ply:GetPos() + Vector(0, 0, 4))
    --     boxEnt.GiveAttachments = ply.TacRP_AttInv
    --     boxEnt:Spawn()
    --     boxEnt:SetNWString("boxname", ply:GetName() .. "'s Death Box")
    --     local count = 0
    --     for i, v in pairs(boxEnt.GiveAttachments) do count = count + v end
    --     boxEnt:SetNWInt("boxcount", count)
    -- end
end)

hook.Add("PlayerSpawn", "TacRP_SpawnAttInv", function(ply, trans)
    if trans then return end

    if engine.ActiveGamemode() != "terrortown" and GetConVar("TacRP_loseattsondie"):GetInt() >= 1 then
        ply.TacRP_AttInv = {}

        TacRP:PlayerSendAttInv(ply)
    end
end)

function TacRP:PlayerSendAttInv(ply)
    if GetConVar("TacRP_free_atts"):GetBool() then return end

    if !IsValid(ply) then return end

    if !ply.TacRP_AttInv then return end

    net.Start("TacRP_sendattinv")

    net.WriteUInt(table.Count(ply.TacRP_AttInv), 32)

    for att, count in pairs(ply.TacRP_AttInv) do
        local atttbl = TacRP.GetAttTable(att)
        local attid = atttbl.ID
        net.WriteUInt(attid, TacRP.Attachments_Bits)
        net.WriteUInt(count, 32)
    end

    net.Send(ply)
end

end
