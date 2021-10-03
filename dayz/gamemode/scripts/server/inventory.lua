PMETA = FindMetaTable("Player")
util.AddNetworkString("UpdateInventory")
util.AddNetworkString("UpdateItem")
util.AddNetworkString("UpdateBank")
util.AddNetworkString("UpdateSkills")
util.AddNetworkString("TipSend")
util.AddNetworkString("sendXP")
util.AddNetworkString("xpGain")
util.AddNetworkString("UpdatePerks")
util.AddNetworkString("SendCraft")
util.AddNetworkString("CL_DropItem")
util.AddNetworkString("CL_PlaceItem")
util.AddNetworkString("CL_UpdateCharacter")
util.AddNetworkString("CL_UseItem")
util.AddNetworkString("CL_DepositItem")
util.AddNetworkString("CL_WithdrawItem")
util.AddNetworkString("CL_LootItem")
util.AddNetworkString("CL_BuySkill")
util.AddNetworkString("UpdateSell")
util.AddNetworkString("CL_SellItem")

net.Receive("CL_SellItem", function(len, ply)
    local itemID = net.ReadUInt(14)
    local quantity = net.ReadUInt(14)
    if not ply:Alive() then return end
    if not ply:HasItem(itemID) then return end
    if tonumber(ply:HasItem(itemID)) < quantity then return end
    if not DayZItems[itemID] or not DayZItems[itemID].CanBeSold then return end
    if not DayZItems[itemID].Price or DayZItems[itemID].Price <= 0 then return end
    local price = math.floor(DayZItems[itemID].Price / 8) * quantity
    ply:GiveMoney(price)
    ply:TakeItem(itemID, quantity)
    ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You sold ", Color(50, 255, 50), quantity, 'x ', DayZItems[itemID].Name, Color(255, 255, 255), " for ", Color(50, 255, 50), '$', price)
    net.Start("UpdateSell")
    net.Send(ply)
end)

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
    if ply:HasItem(15) then return true end
    return false
end

function PMETA:AddWeight()
    local weight = 0
    local bankWeight = 0
    for i = 1, table.Count(DayZItems) do
        if (DayZItems[i].Weight) then
            weight = weight + DayZItems[i].Weight * self.Inventory[i]
            bankWeight = bankWeight + DayZItems[i].Weight * self.BankTable[i]
        end
    end
    self.WeightCur = weight
    self.WeightBankCur = bankWeight
end

function PMETA:DropAll()
    local BonePos, BoneAng = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Spine4"))
    BonePos = BonePos + (BoneAng:Forward() * -28) + (BoneAng:Right() * -2) + (BoneAng:Up() * -2)
    BoneAng = Angle(0, BoneAng.y + 180, 0)
    local BackPackEnt = ents.Create("backpack")
    BackPackEnt:SetPos(BonePos)
    BackPackEnt:SetAngles(BoneAng)
    BackPackEnt.OwnerSteamID = self:SteamID()
    BackPackEnt.Inventory = {}
    BackPackEnt:Spawn()
    if (BackPackEnt:GetPhysicsObject():IsValid() and self:Alive()) then BackPackEnt:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, -1)) end
    for i = 1, table.Count(DayZItems) do
        BackPackEnt.Inventory[i] = self.Inventory[i]
        if (self.Perk[3] == true) and (math.random(0, 100) <= 100) then
            self:SetItem(i, 0)
        else
            self:SetItem(i, 0)
        end
    end
    if self.face == 99 then BackPackEnt.Inventory[21] = BackPackEnt.Inventory[21] + 1 end
end

function PMETA:LoadInventory()
    if not self.Inventory then self.Inventory = {} end
    local playerItems = sql.QueryRow("SELECT * FROM DayZ_items WHERE unique_id = '"..self:SteamID() .. "'")
    playerItems.unique_id = nil
    for i = 1, table.Count(DayZItems) do self.Inventory[i] = tonumber(playerItems["Item"..i]) end
    self:LoadBank()
    self:SendInventory()
    self:AddWeight()
    self:UpdateWeapons()
end

