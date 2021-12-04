function ShopMenu()
    DFrame_ShopMenu = vgui.Create("DFrame")
    DFrame_ShopMenu:SetTitle("")
    DFrame_ShopMenu:SetSize(800, 600)
    DFrame_ShopMenu:Center()
    DFrame_ShopMenu:SetDraggable(false)
    DFrame_ShopMenu:MakePopup()
    DFrame_ShopMenu:ShowCloseButton(true)
    DFrame_ShopMenu.Paint = function()
        local width = DFrame_ShopMenu:GetWide()
        local height = DFrame_ShopMenu:GetTall()
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(0, 0, 0, 180))
        surface.DrawTexturedRectUV(0, 0, width, height, 0, 0, width * 0.001, height * 0.001)
        dFrame_Banner(width, 35)
        draw.DrawText("Safe Zone Shop", "DebugFixedLarge", 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end
    local DPropSheet_Shop = vgui.Create("DPropertySheet", DFrame_ShopMenu)
    DPropSheet_Shop:SetPos(10, 40)
    DPropSheet_Shop:SetSize(DFrame_ShopMenu:GetWide() - 20, DFrame_ShopMenu:GetTall() - 50)
    DPropSheet_Shop.Paint = function() end
    local PanelSizeX = 746
    local PanelSizeY = 510
    local PanelPosX = 11
    local PanelPosY = 22
    DPanel_Weapon_Tab = vgui.Create("DPanel")
    DPanel_Ammo_Tab = vgui.Create("DPanel")
    DPanel_Equipment_Tab = vgui.Create("DPanel")
    DPanel_Survival_Tab = vgui.Create("DPanel")
    DPanel_Perk_Tab = vgui.Create("DPanel")
    DPanel_Sell_Tab = vgui.Create("DPanel")
    local shopMenuPanels = {DPanel_Weapon_Tab, DPanel_Ammo_Tab, DPanel_Equipment_Tab, DPanel_Survival_Tab, DPanel_Perk_Tab, DPanel_Sell_Tab}
    for i = 1, table.Count(shopMenuPanels) do
        shopMenuPanels[i]:SetParent(DPropSheet_Shop)
        shopMenuPanels[i]:SetSize(PanelSizeX, PanelSizeY)
        shopMenuPanels[i]:SetPos(PanelPosX, PanelPosY)
        shopMenuPanels[i].Paint = function() end
    end
    DPropSheet_Shop:AddSheet("Weapons", DPanel_Weapon_Tab, "gui/silkicons/world", true, true, "Purchase Weapons")
    DPropSheet_Shop:AddSheet("Ammo", DPanel_Equipment_Tab, "gui/silkicons/find", true, true, "Purchase Equipment")
    DPropSheet_Shop:AddSheet("Survival Gear", DPanel_Survival_Tab, "gui/silkicons/cart", true, true, "Purchase Basic Survivable Items")
    DPropSheet_Shop:AddSheet("Crafting Materials", DPanel_Ammo_Tab, "gui/silkicons/bullet_black", true, true, "Purchase Materials")
    DPropSheet_Shop:AddSheet("Character Perks", DPanel_Perk_Tab, "gui/silkicons/award_star_gold_1", true, true, "Credit Store")
    DPropSheet_Shop:AddSheet("Sell", DPanel_Sell_Tab, "icon16/money.png", true, true, "Sell Items")
    shopTab(DPanel_Weapon_Tab, "shop_weapons")
    shopTab(DPanel_Ammo_Tab, "shop_barricades")
    shopTab(DPanel_Equipment_Tab, "shop_equipment")
    shopTab(DPanel_Survival_Tab, "shop_gear")
    shopTab(DPanel_Perk_Tab, "shop_perks")
    DPanelList_ShopTabSell = vgui.Create("DPanelList", DPanel_Sell_Tab)
    DPanelList_ShopTabSell:SetSize(745, 492)
    DPanelList_ShopTabSell:SetPos(0, 10)
    DPanelList_ShopTabSell:SetPadding(7.5)
    DPanelList_ShopTabSell:SetSpacing(2)
    DPanelList_ShopTabSell:EnableHorizontal(3)
    DPanelList_ShopTabSell:EnableVerticalScrollbar(true)
    DPanelList_ShopTabSell.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_ShopTabSell:GetWide(), DPanelList_ShopTabSell:GetTall(), Color(30, 30, 30, 0)) end
    updateSell()
    local DButton_Donate = createButton(DFrame_ShopMenu, 400, 4, 250, 30, "Donation Benefits & Information")
    DButton_Donate.DoClick = function()
        DFrame_ShopMenu:Remove()
        donateMenuSafe()
    end
    for i = 1, table.Count(DPropSheet_Shop.Items) do
        DPropSheet_Shop.Items[i].Tab:SetAutoStretchVertical(false)
        DPropSheet_Shop.Items[i].Tab:SetSize(50, 50)
        DPropSheet_Shop.Items[i].Tab:SetFont("DebugFixed")
        DPropSheet_Shop.Items[i].Tab.Paint = function()
            draw.RoundedBox(10, 0, 0, 1, 18, Color(0, 0, 0, 255))
            draw.RoundedBox(10, 0, 0, DPropSheet_Shop.Items[i].Tab:GetWide() - 5, DPropSheet_Shop.Items[i].Tab:GetTall(), Color(0, 0, 0, 100))
        end
    end
