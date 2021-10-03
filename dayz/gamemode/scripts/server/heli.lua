CarSpawns = {}
CarSpawns["rp_stalker_new"] = {
    Vector(-1270.8657226563, 5223.2392578125, -448.59454345703),
    Vector(-1255.6027832031, 2079.2026367188, -80.729675292969),
    Vector(-1783.8615722656, -2554.9389648438, -1.96875),
    Vector(-7476.3271484375, -3615.1896972656, -276.66998291016),
    Vector(-11475.126953125, -10549.83203125, -633.96875),
    Vector(-7826.7080078125, -12491.537109375, -473.96875),
    Vector(1242.5222167969, -6672.0024414063, -145.92120361328),
    Vector(8380.2548828125, -2809.5834960938, -512.74719238281),
    Vector(9751.77734375, -4731.42578125, -538.15679931641),
    Vector(10905.939453125, -9919.6533203125, -509.96875),
    Vector(7852.6181640625, 2075.7380371094, -681.96875),
    Vector(10697.681640625, 12424.51171875, -419.14215087891),
    Vector(-4095.6306152344, 12041.888671875, 61.302124023438),
    Vector(-7818.6630859375, 2896.654296875, -639.24969482422),
}

function AddHeli()
    timer.Create("Heli_Respawn", 60, 0, function()
        TotalVehicles = table.Count(ents.FindByClass("sent_sakariashelicopter"))
        if TotalVehicles < 1 then
            SpawnCar(table.Random(CarSpawns[string.lower(game.GetMap())]))
        end
    end)
end
hook.Add("InitPostEntity", "CarLoad", AddHeli)

function SpawnCar(Vec3)
    local heliVehicle = ents.Create("sent_sakariashelicopter")
    heliVehicle:SetModel("models/military2/air/air_h500.mdl")
    heliVehicle:SetKeyValue("vehiclescript", "scripts/vehicles/HeliSeat.txt")
    heliVehicle:SetPos(Vec3)
    heliVehicle:SetHealth(100)
    heliVehicle:SetNWInt("fuel", 0)
    heliVehicle.Destroyed = false
    heliVehicle:Spawn()
    heliVehicle:Activate()
    function heliVehicle:Think()
    	timer.Simple(4, function() if heliVehicle:IsValid() then heliVehicle:Think() end end)
	end
	heliVehicle:Think()
	local carPos = heliVehicle:GetPos()
	local carAngle = heliVehicle:GetAngles()
	local seatPos = carPos + (carAngle:Forward() * 15) + (carAngle:Right() * 40) + (carAngle:Up() * 20)
	heliVehicle.Seats = {}
	heliVehicle.Seats[1] = ents.Create("prop_vehicle_prisoner_pod")
	heliVehicle.Seats[1]:SetModel("models/nova/airboat_seat.mdl")
	heliVehicle.Seats[1]:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	heliVehicle.Seats[1]:SetAngles(carAngle)
	heliVehicle.Seats[1]:SetPos(seatPos)
	heliVehicle.Seats[1]:Spawn()
	heliVehicle.Seats[1]:Activate()
	heliVehicle.Seats[1]:SetParent(heliVehicle)
end

function doHealthCheck(ent)
    if ent:Health() <= 0 then
        if ent.Destroyed == false then
            ent.Destroyed = true
            doVehicleExplode(ent:GetPos())
            ent:Remove()
        end
    end
end

function doVehicleExplode(Location)
    local explode = ents.Create("env_explosion")
    explode:SetPos(Location)
    explode:Spawn()
    explode:SetKeyValue("iMagnitude", "220")
    explode:Fire("Explode", 0, 0)
    explode:EmitSound("weapon_AWP.Single", 400, 400)
end

function VehicleEnter(ply, Vehicle)
    if ply.CantUse then return false end
    if Vehicle:IsVehicle() then
        local Driver = Vehicle:GetDriver()
        if (Driver and Driver:IsValid() and Driver:IsPlayer()) then
            if Vehicle.Seats then
                for _, seat in pairs(Vehicle.Seats) do
                    if (seat:IsValid() and not seat:GetDriver():IsPlayer()) then
                        ply:EnterVehicle(seat)
                        ply.CantUse = true
                        timer.Simple(1, function() ply.CantUse = false end)
                        return false
                    end
                end
            end
        end
    end
    if (not ply:HasSkill(12) and Vehicle:IsVehicle()) then
        ply:ChatPrint("You do not have the skill to drive this vehicle.")
        ply.CantUse = true
        timer.Simple(1, function() ply.CantUse = false end)
        return false
    end
end
hook.Add("PlayerUse", "GetInCar", VehicleEnter)

function plyEnterVehicle(ply, vehicle)
    if vehicle:GetNWInt("fuel") then
        if vehicle:GetNWInt("fuel") <= 0 then
            vehicle:Fire("turnoff", "", 0)
        elseif vehicle:GetNWInt("fuel") > 0 then
            vehicle:Fire("turnon", "", 0)
        end
    end
end
hook.Add("PlayerEnteredVehicle", "plyEnterVehicle", plyEnterVehicle)