function PMETA:LoadSkills()
    if not self.Skills then self.Skills = {} end
    local playerSkills = sql.QueryRow("SELECT * FROM DayZ_skills WHERE unique_id = '"..self:SteamID() .. "'")
    playerSkills.unique_id = nil
    for i = 1, table.Count(DayZSkills) do self.Skills[i] = tonumber(playerSkills["Skill"..i]) end
    self:SendSkills()
end

function PMETA:SendSkills()
    net.Start("UpdateSkills")
    for i = 1, table.Count(DayZSkills) do net.WriteUInt(self.Skills[i], 14) end
    net.Send(self)
end

function PMETA:TakeXP(amount)
    self.XP = self.XP - amount
    saveMoney(self)
    self:UpdateCurrencies()
end

function PMETA:HasSkill(SkillID)
    if not DayZSkills[SkillID] then return false end
    if self.Skills[SkillID] > 0 then
        return true
    else
        return false
    end
end

function PMETA:BuySkill(SkillID)
    if not DayZSkills[SkillID] then return end
    if self:HasSkill(SkillID) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You already have this skill")
        return
    end
    if DayZSkills[SkillID].Prereq then
        if not self:HasSkill(DayZSkills[SkillID].Prereq) then
            self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You do not meet the prerequisite for this skill")
            return
        end
    end
    local Cost = DayZSkills[SkillID].XP
    local XP = self.XP
    if XP - Cost < 0 then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You are not expierenced enough")
        return
    end
    self:TakeXP(Cost)
    self.Skills[SkillID] = 1
    self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You have learned: ", Color(50, 255, 50), DayZSkills[SkillID].Name, Color(255, 255, 255), "!")
    sql.Query("UPDATE DayZ_skills SET "..tostring("Skill"..SkillID) .. " = "..self.Skills[SkillID] .. " WHERE unique_id = '"..self:SteamID() .. "'")
    self:SendSkills()
end
net.Receive("CL_BuySkill", function(len, ply) ply:BuySkill(net.ReadUInt(14)) end)

function PMETA:SendInventory()
    net.Start("UpdateInventory")
    for i = 1, table.Count(DayZItems) do net.WriteUInt(self.Inventory[i], 14) end
    net.Send(self)
end

function PMETA:UpdateItem(itemID)
    sql.Query("UPDATE DayZ_items SET "..tostring("Item"..itemID) .. " = "..self.Inventory[itemID] .. " WHERE unique_id = '"..self:SteamID() .. "'")
    self:SendInventory()
    self:UpdateWeapons()
    self:AddWeight()
    local wep = self:GetActiveWeapon()
    if (wep:IsValid() and wep:IsWeapon() and wep:Clip2() >= 0) then
        wep:SetClip2(HasItem(self, wep.Primary.AmmoItem))
        wep:UpdateClip()
    end
end

function PMETA:setCharModel(face, clothes, gender)
    self.gender = tonumber(gender)
    self.face = tonumber(face)
    self.clothes = tonumber(clothes)
    self:UpdateCharModel()
end

function PMETA:UpdateCharModel()
    gender = tonumber(self.gender)
    face = tonumber(self.face)
    clothes = tonumber(self.clothes)
    if face == 99 then
        self:SetModel("models/combine_sniper.mdl")
    else
        if (gender == 0) then
            self:SetModel(DayZ_Male[face][clothes])
        elseif (gander == 1) then
            self:SetModel(DayZ_Female[face][clothes])
        elseif (gender == 2) then
            self:SetModel(DayZ_Custom[face][clothes])
        end
    end
    saveAppearance(self)
end

net.Receive("CL_UpdateCharacter", function(len, ply) ply:setCharModel(net.ReadUInt(6), net.ReadUInt(6), net.ReadUInt(6)) end)

function PMETA:UpdateWeapons()
    for ItemID = 1, table.Count(DayZItems) do
        if DayZItems[ItemID].Weapon ~= nil then
            if self:HasItem(ItemID) then
                self:Give(DayZItems[ItemID].Weapon)
            else
                self:StripWeapon(DayZItems[ItemID].Weapon)
            end
        end
    end
end

function PMETA:HasItem(ItemID)
    local quantity = self.Inventory[ItemID]
    if (quantity > 0) then return quantity end
    return false
