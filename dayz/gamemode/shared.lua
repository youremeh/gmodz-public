GM.Name = "GMod-Z"
GM.Author = "youremeh @ GitHub"
GM.Email = "N/A"
GM.Website = "https://discord.gg/HJEBugJ4aA"

team.SetUp(1, "Survivor", Color(0, 0, 0, 80))

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