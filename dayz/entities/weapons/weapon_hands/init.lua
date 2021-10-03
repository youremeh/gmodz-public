AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

function SWEP:OnDrop()
    if (IsValid(self.Weapon)) then
        self.Weapon:Remove()
    end
end

function SWEP:PrimaryAttack()
    local trace = util.GetPlayerTrace(self.Owner)
    local tr = util.TraceLine(trace)
    local EyeTrace = self.Owner:GetEyeTrace();
    if self.Owner:IsAdmin() then
        self.Owner:PrintMessage(HUD_PRINTCONSOLE, "Vector("..math.Round(tr.HitPos.x) .. ", "..math.Round(tr.HitPos.y) .. ", "..math.Round(tr.HitPos.z) .. "),")
    end
end