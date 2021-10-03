net.Receive("CharSelect", function(len) genderSelection() end)
function genderSelection()
    if DFrame_Select_Gender then return false end
    local DFrame_Select_Gender = vgui.Create("DFrame")
    DFrame_Select_Gender:SetTitle("")
    DFrame_Select_Gender:SetSize(ScrW(), ScrH())
    DFrame_Select_Gender:Center()
    DFrame_Select_Gender:SetDraggable(false)
    DFrame_Select_Gender:MakePopup()
    DFrame_Select_Gender:ShowCloseButton(false)
    DFrame_Select_Gender.Paint = function()
        draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255))
        draw.DrawText(_U('selectGender'), "ScoreboardHeader", ScrW() / 2, ScrH() / 2 - 100, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
    local DButton_MaleSelection = createButton(DFrame_Select_Gender, ScrW() / 2 - 150, ScrH() / 2 - 45, 300, 40, _U('genderMale'))
    DButton_MaleSelection.DoClick = function()
        DFrame_Select_Gender:Remove()
        DFrame_Select_Gender = nil
        selectCharacter(0)
    end
    local DButton_FemaleSelection = createButton(DFrame_Select_Gender, ScrW() / 2 - 150, ScrH() / 2 + 5, 300, 40, _U('genderFemale'))
    DButton_FemaleSelection.DoClick = function()
        DFrame_Select_Gender:Remove()
        DFrame_Select_Gender = nil
        selectCharacter(1)
    end
    local DButton_CustomSelection = createButton(DFrame_Select_Gender, ScrW() / 2 - 150, ScrH() / 2 + 55, 300, 40, _U('genderCustom'))
    DButton_CustomSelection.DoClick = function()
        DFrame_Select_Gender:Remove()
        DFrame_Select_Gender = nil
        selectCharacter(2)
    end
end

function selectCharacter(gender)
    local HeadNumber = 1
    local Clothes = 1
    local tbl = DayZ_Male
    if gender == 1 then
        tbl = DayZ_Female
    elseif gender == 2 then
        tbl = DayZ_Custom
    end
    local DFrame_ModelScreen = vgui.Create("DFrame")
    DFrame_ModelScreen:SetTitle("")
    DFrame_ModelScreen:SetSize(ScrW(), ScrH())
    DFrame_ModelScreen:Center()
    DFrame_ModelScreen:SetDraggable(false)
    DFrame_ModelScreen.Paint = function()
        draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255))
        draw.DrawText(_U('selectModel'), "ScoreboardHeader", ScrW() / 2, 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.DrawText(_U('selectBodyType'), "ScoreboardContent", ScrW() / 2 - 150, ScrH() / 2 - 185, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
        draw.DrawText(_U('selectClothes'), "ScoreboardContent", ScrW() / 2 - 200, ScrH() / 2 + 25, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
    end
    DFrame_ModelScreen:MakePopup()
    DFrame_ModelScreen:ShowCloseButton(false)
    DModelPanel_Player = vgui.Create("DModelPanel", DFrame_ModelScreen)
    DModelPanel_Player:SetModel(tbl[HeadNumber][Clothes])
    DModelPanel_Player:SetPos(ScrW() / 2 - 110, ScrH() / 2 - 250)
    DModelPanel_Player:SetSize(200, 500)
    DModelPanel_Player:SetCamPos(Vector(47, 0, 35))
    DModelPanel_Player:SetLookAt(Vector(0, 0, 35))
    DModelPanel_Player:SetFOV(40)
    function DModelPanel_Player:LayoutEntity(Entity)
        self:SetCamPos(Vector(47, 0, 35))
        self:SetLookAt(Vector(0, 0, 35))
    end
    local DButton_HeadLeft = createButton(DFrame_ModelScreen, ScrW() / 2 - 150, ScrH() / 2 - 200, 50, 50, "<")
    DButton_HeadLeft.DoClick = function()
        if (HeadNumber + 1) > table.Count(tbl) then
            HeadNumber = 1
        else
            HeadNumber = HeadNumber + 1
        end
        DModelPanel_Player:SetModel(tbl[HeadNumber][Clothes])
    end
    local DButton_HeadRight = createButton(DFrame_ModelScreen, ScrW() / 2 + 100, ScrH() / 2 - 200, 50, 50, ">")
    DButton_HeadRight.DoClick = function()
        if (HeadNumber - 1) <= 0 then
            HeadNumber = table.Count(tbl)
        else
            HeadNumber = HeadNumber - 1
        end
        DModelPanel_Player:SetModel(tbl[HeadNumber][Clothes])
    end
    local DButton_ClothesLeft = createButton(DFrame_ModelScreen, ScrW() / 2 - 200, ScrH() / 2, 70, 70, "<")
    DButton_ClothesLeft.DoClick = function()
        if (Clothes + 1) > table.Count(tbl[HeadNumber]) then
            Clothes = 1
        else
            Clothes = Clothes + 1
        end
        DModelPanel_Player:SetModel(tbl[HeadNumber][Clothes])
    end
    local DButton_ClothesRight = createButton(DFrame_ModelScreen, ScrW() / 2 + 130, ScrH() / 2, 70, 70, ">")
    DButton_ClothesRight.DoClick = function()
        if (Clothes - 1) <= 0 then
            Clothes = table.Count(tbl[HeadNumber])
        else
            Clothes = Clothes - 1
        end
        DModelPanel_Player:SetModel(tbl[HeadNumber][Clothes])
    end
    local DButton_Confirm = createButton(DFrame_ModelScreen, ScrW() / 2 - 125, ScrH() / 2 + 200, 250, 50, _U('selectConfirm'))
    DButton_Confirm.DoClick = function()
        sendCharacterUpdate(HeadNumber, Clothes, gender)
        DFrame_ModelScreen:Remove()
    end
    local DButton_Back = createButton(DFrame_ModelScreen, ScrW() / 2 - 125, ScrH() / 2 + 250, 250, 50, _U('selectBack'))
    DButton_Back.DoClick = function()
        DFrame_ModelScreen:Remove()
        genderSelection()
    end
end

function sendCharacterUpdate(head, clothes, gender)
    net.Start("CL_UpdateCharacter")
    net.WriteUInt(head, 6)
    net.WriteUInt(clothes, 6)
    net.WriteUInt(gender, 6)
    net.SendToServer()
end

function GM:PostDrawViewModel(vm, ply, weapon)
    if (weapon.UseHands || not weapon:IsScripted()) then
        local hands = LocalPlayer():GetHands()
        if (IsValid(hands)) then hands:DrawModel() end
    end
end