end

function PMETA:GiveItem(itemID, amount)
    local amount = tonumber(amount)
    if amount < 0 then return false end
    self.Inventory[itemID] = self.Inventory[itemID] + amount
    self:UpdateItem(itemID)
end

function PMETA:SetItem(itemID, amount)
    local amount = tonumber(amount)
    self.Inventory[itemID] = amount
    sql.Query("UPDATE DayZ_items SET "..tostring("Item"..itemID) .. " = "..self.Inventory[itemID] .. " WHERE unique_id = '"..self:SteamID() .. "'")
    self:UpdateItem(itemID)
end

function PMETA:TakeItem(itemID, amount)
    if tonumber(amount) < 0 then return false end
    self.Inventory[itemID] = math.Clamp(self.Inventory[itemID] - amount, 0, 9999999999)
    self:UpdateItem(itemID)
end

concommand.Add("useitem", function(ply, cmd, args) ply:UseItem(itemID) end)
function PMETA:UseItem(itemID)
    if not self:Alive() then return end
    if not self:HasItem(itemID) then return end
    local useItem = DayZItems[itemID].useFunc(self, itemID)
    if not useItem then self:TakeItem(itemID, 1) end
end

net.Receive("CL_UseItem", function(len, ply)
    ply:UseItem(net.ReadUInt(14))
    local unused = net.ReadUInt(14)
end)

function PMETA:UpdatePerks()
    local perkTable = sql.QueryRow("SELECT * FROM DayZ_perks WHERE unique_id = '"..self:SteamID() .. "'")
    self.Perk = {}
    self.Perk[1] = numberToBool(perkTable.Item_perk1)
    self.Perk[2] = numberToBool(perkTable.Item_perk2)
    self.Perk[3] = numberToBool(perkTable.Item_perk3)
    self.Perk[4] = numberToBool(perkTable.Item_perk4)
    self.Perk[5] = numberToBool(perkTable.Item_perk5)
    net.Start("UpdatePerks")
    for i = 1, table.Count(DayZShop["shop_perks"]) do net.WriteBit(self.Perk[i]) end
    net.Send(self)
end

function PMETA:GivePerk(perk)
    if not perk then return false end
    self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You have unlocked the ", Color(50, 255, 50), DayZItems[DayZShop["shop_perks"][perk]].Name, Color(255, 255, 255), " perk!")
    sql.Query("UPDATE DayZ_perks SET Item_perk"..perk.." = 1 WHERE unique_id = '"..self:SteamID() .. "'")
    self:UpdatePerks()
end

function PMETA:HasPerk(perk)
    if self.Perk[perk] == 1 then
        return true
    else
        return false
    end
end

function PMETA:PlaceItem(ItemID, position, rotation)
    local ItemID = tonumber(ItemID)
    local inSafeZone = self:inSafeZone()
    if (inSafeZone == true and DayZItems[ItemID].Pot) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You cannot place plant pots in a Safe Zone")
        return false
    end
    if (inSafeZone == true and DayZItems[ItemID].Barricade) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You cannot place barricades in a Safe Zone")
        return false
    end
    self.Inventory[ItemID] = self.Inventory[ItemID] - 1
    local PlacedEnt = ents.Create("base_item")
    PlacedEnt.ItemID = ItemID
    PlacedEnt.Amount = 1
    PlacedEnt.Dropped = true
    PlacedEnt.Owner = self
    PlacedEnt:SetPos(position)
    PlacedEnt:SetAngles(rotation)
    PlacedEnt:Spawn()
    if DayZItems[ItemID].PlaceFunction then
        local placebItem = DayZItems[ItemID].PlaceFunction(self, PlacedEnt, ItemID)
    end
    self:UpdateItem(ItemID)
end
net.Receive("CL_PlaceItem", function(len, ply) ply:PlaceItem(net.ReadUInt(14), net.ReadVector(), net.ReadAngle()) end)

