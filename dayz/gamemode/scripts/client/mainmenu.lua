mainMenuWidth, mainMenuHeight = 645, 525
subMenuWidth, subMenuHeight = mainMenuWidth - 25, mainMenuHeight - 50
surface.CreateFont("DebugFixedLarge", {font = "DebugFixed", size = 20})

function dFrame_Banner(width, height)
    surface.SetMaterial(Material("icons/background_cracks"))
    surface.SetDrawColor(Color(77, 67, 57, 255))
    surface.DrawTexturedRectUV(0, 0, width, height, 0.1, 0.4, width * 0.001 + 0.1, height * 0.001 + 0.4)
    draw.RoundedBox(10, 0, 0, width, 2, Color(0, 0, 0, 255))
    draw.RoundedBox(10, 0, height, width, 2, Color(0, 0, 0, 255))
end

function MainMenu()
    if not LocalPlayer():Alive() then return false end
    dFrame_Main_Menu = vgui.Create("DFrame")
    dFrame_Main_Menu:SetTitle("")
    dFrame_Main_Menu:SetSize(mainMenuWidth, mainMenuHeight)
    dFrame_Main_Menu:Center()
    dFrame_Main_Menu:SetDraggable(true)
    dFrame_Main_Menu:MakePopup()
    dFrame_Main_Menu:ShowCloseButton(false)
    dFrame_Main_Menu.Paint = function()
        local width, height = dFrame_Main_Menu:GetWide(), dFrame_Main_Menu:GetTall()
        draw.RoundedBox(10, 0, 0, width, height, Color(0, 0, 0, 35))
        surface.SetMaterial(Material("icons/background_cracks"))
        surface.SetDrawColor(Color(0, 0, 0, 180))
        surface.DrawTexturedRectUV(0, 0, width, height, 0, 0, width * 0.001, height * 0.001)
        dFrame_Banner(width, 35)
        draw.DrawText(LocalPlayer():Nick(), "DebugFixedLarge", mainMenuWidth - 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
    end
    local tabX, tabY = 11, 22
    local tabW, tabH = subMenuWidth, subMenuHeight
    local DPropSheet_MenuContents = vgui.Create("DPropertySheet")
    DPropSheet_MenuContents:SetParent(dFrame_Main_Menu)
    DPropSheet_MenuContents:SetPos(12, 10)
    DPropSheet_MenuContents:SetSize(tabW, tabH + 45)
    DPropSheet_MenuContents.Paint = function() end
    DPanel_Inventory_Tab = vgui.Create("DPanel")
    DPanel_Skill_Tab = vgui.Create("DPanel")
    DPanel_Craft_Tab = vgui.Create("DPanel")
    DPanel_Advert_Tab = vgui.Create("DPanel")
    local mainMenuPanels = {DPanel_Inventory_Tab, DPanel_Skill_Tab, DPanel_Craft_Tab, DPanel_Advert_Tab}
    for i = 1, table.Count(mainMenuPanels) do
        mainMenuPanels[i]:SetParent(DPropSheet_MenuContents)
        mainMenuPanels[i]:SetSize(tabW, tabH)
        mainMenuPanels[i]:SetPos(tabX, tabY)
        mainMenuPanels[i].Paint = function() end
    end
    DPropSheet_MenuContents:AddSheet("Inventory", DPanel_Inventory_Tab, "gui/silkicons/backpack", true, true, "It's literally your inventory. What more information do you need?")
    DPropSheet_MenuContents:AddSheet("Stats", DPanel_Skill_Tab, "gui/silkicons/user_red", true, true, "View your character stats, perks and skills and spend your hard earned XP")
    DPropSheet_MenuContents:AddSheet("Crafting", DPanel_Craft_Tab, "gui/silkicons/wrench", true, true, "View craftable items")
    DPropSheet_MenuContents:AddSheet("Help", DPanel_Advert_Tab, "gui/silkicons/help", true, true, "View controls/commands, content pack, rules and donation perks")
    for i = 1, table.Count(DPropSheet_MenuContents.Items) do
        DPropSheet_MenuContents.Items[i].Tab:SetAutoStretchVertical(false)
        DPropSheet_MenuContents.Items[i].Tab:SetSize(50, 50)
        DPropSheet_MenuContents.Items[i].Tab:SetFont("DebugFixed")
        DPropSheet_MenuContents.Items[i].Tab.Paint = function() draw.RoundedBox(10, 0, 0, 1, 18, Color(0, 0, 0, 255)) end
    end
    Inventory_List(DPanel_Inventory_Tab)
    skillsMenu(DPanel_Skill_Tab)
    craftMenu(DPanel_Craft_Tab)
    helpMenu(DPanel_Advert_Tab)
end

function helpMenu(frame)
    if DPanel_Help_Screen and DPanel_Help_Screen:IsValid() then else
        local buttonWidth, buttonHeight = 300, 40
        DPanel_Help_Screen = vgui.Create("DPanel", frame)
        DPanel_Help_Screen:SetSize(subMenuWidth, subMenuHeight)
        DPanel_Help_Screen:SetPos(0, 5)
        DPanel_Help_Screen.Paint = function() draw.RoundedBox(10, 0, 0, DPanel_Help_Screen:GetWide(), DPanel_Help_Screen:GetTall(), Color(50, 50, 50, 50)) end
        local DButton_ContentPack = createButton(DPanel_Help_Screen, mainMenuWidth * 0.5 - buttonWidth * 0.5, 75, buttonWidth, buttonHeight, "Server Content Pack")
        DButton_ContentPack.DoClick = function() gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2595587443") end
        local DButton_Controls = createButton(DPanel_Help_Screen, mainMenuWidth * 0.5 - buttonWidth * 0.5, 125, buttonWidth, buttonHeight, "Basic Controls/Commands")
        DButton_Controls.DoClick = function() menuControlsInfo() end
        local DButton_Server_Rules = createButton(DPanel_Help_Screen, mainMenuWidth * 0.5 - buttonWidth * 0.5, 175, buttonWidth, buttonHeight, "Server Rules")
        DButton_Server_Rules.DoClick = function() menuRulesInfo() end
        local Donation_Info = createButton(DPanel_Help_Screen, mainMenuWidth * 0.5 - buttonWidth * 0.5, 225, buttonWidth, buttonHeight, "Donation Info")
        Donation_Info.DoClick = function() donateMenuSafe() end
    end
end

function skillsMenu(frame)
    local function statMenu(frame)
        if DPanel_Stat_Menu and DPanel_Stat_Menu:IsValid() then else
            DPanel_Stat_Menu = vgui.Create("DPanel", frame)
            DPanel_Stat_Menu:SetSize(subMenuWidth, subMenuHeight)
            DPanel_Stat_Menu:SetPos(0, 5)
            DPanel_Stat_Menu.Paint = function()
                draw.RoundedBox(10, 0, 0, DPanel_Stat_Menu:GetWide(), DPanel_Stat_Menu:GetTall(), Color(50, 50, 50, 50))
                draw.DrawText("Name: "..LocalPlayer():Nick(), "TargetIDMedium", 10, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                if LocalPlayer().XP then
                    draw.DrawText("XP: "..LocalPlayer().XP, "TargetIDMedium", 10, 45, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("Money: $"..LocalPlayer().Money, "TargetIDMedium", 10, 65, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("Credits: "..LocalPlayer().Credits, "TargetIDMedium", 10, 85, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("Hunger: "..LocalPlayer().Hunger, "TargetIDMedium", 10, 125, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("Thirst: "..LocalPlayer().Thirst, "TargetIDMedium", 10, 145, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("Stamina: "..LocalPlayer().Stamina, "TargetIDMedium", 10, 165, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                end
            end
            local DModelPanel_Player = vgui.Create("DModelPanel", DPanel_Stat_Menu)
            DModelPanel_Player:SetModel(LocalPlayer():GetModel())
            DModelPanel_Player:SetPos(subMenuWidth * 0.6, 0)
            DModelPanel_Player:SetSize(subMenuWidth * 0.3, subMenuHeight * 0.9)
            DModelPanel_Player:SetFOV(90)
            function DModelPanel_Player:LayoutEntity(Entity)
                self:SetCamPos(Vector(20, 0, 55))
                self:SetLookAt(Vector(0, 0, 55))
            end
        end
    end
    local function perkMenu(frame)
        local function boolToText(b)
            if (b) then
                return "Owned", Color(0, 255, 0, 255)
            else
                return "Not Owned", Color(255, 255, 255, 255)
            end
        end
        if DPanel_Perk_Menu and DPanel_Perk_Menu:IsValid() then else
            DPanel_Perk_Menu = vgui.Create("DPanel", frame)
            DPanel_Perk_Menu:SetSize(subMenuWidth, subMenuHeight)
            DPanel_Perk_Menu:SetPos(0, 5)
            DPanel_Perk_Menu.Paint = function()
                draw.RoundedBox(10, 0, 0, DPanel_Perk_Menu:GetWide(), DPanel_Perk_Menu:GetTall(), Color(50, 50, 50, 50))
                for i = 1, table.Count(DayZShop["shop_perks"]) do
                    local txt, clr = boolToText(PlayerPerks[i])
                    draw.DrawText(DayZItems[DayZShop["shop_perks"][i]].Name, "DebugFixed", 10, 10 + (i - 1) * 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText(txt, "DebugFixed", 600, 10 + (i - 1) * 25, clr, TEXT_ALIGN_RIGHT)
                    draw.RoundedBox(10, 0, (i) * 25, DPanel_Perk_Menu:GetWide(), 1, Color(255, 255, 255, 255))
                end
            end
        end
    end
    local function skillMenu(frame)
        local skillTable = {
            {x = 20,  y = 30,           clr = Color(130, 70, 15, 255), skill = 11},
            {x = 100, y = 30, dir = 2,  clr = Color(130, 70, 15, 255), skill = 10},
            {x = 180, y = 30, dir = 2,  clr = Color(130, 70, 15, 255), skill = 9},
            {x = 260, y = 30, dir = 2,  clr = Color(130, 70, 15, 255), skill = 8},
            {x = 340, y = 30, dir = 2,  clr = Color(130, 70, 15, 255), skill = 7},
            {x = 20,  y = 110,          clr = Color(100, 0, 0, 255),   skill = 17},
            {x = 100, y = 110, dir = 2, clr = Color(100, 0, 0, 255),   skill = 18},
            {x = 180, y = 110, dir = 2, clr = Color(100, 0, 0, 255),   skill = 16},
            {x = 260, y = 110, dir = 2, clr = Color(100, 0, 0, 255),   skill = 15},
            {x = 100, y = 190, dir = 6, clr = Color(100, 0, 0, 255),   skill = 19},
            {x = 180, y = 190, dir = 8, clr = Color(100, 0, 0, 255),   skill = 20},
            {x = 340, y = 190, dir = 3, clr = Color(20, 60, 130, 255), skill = 1},
            {x = 340, y = 270, dir = 3, clr = Color(20, 60, 130, 255), skill = 2},
            {x = 340, y = 350, dir = 4, clr = Color(20, 60, 130, 255), skill = 3},
            {x = 420, y = 350,          clr = Color(20, 60, 130, 255), skill = 4},
            {x = 420, y = 110, dir = 4, clr = Color(50, 100, 20, 255), skill = 12},
            {x = 500, y = 110, dir = 3, clr = Color(50, 100, 20, 255), skill = 13},
            {x = 500, y = 190,          clr = Color(50, 100, 20, 255), skill = 14}
        }
        highlightSkill = nil
        if DPanel_Skill_Menu and DPanel_Skill_Menu:IsValid() then else
            DPanel_Skill_Menu = vgui.Create("DPanel", frame)
            DPanel_Skill_Menu:SetSize(subMenuWidth, subMenuHeight)
            DPanel_Skill_Menu:SetPos(0, 5)
            local w, h = DPanel_Skill_Menu:GetWide(), DPanel_Skill_Menu:GetTall()
            DPanel_Skill_Menu.Paint = function()
                draw.RoundedBox(10, 0, 0, w, h, Color(50, 50, 50, 50))
                if LocalPlayer().XP then draw.DrawText("XP: "..LocalPlayer().XP, "TargetIDMedium", w - 18, 5, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT) end
                if (highlightSkill) then
                    draw.RoundedBox(10, 0, h * 0.6, w * 0.5, h * 0.4, Color(0, 0, 0, 125))
                    local skillTbl = DayZSkills[highlightSkill.skill]
                    draw.DrawText(skillTbl.Name, "TargetIDMedium", 5, h * 0.6, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("Cost: "..skillTbl.XP.."XP", "TargetIDMedium", 5, h * 0.6 + 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText(skillTbl.Desc, "DebugFixed", 5, h * 0.6 + 40, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
                end
                surface.SetMaterial(Material("icons/skills/middle"))
                surface.SetDrawColor(Color(255, 255, 255, 150))
                surface.DrawTexturedRectUV(317, 88, 97, 96, 0, 0, 1, 1)
            end
            local DButton_Unlock = createButton(DPanel_Skill_Menu, w * 0.085, h * 0.9 - 30, 200, 30, "UNLOCK SKILL")
            DButton_Unlock.DoClick = function()
                if not highlightSkill then return end
                net.Start("CL_BuySkill")
                net.WriteUInt(highlightSkill.skill, 14)
                net.SendToServer()
            end
            for _, arrow in pairs(skillTable) do
                local x, y = arrow.x, arrow.y
                local size = 50
                local gap = 40
                local r = 0
                if arrow.dir == 1 then y = y + 50 r = 0 end
                if arrow.dir == 2 then x = x - 50 r = 90 end
                if arrow.dir == 3 then y = y + 50 r = 180 end
                if arrow.dir == 4 then x = x + 50 r = 270 end
                if arrow.dir == 6 then y = y - 50 r = 180 end
                if arrow.dir == 8 then x = x - 50 r = 270 end
                if arrow.dir == 9 then x = x + 50 r = 90 end
                local DArrow_Skill = vgui.Create("DPanel", DPanel_Skill_Menu)
                DArrow_Skill:SetPos(x, y)
                DArrow_Skill:SetSize(size, size)
                DArrow_Skill:SetText("")
                DArrow_Skill.Paint = function()
                    if arrow.dir then
                        surface.SetMaterial(Material("icons/skills/arrow"))
                        surface.SetDrawColor(Color(255, 255, 255, 100))
                        surface.DrawTexturedRectRotated(size * 0.5, size * 0.5, size, size, r)
                    end
                end
            end
            for k, skill in pairs(skillTable) do
                local DButton_Skill = vgui.Create("DButton", DPanel_Skill_Menu)
                DButton_Skill:SetPos(skill.x - 7, skill.y - 7)
                DButton_Skill:SetSize(64, 64)
                DButton_Skill:SetText("")
                DButton_Skill.Paint = function()
                    surface.SetMaterial(Material("icons/skills/inside"))
                    surface.SetDrawColor(skill.clr)
                    surface.DrawTexturedRectUV(7, 7, 50, 50, 0, 0, 1, 1)
                    surface.SetMaterial(Material("icons/skills/border"))
                    if (selectedSkill == k) then
                        surface.SetDrawColor(Color(255, 255, 255, 200))
                        surface.DrawTexturedRectUV(6, 6, 52, 52, 0, 0, 1, 1)
                    else
                        surface.SetDrawColor(Color(255, 255, 255, 200))
                        surface.DrawTexturedRectUV(7, 7, 50, 50, 0, 0, 1, 1)
                    end
                    if (highlightSkill == skill) then
                        surface.SetDrawColor(Color(255, 255, 255, 200))
                        surface.DrawTexturedRectUV(0, 0, 64, 64, 0, 0, 1, 1)
                    end
                    if Client_Skills[skill.skill] == 0 then
                        surface.SetMaterial(Material("icons/skills/padlock"))
                        surface.SetDrawColor(Color(255, 255, 255, 255))
                        surface.DrawTexturedRectUV(7, 7, 50, 50, 0, 0, 1, 1)
                    end
                end
                DButton_Skill.OnCursorEntered = function() selectedSkill = k end
                DButton_Skill.OnCursorExited = function() selectedSkill = nil end
                DButton_Skill.DoClick = function() highlightSkill = skill end
            end
        end
    end
    if DPanel_Skills and DPanel_Skills:IsValid() then else
        DPanel_Skills = vgui.Create("DPanel", frame)
        DPanel_Skills:SetSize(subMenuWidth, subMenuHeight)
        DPanel_Skills:SetPos(0, 5)
        DPanel_Skills.Paint = function() end
        local tabX, tabY = 11, 22
        local tabW, tabH = subMenuWidth, subMenuHeight
        local DPropSheet_StatContents = vgui.Create("DPropertySheet")
        DPropSheet_StatContents:SetParent(DPanel_Skills)
        DPropSheet_StatContents:SetPos(12, 10)
        DPropSheet_StatContents:SetSize(tabW, tabH + 45)
        DPropSheet_StatContents.Paint = function() end
        DPanel_Stats_Tab = vgui.Create("DPanel")
        DPanel_Perks_Tab = vgui.Create("DPanel")
        DPanel_Skills_Tab = vgui.Create("DPanel")
        local statPanels = {DPanel_Stats_Tab, DPanel_Perks_Tab, DPanel_Skills_Tab}
        for i = 1, table.Count(statPanels) do
            statPanels[i]:SetParent(DPropSheet_StatContents)
            statPanels[i]:SetSize(tabW, tabH)
            statPanels[i]:SetPos(tabX, tabY)
            statPanels[i].Paint = function() end
        end
        DPropSheet_StatContents:AddSheet("Stats", DPanel_Stats_Tab, "gui/silkicons/report", true, true, "Player Stats")
        DPropSheet_StatContents:AddSheet("Perks", DPanel_Perks_Tab, "gui/silkicons/award_star_gold_1", true, true, "Player Perks")
        DPropSheet_StatContents:AddSheet("Skills", DPanel_Skills_Tab, "gui/silkicons/chart_line", true, true, "Player Skills")
        for i = 1, table.Count(DPropSheet_StatContents.Items) do
            DPropSheet_StatContents.Items[i].Tab:SetAutoStretchVertical(false)
            DPropSheet_StatContents.Items[i].Tab:SetSize(50, 50)
            DPropSheet_StatContents.Items[i].Tab:SetFont("DebugFixed")
            DPropSheet_StatContents.Items[i].Tab.Paint = function() draw.RoundedBox(10, 0, 0, 1, 18, Color(0, 0, 0, 255)) end
        end
        statMenu(DPanel_Stats_Tab)
        perkMenu(DPanel_Perks_Tab)
        skillMenu(DPanel_Skills_Tab)
    end
end

function craftMenu(frame)
    if DPanel_Crafting and DPanel_Crafting:IsValid() then else
        DPanel_Crafting = vgui.Create("DPanel", frame)
        DPanel_Crafting:SetSize(subMenuWidth, subMenuHeight)
        DPanel_Crafting:SetPos(0, 5)
        DPanel_Crafting.Paint = function() end
        local tabX, tabY = 11, 22
        local tabW, tabH = subMenuWidth, subMenuHeight
        local DPropSheet_CraftContents = vgui.Create("DPropertySheet", frame)
        DPropSheet_CraftContents:SetParent(DPanel_Crafting)
        DPropSheet_CraftContents:SetPos(12, 10)
        DPropSheet_CraftContents:SetSize(tabW, tabH + 45)
        DPropSheet_CraftContents.Paint = function() end
        DPanel_Basic_Tab = vgui.Create("DPanel")
        DPanel_Intermediate_Tab = vgui.Create("DPanel")
        DPanel_Luxury_Tab = vgui.Create("DPanel")
        local statPanels = {DPanel_Basic_Tab, DPanel_Intermediate_Tab, DPanel_Luxury_Tab}
        for i = 1, table.Count(statPanels) do
            statPanels[i]:SetParent(DPropSheet_CraftContents)
            statPanels[i]:SetSize(tabW, tabH)
            statPanels[i]:SetPos(tabX, tabY)
            statPanels[i].Paint = function() end
        end
        DPropSheet_CraftContents:AddSheet("Basics", DPanel_Basic_Tab, "icon16/medal_bronze_1.png", true, true, "Craft basics items")
        DPropSheet_CraftContents:AddSheet("Advanced", DPanel_Intermediate_Tab, "icon16/medal_silver_1.png", true, true, "Craft advanced items")
        DPropSheet_CraftContents:AddSheet("Legendary", DPanel_Luxury_Tab, "icon16/medal_gold_1.png", true, true, "Craft legendary items")
        for i = 1, table.Count(DPropSheet_CraftContents.Items) do
            DPropSheet_CraftContents.Items[i].Tab:SetAutoStretchVertical(false)
            DPropSheet_CraftContents.Items[i].Tab:SetSize(50, 50)
            DPropSheet_CraftContents.Items[i].Tab:SetFont("DebugFixed")
            DPropSheet_CraftContents.Items[i].Tab.Paint = function() draw.RoundedBox(10, 0, 0, 1, 18, Color(0, 0, 0, 255)) end
        end
        local function updateCrafts()
            local function addCraftType(frame, crafttype)
                for _, craft in pairs(DayZCraft[crafttype]) do
                    local item = craft[1]
                    local speed = craft[2]
                    local ing = craft[3]
                    local Craft_Item = vgui.Create("DPanelList")
                    Craft_Item:SetParent(frame)
                    Craft_Item:SetSize(600, 140)
                    Craft_Item:SetPos(0, 0)
                    Craft_Item:SetSpacing(5)
                    Craft_Item.Paint = function()
                        draw.RoundedBox(10, 0, 0, Craft_Item:GetWide() - 6, Craft_Item:GetTall(), Color(0, 0, 0, 150))
                        draw.RoundedBox(10, 4, 4, 92, 92, Color(139, 133, 97, 55))
                    end
                    local dModelPanel_Item = vgui.Create("DModelPanel")
                    dModelPanel_Item:SetParent(Craft_Item)
                    dModelPanel_Item:SetPos(0, 0)
                    dModelPanel_Item:SetSize(100, 100)
                    dModelPanel_Item:SetModel(DayZItems[item].Model)
                    dModelPanel_Item:SetLookAt(Vector(0, 0, 0))
                    local camPos = Vector(30, 0, 30)
                    if DayZItems[item].CamOffset then camPos = camPos * DayZItems[item].CamOffset end
                    dModelPanel_Item:SetCamPos(camPos)
                    local DLabel_ItemName = vgui.Create("DLabel")
                    DLabel_ItemName:SetColor(Color(255, 255, 255, 255))
                    DLabel_ItemName:SetFont("Trebuchet18")
                    DLabel_ItemName:SetText(DayZItems[item].Name)
                    DLabel_ItemName:SizeToContents()
                    DLabel_ItemName:SetParent(Craft_Item)
                    DLabel_ItemName:SetPos(120, 0)
                    if DayZItems[item].Desc ~= nil then
                        local DLabel_ItemDesc = vgui.Create("DLabel")
                        DLabel_ItemDesc:SetColor(Color(255, 255, 255, 255))
                        DLabel_ItemDesc:SetFont("Trebuchet18")
                        DLabel_ItemDesc:SetText(DayZItems[item].Desc)
                        DLabel_ItemDesc:SizeToContents()
                        DLabel_ItemDesc:SetParent(Craft_Item)
                        DLabel_ItemDesc:SetPos(120, 20)
                    end
                    local DLabel_Clock = vgui.Create("DImage", Craft_Item)
                    DLabel_Clock:SetPos(540, 5)
                    DLabel_Clock:SetSize(16, 16)
                    DLabel_Clock:SetImage("icon16/clock.png")
                    local DLabel_ItemSpeed = vgui.Create("DLabel")
                    DLabel_ItemSpeed:SetColor(Color(255, 255, 255, 255))
                    DLabel_ItemSpeed:SetFont("Trebuchet18")
                    DLabel_ItemSpeed:SetText(speed .. "s")
                    DLabel_ItemSpeed:SizeToContents()
                    DLabel_ItemSpeed:SetParent(Craft_Item)
                    DLabel_ItemSpeed:SetPos(560, 5)
                    local DLabel_ItemIng = vgui.Create("DLabel")
                    DLabel_ItemIng:SetColor(Color(255, 255, 255, 255))
                    DLabel_ItemIng:SetFont("Trebuchet18")
                    DLabel_ItemIng:SetText("You need:")
                    DLabel_ItemIng:SizeToContents()
                    DLabel_ItemIng:SetParent(Craft_Item)
                    DLabel_ItemIng:SetPos(120, 35)
                    for k, v in pairs(ing) do
                        local obj = v[1]
                        local quantity = v[2]
                        local DLabel_ObjName = vgui.Create("DLabel")
                        DLabel_ObjName:SetColor(Color(255, 255, 255, 255))
                        DLabel_ObjName:SetFont("Default")
                        DLabel_ObjName:SetText("- " .. quantity .. " x " .. DayZItems[obj].Name)
                        DLabel_ObjName:SizeToContents()
                        DLabel_ObjName:SetParent(Craft_Item)
                        local x1 = 125 + ((k - 1) % 2) * 240
                        local y1 = 50 + ((k - 1) / 2) * 15
                        DLabel_ObjName:SetPos(x1, y1)
                        if not Client_Inventory[obj] or Client_Inventory[obj] < quantity then DLabel_ObjName:SetColor(Color(200, 0, 0)) end
                    end
                    local DButton_BuyItem = createButton(Craft_Item, 5, 105, 90, 30, "CRAFT")
                    DButton_BuyItem.DoClick = function() RunConsoleCommand("CraftItem", item) end
                    frame:AddItem(Craft_Item)
                end
            end
            local DPanelList_CraftBasicsTab = vgui.Create("DPanelList", DPanel_Basic_Tab)
            DPanelList_CraftBasicsTab:SetSize(600, 420)
            DPanelList_CraftBasicsTab:SetPos(0, 10)
            DPanelList_CraftBasicsTab:SetPadding(7.5)
            DPanelList_CraftBasicsTab:SetSpacing(2)
            DPanelList_CraftBasicsTab:EnableHorizontal(3)
            DPanelList_CraftBasicsTab:EnableVerticalScrollbar(true)
            DPanelList_CraftBasicsTab.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_CraftBasicsTab:GetWide(), DPanelList_CraftBasicsTab:GetTall(), Color(30, 30, 30, 0)) end
            local DPanelList_CraftIntermediatesTab = vgui.Create("DPanelList", DPanel_Intermediate_Tab)
            DPanelList_CraftIntermediatesTab:SetSize(600, 420)
            DPanelList_CraftIntermediatesTab:SetPos(0, 10)
            DPanelList_CraftIntermediatesTab:SetPadding(7.5)
            DPanelList_CraftIntermediatesTab:SetSpacing(2)
            DPanelList_CraftIntermediatesTab:EnableHorizontal(3)
            DPanelList_CraftIntermediatesTab:EnableVerticalScrollbar(true)
            DPanelList_CraftIntermediatesTab.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_CraftIntermediatesTab:GetWide(), DPanelList_CraftIntermediatesTab:GetTall(), Color(30, 30, 30, 0)) end
            local DPanelList_CraftLuxuriesTab = vgui.Create("DPanelList", DPanel_Luxury_Tab)
            DPanelList_CraftLuxuriesTab:SetSize(600, 420)
            DPanelList_CraftLuxuriesTab:SetPos(0, 10)
            DPanelList_CraftLuxuriesTab:SetPadding(7.5)
            DPanelList_CraftLuxuriesTab:SetSpacing(2)
            DPanelList_CraftLuxuriesTab:EnableHorizontal(3)
            DPanelList_CraftLuxuriesTab:EnableVerticalScrollbar(true)
            DPanelList_CraftLuxuriesTab.Paint = function() draw.RoundedBox(10, 0, 0, DPanelList_CraftLuxuriesTab:GetWide(), DPanelList_CraftLuxuriesTab:GetTall(), Color(30, 30, 30, 0)) end
            if Client_Skills[1] == 0 then
                local DLabel_No = vgui.Create("DLabel")
                DLabel_No:SetColor(Color(255, 255, 255, 255))
                DLabel_No:SetFont("Trebuchet18")
                DLabel_No:SetText("You don't have the required skill")
                DLabel_No:SizeToContents()
                DLabel_No:SetParent(DPanelList_CraftBasicsTab)
                DLabel_No:SetPos(10, 10)
            else
                addCraftType(DPanelList_CraftBasicsTab, "craft_basics")
            end
            if Client_Skills[2] == 0 then
                local DLabel_No = vgui.Create("DLabel")
                DLabel_No:SetColor(Color(255, 255, 255, 255))
                DLabel_No:SetFont("Trebuchet18")
                DLabel_No:SetText("You don't have the required skill")
                DLabel_No:SizeToContents()
                DLabel_No:SetParent(DPanelList_CraftIntermediatesTab)
                DLabel_No:SetPos(10, 10)
            else
                addCraftType(DPanelList_CraftIntermediatesTab, "craft_intermediates")
            end
            if Client_Skills[4] == 0 then
                local DLabel_No = vgui.Create("DLabel")
                DLabel_No:SetColor(Color(255, 255, 255, 255))
                DLabel_No:SetFont("Trebuchet18")
                DLabel_No:SetText("You don't have the required skill")
                DLabel_No:SizeToContents()
                DLabel_No:SetParent(DPanelList_CraftLuxuriesTab)
                DLabel_No:SetPos(10, 10)
            else
                addCraftType(DPanelList_CraftLuxuriesTab, "craft_luxuries")
            end
        end
        updateCrafts()
    end
end

net.Receive("SendCraft", function(len)
    local item = net.ReadUInt(14)
    local speed = net.ReadUInt(14)
    if not LocalPlayer().Crafts then LocalPlayer().Crafts = {} end
    LocalPlayer().Crafts[table.Count(LocalPlayer().Crafts) + 1] = {item, speed, CurTime()}
end)

hook.Add("HUDPaint", "CraftHUDPaint", function()
    if LocalPlayer().Crafts then
        local c = 1
        for k, v in pairs(LocalPlayer().Crafts) do
            if v[2] + v[3] < CurTime() then LocalPlayer().Crafts[k] = nil continue end
            surface.SetDrawColor(Color(0, 0, 0, 200))
            surface.DrawRect(ScrW() - 300, ScrH() - 60 - (c - 1) * 30, 300, 30)
            surface.SetDrawColor(Color(0, 0, 0, 230))
            surface.DrawRect(ScrW() - 300, ScrH() - 60 - (c - 1) * 30, (v[3] + v[2] - CurTime()) / v[2] * 300, 30)
            draw.DrawText(DayZItems[v[1]].Name, "Trebuchet18", ScrW() - 290, ScrH() - 55 - (c - 1) * 30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            c = c + 1
        end
    end
end)

function ClientKeyPress()
    if (input.IsKeyDown(KEY_M) == true and not LocalPlayer():IsTyping()) then
        DrawMap = true
    else
        DrawMap = false
    end
end
hook.Add("Think", "ClientKeyPress", ClientKeyPress)
hook.Add("OnSpawnMenuOpen", "OnSpawnMenuOpen11", function() MainMenu() end)
hook.Add("OnSpawnMenuClose", "OnSpawnMenuClose11", function()
    if(dFrame_Main_Menu)then
        dFrame_Main_Menu:Remove()
        dFrame_Main_Menu = nil
    end
end)

function drawMap()
    if DrawMap == true then
        local BoxSize = 1024
        local Offset = BoxSize * 0.5
        draw.RoundedBox(10, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 225 ) )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetTexture( surface.GetTextureID("gui/map") )
        surface.DrawTexturedRect( ( ScrW() / 2 ) - Offset, ( ScrH() / 2 ) - Offset, BoxSize, BoxSize )
        draw.RoundedBox(10, ( ScrW() / 2 ) - Offset, (BoxSize/5), BoxSize, 1, Color( 255, 255, 255, 225 ) )
        draw.RoundedBox(10, ( ScrW() / 2 ) - Offset, (BoxSize/5)*2, BoxSize, 1, Color( 255, 255, 255, 225 ) )
        draw.RoundedBox(10, ( ScrW() / 2 ) - Offset, (BoxSize/5)*3, BoxSize, 1, Color( 255, 255, 255, 225 ) )
        draw.RoundedBox(10, ( ScrW() / 2 ) - Offset, (BoxSize/5)*4, BoxSize, 1, Color( 255, 255, 255, 225 ) )
        draw.RoundedBox(10, ( ScrW() / 2 ) - Offset + (BoxSize/5),  ( ScrH() / 2 ) - Offset, 1, BoxSize, Color( 255, 255, 255, 225 ) )
        draw.RoundedBox(10, ( ScrW() / 2 ) - Offset + (BoxSize/5)*2, ( ScrH() / 2 ) - Offset, 1, BoxSize, Color( 255, 255, 255, 225 ) )
        draw.RoundedBox(10, ( ScrW() / 2 ) - Offset + (BoxSize/5)*3, ( ScrH() / 2 ) - Offset, 1, BoxSize, Color( 255, 255, 255, 225 ) )
        draw.RoundedBox(10, ( ScrW() / 2 ) - Offset + (BoxSize/5)*4, ( ScrH() / 2 ) - Offset, 1, BoxSize, Color( 255, 255, 255, 225 ) )
    end
end
hook.Add("HUDPaint", "drawMap", drawMap)

function menuControlsInfo()
    local dFrame_ControlPanel = vgui.Create("DFrame")
    dFrame_ControlPanel:SetPos(0, 0)
    dFrame_ControlPanel:SetSize(500, 450)
    dFrame_ControlPanel:Center()
    dFrame_ControlPanel:SetTitle("Player Controls/Commands")
    dFrame_ControlPanel:SetVisible(true)
    dFrame_ControlPanel:SetDraggable(true)
    dFrame_ControlPanel:MakePopup()
    dFrame_ControlPanel:ShowCloseButton(true)
    dFrame_ControlPanel.Paint = function()
        draw.RoundedBox(10, 1, 1, dFrame_ControlPanel:GetWide() - 2, dFrame_ControlPanel:GetTall() - 2, Color(100, 90, 80, 255))
        draw.RoundedBox(10, 1, 1, dFrame_ControlPanel:GetWide() - 2, 25, Color(77, 67, 57, 255))
        draw.RoundedBox(10, 1, 1, dFrame_ControlPanel:GetWide() - 2, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 1, 25, dFrame_ControlPanel:GetWide() - 2, 2, Color(0, 0, 0, 255))
    end
    local dPanel_Info = vgui.Create("DPanel", dFrame_ControlPanel)
    dPanel_Info:SetSize(480, 410)
    dPanel_Info:SetPos(10, 30)
    dPanel_Info.Paint = function() draw.RoundedBox(10, 0, 0, dPanel_Info:GetWide(), dPanel_Info:GetTall(), Color(88, 77, 67, 255)) end
    local dLabel_Benefits = vgui.Create("DLabel")
    dLabel_Benefits:SetColor(Color(255, 255, 255, 255))
    if UseNewShop then
        dLabel_Benefits:SetText("BUTTON COMMANDS\nQ - Inventory\nE - Pickup Loot Item\nF4 - Toggle Thirdperson\nF - Flaslight (Must be in your inventory)\n\nCHAT COMMANDS\n/g or // - Global Chat\n/trade - Trade Chat\n/group - Group Chat\n\nCONSOLE COMMANDS\ndz_hud [1/0] - Toggle new/old hud layout\ndz_minimap [1/0] - Toggle minimap hud [COMING SOON]\ndz_showsafezone [1/0] - Show the SafeZone/Bank 3D text")
    else
        dLabel_Benefits:SetText("BUTTON COMMANDS\nQ - Inventory\nE - Pickup Loot Item\nF2 - Open SafeZone Shop\nF4 - Toggle Thirdperson\nF - Flaslight (Must be in your inventory)\n\nCHAT COMMANDS\n/g or // - Global Chat\n/trade - Trade Chat\n/group - Group Chat\n\nCONSOLE COMMANDS\ndz_hud [1/0] - Toggle new/old hud layout\ndz_minimap [1/0] - Toggle minimap hud [COMING SOON]\ndz_showsafezone [1/0] - Show the SafeZone/Bank 3D text")
    end
    dLabel_Benefits:SetPos(20, 30)
    dLabel_Benefits:SetFont("TargetIDSmall")
    dLabel_Benefits:SizeToContents()
    dLabel_Benefits:SetParent(dFrame_ControlPanel)
end

function menuRulesInfo()
    local dFrame_ControlPanel = vgui.Create("DFrame")
    dFrame_ControlPanel:SetPos(0, 0)
    dFrame_ControlPanel:SetSize(500, 450)
    dFrame_ControlPanel:Center()
    dFrame_ControlPanel:SetTitle("Server Rules")
    dFrame_ControlPanel:SetVisible(true)
    dFrame_ControlPanel:SetDraggable(true)
    dFrame_ControlPanel:MakePopup()
    dFrame_ControlPanel:ShowCloseButton(true)
    dFrame_ControlPanel.Paint = function()
        draw.RoundedBox(10, 1, 1, dFrame_ControlPanel:GetWide() - 2, dFrame_ControlPanel:GetTall() - 2, Color(100, 90, 80, 255))
        draw.RoundedBox(10, 1, 1, dFrame_ControlPanel:GetWide() - 2, 25, Color(77, 67, 57, 255))
        draw.RoundedBox(10, 1, 1, dFrame_ControlPanel:GetWide() - 2, 2, Color(0, 0, 0, 255))
        draw.RoundedBox(10, 1, 25, dFrame_ControlPanel:GetWide() - 2, 2, Color(0, 0, 0, 255))
    end
    local dPanel_Info = vgui.Create("DPanel", dFrame_ControlPanel)
    dPanel_Info:SetSize(480, 410)
    dPanel_Info:SetPos(10, 30)
    dPanel_Info.Paint = function() draw.RoundedBox(10, 0, 0, dPanel_Info:GetWide(), dPanel_Info:GetTall(), Color(88, 77, 67, 255)) end
    local dLabel_Benefits = vgui.Create("DLabel")
    dLabel_Benefits:SetColor(Color(255, 255, 255, 255))
    dLabel_Benefits:SetText("1) Community Rules & Guidelines must be followed (viewable on our Discord)\n2) Do not Cheat/Hack/Exploit\n3) Do not Troll\n4) Try not to Combat Log\n5) No Malicious/Sexual Acts\n6) Use Common Sense\n\nEveryone is here to have fun and play a video game. While the nature of GmodZ is\nto kill everyone you see, dont get so upset about dying.")
    dLabel_Benefits:SetPos(20, 30)
    dLabel_Benefits:SetFont("TargetIDSmall")
    dLabel_Benefits:SizeToContents()
    dLabel_Benefits:SetParent(dFrame_ControlPanel)
end