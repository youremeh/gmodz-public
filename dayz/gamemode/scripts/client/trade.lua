net.Receive("OpenTradeMenu", function(len)
    local ent = net.ReadEntity()
    ent.OfferedItems = {}
    ACCEPT_MESSAGE = nil
    PLAYER_1 = nil
    PLAYER_2 = nil
    TradeMenu(ent)
end)

net.Receive("CloseTradeMenu", function(len)
    if(DFrame_Trade_Menu) then
        DFrame_Trade_Menu:Remove()
        DFrame_Trade_Menu = nil
    end
    cleanVariables()
end)

function cleanVariables()
    PLAYER_1.OfferedItems = nil
    PLAYER_1.AcceptTrade = nil
    PLAYER_2.OfferedItems = nil
    PLAYER_2.AcceptTrade = nil
    ACCEPT_MESSAGE = nil
    PLAYER_1 = nil
    PLAYER_2 = nil
end

function TradeMenu(ply2)
    if DFrame_Trade_Menu then return end
    PLAYER_1 = LocalPlayer()
    PLAYER_1.OfferedItems = {}
    PLAYER_2 = ply2
    DFrame_Trade_Menu = vgui.Create("DFrame")
    DFrame_Trade_Menu:SetTitle("")
    DFrame_Trade_Menu:SetSize(800, 600)
    DFrame_Trade_Menu:Center()
    DFrame_Trade_Menu:SetDraggable(false)
    DFrame_Trade_Menu:MakePopup()
    DFrame_Trade_Menu:ShowCloseButton(false)
    local width, height = DFrame_Trade_Menu:GetWide(), DFrame_Trade_Menu:GetTall()
    DFrame_Trade_Menu.Paint = function()
        draw.RoundedBox(10, 0, 0, width, height, Color(0, 0, 0, 55))
        draw.RoundedBox(10, 0, 0, width, 35, Color(77, 67, 57, 255))
        draw.RoundedBox(10, 0, 0, width, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 0, 35, width, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 0, 0, width, height, Color(0, 0, 0, 55))
        draw.RoundedBox(10, 1, 1, width - 2, 35, Color(77, 67, 57, 255))
        draw.RoundedBox(10, 1, 1, width - 2, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 1, 35, width - 2, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 0, height / 2, width, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, width / 2 - 1, 0, 2, height * 0.5, Color(0, 0, 0, 255))
        if (ACCEPT_MESSAGE) then draw.DrawText(ACCEPT_MESSAGE, "DebugFixed", width * 0.5, height * 0.25, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER) end
    end
    local DLabel_Offer = vgui.Create("DLabel", DFrame_Trade_Menu)
    DLabel_Offer:SetColor(Color(255, 255, 255, 255))
    DLabel_Offer:SetText("Your Offer")
    DLabel_Offer:SetPos(127, 6)
    DLabel_Offer:SetFont("Trebuchet24")
    DLabel_Offer:SizeToContents()
    local DLabel_Offer2 = vgui.Create("DLabel", DFrame_Trade_Menu)
    DLabel_Offer2:SetColor(Color(255, 255, 255, 255))
    DLabel_Offer2:SetText("Their Offer")
    DLabel_Offer2:SetPos(547, 6)
    DLabel_Offer2:SetFont("Trebuchet24")
    DLabel_Offer2:SizeToContents()
    DPanelList_Inv = vgui.Create("DPanelList", DFrame_Trade_Menu)
    DPanelList_Inv:SetSize(780, height * 0.5 - 10)
    DPanelList_Inv:SetPos(10, height * 0.5)
    DPanelList_Inv:SetPadding(7.5)
    DPanelList_Inv:SetSpacing(2)
    DPanelList_Inv:EnableHorizontal(3)
    DPanelList_Inv:EnableVerticalScrollbar(true)
    DPanelList_Inv.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_Inv:GetWide(), DPanelList_Inv:GetTall(), Color(50, 50, 50, 50)) end
    DPanelList_PLAYER_1_Contents = vgui.Create("DPanelList", DFrame_Trade_Menu)
    DPanelList_PLAYER_1_Contents:SetSize(390, height * 0.5 - 40)
    DPanelList_PLAYER_1_Contents:SetPos(10, 40)
    DPanelList_PLAYER_1_Contents:SetPadding(7.5)
    DPanelList_PLAYER_1_Contents:SetSpacing(2)
    DPanelList_PLAYER_1_Contents:EnableHorizontal(3)
    DPanelList_PLAYER_1_Contents:EnableVerticalScrollbar(true)
    DPanelList_PLAYER_1_Contents.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_Inv:GetWide(), DPanelList_Inv:GetTall(), Color(50, 50, 50, 50)) end
    DPanelList_PLAYER_2_Contents = vgui.Create("DPanelList", DFrame_Trade_Menu)
    DPanelList_PLAYER_2_Contents:SetSize(390, height * 0.5 - 40)
    DPanelList_PLAYER_2_Contents:SetPos(width * 0.5 + 10, 40)
    DPanelList_PLAYER_2_Contents:SetPadding(7.5)
    DPanelList_PLAYER_2_Contents:SetSpacing(2)
    DPanelList_PLAYER_2_Contents:EnableHorizontal(3)
    DPanelList_PLAYER_2_Contents:EnableVerticalScrollbar(true)
    DPanelList_PLAYER_2_Contents.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_Inv:GetWide(), DPanelList_Inv:GetTall(), Color(50, 50, 50, 50)) end
    local DButton_Accept = createButton(DFrame_Trade_Menu, width * 0.5 - 50, height * 0.3, 100, 30, "Accept")
    DButton_Accept.DoClick = function()
        net.Start("CL_RequestAccept")
        net.SendToServer()
    end
    local DButton_Decline = createButton(DFrame_Trade_Menu, width * 0.5 - 50, height * 0.4, 100, 30, "Decline")
    DButton_Decline.DoClick = function()
        net.Start("CL_RequestTradeClose")
        net.SendToServer()
    end
    updateTradeMenu()
