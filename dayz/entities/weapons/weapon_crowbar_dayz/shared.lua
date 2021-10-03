SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.AnimPrefix = "crowbar"
SWEP.HoldType = "melee"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
CROWBAR_RANGE = 75.0
CROWBAR_REFIRE = 0.7
SWEP.Primary.Sound = Sound("Weapon_Crowbar.Single")
SWEP.Primary.Hit = Sound("Weapon_Crowbar.Melee_Hit")
SWEP.Primary.Range = CROWBAR_RANGE
SWEP.Primary.Damage = 25.0
SWEP.Primary.DamageType = DMG_CLUB
SWEP.Primary.Force = 0.75
SWEP.Primary.ClipSize = -1
SWEP.Primary.Delay = CROWBAR_REFIRE
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "None"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "None"

function SWEP:Initialize()
    if (SERVER) then
        self:SetNPCMinBurst(0)
        self:SetNPCMaxBurst(0)
        self:SetNPCFireRate(self.Primary.Delay)
    end
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    local pPlayer = self.Owner
    if (!pPlayer) then
        return
    end
    if (!self:CanPrimaryAttack()) then return end
    local vecSrc = pPlayer:GetShootPos()
    local vecDirection = pPlayer:GetAimVector()
    local trace = {}
    trace.start = vecSrc
    trace.endpos = vecSrc + (vecDirection * self:GetRange())
    trace.filter = pPlayer
    local traceHit = util.TraceLine(trace)
    if (traceHit.Hit) then
        self.Weapon:EmitSound(self.Primary.Hit)
        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
        pPlayer:SetAnimation(PLAYER_ATTACK1)
        self.Weapon:SetNextPrimaryFire(CurTime() + self:GetFireRate())
        self.Weapon:SetNextSecondaryFire(CurTime() + self.Weapon:SequenceDuration())
        self:Hit(traceHit, pPlayer)
        return
    end
    self.Weapon:EmitSound(self.Primary.Sound)
    self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
    pPlayer:SetAnimation(PLAYER_ATTACK1)
    self.Weapon:SetNextPrimaryFire(CurTime() + self:GetFireRate())
    self.Weapon:SetNextSecondaryFire(CurTime() + self.Weapon:SequenceDuration())
    self:Swing(traceHit, pPlayer)
    return
end

function SWEP:SecondaryAttack()
    return false
end

function SWEP:Reload()
    return false
end

function SWEP:GetDamageForActivity(hitActivity)
    return self.Primary.Damage
end

function SWEP:AddViewKick()
    local pPlayer = self:GetOwner()
    if (pPlayer == NULL) then
        return
    end
    if (pPlayer:IsNPC()) then
        return
    end
    local punchAng = Angle(0, 0, 0)
    punchAng.pitch = math.Rand(1.0, 2.0)
    punchAng.yaw = math.Rand(-2.0, -1.0)
    punchAng.roll = 0.0
    pPlayer:ViewPunch(punchAng)
end

function SWEP:Deploy()
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
    self:SetDeploySpeed(self.Weapon:SequenceDuration())
    return true
end

function SWEP:Hit(traceHit, pPlayer)
    local vecSrc = pPlayer:GetShootPos()
    if (SERVER) then
        pPlayer:TraceHullAttack(vecSrc, traceHit.HitPos, Vector(-16, -16, -16), Vector(36, 36, 36), self:GetDamageForActivity(), self.Primary.DamageType, self.Primary.Force)
    end
end

function SWEP:Swing(traceHit, pPlayer) end

function SWEP:CanPrimaryAttack()
    return true
end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:SetDeploySpeed(speed)
    self.m_WeaponDeploySpeed = tonumber(speed / GetConVarNumber("phys_timescale"))
    self.Weapon:SetNextPrimaryFire(CurTime() + speed)
    self.Weapon:SetNextSecondaryFire(CurTime() + speed)
end

function SWEP:Drop(vecVelocity)
    if (not CLIENT) then
        self:Remove()
    end
end

function SWEP:GetRange()
    return self.Primary.Range
end

function SWEP:GetFireRate()
    return self.Primary.Delay
end
