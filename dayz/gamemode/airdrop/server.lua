include("config.lua")
util.AddNetworkString("airdrop_no")
util.AddNetworkString("airdrop_confirm")
util.AddNetworkString("airdrop_start")

GM.InAirDrop = false
GM.AirDropPos = Vector()
GM.AirDropEnt = Entity(1)

hook.Add("Think", "airdrop_think", function()
    if GAMEMODE.InAirDrop then
        if GAMEMODE.AirDropPos == Vector() then GAMEMODE.ForceStopAirDrop() end
    else
        if #ents.FindByClass("thrown_airdrop") > 0 or #ents.FindByClass("airdrop_plane") > 0 then GAMEMODE.ForceStopAirDrop() end
    end
end)

function GM.StartAirDrop(ent)
    if not ent:IsValid() then return end
    GAMEMODE.AirDropEnt = ent
    GAMEMODE.AirDropPos = ent:GetPos()
    local StartLocations = GAMEMODE.AirDropStartLocations[game.GetMap()]
    if not StartLocations then GAMEMODE.ForceStopAirDrop() return end
    if not GAMEMODE.AirDropHeight[game.GetMap()] then GAMEMODE.ForceStopAirDrop() return end
    local StartLocation = Vector()
    local MaxDist = 0
    for k, v in pairs(StartLocations) do
        if v:Distance(GAMEMODE.AirDropPos) > MaxDist then
            MaxDist = v:Distance(GAMEMODE.AirDropPos)
            StartLocation = v
        end
    end
    StartLocation = Vector(StartLocation.x, StartLocation.y, GAMEMODE.AirDropHeight[game.GetMap()])
    timer.Simple(10, function()
        if not GAMEMODE.InAirDrop then return end
        local AirDropPlane = ents.Create("airdrop_plane")
        AirDropPlane:SetPos(StartLocation + (GAMEMODE.AirDropPos - StartLocation):GetNormalized() * 350)
        AirDropPlane:SetAngles(Angle(0, 0, 0))
        AirDropPlane:SetModelScale(ent:GetModelScale() / 2, 0)
        AirDropPlane:Spawn()
        AirDropPlane:Activate()
        AirDropPlane:AirDrop(StartLocation, GAMEMODE.AirDropPos, GAMEMODE.AirDropPlaneSpeed)
    end)
    GAMEMODE.InAirDrop = true
end
concommand.Add("airdropstuff", GM.StartAirDrop)

function GM.ForceStopAirDrop()
    GAMEMODE.AirDropPos = Vector()
    GAMEMODE.AirDropEntity = Entity(1)
    GAMEMODE.InAirDrop = false
    for k, v in pairs(ents.FindByClass("thrown_airdrop")) do v:Remove() end
    for k, v in pairs(ents.FindByClass("airdrop_plane")) do v:Remove() end
end

function GM.UseAirDrop(ply)
    if not ply:IsValid() then return end
    if GAMEMODE.InAirDrop then
        net.Start("airdrop_no")
        net.Send(ply)
    else
        net.Start("airdrop_confirm")
        net.Send(ply)
    end
end

function GM.CreateAirDropCrateLoots()
    if not GAMEMODE.MinLootPerCrate then return end
    if not GAMEMODE.MaxLootPerCrate then return end
    if not GAMEMODE.AirDropLoots then return end
    if GAMEMODE.MinLootPerCrate > table.Count(GAMEMODE.AirDropLoots) then GAMEMODE.MinLootPerCrate = 1 end
    if GAMEMODE.MaxLootPerCrate > table.Count(GAMEMODE.AirDropLoots) then GAMEMODE.MaxLootPerCrate = table.Count(GAMEMODE.AirDropLoots) end
    local ItemTable = {}
    local Loots = math.random(GAMEMODE.MinLootPerCrate, GAMEMODE.MaxLootPerCrate)
    local Nb = 0
    while(Nb < Loots) do
        local item = GAMEMODE.AirDropLoots[math.random(1, table.Count(GAMEMODE.AirDropLoots))]
        if(math.random(0, 100) <= item[3]) then
            Nb = Nb + 1
            if not ItemTable[item[1]] then
                ItemTable[item[1]] = item[2]
            else
                ItemTable[item[1]] = ItemTable[item[1]] + item[2]
            end
        end
    end
    return ItemTable
end

net.Receive("airdrop_start", function(ln, ply)
    if not ply:IsValid() then return end
    if not ply:HasItem(2) then return end
    if GAMEMODE.InAirDrop then return end
    if not GAMEMODE.AirDropStartLocations[game.GetMap()] then return end
    if not GAMEMODE.AirDropHeight[game.GetMap()] then return end
    if not GAMEMODE.MinLootPerCrate then return end
    if not GAMEMODE.MaxLootPerCrate then return end
    if not GAMEMODE.AirDropLoots then return end
    local nade = ents.Create("thrown_airdrop")
    local EA = ply:EyeAngles()
    local pos = ply:GetShootPos()
    pos = pos + EA:Right() * 5 - EA:Up() * 4 + EA:Forward() * 8
    nade:SetPos(pos)
    nade:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
    nade:Spawn()
    nade:SetOwner(ply)
    nade:Fuse(3)
    local phys = nade:GetPhysicsObject()
    if IsValid(phys) then
        local force = 1000
        phys:SetVelocity(EA:Forward() * force * 0.3 + Vector(0, 0, 100))
        phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
    end
    GAMEMODE.StartAirDrop(nade)
    ply:TakeItem(2, 1)
end)