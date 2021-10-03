include('shared.lua')

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false

function SWEP:DoDrawCrosshair(x, y)
    if GUI_ShowHUD == 0 then return true end
end