function PMETA:DropItem(ItemID, amount)
    ItemID, amount = tonumber(ItemID), tonumber(amount)
    if amount < 0 then return false end
    if not self:HasItem(ItemID) or tonumber(self:HasItem(ItemID)) < amount then return end
    self.Inventory[ItemID] = self.Inventory[ItemID] - amount
    local DropedEnt = ents.Create("base_item")
    DropedEnt.ItemID = ItemID
    DropedEnt.Amount = amount
    DropedEnt.Dropped = true
    DropedEnt:SetPos(self:EyePos() + (self:GetAimVector() * 30))
    DropedEnt:SetAngles(Angle(0, self:EyeAngles().y, 0))
    DropedEnt:Spawn()
    if DropedEnt:GetPhysicsObject():IsValid() and self:Alive() then DropedEnt:GetPhysicsObject():ApplyForceCenter(self:GetAimVector() * 120) end
    self:UpdateItem(ItemID)
end
net.Receive("CL_DropItem", function(len, ply) ply:DropItem(net.ReadUInt(14), net.ReadUInt(14)) end)

function PMETA:Drink(amount)
    if amount < 0 then return false end
    if self.Thirst + amount > 100 then
        self.Thirst = 100
        self:EmitSound("action/action_drink_0.wav", 50, 100)
    else
        self.Thirst = self.Thirst + amount
        self:EmitSound("action/action_drink_0.wav", 50, 100)
    end
    saveSurvivalStats(self)
end

function PMETA:Eat(amount)
    if amount < 0 then return false end
    if self.Hunger + amount > 100 then
        self.Hunger = 100
        self:EmitSound("action/action_eat_"..math.random(0,3)..".wav", 50, 100)
    else
        self.Hunger = self.Hunger + amount
        self:EmitSound("action/action_eat_"..math.random(0,3)..".wav", 50, 100)
    end
    saveSurvivalStats(self)
end

function PMETA:Heal(amount, painkiller)
    if amount < 0 then return false end
    if self:HasSkill(8) then amount = amount + 15 end
    if self:Health() + amount > 100 then
        self:SetHealth(100)
        if painkiller then
            self:EmitSound("action/painkiller_0"..math.random(1,4)..".wav", 50, 100)
        else
            self:EmitSound("action/bandage_0"..math.random(1,2)..".wav", 50, 100)
        end
    else
        self:SetHealth(self:Health() + amount)
        if painkiller then
            self:EmitSound("action/painkiller_0"..math.random(1,4)..".wav", 50, 100)
        else
            self:EmitSound("action/bandage_0"..math.random(1,2)..".wav", 50, 100)
        end
    end
    saveSurvivalStats(self)
end

function PMETA:BuyItemMoney(ItemID, amount)
    ItemID, amount = tonumber(ItemID), tonumber(amount)
    if amount < 0 then return false end
    if DayZItems[ItemID].Price * amount > self.Money then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You can't afford that")
        return false
    end
    local weightLimit = self:getWeightLimit()
    if (self.WeightCur + (DayZItems[ItemID].Weight * amount) > weightLimit) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Your inventory is full")
        return false
    end
    self.Money = self.Money - (amount * DayZItems[ItemID].Price)
    if DayZItems[ItemID].ClipSize then amount = DayZItems[ItemID].ClipSize end
    self:GiveItem(ItemID, amount)
    self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You spent ", Color(50, 255, 50), '$', DayZItems[ItemID].Price, Color(255, 255, 255), ' on ', Color(50, 255, 50), DayZItems[ItemID].Name, Color(255, 255, 255), "!")
    self:EmitSound("item_buy.wav", 75, 100)
    self:UpdateCurrencies()
    if DayZItems[ItemID].LootType == "Perk" then self:UseItem(ItemID) end
end
concommand.Add("BuyItemMoney", function(ply, cmd, args) ply:BuyItemMoney(args[1], 1) end)

