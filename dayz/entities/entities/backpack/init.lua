AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("UpdateBackpack")
util.AddNetworkString("OpenBackpack")
util.AddNetworkString("CloseBackpack")

function ENT:Initialize()
    self:SetModel("models/Fallout 3/Campish_Pack.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:GetPhysicsObject():Wake()
    timer.Simple(180, function()
        if self:IsValid() then
            self:Remove()
        end
    end)
end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end
    if activator.CantUse then return end
    activator.CantUse = true
    timer.Simple(1, function() activator.CantUse = false end)
    UpdateBackpackLoot(self, activator)
    net.Start("OpenBackpack")
    net.WriteUInt(0, 1)
    net.Send(activator)
end

function UpdateBackpackLoot(backpack, ply)
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
        net.Start("CloseBackpack")
        net.Send(ply)
        return false
    end
end