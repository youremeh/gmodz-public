surface.CreateFont("ScoreboardHeader", {font = "Trebuchet24", weight = 1000, size = 35, scanlines = 2})
surface.CreateFont("ScoreboardHeaderNoLines", {font = "Trebuchet24", weight = 1000, size = 35, scanlines = 0})
surface.CreateFont("SubScoreboardHeader", {font = "Trebuchet24", weight = 1000, size = 22, scanlines = 2})
surface.CreateFont("ScoreboardContent", {font = "Trebuchet24", weight = 500, size = 16})
surface.CreateFont("Scoreboardtext", {font = "Trebuchet24", weight = 500, size = 18})

function GM:ScoreboardShow()
    GAMEMODE:HUDDrawScoreboard()
    gui.EnableScreenClicker(true)
    LocalPlayer().ScoreBoard = true
end

function GM:ScoreboardHide()
    DPanel_Scoreboard:SetVisible(false)
    gui.EnableScreenClicker(false)
    LocalPlayer().ScoreBoard = false
end

function GM:HUDDrawScoreboard()
    DPanel_Scoreboard = vgui.Create("DPanel")
    DPanel_Scoreboard:SetTall(740)
    DPanel_Scoreboard:SetWide(800)
    DPanel_Scoreboard:Center()
    DPanel_Scoreboard:SetVisible(true)
    DPanel_Scoreboard.Paint = function() draw.DrawText("", "ScoreboardContent", 425, 0, Color(200, 200, 200, 150), TEXT_ALIGN_RIGHT) end
    local DPanelList_Players = vgui.Create("DPanelList", DPanel_Scoreboard)
    DPanelList_Players:SetPos(0, 15)
    DPanelList_Players:SetTall(640)
    DPanelList_Players:SetWide(800)
    DPanelList_Players.Paint = function() end
    DPanelList_Players:SetSpacing(1)
    DPanelList_Players:EnableHorizontal(true)
    DPanelList_Players:EnableVerticalScrollbar(true)
    for _, ply in pairs(player.GetAll()) do
        if (ply and ply:IsValid()) then
            local plySteamID = ply:SteamID()
            local pLevel = ply:GetNWInt("plevel")
            local DButton_Player = vgui.Create("DButton")
            DButton_Player:SetPos(0, 0)
            DButton_Player:SetText("")
            DButton_Player:SetWide(390)
            DButton_Player:SetTall(35)
            DButton_Player.Paint = function()
                if not PlayerRank[pLevel] then return end
                if ply == selectedPlayer then
                    draw.RoundedBox(10, 0, 0, 390, 35, Color(0, 0, 0, 225))
                else
                    draw.RoundedBox(10, 0, 0, 390, 35, Color(0, 0, 0, 120))
                end
                if not ply.InGroup then
                    draw.RoundedBox(10, 0, 0, 390, 1, Color(0, 0, 0, 255))
                    draw.RoundedBox(10, 0, 34, 390, 1, Color(0, 0, 0, 255))
                    draw.RoundedBox(10, 0, 0, 1, 35, Color(0, 0, 0, 255))
                    draw.RoundedBox(10, 389, 0, 1, 35, Color(0, 0, 0, 255))
                else
                    draw.RoundedBox(10, 0, 0, 390, 1, Color(0, 220, 255, 255))
                    draw.RoundedBox(10, 0, 34, 390, 1, Color(0, 220, 255, 255))
                    draw.RoundedBox(10, 0, 0, 1, 35, Color(0, 220, 255, 255))
                    draw.RoundedBox(10, 389, 0, 1, 35, Color(0, 220, 255, 255))
                end
                draw.RoundedBox(10, 9, 1, 34, 34, PlayerRank[pLevel].Clr)
                if (ply and ply:IsValid()) then
                    if ply:Ping() < 100 then
                        draw.RoundedBox(10, 50, 28, 4, 4, Color(0, 255, 0, 255))
                        draw.RoundedBox(10, 55, 24, 4, 8, Color(0, 255, 0, 255))
                        draw.RoundedBox(10, 60, 20, 4, 12, Color(0, 255, 0, 255))
                    elseif ply:Ping() < 225 then
                        draw.RoundedBox(10, 50, 28, 4, 4, Color(255, 255, 0, 255))
                        draw.RoundedBox(10, 55, 24, 4, 8, Color(255, 255, 0, 255))
                        draw.RoundedBox(10, 60, 20, 4, 12, Color(155, 155, 155, 255))
                    else
                        draw.RoundedBox(10, 50, 28, 4, 4, Color(255, 0, 0, 255))
                        draw.RoundedBox(10, 55, 24, 4, 8, Color(155, 155, 155, 255))
                        draw.RoundedBox(10, 60, 20, 4, 12, Color(155, 155, 155, 255))
                    end
                end
            end
            DButton_Player.OnCursorEntered = function() selectedPlayer = ply end
            DButton_Player.OnCursorExited = function() selectedPlayer = nil end
            DButton_Player.DoClick = function()
                playerOptions = DermaMenu()
                playerOptions:AddOption(_U('viewSteam'), function()
                    local stSteamID = string.Explode(":", ply:SteamID())
                    local iCommunityID = tonumber(stSteamID[3]) * 2 + 7960265728 + tonumber(stSteamID[2])
                    gui.OpenURL("http://steamcommunity.com/profiles/7656119"..iCommunityID)
                end)
                playerOptions:AddOption(_U('copyID64'), function()
                    local stSteamID = string.Explode(":", ply:SteamID())
                    local iCommunityID = tonumber(stSteamID[3]) * 2 + 7960265728 + tonumber(stSteamID[2])
                    SetClipboardText("7656119"..iCommunityID)
                end)
                if ply ~= LocalPlayer() then
                    if ply.InGroup then
                        playerOptions:AddOption(_U('groupKick'), function()
                            net.Start("CL_KickPlayer")
                            net.WriteEntity(ply)
                            net.SendToServer()
                        end)
                    else
                        playerOptions:AddOption(_U('groupInvite'), function()
                            net.Start("CL_InvitePlayer")
                            net.WriteEntity(ply)
                            net.SendToServer()
                        end)
                    end
                end
                if ply == currentInvite then
                    playerOptions:AddOption(_U('groupAccept'), function()
                        net.Start("CL_AcceptInvite")
                        net.SendToServer()
                        currentInvite = nil
                    end)
                end
                if ply == LocalPlayer() then
                    if LocalPlayer().InGroup then
                        playerOptions:AddOption(_U('groupLeave'), function()
                            net.Start("CL_LeaveGroup")
                            net.SendToServer()
                        end)
                    end
                end
                if LocalPlayer():IsDayZAdmin() then
                    playerOptions:AddOption("", function() end)
                    local giveRankMenu = playerOptions:AddSubMenu(_U('setRank'), function () end)
                    local giveCreditsMenu = playerOptions:AddSubMenu(_U('giveCredits'), function () end)
                    local giveMoneyMenu = playerOptions:AddSubMenu(_U('giveMoney'), function () end)
                    local giveXPMenu = playerOptions:AddSubMenu(_U('giveXP'), function () end)
                    local credits = {25, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300}
                    local money = {500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 20000}
                    local xp = {500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 20000}
                    for i in pairs(PlayerRank) do
                        giveRankMenu:AddOption(PlayerRank[i].Name, function() RunConsoleCommand("setrank", ply:SteamID(), i) end)
                    end
                    for i = 1, table.Count(credits) do
                        giveCreditsMenu:AddOption(credits[i], function() RunConsoleCommand("dz_GiveCredits", ply:UserID(), credits[i]) end)
                    end
                    for i = 1, table.Count(money) do
                        giveMoneyMenu:AddOption(money[i], function() RunConsoleCommand("dz_AddMoney", ply:UserID(), money[i]) end)
                    end
                    for i = 1, table.Count(xp) do
                        giveXPMenu:AddOption(xp[i], function() RunConsoleCommand("dz_GiveXP", ply:UserID(), xp[i]) end)
                    end
                    playerOptions:AddOption(_U('resetMoney'), function() RunConsoleCommand("dz_ResetMoney", ply:UserID()) end)
                    playerOptions:AddOption(_U('tp2Player'), function() RunConsoleCommand("dz_TeleportToPlayer", ply:UserID()) end)
                    playerOptions:AddOption(_U('tpPlayer2Me'), function() RunConsoleCommand("dz_TeleportPlayerHere", ply:UserID()) end)
                    local ruleTable = {'Breaking Community Rules & Guidelines', 'Hack/Cheat/Exploit', 'Trolling', 'Combat Logging', 'Malicious/Sexual Acts'}
                    local kickMenu = playerOptions:AddSubMenu(_U('kick'), function () end)
                    for i = 1, table.Count(ruleTable) do
                        kickMenu:AddOption(ruleTable[i], function() RunConsoleCommand("dz_Kick", ply:UserID(), ruleTable[i]) end)
                    end
                    local banMenu = playerOptions:AddSubMenu(_U('ban'), function () end)
                    for i = 1, table.Count(ruleTable) do
                        banMenu:AddOption(ruleTable[i], function() RunConsoleCommand("dz_Ban", ply:UserID(), ruleTable[i]) end)
                    end
                end
                playerOptions:Open(gui.MousePos())
            end
            local AvatarImage_Player = vgui.Create("AvatarImage", DButton_Player)
            AvatarImage_Player:SetPos(10, 2)
            AvatarImage_Player:SetSize(32, 32)
            AvatarImage_Player:SetPlayer(ply)
            local DLabel_Name = vgui.Create("DLabel", DButton_Player)
            DLabel_Name:SetPos(50, 0)
            DLabel_Name:SetText(" ")
            DLabel_Name:SetSize(200, 40)
            DLabel_Name.Paint = function()
                surface.SetTextColor(PlayerRank[pLevel].Clr)
                surface.SetTextPos(0, 0)
                surface.SetFont("Scoreboardtext")
                if (ply and ply:IsValid()) then surface.DrawText(ply:Nick()) end
            end
            local DLabel_pLevel = vgui.Create("DLabel", DButton_Player)
            DLabel_pLevel:SetPos(280, 20)
            DLabel_pLevel:SetFont("ScoreboardContent")
            DLabel_pLevel:SetSize(200, 10)
            DLabel_pLevel:SetText(PlayerRank[pLevel].Name)
            DLabel_pLevel:SetColor(PlayerRank[pLevel].Clr)
            if PlayerTitle[plySteamID] then
                DLabel_pLevel:SetPos(280, 20)
                DLabel_pLevel:SetText(PlayerTitle[plySteamID])
            end
            local DLabel_Ping = vgui.Create("DLabel", DButton_Player)
            DLabel_Ping:SetPos(70, 18)
            DLabel_Ping:SetFont("ScoreboardContent")
            DLabel_Ping:SetColor(Color(255, 255, 255, 255))
            if LocalPlayer():IsAdmin() then
                DLabel_Ping:SetText(ply:Ping() .. _U('pingMS').." | " .. _U('kills')..": "..ply:GetNWInt("kills") .. " | ".._U('access')..": "..pLevel)
            else
                DLabel_Ping:SetText(ply:Ping() .. _U('pingMS').." | " .. _U('kills')..": "..ply:GetNWInt("kills"))
            end
            DLabel_Ping:SizeToContents()
            local DLabel_BanditStatus = vgui.Create("DLabel", DButton_Player)
            DLabel_BanditStatus:SetPos(280, 2)
            DLabel_BanditStatus:SetSize(200, 15)
            DLabel_BanditStatus:SetFont("ScoreboardContent")
            if ply:GetNWInt("kills") >= 3 then
                DLabel_BanditStatus:SetText(_U('killsBandit'))
                DLabel_BanditStatus:SetPos(280, 2)
                DLabel_BanditStatus:SetColor(Color(200, 0, 0, 255))
            elseif ply:GetNWInt("kills") < -3 then
                DLabel_BanditStatus:SetText(_U('killsHero'))
                DLabel_BanditStatus:SetColor(Color(0, 0, 200, 255))
            else
                DLabel_BanditStatus:SetText(_U('killsNeutral'))
                DLabel_BanditStatus:SetColor(Color(255, 255, 255, 255))
            end
            DPanelList_Players:AddItem(DButton_Player)
        end
    end
end

net.Receive("SV_GroupInvite", function(len)
    currentInvite = net.ReadEntity()
    timer.Destroy("inviteTimeout")
    timer.Create("inviteTimeout", 25, 1, function() currentInvite = nil end)
end)

net.Receive("SV_SendGroup", function(len)
    local groupSize = net.ReadUInt(10)
    for _, ply in pairs(player.GetAll()) do ply.InGroup = nil end
    for i = 1, groupSize do
        local plyEnt = net.ReadEntity()
        plyEnt.InGroup = true
    end
end)