include("shared.lua")

function ENT:Initialize()
    self.PlaneSound = CreateSound(self, Sound("npc/attack_helicopter/aheli_rotor_loop1.wav"))
    self.PlaneSound:SetSoundLevel(140)
    self.LastPlayTime = 0
    self.TimeLong = 5.88
end

function ENT:Draw()
    self.Entity:DrawModel()
end

function ENT:OnRemove()
    self.PlaneSound:Stop()
end

function ENT:Think()
    if self.LastPlayTime + self.TimeLong < CurTime() then
        self.PlaneSound:Stop()
        self.PlaneSound:Play()
        self.LastPlayTime = CurTime()
    end
end