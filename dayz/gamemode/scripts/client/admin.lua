function AdminMenu()
    if LocalPlayer():GetNWInt("plevel") > 10 then
    else
        return false
    end

    local Menu = DermaMenu()
    Menu:SetPos(gui.MousePos())
    Menu:AddOption("Noclip", function()
        RunConsoleCommand("dz_noclip")
    end)

    local PlayersMenu = Menu:AddSubMenu("Players")
    for _, ply in pairs(player.GetAll()) do
        local IndPlayer = PlayersMenu:AddSubMenu(ply:Name())
        IndPlayer:AddOption("Kick", function()
            RunConsoleCommand("dz_kick", ply:UserID())
        end)

        IndPlayer:AddOption("Ban", function() end)

        IndPlayer:AddOption("Teleport to", function()
            RunConsoleCommand("dz_teleporttoplayer", ply:UserID())
        end)

        IndPlayer:AddOption("Teleport here", function()
            RunConsoleCommand("dz_teleportplayerhere", ply:UserID())
        end)

        local DonIndPlayer = IndPlayer:AddSubMenu("Donator Rewards")
        DonIndPlayer:AddOption("Make VIP", function()
            RunConsoleCommand("dz_MakeVIP", ply:UserID())
        end)

        DonIndPlayer:AddOption("Make Gold", function()
            RunConsoleCommand("dz_MakeGold", ply:UserID())
        end)

        DonIndPlayer:AddOption("Make Admin", function()
            RunConsoleCommand("dz_MakeAdmin", ply:UserID())
        end)

        DonIndPlayer:AddOption("Demote", function()
            RunConsoleCommand("dz_RemoveRank", ply:UserID())
        end)

        local CreditsIndPlayer = DonIndPlayer:AddSubMenu("Give Credits")
        CreditsIndPlayer:AddOption("Give 100 Credits to "..ply:Name(), function()
            RunConsoleCommand("dz_givecredits", ply:UserID(), 100)
        end)

        CreditsIndPlayer:AddOption("Give 500 Credits to "..ply:Name(), function()
            RunConsoleCommand("dz_givecredits", ply:UserID(), 500)
        end)

        CreditsIndPlayer:AddOption("Give 1000 Credits to "..ply:Name(), function()
            RunConsoleCommand("dz_givecredits", ply:UserID(), 1000)
        end)

        CreditsIndPlayer:AddOption("Give 2000 Credits to "..ply:Name(), function()
            RunConsoleCommand("dz_givecredits", ply:UserID(), 2000)
        end)

        CreditsIndPlayer:AddOption("Give 3000 Credits to "..ply:Name(), function()
            RunConsoleCommand("dz_givecredits", ply:UserID(), 3000)
        end)

        CreditsIndPlayer:AddOption("Give 4000 Credits to "..ply:Name(), function()
            RunConsoleCommand("dz_givecredits", ply:UserID(), 4000)
        end)

        CreditsIndPlayer:AddOption("Give 5000 Credits to "..ply:Name(), function()
            RunConsoleCommand("dz_givecredits", ply:UserID(), 5000)
        end)

        CreditsIndPlayer:AddOption("Give 10000 Credits to "..ply:Name(), function()
            RunConsoleCommand("dz_givecredits", ply:UserID(), 10000)
        end)
    end
    Menu:Open()
end

concommand.Add("AdminMenu", function(ply, cmd, args) AdminMenu() end)