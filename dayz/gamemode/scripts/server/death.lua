util.AddNetworkString("SendHitInfo")
util.AddNetworkString("HurtInfo")
util.AddNetworkString("DeathMessage")

function sendDeathMessage(ply, msg)
    net.Start("DeathMessage")
    net.WriteString(msg)
    net.Send(ply)
end

function GM:GetFallDamage(ply, speed)
    speed = speed - 580
    return speed * (100 / (1024 - 580))
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
    ply:DropAll()
    ply:CreateRagdoll()
    ply.AllowRespawn = false
    if ply:GetNWInt("kills") >= 3 then
        attacker:SetNWInt("kills", attacker:GetNWInt("kills") - 2)
        if attacker:IsValid() and attacker ~= ply then
            attacker:GiveXP(25)
            attacker:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You killed a Bandit!")
        end
    else
        attacker:SetNWInt("kills", attacker:GetNWInt("kills") + 1)
        --if attacker:IsNPC() then
        --elseif attacker:IsValid() and attacker ~= ply then
        --    attacker:GiveXP(5)
        --end
    end
    if attacker:IsPlayer() then
        if attacker:Nick() == ply:Nick() then
            sendDeathMessage(ply, "You failed to survive the apocalypse.")
        else
            sendDeathMessage(ply, "You were killled by "..attacker:Nick())
        end
    elseif attacker:IsNPC() then
        sendDeathMessage(ply, "You were eaten by a Zombie.")
    else
        sendDeathMessage(ply, "You failed to survive the apocalypse.")
    end
    timer.Simple(5, function()
        if ply:IsValid() then ply.AllowRespawn = true end
    end)
    timer.Simple(0.1, function() saveCharacter(ply) end)
end

function GM:PlayerDeathThink(ply)
    if ply:IsValid() then
        if ply.AllowRespawn == true then
            if(ply:KeyDown(IN_ATTACK)) then
                ply.AllowRespawn = false
                ply:Spawn()
            end
        end
    end
end

function GM:EntityTakeDamage(ent, dmginfo)
    if dmginfo:GetAttacker():IsNPC() then dmginfo:ScaleDamage((math.random(20, 30) * 0.1)) end
    if ent:IsPlayer() then
        if (ent:HasSkill(11)) then dmginfo:ScaleDamage(0.85) end
    end
    if ent:IsNPC() and dmginfo:GetAttacker():IsPlayer() then
        if (dmginfo:GetAttacker().Perk[5]) then
            dmginfo:ScaleDamage(3.75)
        else
            dmginfo:ScaleDamage(2.5)
        end
    end
    if (ent:IsNPC() and dmginfo:GetAttacker():IsPlayer()) then
        if (ent:Health() - dmginfo:GetDamage()) <= 0 then
            local xpAward = 5
            if dmginfo:GetAttacker():GetNWInt("plevel") == 1 then
                xpAward = xpAward * 2
            elseif dmginfo:GetAttacker():GetNWInt("plevel") == 2 then
                xpAward = xpAward * 3
            elseif dmginfo:GetAttacker():GetNWInt("plevel") >= 10 then
                xpAward = xpAward * 4
            end
            dmginfo:GetAttacker():GiveXP(xpAward)
            DropMoney(ent, 50, 300, 50)
        end
    end
    if (ent:GetClass() == "prop_vehicle_jeep") then
        ent:SetHealth(ent:Health() - (dmginfo:GetDamage() * 0.5))
        ent:EmitSound("npc/attack_helicopter/aheli_damaged_alarm1.wav")
        doHealthCheck(ent)
    end
    if (ent:GetClass() == "sent_sakariashelicopter") then
        ent:SetHealth(ent:Health() - (dmginfo:GetDamage() * 0.5))
        ent:EmitSound("npc/attack_helicopter/aheli_damaged_alarm1.wav")
        doHealthCheck(ent)
    end
    if ent:IsPlayer() then
        if ent:Alive() then
            net.Start("HurtInfo")
            net.Send(ent)
            saveSurvivalStats(ent)
        end
    end
    if dmginfo:GetAttacker():IsPlayer() then
        if ent:IsPlayer() or ent:IsNPC() then
            net.Start("SendHitInfo")
            net.Send(dmginfo:GetAttacker())
        end
    end
end

function PlayerDamages(victim, attacker) end
hook.Add("PlayerShouldTakeDamage", "PlayerDamages", PlayerDamages)

function OverrideDeathSound() return true end
hook.Add("PlayerDeathSound", "OverrideDeathSound", OverrideDeathSound)

function DropMoney(ent, amountlow, amounthigh, dropChance)
    if ent.DroppedMoney then return end
    ent.DroppedMoney = true
    if math.random(0, 1000) <= dropChance then
        moneyitem = ents.Create("money")
        moneyitem:Spawn()
        moneyitem:SetPos(ent:GetPos())
        moneyitem.Money = math.random(amountlow, amounthigh)
    end
end