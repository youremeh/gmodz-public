util.AddNetworkString("GlobalChat")
util.AddNetworkString("TradeChat")
util.AddNetworkString("GroupChat")
util.AddNetworkString("ProximityChat")

function GM:PlayerSay(ply, text, team, is_dead)
    if string.find(string.lower(text), "/g ") == 1 or string.find(string.lower(text), "// ") == 1 then
        net.Start("GlobalChat")
        net.WriteEntity(ply)
        net.WriteString(string.sub(text, 4))
        net.Broadcast()
        print("GLOBAL: "..ply:Nick() .. ": "..string.sub(text, 4))
    elseif string.find(string.lower(text), "/ooc ") == 1 then
        net.Start("GlobalChat")
        net.WriteEntity(ply)
        net.WriteString(string.sub(text, 6))
        net.Broadcast()
        print("GLOBAL: "..ply:Nick() .. ": "..string.sub(text, 6))
    elseif string.find(string.lower(text), "/trade ") == 1 then
        net.Start("TradeChat")
        net.WriteEntity(ply)
        net.WriteString(string.sub(text, 8))
        net.Broadcast()
        print("TRADE: "..ply:Nick() .. ": "..string.sub(text, 8))
    elseif string.find(string.lower(text), "/group ") == 1 then
        for _, ent in pairs(player.GetAll()) do
            if (ply.Group and ply.Group:IsValid() and ply.Group == ent.Group) then
                net.Start("GroupChat")
                net.WriteEntity(ply)
                net.WriteString(string.sub(text, 8))
                net.Send(ent)
                print("GROUP CHAT: "..ply:Nick() .. ": "..string.sub(text, 8))
            else
                ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You're not in a group!")
                print("NO GROUP: "..ply:Nick() .. ": "..string.sub(text, 8))
            end
        end
    else
        for _, ent in pairs(player.GetAll()) do
            if ply:GetPos():Distance(ent:GetPos()) < 450 then
                net.Start("ProximityChat")
                net.WriteEntity(ply)
                net.WriteString(text)
                net.Send(ent)
            end
        end
        print("PROXIMITY: "..ply:Nick() .. ": "..text)
    end
    return false
end

function GM:PlayerCanHearPlayersVoice(plOne, plTwo)
    local ply1pos = plOne:GetPos()
    local ply2pos = plTwo:GetPos()
    if plOne:Alive() then
        return ply1pos:Distance(ply2pos) <= 425
    else
        return false
    end
end