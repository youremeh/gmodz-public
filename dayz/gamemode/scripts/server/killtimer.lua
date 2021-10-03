util.AddNetworkString("SendKillTimer")

function GM:PlayerDeath(ply, killer)
	ply.KillTimer = nil
	net.Start("SendKillTimer")
		net.WriteUInt(0, 32)
	net.Send(ply)
	if IsValid(killer) and killer:IsPlayer() and killer ~= ply then
		killer.KillTimer = CurTime()
		net.Start("SendKillTimer")
			net.WriteUInt(killer.KillTimer, 32)
		net.Send(killer)
	end
end

local function CheckKillTimer()
	for k,v in pairs(player.GetAll()) do
		if v.KillTimer and v.KillTimer > CurTime() and v:inSafeZone() then
			--v:Kill()
			--local vPoint = v:GetPos()
			--local effectdata = EffectData()
			--effectdata:SetStart(vPoint)
			--effectdata:SetOrigin(vPoint)
			--effectdata:SetScale(1)
			--util.Effect("HelicopterMegaBomb", effectdata)
			v:SetPos(table.Random(Spawns[string.lower(game.GetMap())]) + Vector(0, 0, 30))
			v:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You have a Combat Timer and cannot enter the SafeZone.")
		end
	end
end
timer.Create("CheckKillTimer", 1, 0, CheckKillTimer)

function GM:PlayerDisconnected(ply)
	if ply.KillTimer and ply.KillTimer > CurTime() then
		GBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), ply:Nick()..' tried to Combat Log and was killed.')
		ply:Kill()
	end
end

function GM:EntityTakeDamage(ent,dmg)
	if IsValid(ent) and ent:IsPlayer() then
		local attacker = dmg:GetAttacker()
		if ent ~= attacker and ent:IsPlayer() and IsValid(attacker) and attacker:IsPlayer() and dmg:GetDamage() > 1 then
			local newTimer = CurTime() + 121
			if not attacker.KillTimer or newTimer > attacker.KillTimer then
				attacker.KillTimer = newTimer
				net.Start("SendKillTimer")
					net.WriteUInt(attacker.KillTimer, 32)
				net.Send(attacker)
			end
		end
	end
end