end
usermessage.Hook("DonatorMenu", ShopMenu)
net.Receive("OpenShop", function(len) ShopMenu() end)

function updateSell()
    DPanelList_ShopTabSell:Clear()
    for ItemID, quantity in pairs(Client_Inventory) do
        if quantity > 0 and DayZItems[ItemID] and DayZItems[ItemID].CanBeSold and DayZItems[ItemID].Price and DayZItems[ItemID].Price > 0 then
            local Inventory_Item, dModelPanel_Item = createInventoryButton(125, 125, ItemID, quantity, true, math.floor(DayZItems[ItemID].Price / 8))
            dModelPanel_Item.DoClick = function()
                D_ItemMENU = DermaMenu()
                D_ItemMENU:AddOption("Sell Item", function()
                    if Client_Inventory[ItemID] > 1 then
                        amountPopupInventory(ItemID, Client_Inventory[ItemID], "CL_SellItem")
                    else
                        sendMessage("CL_SellItem", ItemID, 1)
                    end
                end)
                D_ItemMENU:Open(gui.MousePos())
            end
            dModelPanel_Item.DoRightClick = function() sendMessage("CL_SellItem", ItemID, 1) end
            DPanelList_ShopTabSell:AddItem(Inventory_Item)
        end
    end
end
net.Receive("UpdateSell", function(len) updateSell() end)

function shopTab(frame, shop)
    if DPanelList_ShopTab and DPanelList_ShopTab:IsValid() then DPanelList_ShopTab:Clear() end
    local DPanelList_ShopTab = vgui.Create("DPanelList", frame)
    DPanelList_ShopTab:SetSize(745, 492)
    DPanelList_ShopTab:SetPos(0, 10)
    DPanelList_ShopTab:SetPadding(7.5)
    DPanelList_ShopTab:SetSpacing(2)
    DPanelList_ShopTab:EnableHorizontal(3)
    DPanelList_ShopTab:EnableVerticalScrollbar(true)
    DPanelList_ShopTab.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_ShopTab:GetWide(), DPanelList_ShopTab:GetTall(), Color(30, 30, 30, 0)) end
    shopItems(DPanelList_ShopTab, shop)
end

