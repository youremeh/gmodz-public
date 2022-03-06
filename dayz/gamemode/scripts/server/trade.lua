util.AddNetworkString("OpenTradeMenu")
util.AddNetworkString("CloseTradeMenu")
util.AddNetworkString("UpdateTrade")
util.AddNetworkString("UpdateOffer")
util.AddNetworkString("CL_RequestTradeClose")
util.AddNetworkString("CL_RequestAccept")
util.AddNetworkString("CL_OfferItem")
util.AddNetworkString("CL_OfferMoney")

function PMETA:OfferMoney(amount)
    if not self:Alive() then return end
    if self.Money < amount then return end
    if (not self.TradeWith or not self.TradeWith:IsValid()) then
        CloseTrade(self)
        return
    end
    self.AcceptTrade = nil
    self.TradeWith.AcceptTrade = nil
    self.OfferedItems["money"] = amount
    net.Start("UpdateTrade")
    net.WriteEntity(self)
    for i = 1, table.Count(DayZItems) do net.WriteUInt(self.OfferedItems[i], 14) end
    net.WriteUInt(amount, 14)
    net.Send({self, self.TradeWith})
end

net.Receive("CL_OfferMoney", function(len, ply)
    local useless = net.ReadUInt(14)
    ply:OfferMoney(tonumber(math.floor(net.ReadUInt(14))))
end)

function PMETA:OfferItem(itemID, amount)
    if not self:Alive() then return end
    if not self:HasItem(itemID) then return end
    if (not self.TradeWith or not self.TradeWith:IsValid()) then
        CloseTrade(self)
        return
    end
    self.AcceptTrade = nil
    self.TradeWith.AcceptTrade = nil
    self.OfferedItems[itemID] = amount
    net.Start("UpdateTrade")
    net.WriteEntity(self)
    for i = 1, table.Count(DayZItems) do net.WriteUInt(self.OfferedItems[i], 14) end
    net.WriteUInt((self.OfferedItems["money"] or 0), 14)
    net.Send({self, self.TradeWith})
end
net.Receive("CL_OfferItem", function(len, ply) ply:OfferItem(net.ReadUInt(14), net.ReadUInt(14)) end)

function PMETA:AcceptOffer()
    if not self.TradeWith then return end
    self.AcceptTrade = true
    net.Start("UpdateOffer")
    net.WriteEntity(self)
    net.Send({self, self.TradeWith})
    if (self.TradeWith and self.TradeWith:IsValid() and self.TradeWith.AcceptTrade == true) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Trade accepted")
        self.TradeWith:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Trade accepted")
        for i = 1, table.Count(DayZItems) do
            self:GiveItem(i, self.TradeWith.OfferedItems[i])
            self.TradeWith:TakeItem(i, self.TradeWith.OfferedItems[i])
            self.TradeWith:GiveItem(i, self.OfferedItems[i])
            self:TakeItem(i, self.OfferedItems[i])
        end
        print(self.OfferedItems["money"], self.TradeWith.OfferedItems["money"])
        if(self.Money >= math.floor(tonumber(self.OfferedItems["money"]))) then
            self.TradeWith:GiveMoney(math.floor(tonumber(self.OfferedItems["money"])))
            self:GiveTakeMoney(-math.floor(tonumber(self.OfferedItems["money"])))
        end
        if(self.TradeWith.Money >= math.floor(tonumber(self.TradeWith.OfferedItems["money"]))) then
            self:GiveMoney(math.floor(tonumber(self.TradeWith.OfferedItems["money"])))
            self.TradeWith:GiveTakeMoney(-math.floor(tonumber(self.TradeWith.OfferedItems["money"])))
        end
        CloseTrade(self, true)
        self:EmitSound("item_buy.wav", 75, 100)
    end
end
net.Receive("CL_RequestAccept", function(len, ply) ply:AcceptOffer() end)

function PlayerThink()
    for _, ply in pairs(player.GetAll()) do
        if not ply.CantUse and (ply:KeyDown(IN_USE)) then
            local tracedata = {start = ply:GetShootPos(), endpos = ply:GetShootPos() + (ply:GetAimVector() * 80), filter = ply}
            local trace = util.TraceLine(tracedata)
            if (trace.HitNonWorld and trace.Entity:IsPlayer()) then
                local ply2 = trace.Entity
                if (ply2.TradeTarget == ply) then
                    ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You have agreed to trade with ", Color(50, 255, 50), ply2:Nick(), Color(255, 255, 255))
                    ply2:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(50, 255, 50), ply:Nick(), Color(255, 255, 255), " has agreed to trade with you")
                    ply.CantUse = true
                    ply.TradeWith = ply2
                    ply2.TradeWith = ply
                    OpenTrade(ply, ply2)
                	timer.Simple(1, function() if ply:IsValid() then ply.CantUse = false end end)
            	else
                	ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You have requested to trade with ", Color(50, 255, 50), ply2:Nick(), Color(255, 255, 255))
               		ply2:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(50, 255, 50), ply:Nick(), Color(255, 255, 255), " has requested to trade with you. Press E on them to accept")
                	ply.TradeTarget = ply2
                	ply.CantUse = true
            		timer.Simple(1, function() if ply:IsValid() then ply.CantUse = false end end)
        			timer.Simple(5, function() if ply:IsValid() then ply.TradeTarget = nil end end)
    			end
			end
		end
	end
end
hook.Add("Think", "PlayerThink", PlayerThink)

function OpenTrade(ply, ply2)
    if not ply.OfferedItems then ply.OfferedItems = {} end
    if not ply2.OfferedItems then ply2.OfferedItems = {} end
    for i = 1, table.Count(DayZItems) do
        ply.OfferedItems[i] = 0
        ply2.OfferedItems[i] = 0
    end
    ply.OfferedItems["money"] = 0
    ply2.OfferedItems["money"] = 0
    ply.AcceptTrade = nil
    ply2.AcceptTrade = nil
    net.Start("OpenTradeMenu")
    net.WriteEntity(ply)
    net.Send(ply2)
    net.Start("OpenTradeMenu")
    net.WriteEntity(ply2)
    net.Send(ply)
end

function CloseTrade(ply, noMessage)
    local ply2 = ply.TradeWith
    if (ply2 and ply2:IsValid()) then
        ply2.TradeWith = nil
        ply2.TradeTarget = nil
        if (not noMessage) then ply2:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(50, 255, 50), ply:Nick(), Color(255, 255, 255), " has declined the trade") end
    end
    ply.TradeWith = nil
    ply.TradeTarget = nil
    if (not noMessage) then ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You have declined the trade") end
    net.Start("CloseTradeMenu")
    if (ply2 and ply2:IsValid()) then
        net.Send({ply, ply2})
    else
        net.Send(ply)
    end
end
net.Receive("CL_RequestTradeClose", function(len, ply) CloseTrade(ply) end)