util.AddNetworkString("CharSelect")
Spawns = {}
Spawns["rp_stalker_new"] = {Vector(-10554, -13567, -621), Vector(-12353, -13392, -587), Vector(-13552, -13225, -256), Vector(-13555, -12214, -290), Vector(-13860, -9847, -685), Vector(-9969, -8181, -504), Vector(-8108, -1739, -272), Vector(-7633, 620, -699), Vector(-8107, 1038, -688), Vector(-5878, 2124, -694), Vector(-4879, 2420, -679), Vector(-6341, 6049, -720), Vector(-8922, 7692, 5), Vector(-7695, 11299, -196), Vector(-7148, 12605, 26), Vector(-8461, 13075, 66), Vector(-5362, 13046, 224), Vector(-3246, 13239, 471), Vector(-866, 13091, 233), Vector(1723, 13168, 97), Vector(4811, 13075, -524), Vector(4609, 9948, -556), Vector(7229, 9760, -590), Vector(10128, 10423, -583), Vector(10689, 9869, -558), Vector(11828, 10146, -548), Vector(13390, 8170, -247), Vector(13361, 5302, -163), Vector(13559, 1764, 298), Vector(13111, -1969, -107), Vector(13778, -4433, 128), Vector(13467, -7196, 65), Vector(13570, -8490, 260), Vector(12928, -11557, -95), Vector(12892, -12820, -108), Vector(11582, -13442, -409), Vector(11082, -13123, -512), Vector(9696, -12079, -512), Vector(6544, -12082, -372), Vector(5338, -12492, -151), Vector(6433, -7461, -466), Vector(6569, -6427, -594), Vector(5739, -2851, -689), Vector(4903, -2130, -677), Vector(3802, -741, -224), Vector(3347, 3302, -456), Vector(3126, 6905, -567), Vector(2332, 8450, -589), Vector(-2899, 9653, -18), Vector(-4324, 9607, -33), Vector(-5115, 8604, -128), Vector(-3808, 5251, -507), Vector(-2362, 3637, -173), Vector(-7569, 2126, -680), Vector(-6143, 9759, -128), Vector(-5348, 11160, -128), Vector(-3707, 11568, 107), Vector(-1635, 11156, 92), Vector(-1124, 10332, -260), Vector(-917, 9526, -256), Vector(-382, 10074, -256), Vector(1252, 12147, 28), Vector(3039, 10534, -579), Vector(3975, 13463, -489)}

PMETA = FindMetaTable("Player")
function loadCharacter(ply)
    local pStats = sql.QueryRow("SELECT * FROM DayZ_stats WHERE unique_id = '"..ply:SteamID() .. "'")
    if (tonumber(pStats.plevel) == -1) then RunConsoleCommand("ulx", "ban", ply:Nick(), "525600", "Player level set to -1") end
    ply.XP = tonumber(pStats.xp)
    ply.Money = tonumber(pStats.money)
    ply.Credits = tonumber(pStats.credits)
    ply:SetNWInt("plevel", tonumber(pStats.plevel))
    ply:SetNWInt("kills", tonumber(pStats.kills))
    ply:UpdatePerks()
    ply:LoadInventory()
    ply:LoadSkills()
    if tonumber(pStats.alive) == 1 then
        ply.gender = tonumber(pStats.gender)
        ply.face = tonumber(pStats.face)
        ply.clothes = tonumber(pStats.clothes)
        ply:SetHealth(tonumber(pStats.health))
        ply.Thirst = tonumber(pStats.thirst)
        ply.Hunger = tonumber(pStats.hunger)
        ply.Spawned = true
        if MapIndex[tonumber(pStats.mapindex)] == game.GetMap() then
            ply:SetPos(Vector(tonumber(pStats.xpos), tonumber(pStats.ypos), tonumber(pStats.zpos)) + Vector(0, 0, 10))
        else
            ply:SetPos(table.Random(Spawns[string.lower(game.GetMap())]) + Vector(0, 0, 30))
        end
        ply:UpdateCharModel()
    else
        newCharacter(ply)
    end
end

