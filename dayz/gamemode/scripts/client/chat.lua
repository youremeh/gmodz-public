net.Receive("GlobalChat", function(len)
    chat.PlaySound()
    ChatPlayer = net.ReadEntity()
    if (not ChatPlayer or not ChatPlayer:IsValid()) then return false end
    chat.AddText(PlayerRank[ChatPlayer:GetNWInt("plevel")].Clr, '[', PlayerRank[ChatPlayer:GetNWInt("plevel")].Name, '] ', Color(200, 200, 200), ChatPlayer:Nick(), Color(125, 125, 125), " ", _U('chatGlobal'), Color(200, 200, 200), ": "..net.ReadString())
end)

net.Receive("TradeChat", function(len)
    chat.PlaySound()
    ChatPlayer = net.ReadEntity()
    if (not ChatPlayer or not ChatPlayer:IsValid()) then return false end
    chat.AddText(PlayerRank[ChatPlayer:GetNWInt("plevel")].Clr, '[', PlayerRank[ChatPlayer:GetNWInt("plevel")].Name, '] ', Color(200, 200, 200), ChatPlayer:Nick(), Color(220, 0, 255, 200), " ", _U('chatTrade'), Color(200, 200, 200), ": "..net.ReadString())
end)

net.Receive("ProximityChat", function(len)
    chat.PlaySound()
    local ChatPlayer = net.ReadEntity()
    if (not ChatPlayer or not ChatPlayer:IsValid()) then return false end
    chat.AddText(PlayerRank[ChatPlayer:GetNWInt("plevel")].Clr, '[', PlayerRank[ChatPlayer:GetNWInt("plevel")].Name, '] ', Color(200, 200, 200), ChatPlayer:Nick(), Color(255, 255, 255), " ", _U('chatNear'),  Color(200, 200, 200), ": "..net.ReadString())
end)

net.Receive("GroupChat", function(len)
    chat.PlaySound()
    ChatPlayer = net.ReadEntity()
    if (not ChatPlayer or not ChatPlayer:IsValid()) then return false end
    chat.AddText(PlayerRank[ChatPlayer:GetNWInt("plevel")].Clr, '[', PlayerRank[ChatPlayer:GetNWInt("plevel")].Name, '] ', Color(200, 200, 200), ChatPlayer:Nick(), Color(255, 255, 255), " ", _U('chatParty'), Color(200, 200, 200), ": "..net.ReadString())
end)