end

function updateTradeMenu()
    DPanelList_Inv:Clear()
    DPanelList_PLAYER_1_Contents:Clear()
    DPanelList_PLAYER_2_Contents:Clear()
    if((LocalPlayer().Money - (tonumber(PLAYER_1.OfferedItems["money"]) or 0)) > 0) then
        local Inventory_Item, dModelPanel_Item = createInventoryMoney(125, 125, LocalPlayer().Money - (tonumber(PLAYER_1.OfferedItems["money"]) or 0))
        DPanelList_Inv:AddItem(Inventory_Item)
        dModelPanel_Item.DoClick = function()
            D_ItemMENU = DermaMenu()
            D_ItemMENU:AddOption("Offer Money", function()
                if LocalPlayer().Money > 1 then
                    amountPopupInventory(-1, LocalPlayer().Money, "CL_OfferMoney", 400)
                else
                    sendMessage("CL_OfferMoney", -1, 1)
                end
            end)
            D_ItemMENU:Open(gui.MousePos())
        end
    end
    for ItemID, quantity in pairs(Client_Inventory) do
        if PLAYER_1.OfferedItems[ItemID] then quantity = quantity - PLAYER_1.OfferedItems[ItemID] end
        if quantity > 0 then
            local Inventory_Item, dModelPanel_Item = createInventoryButton(125, 125, ItemID, quantity)
            dModelPanel_Item.DoClick = function()
                D_ItemMENU = DermaMenu()
                D_ItemMENU:AddOption("Offer Item", function()
                    if Client_Inventory[ItemID] > 1 then
                        amountPopupInventory(ItemID, Client_Inventory[ItemID], "CL_OfferItem")
                    else
                        sendMessage("CL_OfferItem", ItemID, 1)
                    end
                end)
                D_ItemMENU:Open(gui.MousePos())
            end
            DPanelList_Inv:AddItem(Inventory_Item)
        end
    end
    for ItemID, quantity in pairs(PLAYER_1.OfferedItems) do
        if quantity > 0 then
            if(ItemID == "money") then
                local Inventory_Item, dModelPanel_Item = createInventoryMoney(125, 125, quantity)
                DPanelList_PLAYER_1_Contents:AddItem(Inventory_Item)
                dModelPanel_Item.DoClick = function()
                    D_ItemMENU = DermaMenu()
                    D_ItemMENU:AddOption("Retract Money", function() sendMessage("CL_OfferMoney", -1, 0) end)
                    D_ItemMENU:Open(gui.MousePos())
                end
            else
                local Inventory_Item, dModelPanel_Item = createInventoryButton(125, 125, ItemID, quantity)
                dModelPanel_Item.DoClick = function()
                    D_ItemMENU = DermaMenu()
                    D_ItemMENU:AddOption("Retract Item", function() sendMessage("CL_OfferItem", ItemID, 0) end)
                    D_ItemMENU:Open(gui.MousePos())
                end
                DPanelList_PLAYER_1_Contents:AddItem(Inventory_Item)
            end
        end
    end
    for ItemID, quantity in pairs(PLAYER_2.OfferedItems) do
        if quantity > 0 then
            if(ItemID == "money") then
                local Inventory_Item, dModelPanel_Item = createInventoryMoney(125, 125, quantity)
                DPanelList_PLAYER_2_Contents:AddItem(Inventory_Item)
            else
                local Inventory_Item, dModelPanel_Item = createInventoryButton(125, 125, ItemID, quantity)
                DPanelList_PLAYER_2_Contents:AddItem(Inventory_Item)
            end
        end
    end
    if (PLAYER_1.AcceptTrade) then
        ACCEPT_MESSAGE = "Waiting for other player."
    elseif (PLAYER_2.AcceptTrade) then
        ACCEPT_MESSAGE = "Other player has accepted."
    end
end

net.Receive("UpdateTrade", function(len)
    local ent = net.ReadEntity()
    for itemID = 1, table.Count(DayZItems) do ent.OfferedItems[itemID] = net.ReadUInt(14) end
    ent.OfferedItems["money"] = net.ReadUInt(14)
    updateTradeMenu()
    PLAYER_1.AcceptTrade = nil
    PLAYER_2.AcceptTrade = nil
    ACCEPT_MESSAGE = nil
end)

net.Receive("UpdateOffer", function(len, ply)
    local trg = net.ReadEntity()
    trg.AcceptTrade = true
    updateTradeMenu()
end)