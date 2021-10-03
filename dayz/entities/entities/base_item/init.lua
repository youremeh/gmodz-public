AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self:SetModel(DayZItems[self.ItemID].Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    if (self.Owner and self.Owner ~= NULL) then
        self:SetMoveType(MOVETYPE_NONE)
    end
    if DayZItems[self.ItemID].Health then
        self:SetHealth(DayZItems[self.ItemID].Health)
    end
    local phys = self:GetPhysicsObject()
    if self.Dead == true then phys:EnableMotion(false)end
    if self.Dropped == true then
        timer.Simple(2, function()
            if self:IsValid() then
                phys:EnableMotion(false)
            end
        end)
        timer.Simple(180, function()
            if self:IsValid() and (not self.Owner or self.Owner == NULL or not self.Owner:IsValid()) then
                self:Remove()
            end
        end)
    else
        phys:EnableMotion(false)
    end
end

function ENT:OnTakeDamage(dmginfo)
    self:SetHealth(self:Health() - dmginfo:GetDamage() * 0.66);
    if (self:Health() <= 0 and DayZItems[self.ItemID].Health) then
        self:GibBreakClient(Vector(10, 10, 10))
        self:Remove()
    end
end
function ENT:Detach() end
function ENT:StartTouch(ent) end
function ENT:EndTouch(ent) end
function ENT:AcceptInput(name, activator, caller) end
function ENT:KeyValue(key, value) end
function ENT:OnRemove() end
function ENT:OnRestore() end
function ENT:PhysicsCollide(data, physobj) end
function ENT:PhysicsSimulate(phys, deltatime) end
function ENT:PhysicsUpdate(phys) end
function ENT:Touch(hitEnt) end
function ENT:UpdateTransmitState(Entity) end

function ENT:Think()
    if (self.Owner and self.Owner ~= NULL and not self.Owner:IsValid()) then
        self:Remove()
    end
    self:NextThink(CurTime() + 2)
end

function ENT:Use(ply, caller)
    if not ply:IsPlayer() then return end
    if ply.CantUse then return end
    ply.CantUse = true
    timer.Simple(1, function() ply.CantUse = false end)
    if not ply.WeightCur then
        return false
    end
    local weightLimit = ply:getWeightLimit()
    if (DayZItems[self.ItemID].Weight > 0) and (ply.WeightCur + (DayZItems[self.ItemID].Weight * self.Amount) > weightLimit) then
        ply:ChatPrint("You cant carry anymore.")
        return false
    end
    if (DayZItems[self.ItemID].Barricade and self.Owner ~= ply) then
        ply:ChatPrint("Only the owner may take barricades down. You can destroy them however.");
        if ply:IsDayZAdmin() then
            ply:ChatPrint("This barricade belongs to "..self.Owner:Nick())
        end
        return false
    else
        if (self.Owner and self.Owner ~= NULL and self.Owner:IsValid()) then
            if (self.Owner ~= ply) and ((self.Owner:Alive()) and (self:GetPos():Distance(self.Owner:GetPos()) < -1)) then
                return false
            elseif (self.Owner ~= ply) then
            end
        end
    end
    if self.SpawnLoot == true then
        TotalLoot = TotalLoot - 1
    end
    ply:EmitSound("items/itempickup.wav", 110, 100)
    ply:GiveItem(self.ItemID, self.Amount)
    self:Remove()
end