function PMETA:BuyItemCredits(ItemID, amount)
    ItemID, amount = tonumber(ItemID), tonumber(amount)
    if amount < 0 then return false end
    if DayZItems[ItemID].Credits * amount > self.Credits then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You can't afford that")
        return false
    end
    local weightLimit = self:getWeightLimit()
    if (self.WeightCur + (DayZItems[ItemID].Weight * amount) > weightLimit) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Your inventory is full")
        return false
    end
    self.Credits = self.Credits - (amount * DayZItems[ItemID].Credits)
    if DayZItems[ItemID].ClipSize then amount = DayZItems[ItemID].ClipSize end
    self:GiveItem(ItemID, amount)
    self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You spent ", Color(50, 255, 50), DayZItems[ItemID].Credits, Color(255, 255, 255), ' credits on ', Color(50, 255, 50), DayZItems[ItemID].Name, Color(255, 255, 255), "!")
    self:EmitSound("item_buy.wav", 75, 100)
    self:UpdateCurrencies()
    if DayZItems[ItemID].LootType == "Perk" then self:UseItem(ItemID) end
end
concommand.Add("BuyItemCredits", function(ply, cmd, args) ply:BuyItemCredits(args[1], 1) end)

function PMETA:GiveXP(amount)
    self.XP = self.XP + amount
    self:UpdateCurrencies()
    net.Start("xpGain")
    net.WriteUInt(amount, 10)
    net.Send(self)
end

function PMETA:UpdateCurrencies()
    net.Start("sendXP")
    net.WriteUInt(self.XP, 16)
    net.WriteUInt(self.Money, 16)
    net.WriteUInt(self.Credits, 16)
    net.Send(self)
    saveMoney(self)
end

function PMETA:GiveMoney(amount)
    if tonumber(amount) < 0 then return false end
    self.Money = self.Money + amount
    self:UpdateCurrencies()
end

function PMETA:GiveTakeMoney(amount)
    self.Money = self.Money + amount
    self:UpdateCurrencies()
end

function PMETA:GiveCredits(amount)
    if tonumber(amount) < 0 then return false end
    self.Credits = self.Credits + amount
    self:UpdateCurrencies()
end

function PMETA:Tip(Str)
    if Str then
        net.Start("TipSend")
        net.WriteString(Str)
        net.Send(self)
    end
end

function GM:ShowTeam(ply)
    if (ply.SafeZone) and (UseNewShop == false) then
        umsg.Start("DonatorMenu", ply)
        umsg.End()
    end
end

function GM:ShowSpare1(ply) end

function PMETA:LoadBank()
    if not self.BankTable then self.BankTable = {} end
    local bankItems = sql.QueryRow("SELECT * FROM DayZ_bank WHERE unique_id = '"..self:SteamID() .. "'")
    bankItems.unique_id = nil
    for i = 1, table.Count(DayZItems) do self.BankTable[i] = tonumber(bankItems["Item"..i]) end
    self:SendBank()
end

function PMETA:UpdateBankItem(ItemID)
    sql.Query("UPDATE DayZ_bank SET "..tostring("Item"..ItemID) .. " = "..self.BankTable[ItemID] .. " WHERE unique_id = '"..self:SteamID() .. "'")
    self:SendBank()
end

function PMETA:SendBank()
    net.Start("UpdateBank")
    for i = 1, table.Count(DayZItems) do net.WriteUInt(self.BankTable[i], 14) end
    net.Send(self)
end

function PMETA:Deposit(ItemID, amount)
    local ItemID, amount = tonumber(ItemID), tonumber(amount)
    if amount < 0 then return false end
    if self.Inventory[ItemID] - amount < 0 then return false end
    self:AddWeight()
    local weightLimit = self:getWeightLimitBank()
    if (self.WeightBankCur + (DayZItems[ItemID].Weight * amount) > weightLimit) and (self:GetNWInt("plevel") == 0) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Your bank is full. Consider donating to earn more space")
        return false
    end
    self.Inventory[ItemID] = self.Inventory[ItemID] - amount
    self:UpdateItem(ItemID)
    self.BankTable[ItemID] = self.BankTable[ItemID] + amount
    self:UpdateBankItem(ItemID)
end
net.Receive("CL_DepositItem", function(len, ply) ply:Deposit(net.ReadUInt(14), net.ReadUInt(14)) end)

