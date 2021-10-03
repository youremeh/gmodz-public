AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("scripts/client/inventory.lua")
AddCSLuaFile("scripts/client/mainmenu.lua")
AddCSLuaFile("scripts/client/hud.lua")
AddCSLuaFile("scripts/client/hints.lua")
AddCSLuaFile("scripts/client/scoreboard.lua")
AddCSLuaFile("scripts/client/safemenu.lua")
AddCSLuaFile("scripts/client/shop.lua")
AddCSLuaFile("scripts/client/chat.lua")
AddCSLuaFile("scripts/client/backpack.lua")
AddCSLuaFile("scripts/client/character.lua")
AddCSLuaFile("scripts/client/trade.lua")
AddCSLuaFile("scripts/client/killtimer.lua")

include('shared.lua')
include('scripts/server/inventory.lua')
include('scripts/server/playerdb.lua')
include('scripts/server/spawn.lua')
include('scripts/server/loot.lua')
include('scripts/server/death.lua')
include('scripts/server/zombies.lua')
include('scripts/server/chat.lua')
include('scripts/server/admin.lua')
include('scripts/server/vehicles.lua')
include('scripts/server/trade.lua')
include('scripts/server/party.lua')
include('scripts/server/fog.lua')
include('scripts/server/killtimer.lua')

AddCSLuaFile("scripts/shared/shar_items.lua")
include('scripts/shared/shar_items.lua')

AddCSLuaFile("scripts/shared/shar_shops.lua")
include('scripts/shared/shar_shops.lua')

AddCSLuaFile("scripts/shared/shar_pmodels.lua")
include('scripts/shared/shar_pmodels.lua')

AddCSLuaFile("scripts/shared/shar_safezone.lua")
include('scripts/shared/shar_safezone.lua')

AddCSLuaFile("scripts/shared/shar_skills.lua")
include('scripts/shared/shar_skills.lua')

AddCSLuaFile("scripts/shared/shar_crafts.lua")
include('scripts/shared/shar_crafts.lua')

AddCSLuaFile('airdrop/client.lua')
include('airdrop/server.lua')

AddCSLuaFile("scripts/shared/shar_locale.lua")
include("scripts/shared/shar_locale.lua")

AddCSLuaFile("scripts/shared/translations/en.lua")
include("scripts/shared/translations/en.lua")

MapIndex = {}
MapIndex[1] = "rp_stalker_new"