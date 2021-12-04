Client_Inventory = Client_Inventory or {}
Client_Bank = Client_Bank or {}
Client_Skills = Client_Skills or {}

net.Receive("UpdateInventory", function(len)
    for itemID = 1, table.Count(DayZItems) do Client_Inventory[itemID] = net.ReadUInt(14) end
    if DFrame_BankMenu and DFrame_BankMenu:IsValid() then
        timer.Simple(0.3, function() bankMenu() end)
    else
        Inventory_List(DPanel_Inventory_Tab)
    end
end)

net.Receive("UpdateSkills", function(len)
    for SkillID = 1, table.Count(DayZSkills) do Client_Skills[SkillID] = net.ReadUInt(14) end
end)

net.Receive("UpdateBank", function(len)
    for itemID = 1, table.Count(DayZItems) do Client_Bank[itemID] = net.ReadUInt(14) end
end)

function calculateWeight(tbl)
    local TotalWeight = 0
    for i = 1, table.Count(DayZItems) do
        if (DayZItems[i].Weight) then TotalWeight = TotalWeight + DayZItems[i].Weight * tbl[i] end
    end
    return TotalWeight
end

function createInventoryMoney(w, h, money)
    local function drawInventoryRoundedBox(width, height, drawSelect)
        draw.RoundedBox(10, 0, 0, width, 1, Color(0, 0, 0, 100))
        draw.RoundedBox(10, 0, 0, 1, width, Color(0, 0, 0, 100))
        draw.RoundedBox(10, 0, width - 1, height, 1, Color(0, 0, 0, 100))
        draw.RoundedBox(10, width - 1, 0, 1, height, Color(0, 0, 0, 100))
        draw.RoundedBox(10, 1, 1, width - 2, height - 2, Color(139, 133, 97, 55))
    end
    local DPanel_Inventory_Item = vgui.Create("DPanel")
    DPanel_Inventory_Item:SetSize(w, h)
    DPanel_Inventory_Item:SetPos(0, 0)
    DPanel_Inventory_Item.Mouse = false
    DPanel_Inventory_Item.Paint = function()
        drawInventoryRoundedBox(w, h)
        if DPanel_Inventory_Item.Mouse then drawInventoryRoundedBox(w, h) end
    end
    local dModelPanel_Item = vgui.Create("DModelPanel", DPanel_Inventory_Item)
    dModelPanel_Item:SetPos(0, 0)
    dModelPanel_Item:SetSize(w, h)
    dModelPanel_Item:SetModel("models/props/cs_assault/money.mdl")
    dModelPanel_Item:SetLookAt(Vector(0, 0, 0))
    dModelPanel_Item:SetCamPos(Vector(8, 8, 8))
    dModelPanel_Item.OnCursorEntered = function()
        DPanel_Inventory_Item.Mouse = true
        if dPanel_Description and dPanel_Description:IsValid() then dPanel_Description:Remove() end
        dPanel_Description = vgui.Create("DPanel")
        local x, y = gui.MousePos()
        dPanel_Description:SetPos(x + 15, y + 5)
        dPanel_Description:SetSize(500, 300)
        dPanel_Description:SetDrawOnTop(true)
        dPanel_Description.Paint = function()
            if not dModelPanel_Item:IsValid() then dPanel_Description:Remove() end
            local x, y = gui.MousePos()
            dPanel_Description:SetPos(x + 15, y + 5)
        end
    end
    dModelPanel_Item.OnCursorExited = function()
        DPanel_Inventory_Item.Mouse = false
        if dPanel_Description and dPanel_Description:IsValid() then dPanel_Description:Remove() end
    end
    dModelPanel_Item.PaintOver = function() draw.DrawText("$" .. (money or 0), "DebugFixed", 2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT) end
    return DPanel_Inventory_Item, dModelPanel_Item
end