function newCharacter(ply)
    ply:UpdatePerks()
    ply:LoadInventory()
    ply:LoadSkills()
    ply.gender = 0
    ply.face = 1
    ply.clothes = 1
    ply:UpdateCharModel()
    ply:SetHealth(100)
    ply.Thirst = 100
    ply.Hunger = 100
    local luck = math.random(1,100)
    local randItem = math.random(1,70)
    local randAmt = math.random(0,1)
    local luck2 = math.random(1,100)
    local randItem2 = math.random(1,70)
    local randAmt2 = math.random(0,1)
    if (ply.Perk[3]) then
        if luck < 75 then
            ply:GiveItem(randItem, randAmt)
            print(luck, randItem, randAmt)
            if luck2 < 95 then
                ply:GiveItem(randItem2, randAmt2)
                print(luck2, randItem2, randAmt2)
            end
        end
    end
    if (ply.Perk[4]) then
        ply:GiveItem(4, 4)
        ply:GiveItem(5, 4)
        ply:GiveItem(14, 2)
        ply:GiveItem(15, 2)
    else
        ply:GiveItem(4, 2)
        ply:GiveItem(5, 2)
        ply:GiveItem(14, 1)
        ply:GiveItem(15, 1)
    end
    ply:SetNWInt("kills", 0)
    ply.Spawned = true
    ply:SetPos(table.Random(Spawns[string.lower(game.GetMap())]) + Vector(0, 0, 30))
    net.Start("CharSelect")
    net.Send(ply)
    saveCharacter(ply)
end

function saveAppearance(ply) sql.Query("UPDATE DayZ_stats SET gender = "..ply.gender..", face = "..ply.face..", clothes = "..ply.clothes.." WHERE unique_id = '"..ply:SteamID() .. "'") end

function saveCharacter(ply)
    local plevel = ply:GetNWInt("plevel")
    local xpos = math.Round(ply:GetPos().x)
    local ypos = math.Round(ply:GetPos().y)
    local zpos = math.Round(ply:GetPos().z)
    for t, j in pairs(MapIndex) do
        if j == game.GetMap() then ply.MapIndex = tonumber(t) end
    end
    if (not ply.Credits) then ply.Credits = 0 end
    if (not ply.Money) then ply.Money = 0 end
    if (not ply.XP) then ply.XP = 0 end
    local xp = ply.XP
    local money = ply.Money
    local kills = ply:GetNWInt("kills")
    local credits = ply.Credits
    if ply:Alive() then
        alive = 1
    else
        alive = 0
    end
    sql.Query("UPDATE DayZ_stats SET gender = "..ply.gender..", face = "..ply.face..",clothes = "..ply.clothes..", plevel = "..plevel..", health = "..ply:Health() .. ", thirst = "..ply.Thirst..", hunger = "..ply.Hunger..", alive = "..alive..", xpos = "..xpos..", ypos = "..ypos..", zpos = "..zpos..", mapindex = "..ply.MapIndex..", xp = "..xp..", money = "..money..", kills = "..kills..", credits = "..credits.." WHERE unique_id = '"..ply:SteamID() .. "'")
end

function saveLocation(ply)
    local xpos = math.Round(ply:GetPos().x)
    local ypos = math.Round(ply:GetPos().y)
    local zpos = math.Round(ply:GetPos().z)
    for t, j in pairs(MapIndex) do
        if j == game.GetMap() then ply.MapIndex = tonumber(t) end
    end
    sql.Query("UPDATE DayZ_stats SET xpos = "..xpos..", ypos = "..ypos..", zpos = "..zpos..", kills = "..ply:GetNWInt("kills") .. ", mapindex = "..ply.MapIndex.." WHERE unique_id = '"..ply:SteamID() .. "'")
end

function saveMoney(ply) sql.Query("UPDATE DayZ_stats SET plevel = "..ply:GetNWInt("plevel") .. ", xp = "..ply.XP..", money = "..ply.Money..", credits = "..ply.Credits.." WHERE unique_id = '"..ply:SteamID() .. "'") end

function saveSurvivalStats(ply)
    local alive = 0
    if ply:Alive() then
        alive = 1
    else
        alive = 0
    end
    sql.Query("UPDATE DayZ_stats SET alive = "..alive..", health = "..ply:Health() .. ", thirst = "..ply.Thirst..", hunger = "..ply.Hunger.." WHERE unique_id = '"..ply:SteamID() .. "'")
