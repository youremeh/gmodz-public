function AdminMenu()
    if LocalPlayer():IsDayZAdmin() then
        return true
    else
        return false
    end

    local Menu = DermaMenu()
    Menu:SetPos(gui.MousePos())
    Menu:AddOption("Noclip", function() RunConsoleCommand("dz_noclip") end)

    local PlayersMenu = Menu:AddSubMenu("Players")
    for _, ply in pairs(player.GetAll()) do
        local IndPlayer = PlayersMenu:AddSubMenu(ply:Name())
        IndPlayer:AddOption("Kick", function() RunConsoleCommand("dz_kick", ply:UserID()) end)

        IndPlayer:AddOption("Ban", function() RunConsoleCommand("dz_ban", ply:UserID()) end)

        local DonIndPlayer = IndPlayer:AddSubMenu("Donator Rewards")
        DonIndPlayer:AddOption("Set VIP (Soon)", function()
            --RunConsoleCommand("dz_MakeVIP", ply:UserID())
        end)

        DonIndPlayer:AddOption("Demote", function() RunConsoleCommand("dz_RemoveRank", ply:UserID()) end)

        CreditsIndPlayer:AddOption("Give 1000 Credits to "..ply:Name(), function() RunConsoleCommand("dz_givecredits", ply:UserID(), 1000) end)
    end
    Menu:Open()
end
concommand.Add("AdminMenu", function(ply, cmd, args) AdminMenu() end)