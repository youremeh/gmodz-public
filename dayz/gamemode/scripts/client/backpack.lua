net.Receive("UpdateBackpack", function(len)
    if not Client_Backpack then Client_Backpack = {} end
    for itemID = 1, table.Count(DayZItems) do Client_Backpack[itemID] = net.ReadUInt(14) end
    if DFrame_LootMenu and DFrame_LootMenu:IsValid() then DFrame_LootMenu:Remove() lootMenu() end
end)

net.Receive("CloseBackpack", function(len)
    if DFrame_LootMenu and DFrame_LootMenu:IsValid() then DFrame_LootMenu:Remove() end
end)

net.Receive("OpenBackpack", function(len) lootMenu(tobool(tonumber(net.ReadUInt(1)))) end)

function lootMenu(crate)
    if DFrame_LootMenu and DFrame_LootMenu:IsValid() then DFrame_LootMenu:Remove() end
    DFrame_LootMenu = vgui.Create("DFrame")
    DFrame_LootMenu:SetSize(800, 500)
    DFrame_LootMenu:MakePopup()
    DFrame_LootMenu:SetTitle("")
    DFrame_LootMenu:Center()
    DFrame_LootMenu.Paint = function()
        local width, height = DFrame_LootMenu:GetWide(), DFrame_LootMenu:GetTall()
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(0, 0, 0, 125))
        surface.DrawTexturedRectUV(0, 0, width, height, 0, 0, width * 0.001, height * 0.001)
        dFrame_Banner(width, 35)
        if crate then
            draw.DrawText("Supply crate", "DebugFixedLarge", 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        else
            draw.DrawText("Dead Player's Backpack", "DebugFixedLarge", 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        end
    end
    if DPanelList_Backpack_Contents and DPanelList_Backpack_Contents:IsValid() then DPanelList_Backpack_Contents:Remove() end
    DPanelList_Backpack_Contents = vgui.Create("DPanelList", DFrame_LootMenu)
    DPanelList_Backpack_Contents:SetSize(790, 440)
    DPanelList_Backpack_Contents:SetPos(10, 40)
    DPanelList_Backpack_Contents:SetPadding(7.5)
    DPanelList_Backpack_Contents:SetSpacing(2)
    DPanelList_Backpack_Contents:EnableHorizontal(3)
    DPanelList_Backpack_Contents:EnableVerticalScrollbar(true)
    DPanelList_Backpack_Contents.Paint = function()
        draw.RoundedBox(10, 0, 0, DPanelList_Backpack_Contents:GetWide(), DPanelList_Backpack_Contents:GetTall(), Color(30, 30, 30, 0))
    end
    for item, quantity in pairs(Client_Backpack) do
        if quantity > 0 then
            local BackPack_Item, dModelPanel_Item = createInventoryButton(120, 120, item, quantity)
            dModelPanel_Item.DoClick = function() sendMessage("CL_LootItem", item, quantity) end
            DPanelList_Backpack_Contents:AddItem(BackPack_Item)
        end
    end
end