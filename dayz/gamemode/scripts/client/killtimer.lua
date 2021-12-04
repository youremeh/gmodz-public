local KillTimer = 0
local function RecvKillTimer() KillTimer = net.ReadUInt(32) end
net.Receive("SendKillTimer", RecvKillTimer)
function HUDPaintTimer()
	local SW, SH = ScrW(), ScrH()
	if KillTimer > CurTime() then
		local halfSW = SW * 0.5
		local halfSH = SH * 0.95
		DrawFadingText(0.8, 'Combat Timer: '..string.ToMinutesSeconds(KillTimer - CurTime()), 'TargetIDMedium', halfSW, halfSH, Color(255, 50, 50, 255), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
end
hook.Add("HUDPaint", "HUDPaintTimer", HUDPaintTimer)