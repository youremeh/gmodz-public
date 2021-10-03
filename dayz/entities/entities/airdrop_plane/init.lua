AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/Combine_Helicopter.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_NONE)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self.Dropped = false
    self.LastDist = 99999999999
end

function ENT:Use(activator, caller)
    return false
end

function ENT:OnRemove()
    return false
end

function ENT:DropCrate()
    if not SERVER or self.Dropped then return end
    self.Dropped = true
    self.Speed = self.Speed * 1.25
    for k, v in pairs(ents.FindByClass("thrown_airdrop")) do
        v:Remove()
    end
    GBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "A helicopter has dropped a crate")
    local Crate = ents.Create("airdrop_crate")
    Crate:SetPos(self.Entity:GetPos() - self.Entity:GetUp() * 150)
    Crate:SetAngles(Angle(0, 0, 0))
    Crate:Spawn()
    Crate:Activate()
end

function ENT:Think()
    if not SERVER then return end
    if not self.Entity:IsInWorld() and self.Dropped then
        GAMEMODE.ForceStopAirDrop()
        self:Remove()
    end
    if self.Dir and self.Height then
        local entphys = self:GetPhysicsObject()
        local up = (self.Height - self.Entity:GetPos().z) / 10
        entphys:SetVelocity(self.Dir * self.Speed + Vector(0, 0, up))
    end
    local PlanePos = Vector(self.Entity:GetPos().x, self.Entity:GetPos().y, 0)
    local GrenadePos = Vector(self.Goto.x, self.Goto.y, 0)
    if not self.Dropped and PlanePos:Distance(GrenadePos) < 5 or self.LastDist < PlanePos:Distance(GrenadePos) then
        self:DropCrate()
    end
    self.LastDist = PlanePos:Distance(GrenadePos)
end

function ENT:AirDrop(origin, pos, speed)
    if not pos then self:Remove() end
    if speed == 0 then self:Remove() end
    self.Dir = (pos - origin):GetNormalized()
    self.Dir = Vector(self.Dir.x, self.Dir.y, 0)
    self.Height = origin.z
    self.Goto = pos
    self.Speed = speed / Vector(self.Dir.x, self.Dir.y):Length2D()
    self.Entity:SetAngles(self.Dir:Angle())
end
