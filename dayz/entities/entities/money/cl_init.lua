include('shared.lua')
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
    self.Entity:DrawModel()
end