function createInventoryButton(w, h, item, quantity, sellshop, sellprice)
    local function drawInventoryRoundedBox(width, height, drawSelect)
        draw.RoundedBox(10, 0, 0, width, 1, Color(0, 0, 0, 100))
        draw.RoundedBox(10, 0, 0, 1, width, Color(0, 0, 0, 100))
        draw.RoundedBox(10, 0, width - 1, height, 1, Color(0, 0, 0, 100))
        draw.RoundedBox(10, width - 1, 0, 1, height, Color(0, 0, 0, 100))
        draw.RoundedBox(10, 1, 1, width - 2, height - 2, Color(139, 133, 97, 55))
    end
    local DPanel_Inventory_Item = vgui.Create("DPanel")
    DPanel_Inventory_Item:SetSize(w, h)
    DPanel_Inventory_Item:SetPos(0, 0)
    DPanel_Inventory_Item.Paint = function()
        drawInventoryRoundedBox(w, h)
        if SelectedInventoryItem == item then drawInventoryRoundedBox(w, h) end
    end
    local dModelPanel_Item = vgui.Create("DModelPanel", DPanel_Inventory_Item)
    dModelPanel_Item:SetPos(0, 0)
    dModelPanel_Item:SetSize(w, h)
    dModelPanel_Item:SetModel(DayZItems[item].Model)
    dModelPanel_Item:SetLookAt(Vector(0, 0, 0))
    local camPos = Vector(30, 0, 30)
    if DayZItems[item].CamOffset then camPos = camPos * DayZItems[item].CamOffset end
    dModelPanel_Item:SetCamPos(camPos)
    dModelPanel_Item.OnCursorEntered = function()
        SelectedInventoryItem = item
        if dPanel_Description and dPanel_Description:IsValid() then dPanel_Description:Remove() end
    end
    dModelPanel_Item.OnCursorExited = function()
        SelectedInventoryItem = nil
        if dPanel_Description and dPanel_Description:IsValid() then dPanel_Description:Remove() end
    end
    dModelPanel_Item.PaintOver = function()
        draw.DrawText(DayZItems[item].Name, "DebugFixed", 2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("x"..quantity, "DebugFixed", 2, 16, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        if DayZItems[item].Weight and DayZItems[item].Weight > 0 then
            weightText = ("Weight: "..DayZItems[item].Weight * quantity)
        else
            weightText = ("")
        end
        draw.DrawText(weightText, "DebugFixed", 5, h / 1.2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        if(sellshop) then draw.DrawText("$" .. (sellprice or 0), "DebugFixed", 2, 28, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT) end
    end
    return DPanel_Inventory_Item, dModelPanel_Item
end

function createButton(frame, x, y, w, h, text)
    local DButton_Main = vgui.Create("DButton", frame)
    DButton_Main:SetPos(x, y)
    DButton_Main:SetSize(w, h)
    DButton_Main:SetText("")
    DButton_Main.Paint = function()
        draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 255))
        if (selectedPanel == DButton_Main) then
            draw.RoundedBox(10, 1, 1, w - 2, h - 2, Color(139, 133, 97, 255))
        else
            draw.RoundedBox(10, 1, 1, w - 2, h - 2, Color(119, 113, 77, 255))
        end
        draw.DrawText(text, "DebugFixed", w * 0.5, h * 0.33, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
    DButton_Main.OnCursorEntered = function() selectedPanel = DButton_Main end
    DButton_Main.OnCursorExited = function() selectedPanel = nil end
    return DButton_Main
end

function createWeight(frame, x, y, w, h)
    local value = calculateWeight(Client_Inventory)
    local maxVal = LocalPlayer():getWeightLimit()
    if DPanel_WeightBar and DPanel_WeightBar:IsValid() then DPanel_WeightBar:Remove() end
    DPanel_WeightBar = vgui.Create("DPanel", frame)
    DPanel_WeightBar:SetSize(w, h)
    DPanel_WeightBar:SetPos(x, y)
    DPanel_WeightBar.Paint = function()
        draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.RoundedBox(10, 2, 2, (w - 4) * (value / maxVal), h - 4, Color(90, 80, 70, 155))
        draw.DrawText(value.."/"..maxVal, "DebugFixed", w * 0.5, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function createBankWeight(frame, x, y, w, h)
    local value = calculateWeight(Client_Bank)
    local maxVal = LocalPlayer():getWeightLimitBank()
    if DPanel_BankWeightBar and DPanel_BankWeightBar:IsValid() then DPanel_BankWeightBar:Remove() end
    DPanel_BankWeightBar = vgui.Create("DPanel", frame)
    DPanel_BankWeightBar:SetSize(w, h)
    DPanel_BankWeightBar:SetPos(x, y)
    DPanel_BankWeightBar.Paint = function()
        draw.RoundedBox(10, 0, 0, w, h, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 2, 2, (w - 4) * (value / maxVal), h - 4, Color(90, 80, 70, 155))
        draw.DrawText("Weight: "..value.."/"..maxVal, "DebugFixed", w * 0.5, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function placeItem(ItemID)
    cancelItem()
    itemPlacer = ents.CreateClientProp()
    itemPlacer:SetPos(LocalPlayer():GetPos())
    itemPlacer:SetModel(DayZItems[ItemID].Model)
    itemPlacer.ItemID = ItemID
    itemPlacer:SetRenderMode(RENDERMODE_TRANSALPHA)
    itemPlacer:SetMaterial("Models/trans")
    itemPlacer:Spawn()
    itemPlacer.AngleOffset = 0
    itemPlacer:SetColor(Color(0, 200, 0, 25))
end

function cancelItem()
    if itemPlacer then
        itemPlacer:Remove()
        itemPlacer = nil
    end
end

function confirmItem()
    net.Start("CL_PlaceItem")
    net.WriteUInt(itemPlacer.ItemID, 14)
    net.WriteVector(itemPlacer:GetPos())
    net.WriteAngle(itemPlacer:GetAngles())
    net.SendToServer()
    if itemPlacer then
        itemPlacer:Remove()
        itemPlacer = nil
    end
end

function placeItemThink()
    if itemPlacer then
        local spawnOffset = Vector(0, 0, 0)
        if DayZItems[itemPlacer.ItemID].SpawnOffset then spawnOffset = DayZItems[itemPlacer.ItemID].SpawnOffset end
        local pos = LocalPlayer():GetPos() + spawnOffset
        local ang = LocalPlayer():GetAngles()
        local newPos = pos + (ang:Forward() * 100)
        itemPlacer:SetPos(Vector(newPos.x, newPos.y, pos.z))
        itemPlacer:SetAngles(Angle(0, ang.y + itemPlacer.AngleOffset, 0))
        local tracePos = Vector(newPos.x, newPos.y, LocalPlayer():GetPos().z)
        local tracedata = {start = tracePos + Vector(0, 0, 1), endpos = tracePos - Vector(0, 0, 3), filter = itemPlacer}
        local trace = util.TraceLine(tracedata)
        local hullTraceData = {}
        hullTraceData.start = itemPlacer:GetPos()
        hullTraceData.endpos = itemPlacer:GetPos()
        hullTraceData.filter = itemPlacer
        local mins = itemPlacer:OBBMins()
        mins.z = mins.z + spawnOffset.z + 4
        hullTraceData.mins = mins
        hullTraceData.maxs = itemPlacer:OBBMaxs()
        local hullTrace = util.TraceHull(hullTraceData)
        if trace.Hit and not hullTrace.Hit then
            canPlace = true
            itemPlacer:SetColor(Color(0, 200, 0, 25))
        else
            canPlace = false
            itemPlacer:SetColor(Color(200, 0, 0, 25))
        end
        if input.IsKeyDown(KEY_R) then itemPlacer.AngleOffset = itemPlacer.AngleOffset + 50 * FrameTime() end
        if input.IsMouseDown(MOUSE_RIGHT) or not LocalPlayer():Alive() then
            cancelItem()
            return true
        end
        if (input.IsMouseDown(MOUSE_LEFT) and canPlace) then
            confirmItem()
            return true
        end
    end
end
hook.Add("Think", "placeItemThink", placeItemThink)

function Inventory_List(frame)
    if not dFrame_Main_Menu then return false end
    if DFrame_BankMenu and DFrame_BankMenu:IsValid() then DFrame_BankMenu:Remove() end
    if DPanelList_Inventory_Contents and DPanelList_Inventory_Contents:IsValid() then DPanelList_Inventory_Contents:Remove() end
    DPanelList_Inventory_Contents = vgui.Create("DPanelList", frame)
    DPanelList_Inventory_Contents:SetSize(subMenuWidth, subMenuHeight)
    DPanelList_Inventory_Contents:SetPos(0, 5)
    DPanelList_Inventory_Contents:SetPadding(7.5)
    DPanelList_Inventory_Contents:SetSpacing(2)
    DPanelList_Inventory_Contents:EnableHorizontal(3)
    DPanelList_Inventory_Contents:EnableVerticalScrollbar(true)
    DPanelList_Inventory_Contents:Clear()
    DPanelList_Inventory_Contents.Paint = function() draw.RoundedBox(10, 0, 0, subMenuWidth, subMenuHeight, Color(50, 50, 50, 50)) end
    local Inventory_Item, dModelPanel_Item = createInventoryMoney(120, 120, LocalPlayer().Money)
    DPanelList_Inventory_Contents:AddItem(Inventory_Item)
    for ItemID = 1, table.Count(Client_Inventory) do
        local quantity = Client_Inventory[ItemID]
        if quantity > 0 then
            local Inventory_Item, dModelPanel_Item = createInventoryButton(120, 120, ItemID, quantity)
            dModelPanel_Item.DoClick = function()
                local itemOptions = DermaMenu()
                if DayZItems[ItemID].useFunc then
                    itemOptions:AddOption("Use Item", function() sendMessage("CL_UseItem", ItemID, 1) end)
                end
                if DayZItems[ItemID].Placeable then
                    itemOptions:AddOption("Place Item", function()
                        placeItem(ItemID)
                        if (dFrame_Main_Menu and dFrame_Main_Menu:IsValid()) then dFrame_Main_Menu:Remove() end
                    end)
                else
                    itemOptions:AddOption("Drop Item", function()
                        if DayZItems[ItemID].ClipSize then
                            amountPopupInventory(ItemID, quantity, "CL_DropItem")
                            if (dFrame_Main_Menu) then dFrame_Main_Menu:Remove() end
                        else
                            amountPopupInventory(ItemID, quantity, "CL_DropItem")
                            if (dFrame_Main_Menu) then dFrame_Main_Menu:Remove() end
                        end
                    end)
                end
                itemOptions:Open(gui.MousePos())
            end
            dModelPanel_Item.DoRightClick = function()
                if DayZItems[ItemID].useFunc then sendMessage("CL_UseItem", ItemID, 1) end
            end
            DPanelList_Inventory_Contents:AddItem(Inventory_Item)
        end
    end
    createWeight(frame, subMenuWidth * 0.1, subMenuHeight * 0.95, subMenuWidth * 0.8, 20)
end

function bankMenu()
    if DFrame_BankMenu and DFrame_BankMenu:IsValid() then DFrame_BankMenu:Remove() end
    DFrame_BankMenu = vgui.Create("DFrame")
    DFrame_BankMenu:SetSize(800, 500)
    DFrame_BankMenu:MakePopup()
    DFrame_BankMenu:SetTitle("Stalker Global")
    DFrame_BankMenu:Center()
    DFrame_BankMenu.Paint = function()
        draw.RoundedBox(10, 0, 0, DFrame_BankMenu:GetWide(), DFrame_BankMenu:GetTall(), Color(0, 0, 0, 180))
        draw.RoundedBox(10, 10, 10, DFrame_BankMenu:GetWide() - 20, DFrame_BankMenu:GetTall() - 20, Color(50, 50, 50, 180))
        draw.RoundedBox(10, DFrame_BankMenu:GetWide() / 2 - 1, 10, 2, DFrame_BankMenu:GetTall() - 20, Color(0, 0, 0, 255))
        dFrame_Banner(DFrame_BankMenu:GetWide(), 35)
    end
    local DLabel_Backpack = vgui.Create("DLabel")
    DLabel_Backpack:SetColor(Color(255, 255, 255, 255))
    DLabel_Backpack:SetText("Your Backpack")
    DLabel_Backpack:SetPos(127, 6)
    DLabel_Backpack:SetFont("Trebuchet24")
    DLabel_Backpack:SizeToContents()
    DLabel_Backpack:SetParent(DFrame_BankMenu)
    local DLabel_Bank = vgui.Create("DLabel")
    DLabel_Bank:SetColor(Color(255, 255, 255, 255))
    DLabel_Bank:SetText("Your Bank")
    DLabel_Bank:SetPos(547, 6)
    DLabel_Bank:SetFont("Trebuchet24")
    DLabel_Bank:SizeToContents()
    DLabel_Bank:SetParent(DFrame_BankMenu)
    DPanelList_Inventory_Contents = vgui.Create("DPanelList", DFrame_BankMenu)
    DPanelList_Inventory_Contents:SetSize(390, 440)
    DPanelList_Inventory_Contents:SetPos(10, 40)
    DPanelList_Inventory_Contents:SetPadding(7.5)
    DPanelList_Inventory_Contents:SetSpacing(2)
    DPanelList_Inventory_Contents:EnableHorizontal(3)
    DPanelList_Inventory_Contents:EnableVerticalScrollbar(true)
    DPanelList_Inventory_Contents.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_Inventory_Contents:GetWide(), DPanelList_Inventory_Contents:GetTall(), Color(30, 30, 30, 0)) end
    DPanelList_Bank_Contents = vgui.Create("DPanelList", DFrame_BankMenu)
    DPanelList_Bank_Contents:SetSize(390, 440)
    DPanelList_Bank_Contents:SetPos(400, 40)
    DPanelList_Bank_Contents:SetPadding(7.5)
    DPanelList_Bank_Contents:SetSpacing(2)
    DPanelList_Bank_Contents:EnableHorizontal(3)
    DPanelList_Bank_Contents:EnableVerticalScrollbar(true)
    DPanelList_Bank_Contents.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_Bank_Contents:GetWide(), DPanelList_Bank_Contents:GetTall(), Color(30, 30, 30, 0)) end
    bankSubMenu()
end
net.Receive("OpenBank", function(len) bankMenu() end)

function bankSubMenu()
    for ItemID, quantity in pairs(Client_Inventory) do
        if quantity > 0 then
            local Inventory_Item, dModelPanel_Item = createInventoryButton(125, 125, ItemID, quantity)
            dModelPanel_Item.DoClick = function()
                D_ItemMENU = DermaMenu()
                D_ItemMENU:AddOption("Deposit Item", function()
                    if quantity > 1 then
                        amountPopupInventory(ItemID, quantity, "CL_DepositItem")
                    else
                        sendMessage("CL_DepositItem", ItemID, 1)
                    end
                end)
                D_ItemMENU:Open(gui.MousePos())
            end
            dModelPanel_Item.DoRightClick = function() sendMessage("CL_DepositItem", ItemID, 1) end
            DPanelList_Inventory_Contents:AddItem(Inventory_Item)
        end
    end
    for ItemID, quantity in pairs(Client_Bank) do
        if quantity > 0 then
            local Inventory_Item, dModelPanel_Item = createInventoryButton(125, 125, ItemID, quantity)
            dModelPanel_Item.DoClick = function()
                W_ItemMENU = DermaMenu()
                W_ItemMENU:AddOption("Withdraw Item", function()
                    if quantity > 1 then
                        amountPopupInventory(ItemID, quantity, "CL_WithdrawItem")
                    else
                        sendMessage("CL_WithdrawItem", ItemID, 1)
                    end
                end)
                W_ItemMENU:Open(gui.MousePos())
            end
            dModelPanel_Item.DoRightClick = function() sendMessage("CL_WithdrawItem", ItemID, 1) end
            DPanelList_Bank_Contents:AddItem(Inventory_Item)
        end
    end
    createWeight(DFrame_BankMenu, DFrame_BankMenu:GetWide() * 0.02, DFrame_BankMenu:GetTall() * 0.93, DFrame_BankMenu:GetWide() * 0.47, 20)
    createBankWeight(DFrame_BankMenu, DFrame_BankMenu:GetWide() * 0.52, DFrame_BankMenu:GetTall() * 0.93, DFrame_BankMenu:GetWide() * 0.47, 20)
end

function amountPopupInventory(item, maxValue, consoleString, widthMoney)
    if not maxValue then maxValue = 1 end
    local boxWidth, boxHeight = 300, 150
    if(widthMoney and widthMoney > 0) then boxWidth = widthMoney end
    local DFrame_ItemAmount = vgui.Create("DFrame")
    DFrame_ItemAmount:SetSize(boxWidth, boxHeight)
    DFrame_ItemAmount:Center()
    DFrame_ItemAmount:SetTitle("Item Amount")
    DFrame_ItemAmount:MakePopup()
    DFrame_ItemAmount.Paint = function()
        DFrame_ItemAmount:MakePopup()
        draw.RoundedBox(10, 0, 0, boxWidth, boxHeight, Color(77, 67, 57, 255))
        draw.RoundedBox(10, 0, 0, boxWidth, 24, Color(77, 67, 57, 255))
        draw.RoundedBox(10, 0, 0, boxWidth, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 0, 22, boxWidth, 2, Color(0, 0, 0, 255))
    end
    local DNumSlider_Amount = vgui.Create("DNumSlider", DFrame_ItemAmount)
    DNumSlider_Amount:SetWide(525)
    DNumSlider_Amount:SetPos(-200, 50)
    DNumSlider_Amount:SetText("")
    DNumSlider_Amount:SetMin(1)
    DNumSlider_Amount:SetMax(maxValue)
    DNumSlider_Amount:SetDecimals(0)
    DNumSlider_Amount:SetValue(1)
    local buttonWidth, buttonHeight = 200, 35
    local buttonX, buttonY = boxWidth * 0.5 - buttonWidth * 0.5, boxHeight * 0.7
    local DButton_Confirm = createButton(DFrame_ItemAmount, buttonX, buttonY, buttonWidth, buttonHeight, "Confirm")
    DButton_Confirm.DoClick = function()
        sendMessage(consoleString, item, DNumSlider_Amount:GetValue())
        DFrame_ItemAmount:Remove()
    end
end

function sendMessage(netStr, item, quantity)
    net.Start(netStr)
    net.WriteUInt(item, 14)
    net.WriteUInt(quantity, 14)
    net.SendToServer()
end