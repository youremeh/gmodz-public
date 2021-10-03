util.AddNetworkString("HungerThirst")
util.AddNetworkString("Stamina")

function GM:PlayerSpawn(ply)
    ply:SetModel("models/player/group03/male_0"..math.random(1, 5) .. ".mdl")
    ply:SetTeam(1)
    ply.SafeZone = false
    ply:SetRunSpeed(175)
    ply:SetWalkSpeed(100)
    ply:SetSlowWalkSpeed(75)
    ply:SetCrouchedWalkSpeed(0.3)
    playerAccountValid(ply)
    timer.Create("currency"..ply:Nick(), 4, 1, function() ply:UpdateCurrencies() end)
    ply:Give("weapon_fists")
    ply:SetupHands()
end

function Lower_HungerWater()
    timer.Create("Lower_Hunger", 20, 0, function()
        for _, ply in pairs(player.GetAll()) do
            if ply:IsValid() and ply.Spawned == true then
                if ply.Hunger > 0 then
                    local hungerLose = 2
                    if ply:HasSkill(7) then hungerLose = 1 end
                    ply.Hunger = ply.Hunger - hungerLose
                elseif ply.Hunger == 0 and ply:Alive() then
                    local healthLoss = 10
                    if ply:HasSkill(9) then healthLoss = 5 end
                    ply:SetHealth(ply:Health() - healthLoss)
                    ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You are dying of hunger")
                    if ply:Health() <= 0 and ply:Alive() then ply:Kill() end
                end
            end
            saveSurvivalStats(ply)
        end
    end)
    timer.Create("Update_Client", 2, 0, function()
        for _, ply in pairs(player.GetAll()) do
            if ply:IsValid() and ply.Spawned == true then
                net.Start("HungerThirst")
                net.WriteUInt(ply.Hunger, 7)
                net.WriteUInt(ply.Thirst, 7)
                net.Send(ply)
            end
        end
    end)
    timer.Create("Lower_Thirst", 14, 0, function()
        for _, ply in pairs(player.GetAll()) do
            if ply:IsValid() and ply.Spawned == true then
                if ply.Thirst > 0 then
                    local thirstLose = 2
                    if ply:HasSkill(10) then thirstLose = 1 end
                    ply.Thirst = ply.Thirst - thirstLose
                    if ply:Health() <= 0 and ply:Alive() then ply:Kill() end
                elseif ply.Thirst == 0 and ply:Alive() then
                    local healthLoss = 15
                    if ply:HasSkill(9) then healthLoss = 5 end
                    ply:SetHealth(ply:Health() - healthLoss)
                    ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You are dying of thirst")
                    if ply:Health() <= 0 and ply:Alive() then ply:Kill() end
                end
                saveSurvivalStats(ply)
            end
        end
    end)
    timer.Create("Props_Fall_Then_Freeze", 1, 1, function()
        for _, ent in pairs(ents.GetAll()) do
            if ent:GetClass() == "prop_physics_multiplayer" then
                ent:SetMoveType(MOVETYPE_NONE)
            elseif ent:GetClass() == "prop_physics" then
                ent:SetMoveType(MOVETYPE_NONE)
            elseif ent:GetClass() == "weapon_357" then
                ent:Remove()
            elseif ent:GetClass() == "item_ammo_357" then
                ent:Remove()
            end
            if string.lower(game.GetMap()) == "rp_evocity2_v2p" then
                if ent:GetPos():Distance(Vector(5167, 4569, -1130)) < 100 then ent:Remove() end
            end
        end
    end)
    local safeZoneTbl = SafeZones[string.lower(game.GetMap())]
    timer.Create("SettlementZone", 1, 0, function()
        for _, ply in pairs(player.GetAll()) do
            local plyIsSafe = ply:inSafeZone()
            if plyIsSafe == true then
                ply:GodEnable()
                ply:SelectWeapon("weapon_fists")
                ply.SafeZone = true
                timer.Pause("Lower_Hunger")
                timer.Pause("Lower_Thirst")
            else
                ply:GodDisable()
                ply.SafeZone = false
                timer.UnPause("Lower_Thirst")
                timer.UnPause("Lower_Hunger")
            end
        end
    end)
end
hook.Add("InitPostEntity", "Lower_HungerWater", Lower_HungerWater)

function SpawnBanks()
    for _, vec in pairs(Banks[string.lower(game.GetMap())]) do
        local Bank_Box = ents.Create("bank")
        Bank_Box:SetPos(vec + Vector(0, 0, 14))
        Bank_Box:Spawn()
    end
end
hook.Add("InitPostEntity", "SpawnBanks", SpawnBanks)

function SpawnShops()
    if UseNewShop then
        for _, vec in pairs(Shops[string.lower(game.GetMap())]) do
            local Bank_Box = ents.Create("shop")
            Bank_Box:SetPos(vec + Vector(0, 0, 14))
            Bank_Box:Spawn()
        end
    end
end
hook.Add("InitPostEntity", "SpawnShops", SpawnShops)

function GM:PlayerSetHandsModel(ply, ent)
    local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simplemodel)
    if (info) then
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end
end