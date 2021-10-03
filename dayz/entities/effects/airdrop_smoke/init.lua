function EFFECT:Init(data)
    self.Entity = data:GetEntity()
    pos = data:GetOrigin()
    self.Emitter = ParticleEmitter(pos)
    for i = 1, 20 do
        local particle = self.Emitter:Add("particle/smokesprites_000"..math.random(1, 9), pos)
        if (particle) then
            particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(0, 30))
            particle:SetDieTime(5)
            particle:SetStartAlpha(math.Rand(150, 200))
            particle:SetEndAlpha(0)
            particle:SetStartSize(math.Rand(5, 10))
            particle:SetEndSize(math.Rand(i * 5, i * 8))
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-1, 1))
            particle:SetColor(50, 255, 50)
            particle:SetAirResistance(100)
            particle:SetGravity(Vector(0, 0, i * 10))
            particle:SetCollide(true)
            particle:SetBounce(1)
        end
    end
end

function EFFECT:Think()
    return false
end

function EFFECT:Render() end