SWEP.Category = "Melee Sweps"
SWEP.PrintName = "Hands"
SWEP.Author = ""
SWEP.Instructions = "For use when walking around."
SWEP.Contact = ""
SWEP.Purpose = "Normal tasks"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModelFOV = 0
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.AnimPrefix = "none"
SWEP.HoldType = "normal"
SWEP.UseHands = false
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "None"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "None"
SWEP.DrawCrosshair = false

function SWEP:Initialize()
    if (SERVER) then
        self:SetNPCMinBurst(0)
        self:SetNPCMaxBurst(0)
        self:SetNPCFireRate(self.Primary.Delay)
    end
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack() end

function SWEP:DrawWorldModel()
    return false
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end

function SWEP:Deploy()
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
    self:SetDeploySpeed(self.Weapon:SequenceDuration())
    return true
end

function SWEP:CanPrimaryAttack()
    return false
end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:SetDeploySpeed(speed)
    self.m_WeaponDeploySpeed = tonumber(speed / GetConVarNumber("phys_timescale"))
    self.Weapon:SetNextPrimaryFire(CurTime() + speed)
    self.Weapon:SetNextSecondaryFire(CurTime() + speed)
end