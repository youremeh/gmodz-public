include('shared.lua')

SWEP.PrintName = "Crowbar"
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false
SWEP.WepSelectFont = "TitleFont"
SWEP.WepSelectLetter = "c"
SWEP.IconFont = "HL2MPTypeDeath"
SWEP.IconLetter = "6"

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
    surface.SetDrawColor(color_transparent)
    surface.SetTextColor(255, 220, 0, alpha)
    local w, h = surface.GetTextSize(self.WepSelectLetter)
end