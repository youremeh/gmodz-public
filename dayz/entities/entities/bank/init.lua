AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

util.AddNetworkString("OpenBank")

function ENT:Initialize()
    self:SetModel("models/props/cs_militia/footlocker01_closed.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_FLY)
    self:SetSolid(SOLID_VPHYSICS)
end

function ENT:KeyValue(key, value) end

function ENT:SetType(strType) end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end
    if activator.CantUse then return end
    activator.CantUse = true
    timer.Simple(1, function() activator.CantUse = false end)
    net.Start("OpenBank")
    net.Send(activator)
end
