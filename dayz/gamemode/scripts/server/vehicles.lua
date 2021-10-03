CarSpawns = {}
CarSpawns["rp_stalker_new"] = {}

function AddCars()
    timer.Create("Car_Respawn", 60, 0, function()
        TotalVehicles = table.Count(ents.FindByClass("prop_vehicle_jeep_old"))
        if TotalVehicles < 3 then
            --SpawnCar(table.Random(CarSpawns[string.lower(game.GetMap())]) )
        end
    end)
end
hook.Add("InitPostEntity", "CarLoad", AddCars)

function SpawnCar(Vec3)
    local jeepVehicle = ents.Create("prop_vehicle_jeep_old")
    jeepVehicle:SetModel("models/buggy.mdl")
    jeepVehicle:SetKeyValue("vehiclescript", "scripts/vehicles/jeep_test.txt")
    jeepVehicle:SetPos(Vec3)
    jeepVehicle:SetHealth(100)
    jeepVehicle:SetNWInt("fuel", 0)
    jeepVehicle.Destroyed = false
    jeepVehicle:Spawn()
    jeepVehicle:Activate()
    function jeepVehicle:Think()
        doFuelCheck(jeepVehicle)
    	timer.Simple(4, function() if jeepVehicle:IsValid() then jeepVehicle:Think() end end)
	end
	jeepVehicle:Think()
	local carPos = jeepVehicle:GetPos()
	local carAngle = jeepVehicle:GetAngles()
	local seatPos = carPos + (carAngle:Forward() * 15) + (carAngle:Right() * 40) + (carAngle:Up() * 20)
	jeepVehicle.Seats = {}
	jeepVehicle.Seats[1] = ents.Create("prop_vehicle_prisoner_pod")
	jeepVehicle.Seats[1]:SetModel("models/nova/airboat_seat.mdl")
	jeepVehicle.Seats[1]:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
	jeepVehicle.Seats[1]:SetAngles(carAngle)
	jeepVehicle.Seats[1]:SetPos(seatPos)
	jeepVehicle.Seats[1]:Spawn()
	jeepVehicle.Seats[1]:Activate()
	jeepVehicle.Seats[1]:SetParent(jeepVehicle)
end

function doFuelCheck(ent)
    local fuelDrain = math.ceil(ent:GetVelocity():Length() / 2000)
    if ent:GetNWInt("fuel") > 0 then
        ent:Fire("turnon", "", 0)
    end
    if fuelDrain > 0 and ent:GetVelocity():Length() > 5 then
        if (ent:GetDriver():IsPlayer()) then
            ent:SetNWInt("fuel", ent:GetNWInt("fuel") - fuelDrain)
            if ent:GetNWInt("fuel") <= 0 then
                ent:Fire("turnoff", "", 0)
                ent:SetNWInt("fuel", 0)
            end
        end
    end
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
                        return true
                    end
                end
            end
        end
    end
    if (not ply:HasSkill(12) and Vehicle:IsVehicle()) then
        ply:ChatPrint("You do not have the skill to drive this vehicle")
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

function plyLeaveVehicle(ply, vehicle)
    if(ply and ply:IsValid()) then
        ply.CantUse = true
        timer.Simple(1, function() ply.CantUse = false end)
    end
end
hook.Add("PlayerLeaveVehicle", "plyLeaveVehicle", plyLeaveVehicle)