function donateMenuSafe()
    local DonatePanel = vgui.Create("DFrame")
    DonatePanel:SetPos(0, 0)
    DonatePanel:SetSize(500, 570)
    DonatePanel:Center()
    DonatePanel:SetTitle("Donation Benefits & Information")
    DonatePanel:SetVisible(true)
    DonatePanel:SetDraggable(true)
    DonatePanel:MakePopup()
    DonatePanel:ShowCloseButton(true)
    DonatePanel.Paint = function()
        draw.RoundedBox(10, 1, 1, DonatePanel:GetWide() - 2, DonatePanel:GetTall() - 2, Color(100, 90, 80, 255))
        draw.RoundedBox(10, 1, 1, DonatePanel:GetWide() - 2, 25, Color(77, 67, 57, 255))
        draw.RoundedBox(10, 1, 1, DonatePanel:GetWide() - 2, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 1, 25, DonatePanel:GetWide() - 2, 2, Color(0, 0, 0, 255))
    end

    local DPanel_Info = vgui.Create("DPanel", DonatePanel)
    DPanel_Info:SetSize(480, 325)
    DPanel_Info:SetPos(10, 30)
    DPanel_Info.Paint = function() draw.RoundedBox(18, 0, 0, DPanel_Info:GetWide(), DPanel_Info:GetTall(), Color(88, 77, 67, 255)) end

    local DLabel_Info = vgui.Create("DLabel", DPanel_Info)
    DLabel_Info:SetColor(Color(255, 255, 255, 255))
    DLabel_Info:SetText("Benefits")
    DLabel_Info:SetPos(5, 0)
    DLabel_Info:SetFont("TargetIDMedium")
    DLabel_Info:SizeToContents()

    local DLabel_BenefitInfo = vgui.Create("DLabel", DPanel_Info)
    DLabel_BenefitInfo:SetColor(Color(255, 255, 255, 255))
    DLabel_BenefitInfo:SetText("Bronze Benefits:\n- 2x XP and Money\n- 25 Store Credits\n- [Bronze] tag\n\nSilver Benfits:\n- 2.5x XP and Money\n- 50 Store Credits\n- [Silver] tag\n\nGold Benfits:\n- 3x XP and Money\n- 75 Store Credits\n- [Gold] tag\n\nPlatinum Benfits:\n- 3.5x XP and Money\n- 100 Store Credits\n- [Platinum] tag")
    DLabel_BenefitInfo:SetPos(5, 25)
    DLabel_BenefitInfo:SetFont("TargetIDSmall")
    DLabel_BenefitInfo:SizeToContents()

    local DPanel_Benfits = vgui.Create("DPanel", DonatePanel)
    DPanel_Benfits:SetSize(480, 200)
    DPanel_Benfits:SetPos(10, 360)
    DPanel_Benfits.Paint = function() draw.RoundedBox(10, 0, 0, DPanel_Benfits:GetWide(), DPanel_Benfits:GetTall(), Color(88, 77, 67, 255)) end

    local DLabel_Information = vgui.Create("DLabel", DPanel_Benfits)
    DLabel_Information:SetColor(Color(255, 255, 255, 255))
    DLabel_Information:SetText("Information")
    DLabel_Information:SetPos(5, 0)
    DLabel_Information:SetFont("TargetIDMedium")
    DLabel_Information:SizeToContents()

    local DLabel_BenefitContent = vgui.Create("DLabel", DPanel_Benfits)
    DLabel_BenefitContent:SetColor(Color(255, 255, 255, 255))
    DLabel_BenefitContent:SetText("Earn 25 store credits per $5 donated\nEarn $5000 in-game cash per $5 donated\n\nAfter donating, please open a support ticket on the store and provide the relevant\ninformation. You will receive your rank & store credits/money within 24 of the support\nticket being open provided you gave the proper information.\n\nBy purchasing ranks/store credits/money, you acknowledge that you are paying for a\nvirtual currency. This means that if you should you be banned, you are not entitled to\nany compensation, including refunds.\nYou also acknowledge that you will not be recieving a physical product.")
    DLabel_BenefitContent:SetPos(5, 25)
    DLabel_BenefitContent:SetFont("TargetIDSmall")
    DLabel_BenefitContent:SizeToContents()
end

function donatorInfo()
    local DFrame_Web = vgui.Create("DFrame")
    DFrame_Web:SetTitle("")
    DFrame_Web:SetSize(subMenuWidth + 10, subMenuHeight + 35)
    DFrame_Web:Center()
    DFrame_Web:SetDraggable(false)
    DFrame_Web:MakePopup()
    DFrame_Web:ShowCloseButton(true)
    DFrame_Web.Paint = function()
        draw.RoundedBox(10, 0, 0, DFrame_Web:GetWide(), DFrame_Web:GetTall(), Color(0, 0, 0, 55))
        draw.RoundedBox(10, 0, 0, DFrame_Web:GetWide(), 25, Color(77, 67, 57, 255))
        draw.RoundedBox(10, 0, 0, DFrame_Web:GetWide(), 1, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 0, 24, DFrame_Web:GetWide(), 1, Color(0, 0, 0, 255))
    end
    donateMenuSafe(DFrame_Web, 5, 25)
end