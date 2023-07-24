GM.Name = "GMod-Z"
GM.Author = "youremeh @ GitHub"
GM.Email = "N/A"
GM.Website = "https://discord.gg/HJEBugJ4aA"

--[[
    True = You use M9K as the weapon base for this gamemode
    False = You use another type of weapon base for this gamemode

    UNTESTED IF YOU CAN CHANGE THIS ON THE FLY
    YOU PROBABLY CAN THO
]]
UseM9K = false

--[[
    True = Players need to go inside the building to use the shop
    False = Players can press F2 while inside SafeZone to use the shop

    YOU CANNOT CHANGE THIS ON THE FLY (True statement creates an entity and can only be spawned at the start of gamemode init)
    IF CHANGED, YOU NEED TO RESTART THE MAP
]]
UseNewShop = true

--[[
    True = Ignores InventorySpaceMulti entirely and use DefaultInventorySpace to set inventory space number
    False = Use the InventorySpaceMulti and adjust inventory size based on player rank

    THIS CAN BE CHANGED ON THE FLY (True statement just changes inventory numbers)
    HOWEVER BE CAREFUL. PLAYERS MIGHT NOTT LIKE THE TRUE VERSION
]]
UseStaticInventorySpace = false

--[[
    The default amount of inventory space a players starts with

    If UseStaticInventorySpace is True, then everyone has DefaultInventorySpace space no matter what
    If UseStaticInventorySpace is False, then everyone has DefaultInventorySpace space multiplied by InventorySpaceMulti

    THIS CAN BE CHANGED ON THE FLY
]]
DefaultInventorySpace = 100

--[[
    True = Ignores BankSpaceMulti entirely and use DefaultBankSpace set bank space number
    False = Use the BankSpaceMulti and adjust bank size based on player rank

    THIS CAN BE CHANGED ON THE FLY (True statement just changes bank numbers)
    HOWEVER BE CAREFUL. PLAYERS MIGHT NOT LIKE THE TRUE VERSION
]]
UseStaticBankSpace = false

--[[
    The default amount of bank space a players starts with

    If UseStaticBankSpace is True, then everyone has DefaultBankSpace space no matter what
    If UseStaticBankSpace is False, then everyone has DefaultBankSpace space multiplied BankSpaceMulti

    THIS CAN BE CHANGED ON THE FLY
]]
DefaultBankSpace = 500

--[[
    The multiplier for players who have a Large Back (Item ID: 24)

    THIS CAN BE CHANGED ON THE FLY
    KEEP THIS ABOVE 1.0, OTHERWISE NOTHING WILL HAPPEN
]]
BackPackMulti = 2.0

team.SetUp(1, "Survivor", Color(0, 0, 0, 80))

PlayerTitle = {}
PlayerTitle["STEAM_0:0:423125380"] = "Developer" --[[ Leave this please <3 ]]
--PlayerTitle["YOUR_STEAM:ID:HERE"] = "Your Rank Here"

PlayerRank = {}
PlayerRank[-1]  = {Name = "Banned",    Clr = Color(0, 0, 0),       CreditGain = 0,   InventorySpaceMulti = 0,   BankSpaceMulti = 0}
PlayerRank[0]   = {Name = "User",      Clr = Color(255, 255, 255), CreditGain = 0,   InventorySpaceMulti = 1,   BankSpaceMulti = 1}
PlayerRank[1]   = {Name = "VIP",       Clr = Color(205, 127, 50),  CreditGain = 100, InventorySpaceMulti = 1.5, BankSpaceMulti = 1.5}
PlayerRank[95]  = {Name = "Moderator", Clr = Color(233, 30, 99),   CreditGain = 50,  InventorySpaceMulti = 2,   BankSpaceMulti = 2}
PlayerRank[96]  = {Name = "Admin",     Clr = Color(233, 30, 99),   CreditGain = 50,  InventorySpaceMulti = 2.5, BankSpaceMulti = 2.5}
PlayerRank[99]  = {Name = "Developer", Clr = Color(233, 30, 99),   CreditGain = 0,   InventorySpaceMulti = 5,   BankSpaceMulti = 5}
PlayerRank[100] = {Name = "Founder",   Clr = Color(233, 30, 99),   CreditGain = 0,   InventorySpaceMulti = 5,   BankSpaceMulti = 5}

EMETA = FindMetaTable("Entity")
function EMETA:inSafeZone()
    local safeZoneTbl = SafeZones[string.lower(game.GetMap())]
    self.InSafeZone = false
    local plyPos = self:GetPos()
    for i = 1, table.Count(safeZoneTbl) do
        if (safeZoneTbl[i].Pos and (plyPos:Distance(safeZoneTbl[i].Pos) < safeZoneTbl[i].Radius)) then
            self.InSafeZone = true
            return true
        elseif safeZoneTbl[i].Mins then
            local mins = safeZoneTbl[i].Mins
            local maxs = safeZoneTbl[i].Max
            if ((plyPos.x > mins.x and plyPos.y > mins.y and plyPos.z > mins.z) and (plyPos.x < maxs.x and plyPos.y < maxs.y and plyPos.z < maxs.z)) then
                self.InSafeZone = true
                return true
            end
        end
    end
    return false
