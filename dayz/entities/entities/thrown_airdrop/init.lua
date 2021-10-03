AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local phys, ef
function ENT:Initialize()
    self:SetModel("models/weapons/w_eq_fraggrenade_thrown.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self.NextImpact = 0
    phys = self:GetPhysicsObject()
    if phys and phys:IsValid() then
        phys:Wake()
    end
    self:GetPhysicsObject():SetBuoyancyRatio(0)
    self.SmokeCSound = CreateSound(self, Sound("ambient/gas/cannister_loop.wav"))
    self.LastPlayTime = 0
    self.TimeLong = 0.5
    self.CanPlay = false
end

function ENT:Use(activator, caller)
    return false
end

function ENT:OnRemove()
    self.SmokeCSound:Stop()
end

local vel, len, CT, pos, own
function ENT:PhysicsCollide(data, physobj)
    vel = physobj:GetVelocity()
    len = vel:Length()
    if len > 500 then
        physobj:SetVelocity(vel * 0.6)
    end
    if len > 100 then
        CT = CurTime()
        if CT > self.NextImpact then
            self:EmitSound("weapons/hegrenade/he_bounce-1.wav", 75, 100)
            self.NextImpact = CT + 0.1
        end
    end
end

function ENT:Smoke()
    if self:IsValid() && pos then
        local smoke = EffectData()
        smoke:SetOrigin(self.Entity:GetPos())
        smoke:SetEntity(self)
        util.Effect("airdrop_smoke", smoke)
        timer.Create("airdrop_smoke_" .. self:EntIndex(), .25, 1, function() if self:IsValid() then self:Smoke() end end)
    end
end

function ENT:Fuse(t)
    timer.Simple(t, function()
        if self:IsValid() then
            pos = self:GetPos()
            own = self:GetOwner()
            ef = EffectData()
            ef:SetOrigin(pos)
            ef:SetMagnitude(1)
            util.Effect("Explosion", ef)
            self:EmitSound("weapons/explosive_m67/m67_explode_" .. math.random(1, 6) .. ".wav", 120, math.random(95, 105))
            self:EmitSound("weapons/smokegrenade/sg_explode.wav", 100, 100)
            self:Smoke()
            self.CanPlay = true
            GBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Someone has called in an airdrop")
        end
    end)
end

function ENT:Think()
    if self.CanPlay and self.LastPlayTime + self.TimeLong < CurTime() then
        self.SmokeCSound:Stop()
        self.SmokeCSound:Play()
        self.LastPlayTime = CurTime()
    end
end