function shopItems(frame, shoptype)
    for _, item in pairs(DayZShop[shoptype]) do
        local Shop_Item = vgui.Create("DPanelList")
        Shop_Item:SetParent(frame)
        Shop_Item:SetSize(730, 120)
        Shop_Item:SetPos(0, 0)
        Shop_Item:SetSpacing(5)
        Shop_Item.Paint = function()
            draw.RoundedBox(10, 0, 0, Shop_Item:GetWide() - 6, Shop_Item:GetTall(), Color(0, 0, 0, 150))
            draw.RoundedBox(10, 4, 4, 112, 112, Color(139, 133, 97, 55))
        end
        local dModelPanel_Item = vgui.Create("DModelPanel")
        dModelPanel_Item:SetParent(Shop_Item)
        dModelPanel_Item:SetPos(0, 0)
        dModelPanel_Item:SetSize(120, 120)
        dModelPanel_Item:SetModel(DayZItems[item].Model)
        dModelPanel_Item:SetLookAt(Vector(0, 0, 0))
        local camPos = Vector(30, 0, 30)
        if DayZItems[item].CamOffset then camPos = camPos * DayZItems[item].CamOffset end
        dModelPanel_Item:SetCamPos(camPos)
        local DLabel_ItemName = vgui.Create("DLabel")
        DLabel_ItemName:SetColor(Color(255, 255, 255, 255))
        DLabel_ItemName:SetFont("Trebuchet24")
        DLabel_ItemName:SetText(DayZItems[item].Name)
        DLabel_ItemName:SizeToContents()
        DLabel_ItemName:SetParent(Shop_Item)
        DLabel_ItemName:SetPos(125, 10)
        if DayZItems[item].Desc ~= nil then
            local DLabel_ItemDesc = vgui.Create("DLabel")
            DLabel_ItemDesc:SetColor(Color(255, 255, 255, 255))
            DLabel_ItemDesc:SetFont("Trebuchet18")
            DLabel_ItemDesc:SetText(DayZItems[item].Desc)
            DLabel_ItemDesc:SizeToContents()
            DLabel_ItemDesc:SetParent(Shop_Item)
            DLabel_ItemDesc:SetPos(125, 30)
        end
        local DLabel_ItemPriceLabel = vgui.Create("DLabel")
        DLabel_ItemPriceLabel:SetColor(Color(255, 255, 255, 255))
        DLabel_ItemPriceLabel:SetFont("Trebuchet18")
        DLabel_ItemPriceLabel:SetText("Prices")
        DLabel_ItemPriceLabel:SizeToContents()
        DLabel_ItemPriceLabel:SetParent(Shop_Item)
        DLabel_ItemPriceLabel:SetPos(125, 65)
        if DayZItems[item].Price ~= nil then
            local DLabel_ItemPriceCash = vgui.Create("DLabel")
            DLabel_ItemPriceCash:SetColor(Color(255, 255, 255, 200))
            DLabel_ItemPriceCash:SetFont("Trebuchet18")
            DLabel_ItemPriceCash:SetText("$ "..DayZItems[item].Price)
            DLabel_ItemPriceCash:SizeToContents()
            DLabel_ItemPriceCash:SetParent(Shop_Item)
            DLabel_ItemPriceCash:SetPos(125, 80)
            local DButton_BuyCash = createButton(Shop_Item, 555, 25, 150, 30, "Buy with $")
            DButton_BuyCash.DoClick = function() RunConsoleCommand("BuyItemMoney", item, 1) end
        end
        if DayZItems[item].Credits ~= nil then
            local DLabel_ItemPriceCredits = vgui.Create("DLabel")
            DLabel_ItemPriceCredits:SetColor(Color(255, 255, 255, 200))
            DLabel_ItemPriceCredits:SetFont("Trebuchet18")
            DLabel_ItemPriceCredits:SetText("Credits: "..DayZItems[item].Credits)
            DLabel_ItemPriceCredits:SizeToContents()
            DLabel_ItemPriceCredits:SetParent(Shop_Item)
            DLabel_ItemPriceCredits:SetPos(125, 95)
            local DButton_BuyCredits = createButton(Shop_Item, 555, 60, 150, 30, "Buy with Credits")
            DButton_BuyCredits.DoClick = function() RunConsoleCommand("BuyItemCredits", item, 1) end
        end
        frame:AddItem(Shop_Item)
    end
end

local texture_Replace = {
    {old = "AJACKS/AJACKS_ROAD1", new = "replacement/road01", },
    {old = "AJACKS/AJACKS_ROAD7", new = "replacement/road02", },
    {old = "TORONTO/PAVEMENT/CONCRETE_TILE/PAVEMENT_TILE_02", new = "replacement/pavement01", },
    {old = "LABS/SE1_CEMENT_LAB_FLOOR_02", new = "replacement/building01", },
    {old = "AJACKS/AJACKS_10", new = "replacement/parking01"},
    {old = "HALL_CONCRETE/HALL_CONCRETE11_WET", new = "replacement/parking01", },
    {old = "SGTSICKTEXTURES/STUCCOLIGHT", new = "replacement/stucco01", },
    {old = "SGTSICKTEXTURES/STUCCOLIGHT2T", new = "replacement/stucco01", },
    {old = "SGTSICKTEXTURES/STUCCODARK", new = "replacement/stucco01", },
    {old = "AJACKS/AJACKS_ROAD5", new = "replacement/road03", },
    {old = "SGTSICKTEXTURES/SICKNESSROAD_02", new = "replacement/parking01", },
    {old = "TORONTO/ASPHALT/ASPHALT_02", new = "replacement/parking01", },
    {old = "SGTSICKTEXTURES/SICKNESSROAD_01", new = "replacement/road03", },
    {old = "INTRO/SE1_STOREFRONT_02I", new = "replacement/storefront01", },
    {old = "INTRO/SE1_STOREFRONT_02M", new = "replacement/storefront02", },
    {old = "INTRO/SE1_STOREFRONT_02J", new = "replacement/storefront01", },
    {old = "INTRO/STOREFRONT_01A", new = "replacement/storefront03", },
    {old = "INTRO/SE1_STOREFRONT_02B", new = "replacement/storefront03", },
    {old = "INTRO/SE1_STOREFRONT_02C", new = "replacement/storefront03", },
    {old = "SGTSICKTEXTURES/STUCCODARKGREEN", new = "replacement/stuccodarkgreen", },
    {old = "AJACKS/AJACKS_ROAD6", new = "replacement/road04", },
    {old = "CS_ITALY/STONEWALL01", new = "replacement/stonewall01", },
    {old = "CS_ITALY/STONEWALL01B", new = "replacement/stonewall01", },
    {old = "CS_ITALY/STONEWALL01A", new = "replacement/stonewall01", },
    {old = "WAREHOUSE/SE1_CINDERBLOCK_WALL_05", new = "replacement/stonewall01", },
    {old = "DE_TRAIN/TRAIN_CEMENT_WALL_02", new = "replacement/stonewall01", },
    {old = "DE_TRAIN/TRAIN_CEMENT_FLOOR_02", new = "replacement/stonewall01", },
    {old = "ENV/BRUSH/CEILINGS/CREAM_CEILING", new = "replacement/stucco01"},
}

function swapTextures()
    for k, v in pairs(texture_Replace) do
        local _originalMaterial = Material(v.old)
        local _replacementMaterial = Material(v.new)
        local _newTexture = _replacementMaterial:GetTexture("$basetexture")
        if (_replacementMaterial && _newTexture) then _originalMaterial:SetTexture("$basetexture", _newTexture) end
    end
end