end

function numberToBool(num)
    if (tonumber(num)) > 0 then
        return true
    else
        return false
    end
end

PMETA = FindMetaTable("Player")
function PMETA:IsDayZAdmin()
    if (self:GetNWInt("plevel") >= 100) or self:IsAdmin() then
        return true
    else
        return false
    end
end

function PMETA:IsDayZSuperAdmin()
    if (self:GetNWInt("plevel") == 100) or self:IsSuperAdmin() then
        return true
    else
        return false
    end
end

function GM:PlayerNoClip(ply)
    if ply:IsDayZAdmin() then return true end
    return false
end

function HasItem(ply, item)
    if SERVER then
        if ply:HasItem(item) then
            return ply:HasItem(item)
        else
            return 0
        end
    end
    if CLIENT then return Client_Inventory[item] end
end

function PMETA:getWeightLimit()
    local multi = 1
    local hasPerk = 1
    if UseStaticInventorySpace then
        if HasItem(self, 24) >= 1 then
            multi = BackPackMulti
        else
            multi = 1
        end
    else
        if HasItem(self, 24) >= 1 then
            multi = PlayerRank[self:GetNWInt("plevel")].InventorySpaceMulti * BackPackMulti
        else
            multi = PlayerRank[self:GetNWInt("plevel")].InventorySpaceMulti
        end
    end
    if SERVER and (self.Perk[2]) then hasPerk = 2 end
    if CLIENT and (PlayerPerks[2]) then hasPerk = 2 end
    return DefaultInventorySpace * multi * hasPerk
end

function PMETA:getWeightLimitBank()
    local multi = 1
    local hasPerk = 1
    if UseStaticBankSpace then
        multi = 1
    else
        multi = PlayerRank[self:GetNWInt("plevel")].BankSpaceMulti
    end
    if SERVER and (self.Perk[2]) then hasPerk = 2 end
    if CLIENT and (PlayerPerks[2]) then hasPerk = 2 end
    return DefaultBankSpace * multi * hasPerk
end

function GM:Move(ply, mv)
    if (CLIENT and not texturesSwapped and ply and ply:IsValid() and LocalPlayer()) then
        texturesSwapped = true
        timer.Simple(3, function() swapTextures() end)
    end
    if not ply.Stamina then ply.Stamina = 100 end
    if SERVER then
        if (ply:KeyPressed(IN_JUMP) and ply:OnGround()) then ply.Stamina = ply.Stamina - 4 end
        if (ply:KeyDown(IN_SPEED) and ply:OnGround() and mv:GetForwardSpeed() > 0) then
            if ply.Stamina > 0 and ply.Perk[1] then
                ply.Stamina = ply.Stamina - 1 * FrameTime()
            elseif ply.Stamina > 0 then
                ply.Stamina = ply.Stamina - 2.5 * FrameTime()
            end
        else
            if mv:GetForwardSpeed() > 5 and ply.Perk[1] then
                ply.Stamina = ply.Stamina + 4 * FrameTime()
            elseif mv:GetForwardSpeed() > 5 then
                ply.Stamina = ply.Stamina + 2 * FrameTime()
            else
                ply.Stamina = ply.Stamina + 4 * FrameTime()
            end
        end
        ply.Stamina = math.Clamp(ply.Stamina, 0, 100)
        if not ply.StaminaSync then ply.StaminaSync = CurTime() end
        if (CurTime() > ply.StaminaSync) then
            ply.StaminaSync = CurTime() + 0.2
            net.Start("Stamina")
            net.WriteUInt(ply.Stamina, 7)
            net.Send(ply)
        end
    end
    if ply.Stamina <= 5 then
        mv:SetMaxSpeed(100)
    else
        if mv:GetForwardSpeed() > 0 then
            mv:SetMaxSpeed(250)
        else
            mv:SetMaxSpeed(100)
        end
    end
    return false
end

if SERVER then
    local PLAYER = FindMetaTable("Player")
    util.AddNetworkString("ColoredMessage")
    function GBroadcast(...)
        local args = {...}
        net.Start("ColoredMessage")
        net.WriteTable(args)
        net.Broadcast()
    end
    function PLAYER:PBroadcast(...)
        local args = {...}
        net.Start("ColoredMessage")
        net.WriteTable(args)
        net.Send(self)
    end
elseif CLIENT then
    net.Receive("ColoredMessage", function(len)
        local msg = net.ReadTable()
        chat.AddText(unpack(msg))
        chat.PlaySound()
    end)
end