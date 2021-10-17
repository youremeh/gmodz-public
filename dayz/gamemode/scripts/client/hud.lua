surface.CreateFont("AmmoType1", {font = "TargetID", size = 60, weight = 600})
surface.CreateFont("AmmoType2", {font = "TargetID", size = 35, weight = 600})
surface.CreateFont("TargetIDWeighted", {font = "Trebuchet24", weight = 1000, size = 18})
surface.CreateFont("TargetIDLarge", {font = "TargetID", size = 40, weight = 600})
surface.CreateFont("TargetIDMedium", {font = "TargetID", size = 20, weight = 600})
surface.CreateFont("TargetIDSmall", {font = "TargetID", size = 15, weight = 400})

local deathMsg = ""
local deathLMBMsg = ""
PlayerPerks = PlayerPerks or {}
net.Receive("DeathMessage", function(len)
    deathMsg = net.ReadString()
    surface.PlaySound("music/death.wav")
    timer.Simple(5, function() deathLMBMsg = _U('respawnMsg') end)
end)

function GM:DrawDeathNotice(x, y)
    local SW, SH = ScrW(), ScrH()
    if LocalPlayer():Health() <= 0 then
        local DeadBoxW = 600
        local DeadBoxH = 150
        local halfDeadBoxW = DeadBoxW * 0.5
        local halfDeadBoxH = DeadBoxH * 0.5
        local halfSW = SW * 0.5
        local halfSH = SH * 0.5
        draw.RoundedBox(10, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255))
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(120, 120, 120, 80))
        surface.DrawTexturedRectUV(halfSW - halfDeadBoxW, halfSH - halfDeadBoxH, DeadBoxW, DeadBoxH, 0, 0, DeadBoxW * 0.005, DeadBoxH * 0.005)
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(180, 20, 20, 255))
        surface.DrawTexturedRectUV(halfSW - halfDeadBoxW, halfSH - halfDeadBoxH, DeadBoxW, 2, 0, 0, DeadBoxW * 0.002, 2 * 0.002)
        surface.DrawTexturedRectUV(halfSW - halfDeadBoxW, halfSH + halfDeadBoxH, DeadBoxW, 2, 0, 0, DeadBoxW * 0.002, 2 * 0.002)
        surface.DrawTexturedRectUV(halfSW - halfDeadBoxW, halfSH - halfDeadBoxH, 2, DeadBoxH, 0, 0, 2 * 0.002, DeadBoxH * 0.002)
        surface.DrawTexturedRectUV(halfSW + halfDeadBoxW, halfSH - halfDeadBoxH, 2, DeadBoxH, 0, 0, 2 * 0.002, DeadBoxH * 0.002)
        draw.DrawText(_U('deathMessage'), "TargetIDLarge", halfSW, halfSH - 50, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
        if deathMsg then draw.DrawText(deathMsg, "TargetIDMedium", halfSW, halfSH, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER) end
        if deathLMBMsg then draw.DrawText(deathLMBMsg, "TargetIDMedium", halfSW, halfSH + 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER) end
    else
        deathMsg, deathLMBMsg = nil, nil
    end
end

local SolidGreen = Color(85, 180, 55, 255)
local SolidRed = Color(175, 0, 0, 255)
local TransGreen = Color(85, 150, 55, 150)
local TransGrey = Color(75, 75, 75, 200)
local bottomPos = ScrH()
local iconSize = 72
function drawIndicatorIcons()
    local function getColour(value)
        value = value * 0.01
        local newColor = Color(0, 0, 0, 0)
        newColor.r = Lerp(value, SolidRed.r, SolidGreen.r)
        newColor.g = Lerp(value, SolidRed.g, SolidGreen.g)
        newColor.b = Lerp(value, SolidRed.b, SolidGreen.b)
        return Color(newColor.r, newColor.g, newColor.b, 255)
    end
    local iconStart = 20
    local health, food, water, stamina = LocalPlayer():Health(), LocalPlayer().Hunger, LocalPlayer().Thirst, LocalPlayer().Stamina
    if not health then health = 100 end
    if not food then food = 100 end
    if not water then water = 100 end
    if not stamina then stamina = 100 end
    healthUV = (health * 0.01) * 64 + 18
    foodUV = (food * 0.01) * 64 + 18
    waterUV = (water * 0.01) * 64 + 18
    staminaUV = (stamina * 0.01) * 64 + 18
    local clrValue = {health, food, water, stamina}
    local uvValue = {healthUV, foodUV, waterUV, staminaUV}
    local bgTable = {"icons/health", "icons/food", "icons/water", "icons/sprint"}
    draw.DrawText(health, "DebugFixed", iconStart, ScrH() - 70, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    draw.DrawText(food, "DebugFixed", iconStart + 80, ScrH() - 70, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    draw.DrawText(water, "DebugFixed", iconStart + 160, ScrH() - 70, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    draw.DrawText(stamina, "DebugFixed", iconStart + 240, ScrH() - 70, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    for i = 1, 4 do
        iconPos = (i - 1) * 80
        surface.SetDrawColor(TransGreen)
        surface.SetMaterial(Material("icons/HUDborder"))
        surface.DrawTexturedRect(iconStart + iconPos, bottomPos - iconSize, iconSize, iconSize)
        surface.SetDrawColor(TransGrey)
        surface.SetMaterial(Material(bgTable[i]))
        surface.DrawTexturedRect(iconStart + iconPos, bottomPos - iconSize, iconSize, iconSize)
        local iconSize2 = iconSize * (uvValue[i] * 0.01)
        surface.SetDrawColor(getColour(clrValue[i]))
        surface.SetMaterial(Material(bgTable[i]))
        surface.DrawTexturedRectUV(iconStart + iconPos, bottomPos - iconSize2, iconSize, iconSize - (iconSize - iconSize2), 0, (1 - uvValue[i] * 0.01), 1, 1)
    end
end

function drawMinimap()
    local size = 160
    surface.SetMaterial(Material("icons/minimap"))
    surface.SetDrawColor(TransGreen)
    surface.DrawTexturedRectRotated(ScrW() - size * 0.5, size * 0.5, size, size, LocalPlayer():GetAngles().y)
    draw.DrawText(_U('comingSoon'), "ChatFont", ScrW() - size * 0.5, size * 0.45, Color(255, 255, 255, 150), TEXT_ALIGN_CENTER)
end

function playerGroupNames()
    for _, ply in pairs(player.GetAll()) do
        if (ply.InGroup and ply ~= LocalPlayer()) then
            local screenPos = (ply:GetPos() + Vector(0, 0, 60)):ToScreen()
            local distance = LocalPlayer():GetPos():Distance(ply:GetPos())
            local distM = math.Round(distance * 0.01905)
            if distM >= 5 then
                draw.DrawText(ply:Nick(), "ChatFont", screenPos.x, screenPos.y, Color(255, 144, 0, distM * 20), TEXT_ALIGN_CENTER)
                draw.DrawText(distM.."m", "ChatFont", screenPos.x, screenPos.y + 12, Color(255, 144, 0, distM * 20), TEXT_ALIGN_CENTER)
            end
        end
    end
end

function HelpMarker()
    local safeZoneTbl = SafeZones[string.lower(game.GetMap())]
    for i = 1, table.Count(safeZoneTbl) do
        if (safeZoneTbl[i].Pos) then
            Loc = safeZoneTbl[i].Pos
        elseif safeZoneTbl[i].Mins then
            local mins = safeZoneTbl[i].Mins
            local maxs = safeZoneTbl[i].Max
            Loc = (mins + maxs) / 2
        end
        local screenPos = Loc:ToScreen()
        local distance = Loc:Distance(LocalPlayer():GetPos())
        local distM = math.Round(distance * 0.01905)
        if(Loc and Loc:Distance(LocalPlayer():GetPos()) >= 5 + (safeZoneTbl[i].Radius or 0)) then
            draw.DrawText(_U('safeZone'), "ChatFont", screenPos.x, screenPos.y - 50, Color(0, 150, 0, distM * 20), TEXT_ALIGN_CENTER)
            draw.DrawText(distM.."m", "ChatFont", screenPos.x, screenPos.y - 36, Color(0, 150, 0, distM * 20), TEXT_ALIGN_CENTER)
        else
            draw.DrawText(_U('bank'), "ChatFont", screenPos.x, screenPos.y - 50, Color(0, 150, 0, distM * 20), TEXT_ALIGN_CENTER)
            draw.DrawText(distM.."m", "ChatFont", screenPos.x, screenPos.y - 36, Color(0, 150, 0, distM * 20), TEXT_ALIGN_CENTER)
        end
    end
end

function drawPlayerHUD_New()
    local sprintSize = 30
    local size = 150
    local x = 0
    local y = ScrH() - size - 5
    if not LocalPlayer().Hunger then LocalPlayer().Hunger = 100 end
    if not LocalPlayer().Thirst then LocalPlayer().Thirst = 100 end
    if not LocalPlayer().Stamina then LocalPlayer().Stamina = 100 end
    surface.SetMaterial(Material("icons/hungerthirst"))
    surface.SetDrawColor(Color(0, 0, 0, 100))
    surface.DrawTexturedRectUV(x, y, size, size, 0, 0, 1, 1)
    surface.SetMaterial(Material("icons/character_icons"))
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawTexturedRectUV(x, y, size, size, 0, 0, 1, 1)
    surface.SetMaterial(Material("icons/character_sprint"))
    surface.SetDrawColor(Color(0, 0, 0, 100))
    surface.DrawTexturedRectUV(x + size * 0.5 - sprintSize * 0.3, y - sprintSize * 0.8, sprintSize, sprintSize, 0, 0, 1, 1)
    local sprintPercent = LocalPlayer().Stamina * 0.01
    local sprintDist = sprintSize - (sprintPercent * sprintSize)
    surface.SetMaterial(Material("icons/character_sprint"))
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawTexturedRectUV(x + size * 0.5 - sprintSize * 0.3, y - sprintSize * 0.8 + sprintDist, sprintSize, sprintSize - sprintDist, 0, 1 - sprintPercent, 1, 1)
    local hungerPercent = math.Clamp(((LocalPlayer().Hunger * 0.01) + 0.21) * 0.75, 0, 1)
    local hungerDist = size - (hungerPercent * size)
    surface.SetMaterial(Material("icons/hungerleft"))
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawTexturedRectUV(x, y + hungerDist, size, size - hungerDist, 0, 1 - hungerPercent, 1, 1)
    local thirstPercent = math.Clamp(((LocalPlayer().Thirst * 0.01) + 0.21) * 0.75, 0, 1)
    local thirstDist = size - (thirstPercent * size)
    surface.SetMaterial(Material("icons/thirstright"))
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawTexturedRectUV(x, y + thirstDist, size, size - thirstDist, 0, 1 - thirstPercent, 1, 1)
    surface.SetMaterial(Material("icons/character_inside"))
    surface.SetDrawColor(Color(50, 0, 0, 200))
    surface.DrawTexturedRectUV(x, y, size, size, 0, 0, 1, 1)
    local alp = 255
    if LocalPlayer():Health() < 25 then alp = math.abs(math.sin(CurTime())) * 255 + 25 end
    local healthPercent = LocalPlayer():Health() * 0.01
    local healthDist = size - (healthPercent * size)
    surface.SetMaterial(Material("icons/character_inside"))
    surface.SetDrawColor(Color(185, 90, 90, alp))
    surface.DrawTexturedRectUV(x, y + healthDist, size, size - healthDist, 0, 1 - healthPercent, 1, 1)
    surface.SetMaterial(Material("icons/character_border"))
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawTexturedRectUV(x, y, size, size, 0, 0, 1, 1)
end

local dzHud = CreateClientConVar("dz_hud", 1, true, false, 'Change HUD styles')
local dzHelp = CreateClientConVar("dz_showsafezone", 1, true, false, 'Show/Hide the SafeZone marker')
local dzMini = CreateClientConVar("dz_minimap", 0, true, false, 'Show/Hide the Mini-Map (BROKEN)')
function drawPlayerHud()
    local SW, SH = ScrW(), ScrH()
    local halfSW = SW * 0.5
    local halfSH = SH * 0.5
    local fifthSH = SH * 0.08
    drawAmmo()
    playerGroupNames()
    if dzMini:GetBool() then drawMinimap() end
    if dzHelp:GetBool() then HelpMarker() end
    if dzHud:GetBool() then
        drawPlayerHUD_New()
    else
        drawIndicatorIcons()
    end
    if LocalPlayer().ScoreBoard == nil then LocalPlayer().ScoreBoard = false end
    local SafeZoneW = 600 / 1.3
    local SafeZoneH = 150 / 1.3
    local halfSafeZoneW = SafeZoneW * 0.5
    local halfSafeZoneH = SafeZoneH * 0.5
    LocalPlayer():inSafeZone()
    if (LocalPlayer().InSafeZone and LocalPlayer().ScoreBoard == false) and (not DFrame_ShopMenu or not DFrame_ShopMenu:IsValid()) then
        draw.RoundedBox(10, halfSW - halfSafeZoneW, fifthSH - halfSafeZoneH, SafeZoneW, SafeZoneH, Color(0, 0, 0, 180))
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(0, 0, 0, 255))
        surface.DrawTexturedRectUV(halfSW - halfSafeZoneW, fifthSH - halfSafeZoneH, SafeZoneW, SafeZoneH, 0, 0, SafeZoneW * 0.002, SafeZoneH * 0.002)
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.DrawTexturedRectUV(halfSW - halfSafeZoneW, fifthSH - halfSafeZoneH, SafeZoneW, 2, 0, 0, SafeZoneW * 0.002, 2 * 0.002)
        surface.DrawTexturedRectUV(halfSW - halfSafeZoneW, fifthSH + halfSafeZoneH, SafeZoneW, 2, 0, 0, SafeZoneW * 0.002, 2 * 0.002)
        surface.DrawTexturedRectUV(halfSW - halfSafeZoneW, fifthSH - halfSafeZoneH, 2, SafeZoneH, 0, 0, 2 * 0.002, SafeZoneH * 0.002)
        surface.DrawTexturedRectUV(halfSW + halfSafeZoneW, fifthSH - halfSafeZoneH, 2, SafeZoneH, 0, 0, 2 * 0.002, SafeZoneH * 0.002)
        DrawFadingText(0.5, _U('safeZoneWarning'), "TargetIDLarge", halfSW, fifthSH - 45, Color(255, 0, 0, 255), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText(_U('safeZoneCantHurt'), "TargetIDMedium", halfSW, fifthSH, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        if UseNewShop then
            draw.DrawText(_U('safeZoneShopNew'), "TargetIDMedium", halfSW, fifthSH + 23, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        else
            draw.DrawText(_U('safeZoneShopOld'), "TargetIDMedium", halfSW, fifthSH + 23, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end
    if LocalPlayer():InVehicle() then
        draw.DrawText(_U('vehFuel')..math.Round(LocalPlayer():GetVehicle():GetNWInt("fuel")) .. "%", "Trebuchet24", halfSW - 75, ScrH() - 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText(_U('vehHealth')..math.Round(LocalPlayer():GetVehicle():Health()) .. " %", "Trebuchet24", halfSW + 75, ScrH() - 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.RoundedBox(10, halfSW - 154, SH - 25, 153, 50, Color(0, 0, 0, 155)) -- Fuel Tank Box
        draw.RoundedBox(10, halfSW + 1, SH - 25, 152, 50, Color(0, 0, 0, 155)) -- Speed Box
    end
    local localTrace = LocalPlayer():GetEyeTrace()
    local trEntity = localTrace.Entity
    if (trEntity and trEntity:IsPlayer()) then
        if (trEntity:Alive()) then
            local plyPos = trEntity:GetPos() + Vector(0, 0, 64)
            local screenPos = (plyPos + Vector(0, 0, 10)):ToScreen()
            local dist = plyPos:Distance(LocalPlayer():GetPos())
            if dist < 500 then
                local alpha = 255 * (math.abs((dist - 500)) / 600)
                draw.RoundedBox(10, screenPos.x - 50, screenPos.y - 25, 100, 60, Color(0, 0, 0, alpha))
                draw.DrawText(trEntity:Nick(), "TargetIDWeighted", screenPos.x, screenPos.y - 15, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
                if trEntity:GetNWInt("kills") >= 3 then
                    draw.DrawText(_U('killsBandit'), "debugFixed", screenPos.x, screenPos.y + 5, Color(200, 0, 0, alpha), TEXT_ALIGN_CENTER)
                elseif trEntity:GetNWInt("kills") < -3 then
                    draw.DrawText(_U('killsHero'), "debugFixed", screenPos.x, screenPos.y + 5, Color(0, 0, 200, alpha), TEXT_ALIGN_CENTER)
                else
                    draw.DrawText(_U('killsNeutral'), "debugFixed", screenPos.x, screenPos.y + 5, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
                end
            end
        end
    end
    if LocalPlayer().Money then
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(0, 0, 0, 230))
        surface.DrawTexturedRectUV(SW - 300, SH - 30, 300, 40, 0, 0, 0.3, 0.04)
        draw.DrawText(_U('moneySign')..LocalPlayer().Money, "TargetIDMedium", SW - 250, SH - 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText(_U('xp')..LocalPlayer().XP, "TargetIDMedium", SW - 50, SH - 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText(_U('credits')..LocalPlayer().Credits, "TargetIDMedium", SW - 150, SH - 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end
hook.Add("HUDPaint", "drawPlayerHud", drawPlayerHud)

function drawAmmo()
    local SW, SH = ScrW(), ScrH()
    if LocalPlayer():GetActiveWeapon():IsValid() && LocalPlayer():GetActiveWeapon():Clip1() >= 0 && LocalPlayer():GetActiveWeapon():GetClass() then
        local clip1 = LocalPlayer():GetActiveWeapon():Clip1()
        local clip2 = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
        draw.RoundedBox(10, SW - 200, SH - 100, 200, 60, Color(0, 0, 0, 160))
        draw.DrawText(LocalPlayer():GetActiveWeapon().PrintName, "DebugFixed", SW - 58, SH - 58, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
        surface.SetTextColor(Color(255, 255, 255))
        surface.SetFont("AmmoType1")
        local x, y = surface.GetTextSize(clip1)
        surface.SetTextPos(SW - 140 - x / 2, SH - 75 - y / 2)
        surface.DrawText(clip1)
        surface.SetTextColor(Color(150, 0, 0))
        surface.SetFont("AmmoType2")
        local x, y = surface.GetTextSize(clip2)
        surface.SetTextPos(SW - 90 - x / 2, SH - 75 - y / 2)
        surface.DrawText("x "..clip2)
    end
end

function GM:HUDDrawTargetID() return false end

function GM:HUDWeaponPickedUp(wep)
    if (not LocalPlayer():Alive()) then return end
    local pickup = {}
    pickup.time = CurTime()
    pickup.name = wep:GetPrintName()
    pickup.holdtime = 5
    pickup.font = "DebugFixed"
    pickup.fadein = 0.04
    pickup.fadeout = 0.3
    pickup.color = Color(255, 255, 255, 255)
    surface.SetFont(pickup.font)
    local w, h = surface.GetTextSize(pickup.name)
    pickup.height = h
    pickup.width = w
    if (self.PickupHistoryLast >= pickup.time) then pickup.time = self.PickupHistoryLast + 0.05 end
    table.insert(self.PickupHistory, pickup)
    self.PickupHistoryLast = pickup.time
end

function GM:HUDDrawPickupHistory()
    if (self.PickupHistory == nil) then return end
    local x, y = ScrW() * 0.18, ScrH() * 0.955
    local tall = 0
    local wide = 0
    for k, v in pairs(self.PickupHistory) do
        if v.time < CurTime() then
            if (v.y == nil) then v.y = y end
            v.y = (v.y * 5 + y) / 6
            local delta = (v.time + v.holdtime) - CurTime()
            delta = delta / v.holdtime
            local alpha = 255
            local colordelta = math.Clamp(delta, 0.6, 0.7)
            if delta > (1 - v.fadein) then
                alpha = math.Clamp((1.0 - delta) * (255 / v.fadein), 0, 255)
            elseif delta < v.fadeout then
                alpha = math.Clamp(delta * (255 / v.fadeout), 0, 255)
            end
            v.x = x + self.PickupHistoryWide - (self.PickupHistoryWide * (alpha / 255))
            local rx, ry, rw, rh = math.Round(v.x - 4), math.Round(v.y - (v.height / 2) - 4), math.Round(self.PickupHistoryWide + 9), math.Round(v.height + 8)
            local bordersize = 8
            surface.SetTexture(self.PickupHistoryCorner)
            surface.SetDrawColor(v.color.r, v.color.g, v.color.b, alpha)
            surface.DrawTexturedRectRotated(rx + bordersize / 2, ry + bordersize / 2, bordersize, bordersize, 0)
            surface.DrawTexturedRectRotated(rx + bordersize / 2, ry + rh - bordersize / 2, bordersize, bordersize, 90)
            surface.DrawRect(rx, ry + bordersize, bordersize, rh - bordersize * 2)
            surface.DrawRect(rx + bordersize, ry, v.height - 4, rh)
            surface.SetDrawColor(0 * colordelta, 0 * colordelta, 0 * colordelta, math.Clamp(alpha, 0, 100))
            surface.DrawRect(rx + bordersize + v.height - 4, ry, rw - (v.height - 4) - bordersize * 2, rh)
            surface.DrawTexturedRectRotated(rx + rw - bordersize / 2, ry + rh - bordersize / 2, bordersize, bordersize, 180)
            surface.DrawTexturedRectRotated(rx + rw - bordersize / 2, ry + bordersize / 2, bordersize, bordersize, 270)
            surface.DrawRect(rx + rw - bordersize, ry + bordersize, bordersize, rh - bordersize * 2)
            draw.SimpleText(v.name, v.font, v.x + 2 + v.height + 8, v.y - (v.height / 2) + 2, Color(0, 0, 0, alpha * 0.75))
            draw.SimpleText(v.name, v.font, v.x + v.height + 8, v.y - (v.height / 2), Color(255, 255, 255, alpha))
            if v.amount then
                draw.SimpleText(v.amount, v.font, v.x + self.PickupHistoryWide + 2, v.y - (v.height / 2) + 2, Color(0, 0, 0, alpha * 0.75), TEXT_ALIGN_RIGHT)
                draw.SimpleText(v.amount, v.font, v.x + self.PickupHistoryWide, v.y - (v.height / 2), Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT)
            end
            y = y + (v.height + 16)
            tall = tall + v.height + 18
            wide = math.Max(wide, v.width + v.height + 24)
            if alpha == 0 then self.PickupHistory[k] = nil end
        end
    end
    self.PickupHistoryTop = (self.PickupHistoryTop * 5 + (ScrH() * 0.75 - tall) / 2) / 6
    self.PickupHistoryWide = (self.PickupHistoryWide * 5 + wide) / 6
end

function hidehud(name)
    for _, hudStrings in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudDamageIndicator"}) do
        if (name == hudStrings) then return false end
    end
    if (LocalPlayer().InSafeZone and name == "CHudWeaponSelection") then return false end
end
hook.Add("HUDShouldDraw", "HideOurHud:D", hidehud)

function DrawPickups()
    local traceRes = LocalPlayer():GetEyeTrace()
    local trace = util.TraceLine(traceRes)
    local dropTypes = {}
    dropTypes["base_item"] = {_U('getItem')}
    dropTypes["money"] = {_U('getMoney'), "MONEY"}
    dropTypes["backpack"] = {_U('getBackpack'), "BACKPACK"}
    dropTypes["bank"] = {_U('getBank'), "SAFE ZONE BANK"}
    if UseNewShop then
        dropTypes["shop"] = {_U('getShop'), "SAFE ZONE SHOP"}
    end
    dropTypes["player"] = {_U('getPlayerTrade'), "TRADE"}
    dropTypes["airdrop_crate"] = {_U('getAirdrop'), "AIRDROP CRATE"}
    if traceRes.HitPos and LocalPlayer():Alive() then
        for _, ent in pairs(ents.FindInSphere(traceRes.HitPos, 15)) do
            if ent and ent:IsValid() and (ent:GetPos() - LocalPlayer():GetPos()):Length() < 80 then
                local class = ent:GetClass()
                if (dropTypes[class] and ent ~= LocalPlayer()) then
                    local screenPos = ent:LocalToWorld(ent:OBBCenter()):ToScreen()
                    local pickupMsg = ""
                    if dropTypes[class][2] then
                        pickupMsg = dropTypes[class][2]
                    elseif (class == "base_item") then
                        pickupMsg = "ITEM"
                        local itemName = string.lower(ent:GetModel())
                        if ent.ItemID then pickupMsg = string.upper(DayZItems[ent.ItemID].Name) end
                    end
                    surface.SetMaterial(Material("icons/background_cracks"))
                    surface.SetDrawColor(Color(0, 0, 0, 200))
                    surface.DrawTexturedRectUV(screenPos.x + 40, screenPos.y - 40, 220, 25, 0, 0, 0.22, 0.025)
                    surface.SetMaterial(Material("icons/background_cracks"))
                    surface.SetDrawColor(Color(0, 0, 0, 200))
                    surface.DrawTexturedRectUV(screenPos.x + 40, screenPos.y - 10, 220, 25, 0, 0, 0.22, 0.05)
                    draw.DrawText(pickupMsg, "ChatFont", screenPos.x + 40, screenPos.y - 40, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText(dropTypes[class][1], "ChatFont", screenPos.x + 40, screenPos.y - 10, Color(182, 87, 93, 255), TEXT_ALIGN_LEFT)
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial(Material("icons/pickup"))
                    surface.DrawTexturedRect(screenPos.x - 35, screenPos.y - 30, 64, 64)
                end
            end
        end
    end
end
hook.Add("HUDPaint", "DrawPickups", DrawPickups)

local DMGIndicatorAlpha = 0
net.Receive("HurtInfo", function(len)
    local TimeH = 0.5
    LocalPlayer().DmgIndicatorTime = CurTime() + TimeH
    DMGIndicatorAlpha = 100
end)

hook.Add("HUDPaint", "DrawDamageIndicator", function()
    if DMGIndicatorAlpha <= 0 then return end
    if LocalPlayer().DmgIndicatorTime and LocalPlayer().DmgIndicatorTime < CurTime() then DMGIndicatorAlpha = DMGIndicatorAlpha - FrameTime() * 600 end
    if DMGIndicatorAlpha > 0 then draw.RoundedBox(10, 0, 0, ScrW(), ScrH(), Color(255, 0, 0, DMGIndicatorAlpha)) end
end)

net.Receive("HungerThirst", function(len)
    LocalPlayer().Hunger = net.ReadUInt(7)
    LocalPlayer().Thirst = net.ReadUInt(7)
end)

net.Receive("Stamina", function(len) LocalPlayer().Stamina = net.ReadUInt(7) end)

net.Receive("sendXP", function(len)
    LocalPlayer().XP = net.ReadUInt(16)
    LocalPlayer().Money = net.ReadUInt(16)
    LocalPlayer().Credits = net.ReadUInt(16)
end)

net.Receive("UpdatePerks", function(len)
    for i = 1, table.Count(DayZShop["shop_perks"]) do PlayerPerks[i] = numberToBool(net.ReadBit()) end
end)

local HitIndicatorAlpha = 0
net.Receive("SendHitInfo", function(len)
    local Time = 0.5
    LocalPlayer().HitIndicatorTime = CurTime() + Time
    HitIndicatorAlpha = 255
end)

hook.Add("HUDPaint", "DrawHitIndicator", function()
    if HitIndicatorAlpha <= 0 then return end
    if LocalPlayer().HitIndicatorTime and LocalPlayer().HitIndicatorTime < CurTime() then HitIndicatorAlpha = HitIndicatorAlpha - FrameTime() * 600 end
    if HitIndicatorAlpha > 0 then
        local x = ScrW() * 0.5
        local y = ScrH() * 0.5
        local Lenght = 21 * (HitIndicatorAlpha / 255)
        Lenght = math.Clamp(Lenght, 8, Lenght)
        local Size = 7
        surface.SetDrawColor(0, 0, 0, HitIndicatorAlpha)
        surface.DrawLine(x + Size, y - Size, x + Lenght, y - Lenght)
        surface.DrawLine(x - Size, y + Size, x - Lenght, y + Lenght)
        surface.DrawLine(x + Size, y + Size, x + Lenght, y + Lenght)
        surface.DrawLine(x - Size, y - Size, x - Lenght, y - Lenght)
        surface.SetDrawColor(225, 225, 225, HitIndicatorAlpha)
        Lenght = 20 * (HitIndicatorAlpha / 255)
        Lenght = math.Clamp(Lenght, 8, Lenght)
        Size = 8
        surface.DrawLine(x + Size, y - Size, x + Lenght, y - Lenght)
        surface.DrawLine(x - Size, y + Size, x - Lenght, y + Lenght)
        surface.DrawLine(x + Size, y + Size, x + Lenght, y + Lenght)
        surface.DrawLine(x - Size, y - Size, x - Lenght, y - Lenght)
    end
end)

function MyCalcView(ply, pos, angles, fov)
    local view = {}
    if (LocalPlayer().ThirdPerson and not LocalPlayer().ForceFirstPerson) then
        local trace = util.TraceLine({start = pos, endpos = ply:GetPos() - (angles:Forward() * 70) + Vector(0, 0, 80), filter = {ply:GetActiveWeapon(), ply}})
        if (trace.Hit and not ply:GetVehicle():IsValid()) then
            view.origin = trace.HitPos + angles:Forward() * 24
        else
            if (ply:GetVehicle():IsValid()) then
                view.origin = ply:GetPos() - (angles:Forward() * 180) + Vector(0, 0, 100)
            else
                view.origin = ply:GetPos() - (angles:Forward() * 70) + Vector(0, 0, 80)
            end
        end
    end
    return view
end
hook.Add("CalcView", "MyCalcView", MyCalcView)

function GM:ShouldDrawLocalPlayer()
    if (LocalPlayer().ThirdPerson == nil) then LocalPlayer().ThirdPerson = false end
    if (LocalPlayer().ThirdPerson and not LocalPlayer().ForceFirstPerson) then
        return true
    else
        return false
    end
end

function ThirdPersonButton()
    if (input.IsKeyDown(KEY_F4) and not F4Press) then
        LocalPlayer().ThirdPerson = not (LocalPlayer().ThirdPerson)
        F4Press = true
    end
    if not (input.IsKeyDown(KEY_F4)) then F4Press = false end
end
hook.Add("Think", "ThirdPersonButton", ThirdPersonButton)

function SetupWorldFog()
    render.FogMode(1)
    render.FogMaxDensity(0.75)
    render.FogColor(60, 60, 60)
    render.FogStart(0)
    render.FogEnd(1500)
    return true
end
hook.Add("SetupWorldFog", "SetupWorldFog", SetupWorldFog)

local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawLine = surface.DrawLine
local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local string_Explode = string.Explode
local math_Rand = math.Rand
local math_random = math.random
local math_sin = math.sin
local math_abs = math.abs
local HSVtoColor = HSVToColor
local Realtime = RealTime
local Frametime = FrameTime
local Curtime = CurTime
local Color = Color
local function m_GetTextSize(text, font)
    surface_SetFont(font)
    return surface_GetTextSize(text)
end
local should_align_x = {[TEXT_ALIGN_CENTER] = true, [TEXT_ALIGN_RIGHT] = true}
local should_align_y = {[TEXT_ALIGN_BOTTOM] = true}
local function m_AlignText(text, font, x, y, xalign, yalign)
    local tw, th = m_GetTextSize(text, font)
    if (should_align_x[xalign]) then x = xalign == TEXT_ALIGN_CENTER and x - (tw / 2) or x - tw end
    if (should_align_y[yalign]) then y = y - th end
    return x, y
end

function GlowColor(c, t, m) return Color(c.r + ((t.r - c.r) * (m)), c.g + ((t.g - c.g) * (m)), c.b + ((t.b - c.b) * (m))) end

function DrawShadowedText(shadow, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    draw_SimpleText(text, font, x + shadow, y + shadow, Color(0, 0, 0, color.a or 255), xalign, yalign)
    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawEnchantedText(speed, text, font, x, y, color, glow_color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    glow_color = glow_color or Color(127, 0, 255)
    local texte = string_Explode("", text)
    local chars_x = 0
    x, y = m_AlignText(text, font, x, y, xalign, yalign)
    surface_SetFont(font)
    for i = 1, #texte do
        local char = texte[i]
        local charw = surface_GetTextSize(char)
        local color_glowing = GlowColor(glow_color, color, math_abs(math_sin((Realtime() - (i * 0.08)) * speed)))
        draw_SimpleText(char, font, x + chars_x, y, color_glowing, xalign, yalign)
        chars_x = chars_x + charw
    end
end

function DrawFadingText(speed, text, font, x, y, color, fading_color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    fading_color = fading_color or Color(255, 255, 255)
    local c = GlowColor(color, fading_color, math_abs(math_sin((Realtime() - 0.08) * speed)))
    draw_SimpleText(text, font, x, y, c, xalign, yalign)
end

function DrawRainbowText(speed, text, font, x, y, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    draw_SimpleText(text, font, x, y, HSVtoColor(Curtime() * (70 * speed) % 360, 1, 1), xalign, yalign)
end

function DrawGlowingText(static, text, font, x, y, color, xalign, yalign)
    local xalign = xalign or TEXT_ALIGN_LEFT
    local yalign = yalign or TEXT_ALIGN_TOP
    local g = static and 1 or math_abs(math_sin((Realtime() - 0.1) * 2))
    for i = 1, 2 do draw_SimpleTextOutlined(text, font, x, y, color, xalign, yalign, i, Color(color.r, color.g, color.b, (20 - (i * 5)) * g)) end
    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawBouncingText(style, intesity, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    local chars_x = 0
    local texte = string_Explode("", text)
    local x, y = m_AlignText(text, font, x, y, xalign, yalign)
    surface_SetFont(font)
    for i = 1, #texte do
        local char = texte[i]
        local charw = surface_GetTextSize(char)
        local y_pos = 1
        local mod = math_sin((Realtime() - (i * 0.1)) * (2 * intesity))
        if (style < 3) then
            y_pos = style == 1 and y_pos - math_abs(mod) or y_pos + math_abs(mod)
        else
            y_pos = y_pos - mod
        end
        draw_SimpleText(char, font, x + chars_x, y - (5 * y_pos), color, xalign, yalign)
        chars_x = chars_x + charw
    end
end

local ne, ea = Curtime(), 0
function DrawElectricText(intensity, text, font, x, y, color, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    draw_SimpleText(text, font, x, y, color, xalign, yalign)
    local charw, charh = m_GetTextSize(text, font)
    ea = ea > 0 and ea - (1000 * Frametime()) or 0
    surface_SetDrawColor(102, 255, 255, ea)
    for i = 1, math_random(5) do surface_DrawLine(x + math_random(charw), y + math_random(charh), x + math_random(charw), y + math_random(charh)) end
    if (ne <= Curtime()) then
        ne = Curtime() + math_Rand(0.5 + (1 - intensity), 1.5 + (1 - intensity))
        ea = 255
    end
end

function DrawFireText(intensity, text, font, x, y, color, xalign, yalign, glow, shadow)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    local cw, ch = m_GetTextSize(text, font)
    for i = 1, cw do
        surface_SetDrawColor(255, math_random(255), 0, 150)
        surface_DrawLine(x - 1 + i, y + ch, x - 1 + i + math_random(-4, 4), y + math_random(ch * intensity, ch))
    end
    if (glow) then DrawGlowingText(true, text, font, x, y, color, xalign, yalign) end
    if (shadow) then draw_SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0), xalign, yalign) end
    draw_SimpleText(text, font, x, y, color, xalign, yalign)
end

function DrawSnowingText(intensity, text, font, x, y, color, color2, xalign, yalign)
    xalign = xalign or TEXT_ALIGN_LEFT
    yalign = yalign or TEXT_ALIGN_TOP
    color2 = color2 or Color(255, 255, 255)
    draw_SimpleText(text, font, x, y, color, xalign, yalign)
    surface_SetDrawColor(color2.r, color2.g, color2.b, 255)
    local tw, th = m_GetTextSize(text, font)
    for i = 1, intensity do
        local lx, ly = math_Rand(0, tw), math_Rand(0, th)
        surface_DrawLine(x + lx, y + ly, x + lx, y + ly + 1)
    end
end