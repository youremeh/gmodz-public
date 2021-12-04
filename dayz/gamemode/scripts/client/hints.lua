local XpAddInc = false
local XPPos = 0
local XP_Amount = 0
local MoneyAddInc = false
local MoneyPos = 0
local Money_Amount = 0
local TipAddInc = false
local TipAlpha = 0
local Tip_String = ""

function HINTPaint()
    if LocalPlayer():IsValid() then
        if itemPlacer then
            draw.DrawText("Press LMB to place or RMB to remove", "Trebuchet24", ScrW() / 2, (ScrH() * 0.8), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            draw.DrawText("Press R to rotate", "Trebuchet24", ScrW() / 2, (ScrH() * 0.8 + 30), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        end
        if XpAddInc == true then
            if XPPos < 200 then XPPos = XPPos + 3 end
        else
            if XPPos > 0 then XPPos = XPPos - 3 end
        end
        local x, y = ScrW() - XPPos, ScrH() * 0.25
        local w, h = 200, 35
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(0, 0, 0, 200))
        surface.DrawTexturedRectUV(x, y, w, h, 0, 0, w * 0.001, h * 0.001)
        draw.DrawText("+"..XP_Amount.."XP Awarded", "Trebuchet24", ScrW() - (XPPos - 15), (ScrH() * 0.25) + 6, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        if MoneyAddInc == true then
            if MoneyPos < 255 then MoneyPos = MoneyPos + 3 end
        else
            if MoneyPos > 0 then MoneyPos = MoneyPos - 3 end
        end
        local x, y = 0, ScrH() / 1.5
        local w, h = 200, 35
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(0, 0, 0, MoneyPos * 0.8))
        surface.DrawTexturedRectUV(x, y, w, h, 0, 0, w * 0.001, h * 0.001)
        draw.DrawText("$"..Money_Amount.." Picked up", "Trebuchet24", 25, (ScrH() / 1.5) + 6, Color(255, 255, 255, MoneyPos), TEXT_ALIGN_LEFT)
        if TipAddInc == true then
            if TipAlpha < 255 then TipAlpha = TipAlpha + 3 end
        else
            if TipAlpha > 0 then
                TipAlpha = TipAlpha - 3
            end
        end
        draw.DrawText("Tip: "..Tip_String, "Trebuchet24", ScrW() / 2, ScrH() - 150, Color(255, 255, 255, TipAlpha), TEXT_ALIGN_CENTER)
    end
end
hook.Add("HUDPaint", "PaintOurHint", HINTPaint)

net.Receive("xpGain", function(len)
    XP_Amount = net.ReadUInt(10)
    XpAddInc = true
    timer.Simple(4, function() XpAddInc = false end)
end)

function Money_CL(umsg)
    Money_Amount = umsg:ReadFloat()
    MoneyAddInc = true
    timer.Simple(4, function() MoneyAddInc = false end)
end
usermessage.Hook("Money_CL", Money_CL)

net.Receive("TipSend", function(len)
    Tip_String = net.ReadString()
    TipAddInc = true
    timer.Simple(4, function() TipAddInc = false end)
end)