end

function updateInventoryTable()
    if sql.TableExists("DayZ_items") then
        for i = 1, table.Count(DayZItems) do
            sql.Query("ALTER TABLE DayZ_items ADD "..tostring("Item"..i) .. " int DEFAULT '0' NOT NULL")
            sql.Query("ALTER TABLE DayZ_bank ADD "..tostring("Item"..i) .. " int DEFAULT '0' NOT NULL")
        end
    end
end

function updateSkillTable()
    if sql.TableExists("DayZ_skills") then
        for i = 1, table.Count(DayZSkills) do sql.Query("ALTER TABLE DayZ_skills ADD "..tostring("Skill"..i) .. " int DEFAULT '0' NOT NULL") end
    end
end

function CreateTables()
    if not sql.TableExists("DayZ_stats") then
        sql.Query("CREATE TABLE DayZ_stats ( unique_id varchar(255), gender int, face int, clothes int, plevel int, health int, hunger int, thirst int, alive int, xpos int, ypos int, zpos int, mapindex int, xp int, money int, kills int, credits int  )")
    end
    if not sql.TableExists("DayZ_perks") then
        sql.Query("CREATE TABLE DayZ_perks ( unique_id varchar(255) )")
        for i = 1, table.Count(DayZShop["shop_perks"]) do sql.Query("ALTER TABLE DayZ_perks ADD "..tostring("Item_perk"..i) .. " int DEFAULT '0' NOT NULL") end
    end
    if not sql.TableExists("DayZ_items") then
        sql.Query("CREATE TABLE DayZ_items ( unique_id varchar(255) )")
    end
    if not sql.TableExists("DayZ_bank") then
        sql.Query("CREATE TABLE DayZ_bank ( unique_id varchar(255) )")
    end
    if not sql.TableExists("DayZ_skills") then
        sql.Query("CREATE TABLE DayZ_skills ( unique_id varchar(255) )")
    end
    updateInventoryTable()
    updateSkillTable()
end
hook.Add("Initialize", "Initialize", CreateTables)

function newPlayerAccount(ply)
    sql.Query("INSERT INTO DayZ_stats (`unique_id`)VALUES ('"..ply:SteamID() .. "')")
    sql.Query("INSERT INTO DayZ_items (`unique_id`)VALUES ('"..ply:SteamID() .. "')")
    sql.Query("INSERT INTO DayZ_bank (`unique_id`)VALUES ('"..ply:SteamID() .. "')")
    sql.Query("INSERT INTO DayZ_skills (`unique_id`)VALUES ('"..ply:SteamID() .. "')")
    sql.Query("INSERT INTO DayZ_perks (`unique_id`)VALUES ('"..ply:SteamID() .. "')")
    result = sql.Query("SELECT unique_id FROM DayZ_stats WHERE unique_id = '"..ply:SteamID() .. "'")
    if (result) then
        newCharacter(ply)
        GBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "This is ", Color(50, 255, 50), ply:Nick(), Color(255, 255, 255), "'s first time joining the server!")
    end
end

function playerAccountValid(ply)
    result = sql.Query("SELECT unique_id FROM DayZ_stats WHERE unique_id = '"..ply:SteamID() .. "'")
    if (result) then
        loadCharacter(ply)
    else
        newPlayerAccount(ply)
    end
end

function PlayerInitialSpawn(ply)
    if ply:IsValid() then
        timer.Create(ply:Nick() .. "posSave", 15, 0, function()
            if ply:IsValid() then saveLocation(ply) end
        end)
    end
    --[[
        -- Uncomment this timer if you have leys screencap and wanna pre-check players before playing
    timer.Create("TakeSnap", 25, 1, function()
        if not ply:IsAdmin() then
            RunConsoleCommand("leyscreencap", "2", ply:SteamID64(), 2, 20, 0, 0)
        else
            print(ply:Nick() .. " is an Admin and avoided a screengrab!")
        end
    end)
    --]]
end
hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn", PlayerInitialSpawn)