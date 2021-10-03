if (SERVER) then
    AddCSLuaFile("shared.lua")
    SWEP.Weight = 5
    SWEP.AutoSwitchTo = false
    SWEP.AutoSwitchFrom = false
end

SWEP.Slot = 1
if (CLIENT) then
    SWEP.DrawAmmo = false
    SWEP.PrintName = "Binoculars"
    SWEP.DrawCrosshair = true
    SWEP.WepSelectIcon = surface.GetTextureID("VGUI/entities/binoculars")
    local w = ScrW()
    local h = ScrH()
    local centerX = w / 2
    local centerY = h / 2
    function SWEP:DrawHUD()
        if(self:GetNWBool("zom") == true)then
            local zoom = self:GetNWInt("zoom")
            local center = Vector(centerX, centerY, 0)
            local scale = Vector(108 - zoom, 108 - zoom, 0)
            local scale2 = Vector(120 - zoom, 120 - zoom, 0)
            local scale3 = Vector(60 - zoom, 60 - zoom, 0)
            self:DrawCircle(center, scale, false);
            self:DrawCircle(center, scale2, false);
            self:DrawCircle(center, scale3, false);
            --local dist = math.Round(LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTraceNoCursor().HitPos) / 12)
            --draw.DrawText(dist.." ft", "ChatFont", centerX, centerY + 135 - zoom, Color(255, 220, 0, 255), 1)
            if(LocalPlayer():GetEyeTraceNoCursor().Entity && IsValid((LocalPlayer():GetEyeTraceNoCursor().Entity)) && not (LocalPlayer():GetEyeTraceNoCursor().Entity:GetClass() == "player"))then
                local str = Localize(LocalPlayer():GetEyeTraceNoCursor().Entity:GetClass(), LocalPlayer():GetEyeTraceNoCursor().Entity:GetClass())
                draw.DrawText(str, "ChatFont", centerX, centerY + 120 - zoom, Color(255, 220, 0, 255), 1)
                self:DrawCircle(center, Vector(55 - zoom, 55 - zoom, 0), true);
                self:DrawCircle(center, Vector(56 - zoom, 56 - zoom, 0), true);
                self:DrawCircle(center, Vector(57 - zoom, 57 - zoom, 0), true);
            end
        end
    end
    function SWEP:DrawCircle(center, scale, boolt)
        local segmentdist = 360 / (2 * math.pi * math.max(scale.x, scale.y) / 2)
        if(boolt)then
            surface.SetDrawColor(255, 0, 0, 70)
        else
            surface.SetDrawColor(255, 220, 0, 70)
        end
        for a = 0, 360 - segmentdist, segmentdist do
            surface.DrawLine(center.x + math.cos(math.rad(a)) * scale.x, center.y - math.sin(math.rad(a)) * scale.y, center.x + math.cos(math.rad(a + segmentdist)) * scale.x, center.y - math.sin(math.rad(a + segmentdist)) * scale.y)
        end
    end
end

SWEP.Category = "Jvs"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_binoculars.mdl"
SWEP.WorldModel = "models/weapons/w_binoculars.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = false
SWEP.Secondary.Automatic = true
SWEP.IsZooming = false
SWEP.DefaultZoom = 75
SWEP.ZoomDistCurrent = SWEP.DefaultZoom
SWEP.MaxZoom = 5

function SWEP:Initialize()
    if (CLIENT) then return end
    self.IsZooming = false;
    self:SetWeaponHoldType("slam")
    self:SetNWBool("zom", self.IsZooming)
end

function SWEP:Think()
    if (CLIENT) then return end
    if(self.IsZooming == false)then
        self.Owner:DrawViewModel(true)
    else
        self.Owner:DrawViewModel(false)
        self.Owner:SetFOV(self.ZoomDistCurrent, 0)
    end
end

function SWEP:Precache()
    util.PrecacheSound("binoculars/binoculars_zoomin.wav")
    util.PrecacheSound("binoculars/binoculars_zoommax.wav")
    util.PrecacheSound("binoculars/binoculars_zoomout.wav")
end

function SWEP:PrimaryAttack(ply)
    if (CLIENT) then return end
    self.IsZooming = true;
    self:SetNWBool("zom", self.IsZooming)
    if self.ZoomDistCurrent > self.MaxZoom then
        self:Zoom(1)
        self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
    else
        self.Owner:EmitSound("binoculars/binoculars_zoommax.wav")
        self.Weapon:SetNextPrimaryFire(CurTime() + 1)
        self.Weapon:SetNextSecondaryFire(CurTime() + 1)
    end
end

function SWEP:Holster()
    if (CLIENT) then return end
    self:RemoveZoom()
    return true
end

function SWEP:Zoom(cont)
    self.ZoomDistCurrent = self.ZoomDistCurrent - cont
    self:SetNWInt("zoom", self.ZoomDistCurrent)
    self.Owner:SetFOV(self.ZoomDistCurrent, 0)
    self.Owner:EmitSound("binoculars/binoculars_zoomin.wav")
    self.Owner:SetDSP(55, false)
end

function SWEP:RemoveZoom()
    self.Owner:SetFOV(0, 0)
    self.ZoomDistCurrent = self.DefaultZoom
    self.IsZooming = false;
    self:SetNWBool("zom", self.IsZooming)
    self:SetNWInt("zoom", self.ZoomDistCurrent)
    self.Owner:SetDSP(0, false)
    self.Owner:EmitSound("binoculars/binoculars_zoomout.wav")
end

function SWEP:SecondaryAttack(ply)
    if (CLIENT) then return end
    if self.ZoomDistCurrent < (self.DefaultZoom) + 1 then
        self:Zoom(-1)
        self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
    else
        self:RemoveZoom()
        self.Weapon:SetNextPrimaryFire(CurTime() + 1)
        self.Weapon:SetNextSecondaryFire(CurTime() + 1)
    end
end

function SWEP:Reload() end
