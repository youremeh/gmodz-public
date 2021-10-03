if SERVER then
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = true
    SWEP.AutoSwitchFrom = true
    AddCSLuaFile("shared.lua")
end

if CLIENT then
    SWEP.PrintName = "Baseball bat"
    SWEP.Slot = 1
    SWEP.SlotPos = 3
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = true
    SWEP.SwayScale = 1.0
    SWEP.BobScale = 1.0
end

SWEP.ViewModelFOV = 62
SWEP.ViewModel = "models/weapons/v_basebt2.mdl"
SWEP.WorldModel = "models/weapons/w_basebt2.mdl"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Primary.Range = 90
SWEP.Primary.Recoil = 4.6
SWEP.Primary.Delay = 1
SWEP.Primary.Damage = 10
SWEP.Primary.Cone = 0.02
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Swing = Sound("weapons/iceaxe/iceaxe_swing1.wav")
SWEP.HitSound = Sound("physics/body/body_medium_impact_hard1.wav")
SWEP.FleshHitSounds = {
    "physics/body/body_medium_impact_hard2.wav",
    "physics/body/body_medium_impact_hard3.wav",
    "physics/body/body_medium_impact_hard4.wav",
    "physics/body/body_medium_impact_hard5.wav",
    "physics/body/body_medium_impact_hard6.wav",
}

function SWEP:Initialize()
    self:SetWeaponHoldType("melee")
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Deploy()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    return true
end

function SWEP:Holster(wep)
    return true
end

function SWEP:CanPrimaryAttack()
    return true
end

function SWEP:SecondaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    local trace = util.GetPlayerTrace(self.Owner)
    local tr = util.TraceLine(trace)
    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    if (self.Owner:GetPos() - tr.HitPos):Length() < self.Primary.Range then
        self.Owner:ViewPunch(Angle(math.Rand(-3, 3) * self.Primary.Recoil, math.Rand(-3, 3) * self.Primary.Recoil, 0))
        if tr.HitNonWorld then
            if SERVER then
                tr.Entity:TakeDamage(20, self.Owner)
            end
            if tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
                self.Weapon:EmitSound(self.FleshHitSounds[math.random(1, table.Count(self.FleshHitSounds))], 100, math.random(95, 110))
            elseif tr.Entity:GetClass() ~= "prop_vehicle_jeep" && not tr.Entity:IsNPC() then
                self.Weapon:EmitSound(self.HitSound, 100, math.random(95, 110))
                local phys = tr.Entity:GetPhysicsObject()
                if phys && phys:IsValid() then
                    phys:ApplyForceCenter(self.Owner:GetAimVector() * 120)
                end
            end
        else
            self.Weapon:EmitSound(self.HitSound, 100, math.random(95, 110))
        end
    end
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha) end
