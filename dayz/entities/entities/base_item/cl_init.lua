include('shared.lua')
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
    for i = 1, table.Count(DayZItems) do
        if (self:GetModel() == string.lower(DayZItems[i].Model)) then
            self.ItemID = i
            break
        end
    end
end

function ENT:Draw()
    self.Entity:DrawModel()
end