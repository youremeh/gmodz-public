AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 0
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

function SWEP:OnDrop() end

function SWEP:GetCapabilities()
    return CAP_WEAPON_MELEE_ATTACK1
end