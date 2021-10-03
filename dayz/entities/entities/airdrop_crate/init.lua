AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/items/item_item_crate.mdl")
    self.Entity:PhysicsInit(SOLID_VPHYSICS)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_VPHYSICS)
    self:GetPhysicsObject():Wake()
    self.Inventory = GAMEMODE.CreateAirDropCrateLoots()
    self.Parachute = ents.Create("prop_physics")
    self.Parachute:SetModel("models/props_debris/metal_panel02a.mdl")
    self.Parachute:SetAngles(Angle(90, 0, 0))
    self.Parachute:SetPos(self.Entity:GetPos() + self.Entity:GetUp() * 150)
    self.Parachute:Spawn()
    self.Parachute:Activate()
    constraint.Rope(self.Entity, self.Parachute, 0, 0, Vector(15, -15, 25), Vector(0, -20, -30), 50, 100, 0, 2, "cable/rope", false)
    constraint.Rope(self.Entity, self.Parachute, 0, 0, Vector(-15, 15, 25), Vector(1, 20, 30), 50, 100, 0, 2, "cable/rope", false)
    constraint.Rope(self.Entity, self.Parachute, 0, 0, Vector(15, 15, 25), Vector(1, -20, 30), 50, 100, 0, 2, "cable/rope", false)
    constraint.Rope(self.Entity, self.Parachute, 0, 0, Vector(-15, -15, 25), Vector(0, 20, -30), 50, 100, 0, 2, "cable/rope", false)
end

function ENT:Think()
    if self.Parachute and self.Parachute:IsValid() then
        local entphys = self.Parachute:GetPhysicsObject()
        entphys:SetVelocity(Vector(-entphys:GetVelocity().x, -entphys:GetVelocity().y, -self.Parachute:GetUp() * 1200))
    end
end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end
    if activator.CantUse then return end
    activator.CantUse = true
    timer.Simple(1, function() activator.CantUse = false end)
    UpdateBackpackLoot(self, activator)
    net.Start("OpenBackpack")
    net.WriteUInt(1, 1)
    net.Send(activator)
end

function ENT:StartTouch(ent)
    if self.Parachute and self.Parachute:IsValid() then
        self.Parachute:Remove()
    end
end

function ENT:OnRemove()
    if self.Parachute and self.Parachute:IsValid() then
        self.Parachute:Remove()
    end
end

function UpdateAirdropLoot(backpack, ply)
    ply.LootTarget = backpack
    net.Start("UpdateBackpack")
    for i = 1, table.Count(DayZItems) do
        net.WriteUInt(backpack.Inventory[i] or 0, 14)
    end
    net.Send(ply)
    local backpackFull = false
    for i = 1, table.Count(DayZItems) do
        if (backpack.Inventory[i] or 0) > 0 then
            backpackFull = true
            break
        end
    end
    if backpackFull == false then
        backpack:Remove()
        ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "This crate is empty")
        net.Start("CloseBackpack")
        net.Send(ply)
        return false
    end
end