function PMETA:Withdraw(ItemID, amount)
    local ItemID, amount = tonumber(ItemID), tonumber(amount)
    if amount < 0 then return false end
    if self.BankTable[ItemID] - amount < 0 then return false end
    local weightLimit = self:getWeightLimit()
    if (self.WeightCur + (DayZItems[ItemID].Weight * amount) > weightLimit) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Your inventory is full")
        return false
    end
    self.BankTable[ItemID] = self.BankTable[ItemID] - amount
    self:GiveItem(ItemID, amount)
    self:UpdateItem(ItemID)
    self:UpdateBankItem(ItemID)
end
net.Receive("CL_WithdrawItem", function(len, ply) ply:Withdraw(net.ReadUInt(14), net.ReadUInt(14)) end)

function PMETA:LootItem(itemID, amount)
    local itemID, amount = tonumber(itemID), tonumber(amount)
    local backpack = self.LootTarget
    if not backpack or not backpack:IsValid() then return false end
    if not self.WeightCur then return false end
    if (self:GetPos():Distance(backpack:GetPos()) > 100) then return false end
    local weightLimit = self:getWeightLimit()
    if (self.WeightCur + (DayZItems[itemID].Weight * amount) > weightLimit) then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Your inventory is full")
        return false
    end
    if (backpack.Inventory[itemID] - amount) < 0 then
        self:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "This item was already taken")
        return false
    end
    backpack.Inventory[itemID] = backpack.Inventory[itemID] - amount
    self:EmitSound("items/itempickup.wav", 110, 100)
    self:GiveItem(itemID, amount)
    for _, ply in pairs(player.GetAll()) do
        if (ply.LootTarget == backpack) and (backpack:GetPos():Distance(ply:GetPos()) < 200) then
            if(ply.LootTarget:GetClass() ~= "airdrop_crate")then
                UpdateBackpackLoot(backpack, ply)
            else
                UpdateAirdropLoot(backpack, ply)
            end
        end
    end
end
net.Receive("CL_LootItem", function(len, ply) ply:LootItem(net.ReadUInt(14), net.ReadUInt(14)) end)

concommand.Add("CraftItem", function(ply, _, args)
    if ply:GetNWInt("plevel") <= 0 then
        ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "Crafting is for supporters only! Please consider donating to unlock this feature")
        return
    end
    if not ply or not ply:IsValid() then return end
    if not args or not args[1] then return end
    local item = tonumber(args[1])
    if not DayZItems[item] then return end
    local craft = nil
    if not ply.Crafts then ply.Crafts = 0 end
    if (ply.Crafts or 0) >= 5 then ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You can't craft more than 5 items at a time") return end
    for k, v in pairs(DayZCraft) do
        for n, p in pairs(v) do
            if p[1] == item then craft = p end
        end
    end
    local Can = true
    if craft then
        for k, v in pairs(craft[3]) do
            if not ply:HasItem(v[1]) or ply:HasItem(v[1]) < v[2] then
                Can = false
                ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You can't craft this item")
                return
            end
        end
    end
    local weightLimit = ply:getWeightLimit()
    if (ply.WeightCur + DayZItems[item].Weight > weightLimit) then
        ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You can't carry this item")
        return false
    end
    if Can then
        net.Start("SendCraft")
        net.WriteUInt(item, 14)
        net.WriteUInt(craft[2], 14)
        net.Send(ply)
        ply.Crafts = ply.Crafts + 1
        timer.Simple(craft[2], function()
            if not ply or not ply:IsValid() or not ply:IsValid() then return end
            local weightLimit = ply:getWeightLimit()
            if (ply.WeightCur + DayZItems[item].Weight > weightLimit) then
                ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You can't carry this item. Crafting has been canceled")
                return false
            end
            for k, v in pairs(craft[3]) do
                if not ply:HasItem(v[1]) or ply:HasItem(v[1]) < v[2] then
                    ply:PBroadcast(Color(255, 50, 50), "[DayZ] ", Color(255, 255, 255), "You can't craft this item. Crafting has been canceled")
                    return
                end
            end
            for k, v in pairs(craft[3]) do ply:TakeItem(v[1], v[2]) end
            ply:GiveItem(item, 1)
            ply:EmitSound("UI/buttonclick.wav", 75, 100)
            ply.Crafts = ply.Crafts - 1
        end)
    end
end)