--[[
    true = You use M9K as the weapon base for this gamemode (you will need to setup the weapons in shar_items.lua)
    false = You use another weapon base for this gamemode

    YOU CAN CHANGE THIS WHENEVER
]]
UseM9K = false

--[[
    true = Players need to go inside the building to use the shop
    false = Players can press F2 while inside SafeZone to use the shop

    REQUIRES A SERVER RESTART WHEN CHANGED (true creates an entity and can only be spawned at the start of gamemode init)
]]
UseNewShop = true

--[[
    true = Ignores InventorySpaceMulti entirely and uses DefaultInventorySpace to set inventory space
    false = Use the InventorySpaceMulti and adjust inventory size based on player rank

    THIS CAN BE CHANGED WHENEVER
]]
UseStaticInventorySpace = false

--[[
    The default amount of inventory space a players starts with

    If UseStaticInventorySpace is true, then everyone has DefaultInventorySpace space no matter what
    If UseStaticInventorySpace is false, then everyone has DefaultInventorySpace space multiplied by InventorySpaceMulti

    THIS CAN BE CHANGED WHENEVER
]]
DefaultInventorySpace = 50

--[[
    True = Ignores BankSpaceMulti entirely and use DefaultBankSpace set bank space number
    False = Use the BankSpaceMulti and adjust bank size based on player rank

    THIS CAN BE CHANGED WHENEVER
]]
UseStaticBankSpace = false

--[[
    The default amount of bank space a players starts with

    If UseStaticBankSpace is true, then everyone has DefaultBankSpace no matter what
    If UseStaticBankSpace is false, then everyone has DefaultBankSpace multiplied by BankSpaceMulti

    THIS CAN BE CHANGED ON THE FLY
]]
DefaultBankSpace = 500

--[[
    The multiplier for players who have a large backpack (Item ID: 24)

    THIS CAN BE CHANGED WHENEVER
    KEEP THE NUMBER ABOVE 1.0
]]
BackPackMulti = 2.0

--[[
    If someone has a combat timer, this will kill them when they attempt to enter the safezone

    THIS CAN BE CHANGED ON THE FLY
]]
SZKillWithTimer = false

--[[
    Will cause an explosion if the above is set to true

    THIS CAN BE CHANGED WHENEVER
    SZKillWithTimer NEEDS TO BE SET TO TRUE FOR THIS TO WORK
]]
SZKillExplosion = false

--[[
    Custom player titles based on their SteamID
]]
PlayerTitle = {}
PlayerTitle["STEAM_0:0:423125380"] = "Developer" --[[ Leave this please <3 ]]
--PlayerTitle["YOUR_STEAM:ID:HERE"] = "Your Rank Here"

--[[
    Custom gamemode based ranks
]]
PlayerRank = {}
PlayerRank[-1]  = {Name = "Banned",    Clr = Color(0, 0, 0),       CreditGain = 0,   InventorySpaceMulti = 0,   BankSpaceMulti = 0}
PlayerRank[0]   = {Name = "User",      Clr = Color(255, 255, 255), CreditGain = 0,   InventorySpaceMulti = 1,   BankSpaceMulti = 1}
PlayerRank[1]   = {Name = "VIP",       Clr = Color(205, 127, 50),  CreditGain = 100, InventorySpaceMulti = 2,   BankSpaceMulti = 2}
PlayerRank[95]  = {Name = "Moderator", Clr = Color(233, 30, 99),   CreditGain = 50,  InventorySpaceMulti = 2,   BankSpaceMulti = 2}
PlayerRank[96]  = {Name = "Admin",     Clr = Color(233, 30, 99),   CreditGain = 50,  InventorySpaceMulti = 2,   BankSpaceMulti = 2}
PlayerRank[99]  = {Name = "Developer", Clr = Color(233, 30, 99),   CreditGain = 0,   InventorySpaceMulti = 2,   BankSpaceMulti = 2}
PlayerRank[100] = {Name = "Founder",   Clr = Color(233, 30, 99),   CreditGain = 0,   InventorySpaceMulti = 2,   BankSpaceMulti = 2}