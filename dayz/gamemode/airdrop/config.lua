GM.AirDropStartLocations = {}
GM.AirDropHeight = {}
--[[
    How fast the Airplane will fly
]]
GM.AirDropPlaneSpeed = 350

--[[
    The default drop location for the Airplane
]]
GM.AirDropStartLocations["rp_stalker_new"] = {
    Vector(11736.82, -12016.33, 2737.51),
}
--[[
    How high the Airplane will be from the ground
]]
GM.AirDropHeight["rp_stalker_new"] = 1800

--[[
    The minimum amount of loot an airdrop will have (takes into account chance %)
]]
GM.MinLootPerCrate = 2

--[[
    The maximum amount of loot an airdrop will have (takes into account chance %)
]]
GM.MaxLootPerCrate = 8

--[[
    Possible Airdrop items
    {ITEM ID, ITEM COUNT, %}
    ITEM ID: The ID for the item set in shar_items.lua
    ITEM COUNT: How many of that item should their be
    %: The percent is has to be in the Airdrop
]]
GM.AirDropLoots = {
    {2, 1, 1},
    {4, 3, 20},
    {5, 3, 20},
    {9, 2, 20},
    {12, 2, 20},
    {13, 3, 15},
    {14, 2, 15},
    {21, 1, 10},
    {22, 1, 12},
    {24, 1, 3},
    {32, 2, 7},
    {33, 2, 9},
    {36, 2, 8},
    {38, 1, 1},
    {40, 2, 12},
    {46, 1, 9},
    {48, 1, 5},
    {60, 5, 35},
    {61, 5, 35},
    {62, 5, 35},
    {63, 5, 35},
    {64, 5, 35},
    {68, 2, 9},
    {69, 2, 5},
    {70, 1, 6},
}