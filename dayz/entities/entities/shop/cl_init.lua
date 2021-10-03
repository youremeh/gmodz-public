include('shared.lua')

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:Initialize() end

function ENT:Draw()
    self:DrawModel()
    local Pos = self:GetPos() + Vector(0, 0, 30)
    local Ang = self:GetAngles() + Angle(0, 0, 90)
    local msgt = ""
    Ang:RotateAroundAxis(Ang:Right(), 90)
    cam.Start3D2D(Pos, Ang, 0.25)
        draw.SimpleTextOutlined(msgt, "TargetIDLarge", 0, 0, Color(200, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
    cam.End3D2D()
    cam.Start3D2D(Pos, Ang + Angle(0, 180, 0), 0.25)
        draw.SimpleTextOutlined(msgt, "TargetIDLarge", 0, 0, Color(200, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))
    cam.End3D2D()
end