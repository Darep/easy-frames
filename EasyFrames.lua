local frame = CreateFrame("FRAME")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("UNIT_FACTION")
--LoadAddOn("Blizzard_ArenaUI")



local function eventHandler(self, event, ...)
    TargetFrameNameBackground:SetVertexColor(0, 0, 0, 0.0)
    TargetFrameNameBackground:SetHeight(18)
    FocusFrameNameBackground:SetVertexColor(0, 0, 0, 0.0)
    FocusFrameNameBackground:SetHeight(18)
    TargetFrameBackground:SetHeight(41)
    FocusFrameBackground:SetHeight(41)
end

local function ReadableNumber(num, places)
    local ret
    -- local placeValue = ("%%.%d1f"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000 then
        ret = string.format("%.0f", num / 1000000000) .. "B" -- billion
    elseif num >= 100000000 then
        ret = string.format("%.3s", num) .. "M" -- millions > 100
    elseif num >= 10000000 then
        ret = string.format("%.2s", num) .. "M" -- million > 10
    elseif num >= 1000000 then
        ret = string.format("%.4s", num) .. "T" -- million > 1
    elseif num >= 100000 then
        ret = string.format("%.3s", num) .. "T" -- thousand > 100
    elseif num >= 10000 then
        ret = string.format("%.0f", num / 1000) .. "T" -- thousand
    else
        ret = num -- hundreds
    end
    return ret
end

frame:SetScript("OnEvent", eventHandler)

PlayerFrameTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-TargetingFrame")
hooksecurefunc("TargetFrame_CheckClassification", function(self, forceNormalTexture)
    local classification = UnitClassification(self.unit);
    --[[
    self.nameBackground:Show();
    self.manabar:Show();
    self.manabar.TextString:Show();
    self.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash");
	]] --
    if (forceNormalTexture) then
        self.borderTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-TargetingFrame");
    elseif (classification == "minus") then
        self.borderTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-TargetingFrame-Minus");
        self.nameBackground:Hide();
        self.manabar:Hide();
        self.manabar.TextString:Hide();
        forceNormalTexture = true;
    elseif (classification == "worldboss" or classification == "elite") then
        self.borderTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-TargetingFrame-Elite");
    elseif (classification == "rareelite") then
        self.borderTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-TargetingFrame-Rare-Elite");
    elseif (classification == "rare") then
        self.borderTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-TargetingFrame-Rare");
    else
        self.borderTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-TargetingFrame");
        forceNormalTexture = true;
    end
end)

--TEST Pet
hooksecurefunc("PetFrame_Update", function(self, override)
    if ((not PlayerFrame.animating) or (override)) then
        if (UnitIsVisible(self.unit) and PetUsesPetFrame() and not PlayerFrame.vehicleHidesPet) then
            if (self:IsShown()) then
                UnitFrame_Update(self);
            else
                self:Show();
            end
            --self.flashState = 1;
            --self.flashTimer = PET_FLASH_ON_TIME;
            if (UnitPowerMax(self.unit) == 0) then
                PetFrameTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-SmallTargetingFramex-NoMana");
                PetFrameManaBarText:Hide();
            else
                PetFrameTexture:SetTexture("Interface\\AddOns\\EasyFrames\\TargetingFrame\\UI-SmallTargetingFramex");
            end
            PetAttackModeTexture:Hide();

            RefreshDebuffs(self, self.unit, nil, nil, true);
        else
            self:Hide();
        end
    end
end)


PetName:ClearAllPoints()
PetName:SetPoint("CENTER", PetFrame, "CENTER", 14, 19)
PetName.SetPoint = function() end

--PlayerPVPIcon:SetAlpha(0)
--TargetFrameTextureFramePVPIcon:SetAlpha(0)
--FocusFrameTextureFramePVPIcon:SetAlpha(0)

--hooksecurefunc(PlayerPVPTimerText, "SetFormattedText", function(self)
--    self.timeLeft = nil
--    self:Hide()
--end)

local noop = function() return end
for _, objname in ipairs({
    "PlayerAttackGlow",
    "PetAttackModeTexture",
    "PlayerRestGlow",
    "PlayerRestIcon",
    "PlayerStatusGlow",
    "PlayerStatusTexture",
    "PlayerAttackBackground",
    "PlayerFrameGroupIndicator",
    "PlayerFrameFlash",
    "TargetFrameFlash",
    "FocusFrameFlash",
    "PetFrameFlash",
    "PlayerFrameRoleIcon",
}) do
    local obj = _G[objname]
    if obj then
        obj:Hide()
        obj.Show = noop
    end
end

--ToT move
TargetFrameToT:ClearAllPoints()
TargetFrameToT:SetPoint("CENTER", TargetFrame, "CENTER", 60, -45)

FocusFrameToT:ClearAllPoints()
FocusFrameToT:SetPoint("CENTER", FocusFrame, "CENTER", 60, -45)


--Names
TargetFrame.name:ClearAllPoints()
TargetFrame.name:SetPoint("CENTER", TargetFrame, "CENTER", -50, 35)
TargetFrame.name.SetPoint = function() end
FocusFrame.name:ClearAllPoints()
FocusFrame.name:SetPoint("CENTER", FocusFrame, "CENTER", -45, 35)
FocusFrame.name.SetPoint = function() end


--bars
--Player bars
PlayerFrameHealthBar:SetHeight(27)
PlayerFrameHealthBar:ClearAllPoints()
PlayerFrameHealthBar:SetPoint("CENTER", PlayerFrame, "CENTER", 50, 14)
PlayerFrameHealthBar.SetPoint = function() end

PlayerFrameManaBar:ClearAllPoints()
PlayerFrameManaBar:SetPoint("CENTER", PlayerFrame, "CENTER", 51, -7)
PlayerFrameManaBar.SetPoint = function() end

--Player Pet bars
PetFrameHealthBar:SetHeight(13)
PetFrameHealthBar:ClearAllPoints()
PetFrameHealthBar:SetPoint("CENTER", PetFrame, "CENTER", 16, 5)
PetFrameHealthBar.SetPoint = function() end

PetFrameManaBar:ClearAllPoints()
PetFrameManaBar:SetPoint("CENTER", PetFrame, "CENTER", 16, -7)
PetFrameManaBar.SetPoint = function() end


PetFrameHealthBar.TextString:ClearAllPoints()
PetFrameHealthBar.TextString:SetPoint("CENTER", PetFrameHealthBar, "CENTER", 0, 0)
PetFrameHealthBar.TextString.SetPoint = function() end
PetFrameManaBar.TextString:ClearAllPoints()
PetFrameManaBar.TextString:SetPoint("CENTER", PetFrameManaBar, "CENTER", 0, 0)
PetFrameManaBar.TextString.SetPoint = function() end

--Target bars
TargetFrameHealthBar:SetHeight(27)
TargetFrameHealthBar:ClearAllPoints()
TargetFrameHealthBar:SetPoint("CENTER", TargetFrame, "CENTER", -50, 14)
TargetFrameHealthBar.SetPoint = function() end

TargetFrameTextureFrameDeadText:ClearAllPoints()
TargetFrameTextureFrameDeadText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)
TargetFrameTextureFrameDeadText.SetPoint = function() end

TargetFrameManaBar:ClearAllPoints()
TargetFrameManaBar:SetPoint("CENTER", TargetFrame, "CENTER", -51, -7)
TargetFrameManaBar.SetPoint = function() end

TargetFrameNumericalThreat:SetScale(0.9)
TargetFrameNumericalThreat:ClearAllPoints()
TargetFrameNumericalThreat:SetPoint("CENTER", TargetFrame, "CENTER", 44, 48)
TargetFrameNumericalThreat.SetPoint = function() end

--Focus bars
FocusFrameHealthBar:SetHeight(27)
FocusFrameHealthBar:ClearAllPoints()
FocusFrameHealthBar:SetPoint("CENTER", FocusFrame, "CENTER", -50, 14)
FocusFrameHealthBar.SetPoint = function() end

FocusFrameTextureFrameDeadText:ClearAllPoints()
FocusFrameTextureFrameDeadText:SetPoint("CENTER", FocusFrameHealthBar, "CENTER", 0, 0)
FocusFrameTextureFrameDeadText.SetPoint = function() end

FocusFrameManaBar:ClearAllPoints()
FocusFrameManaBar:SetPoint("CENTER", FocusFrame, "CENTER", -51, -7)
FocusFrameManaBar.SetPoint = function() end

FocusFrameNumericalThreat:ClearAllPoints()
FocusFrameNumericalThreat:SetPoint("CENTER", FocusFrame, "CENTER", 44, 48)
FocusFrameNumericalThreat.SetPoint = function() end





--Textstrings
--Fonts
PlayerFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
TargetFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
FocusFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
TargetFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
PlayerFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
FocusFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")

TargetFrameHealthBar.TextString:ClearAllPoints()
TargetFrameHealthBar.TextString:SetPoint("CENTER", TargetFrame, "CENTER", -53, 12)
TargetFrameHealthBar.TextString.SetPoint = function() end

PlayerFrameHealthBar.TextString:ClearAllPoints()
PlayerFrameHealthBar.TextString:SetPoint("CENTER", PlayerFrame, "CENTER", 53, 12)
PlayerFrameHealthBar.TextString.SetPoint = function() end

FocusFrameHealthBar.TextString:ClearAllPoints()
FocusFrameHealthBar.TextString:SetPoint("CENTER", FocusFrame, "CENTER", -53, 12)
FocusFrameHealthBar.TextString.SetPoint = function() end

PlayerFrameManaBar.TextString:ClearAllPoints()
PlayerFrameManaBar.TextString:SetPoint("CENTER", PlayerFrame, "CENTER", 53, -7)
PlayerFrameManaBar.TextString.SetPoint = function() end

TargetFrameManaBar.TextString:ClearAllPoints()
TargetFrameManaBar.TextString:SetPoint("CENTER", TargetFrame, "CENTER", -50, -7)
TargetFrameManaBar.TextString.SetPoint = function() end

FocusFrameManaBar.TextString:ClearAllPoints()
FocusFrameManaBar.TextString:SetPoint("CENTER", FocusFrame, "CENTER", -50, -7)
FocusFrameManaBar.TextString.SetPoint = function() end




--Resource Format
FrameList = { "Target", "Focus", "Player" }
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", function(statusFrame, textString, value, valueMin, valueMax)
    for i = 1, select("#", unpack(FrameList)) do
        local FrameName = (select(i, unpack(FrameList)))
        if (UnitPowerType(FrameName) == 0) then --mana
            _G[FrameName .. "FrameManaBar"].TextString:SetText(string.format("%.0f%%", (UnitMana(FrameName) / UnitManaMax(FrameName)) * 100))
        elseif (UnitPowerType(FrameName) == 1 or UnitPowerType(FrameName) == 2 or UnitPowerType(FrameName) == 3 or UnitPowerType(FrameName) == 6) then
            _G[FrameName .. "FrameManaBar"].TextString:SetText(AbbreviateLargeNumbers(UnitMana(FrameName)))
        end
        if (UnitManaMax(FrameName) == 0) then
            _G[FrameName .. "FrameManaBar"].TextString:SetText(" ")
        end
    end
end)




EasyFrames = {};
EasyFrames.panel = CreateFrame("Frame", "EasyFrames", UIParent);
EasyFrames.panel.name = "EasyFrames";
InterfaceOptions_AddCategory(EasyFrames.panel);

EasyFrames.childpanel = CreateFrame("Frame", "GUIGeneralFrame", EasyFrames.panel);
EasyFrames.childpanel.name = "General";
EasyFrames.childpanel.parent = EasyFrames.panel.name;
InterfaceOptions_AddCategory(EasyFrames.childpanel);

EasyFrames.childpanel = CreateFrame("Frame", "GUIPlayerFrame", EasyFrames.panel);
EasyFrames.childpanel.name = "Player Frame Settings";
EasyFrames.childpanel.parent = EasyFrames.panel.name;
InterfaceOptions_AddCategory(EasyFrames.childpanel);

EasyFrames.childpanel = CreateFrame("Frame", "GUITargetFrame", EasyFrames.panel);
EasyFrames.childpanel.name = "Target Frame Settings";
EasyFrames.childpanel.parent = EasyFrames.panel.name;
InterfaceOptions_AddCategory(EasyFrames.childpanel);

EasyFrames.childpanel = CreateFrame("Frame", "GUIFocusFrame", EasyFrames.panel);
EasyFrames.childpanel.name = "Focus Frame Settings";
EasyFrames.childpanel.parent = EasyFrames.panel.name;
InterfaceOptions_AddCategory(EasyFrames.childpanel);

EasyFrames.childpanel = CreateFrame("Frame", "GUIPetFrame", EasyFrames.panel);
EasyFrames.childpanel.name = "Pet Frame Settings";
EasyFrames.childpanel.parent = EasyFrames.panel.name;
InterfaceOptions_AddCategory(EasyFrames.childpanel);






SlashCmdList.EasyFrames = function()
    InterfaceOptionsFrame_OpenToCategory(EasyFrames.panel)
    InterfaceOptionsFrame_OpenToCategory(EasyFrames.panel)
end
SLASH_EasyFrames1 = "/easyframes"
SLASH_EasyFrames1 = "/ef"




-----------------------------
--- ##ADDON RELATED STUFF##---
-----------------------------

EasyFramesDB = {
    ["castby"] = 55,
    ["fcastbx"] = -195,
    --    ["palaspecialx"] = 0,
    ["targetoffocus"] = 1,
    ["classcolorttot"] = 1,
    ["classcolorftot"] = 1,
    ["castbx"] = -15,
    ["playername"] = 1,
    ["palaspecialy"] = 0,
    ["fcastby"] = 0,
    ["classcolortarget"] = 1,
    ["framescaletarget"] = 1.176947474479675,
    --    ["specialx"] = 0,
    ["framescalefocus"] = 1.176947474479675,
    ["classcolorFocus"] = 1,
    ["specialy"] = 0,
    --    ["monkspecialx"] = 0,
    ["framescaleplayer"] = 1.176947474479675,
    ["targetoftarget"] = 1,
    ["classcolorarena"] = 1,
    ["monkspecialy"] = 0,
    ["classcolor"] = 1,
    ["playerspecialbar"] = 1,
    ["classportraits"] = 0,
    ["playerhitindi"] = 1,
    ["bartex"] = 4,
    ["classcolorplayer"] = 1,
    ["darkentextures"] = 0.9,
    ["hformat"] = 5,
    ["scaleselfbuffsize"] = 1.4,
}

EasyFramesDB.darkentextures = 0.9;


unserAddon = {}

-- function to initialize when addon has loaded
function unserAddon:Init(event, addon)

    if (event == "ADDON_LOADED" and addon == "EasyFrames") then

        print("|cff71C671EasyFrames|cffffffff loaded. Options: |cff71C671/ef")

        unserAddon:CreateGUI(unserFrameAddon)

        if (EasyFramesDB.castbx ~= 0 or EasyFramesDB.castby ~= 0) then
            TargetFrameSpellBar:ClearAllPoints()
            TargetFrameSpellBar:SetPoint("CENTER", TargetFrame, "CENTER", EasyFramesDB.castbx, EasyFramesDB.castby)
            TargetFrameSpellBar.SetPoint = function() end
        end

        if (EasyFramesDB.framescaletarget and EasyFramesDB.framescaletarget ~= 1) then
            TargetFrame:SetScale(EasyFramesDB.framescaletarget)
        end

        if (EasyFramesDB.framescalefocus and EasyFramesDB.framescalefocus ~= 1) then
            FocusFrame:SetScale(EasyFramesDB.framescalefocus)
        end

        if (EasyFramesDB.framescaleplayer and EasyFramesDB.framescaleplayer ~= 1) then
            PlayerFrame:SetScale(EasyFramesDB.framescaleplayer)
        end

        if (EasyFramesDB.darkentextures and EasyFramesDB.darkentextures ~= 1) then

            for i, v in pairs({
                PlayerFrameTexture, TargetFrameTextureFrameTexture, PetFrameTexture, FocusFrameTextureFrameTexture,
                TargetFrameToTTextureFrameTexture, FocusFrameToTTextureFrameTexture
            }) do
                v:SetVertexColor(EasyFramesDB.darkentextures, EasyFramesDB.darkentextures, EasyFramesDB.darkentextures)
            end
        end

        if (EasyFramesDB.fcastbx ~= 0 or EasyFramesDB.fcastby ~= 0) then
            FocusFrameSpellBar:ClearAllPoints()
            FocusFrameSpellBar:SetPoint("CENTER", FocusFrame, "CENTER", EasyFramesDB.fcastbx, EasyFramesDB.fcastby)
            FocusFrameSpellBar.SetPoint = function() end
        end

        PlayerName:ClearAllPoints()
        PlayerName:SetPoint("CENTER", PlayerFrame, "CENTER", 50, 35)
        PlayerName.SetPoint = function() end



        if (EasyFramesDB.percentcolorplayer) then
            PlayerPercentcolorcheck:SetChecked(true)
        end

        if (EasyFramesDB.percentcolortarget) then
            TargetPercentcolorcheck:SetChecked(true)
        end

        if (EasyFramesDB.percentcolorfocus) then
            FocusPercentcolorcheck:SetChecked(true)
        end

        if (EasyFramesDB.percentcolorpet) then
            PetPercentcolorcheck:SetChecked(true)
        end

        if (EasyFramesDB.percentcolortargettot) then
            TargetToTPercentcolorcheck:SetChecked(true)
        end

        if (EasyFramesDB.percentcolorfocustot) then
            FocusToTPercentcolorcheck:SetChecked(true)
        end

        if (EasyFramesDB.classcolor) then
            classcolorcheck:SetChecked(true)

            local function colour(statusbar, unit)
                if (unit ~= mouseover) then
                    local _, class, c

                    local value = UnitHealth(unit);
                    local min, max = statusbar:GetMinMaxValues();

                    local r, g, b;

                    if ((value < min) or (value > max)) then
                        return;
                    end
                    if ((max - min) > 0) then
                        value = (value - min) / (max - min);
                    else
                        value = 0;
                    end
                    if (value > 0.5) then
                        r = (1.0 - value) * 2;
                        g = 1.0;
                    else
                        r = 1.0;
                        g = value * 2;
                    end
                    b = 0.0;


                    if (UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit)) then

                        _, class = UnitClass(unit)
                        c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
                        statusbar:SetStatusBarColor(c.r, c.g, c.b)

                        if (not EasyFramesDB.classcolorplayer) then
                            if (EasyFramesDB.percentcolorplayer) then

                                if (statusbar == PlayerFrameHealthBar) then
                                    PlayerFrameHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == PlayerFrameHealthBar) then
                                    if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                        PlayerFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                    else
                                        PlayerFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                    end
                                end
                            end
                        else
                            PlayerClasscolorcheck:SetChecked(true)
                        end

                        if (not EasyFramesDB.classcolortarget) then
                            if (EasyFramesDB.percentcolortarget) then
                                if (statusbar == TargetFrameHealthBar) then
                                    TargetFrameHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == TargetFrameHealthBar) then
                                    if (not UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                            TargetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                        else
                                            TargetFrameHealthBar:SetStatusBarColor(1, 0, 0)
                                        end
                                    end
                                    if (UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                            TargetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                        else
                                            TargetFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                        end
                                    end
                                end
                            end
                        else
                            targetclasscolorcheck:SetChecked(true)
                        end

                        if (not EasyFramesDB.classcolorFocus) then
                            if (EasyFramesDB.percentcolorfocus) then

                                if (statusbar == FocusFrameHealthBar) then
                                    FocusFrameHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == FocusFrameHealthBar) then
                                    if (not UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                            FocusFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                        else
                                            FocusFrameHealthBar:SetStatusBarColor(1, 0, 0)
                                        end
                                    end
                                    if (UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                            FocusFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                        else
                                            FocusFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                        end
                                    end
                                end
                            end
                        else
                            focusclasscolorcheck:SetChecked(true)
                        end

                        if (not EasyFramesDB.classcolorttot) then
                            if (EasyFramesDB.percentcolortargettot) then

                                if (statusbar == TargetFrameToTHealthBar) then
                                    TargetFrameToTHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == TargetFrameToTHealthBar) then
                                    if (not UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                            TargetFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                        else
                                            TargetFrameToTHealthBar:SetStatusBarColor(1, 0, 0)
                                        end
                                    end
                                    if (UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                            TargetFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                        else
                                            TargetFrameToTHealthBar:SetStatusBarColor(0, 1, 0)
                                        end
                                    end
                                end
                            end
                        else
                            Ttotclasscolorcheck:SetChecked(true)
                        end

                        if (not EasyFramesDB.classcolorftot) then
                            if (EasyFramesDB.percentcolorfocustot) then

                                if (statusbar == FocusFrameToTHealthBar) then
                                    FocusFrameToTHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == FocusFrameToTHealthBar) then
                                    if (not UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                            FocusFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                        else
                                            FocusFrameToTHealthBar:SetStatusBarColor(1, 0, 0)
                                        end
                                    end
                                    if (UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                            FocusFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                        else
                                            FocusFrameToTHealthBar:SetStatusBarColor(0, 1, 0)
                                        end
                                    end
                                end
                            end
                        else
                            Ftotclasscolorcheck:SetChecked(true)
                        end



                    else --no player but classcolored

                        if (UnitIsConnected(unit) and unit == statusbar.unit) then
                            if (EasyFramesDB.percentcolortargettot) then

                                if (statusbar == TargetFrameToTHealthBar) then
                                    TargetFrameToTHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == TargetFrameToTHealthBar) then
                                    if (not UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                            TargetFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                        else
                                            TargetFrameToTHealthBar:SetStatusBarColor(1, 0, 0)
                                        end
                                    end
                                    if (UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                            TargetFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                        else
                                            TargetFrameToTHealthBar:SetStatusBarColor(0, 1, 0)
                                        end
                                    end
                                end
                            end

                            if (EasyFramesDB.percentcolorpet) then

                                if (statusbar == PetFrameHealthBar) then
                                    PetFrameHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == PetFrameHealthBar) then

                                    if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                        PetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                    else
                                        PetFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                    end
                                end
                            end



                            if (EasyFramesDB.percentcolorfocustot) then

                                if (statusbar == FocusFrameToTHealthBar) then
                                    FocusFrameToTHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == FocusFrameToTHealthBar) then
                                    if (not UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                            FocusFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                        else
                                            FocusFrameToTHealthBar:SetStatusBarColor(1, 0, 0)
                                        end
                                    end
                                    if (UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                            FocusFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                        else
                                            FocusFrameToTHealthBar:SetStatusBarColor(0, 1, 0)
                                        end
                                    end
                                end
                            end


                            if (EasyFramesDB.percentcolorfocus) then
                                if (statusbar == FocusFrameHealthBar) then
                                    FocusFrameHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == FocusFrameHealthBar) then
                                    if (not UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                            FocusFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                        else
                                            FocusFrameHealthBar:SetStatusBarColor(1, 0, 0)
                                        end
                                    end
                                    if (UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                            FocusFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                        else
                                            FocusFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                        end
                                    end
                                end
                            end


                            if (EasyFramesDB.percentcolortarget) then
                                if (statusbar == TargetFrameHealthBar) then
                                    TargetFrameHealthBar:SetStatusBarColor(r, g, b);
                                end
                            else
                                if (statusbar == TargetFrameHealthBar) then
                                    if (not UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                            TargetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                        else
                                            TargetFrameHealthBar:SetStatusBarColor(1, 0, 0)
                                        end
                                    end
                                    if (UnitIsFriend("player", unit)) then
                                        if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                            TargetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                        else
                                            TargetFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            hooksecurefunc("UnitFrameHealthBar_Update", colour)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                colour(self, self.unit)
            end)
        else --no classcolored

            local function colourx(statusbar, unit)
                if (unit ~= mouseover) then
                    local value = UnitHealth(unit);
                    local min, max = statusbar:GetMinMaxValues();

                    local r, g, b;

                    if ((value < min) or (value > max)) then
                        return;
                    end
                    if ((max - min) > 0) then
                        value = (value - min) / (max - min);
                    else
                        value = 0;
                    end
                    if (value > 0.5) then
                        r = (1.0 - value) * 2;
                        g = 1.0;
                    else
                        r = 1.0;
                        g = value * 2;
                    end
                    b = 0.0;

                    if (UnitIsConnected(unit) and unit == statusbar.unit) then
                        if (EasyFramesDB.percentcolorplayer) then
                            PlayerPercentcolorcheck:SetChecked(true);
                            if (statusbar == PlayerFrameHealthBar) then
                                PlayerFrameHealthBar:SetStatusBarColor(r, g, b);
                            end
                        else
                            if (statusbar == PlayerFrameHealthBar) then
                                if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                    PlayerFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                else
                                    PlayerFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                end
                            end
                        end



                        if (EasyFramesDB.percentcolortargettot) then

                            if (statusbar == TargetFrameToTHealthBar) then
                                TargetFrameToTHealthBar:SetStatusBarColor(r, g, b);
                            end
                        else
                            if (statusbar == TargetFrameToTHealthBar) then
                                if (not UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                        TargetFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                    else
                                        TargetFrameToTHealthBar:SetStatusBarColor(1, 0, 0)
                                    end
                                end
                                if (UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                        TargetFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                    else
                                        TargetFrameToTHealthBar:SetStatusBarColor(0, 1, 0)
                                    end
                                end
                            end
                        end



                        if (EasyFramesDB.percentcolorfocustot) then

                            if (statusbar == FocusFrameToTHealthBar) then
                                FocusFrameToTHealthBar:SetStatusBarColor(r, g, b);
                            end
                        else
                            if (statusbar == FocusFrameToTHealthBar) then
                                if (not UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                        FocusFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                    else
                                        FocusFrameToTHealthBar:SetStatusBarColor(1, 0, 0)
                                    end
                                end
                                if (UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                        FocusFrameToTHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                    else
                                        FocusFrameToTHealthBar:SetStatusBarColor(0, 1, 0)
                                    end
                                end
                            end
                        end


                        if (EasyFramesDB.percentcolorfocus) then

                            if (statusbar == FocusFrameHealthBar) then
                                FocusFrameHealthBar:SetStatusBarColor(r, g, b);
                            end
                        else
                            if (statusbar == FocusFrameHealthBar) then
                                if (not UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                        FocusFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                    else
                                        FocusFrameHealthBar:SetStatusBarColor(1, 0, 0)
                                    end
                                end
                                if (UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                        FocusFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                    else
                                        FocusFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                    end
                                end
                            end
                        end



                        if (EasyFramesDB.percentcolortarget) then
                            if (statusbar == TargetFrameHealthBar) then
                                TargetFrameHealthBar:SetStatusBarColor(r, g, b);
                            end
                        else
                            if (statusbar == TargetFrameHealthBar) then
                                if (not UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                        TargetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                    else
                                        TargetFrameHealthBar:SetStatusBarColor(1, 0, 0)
                                    end
                                end
                                if (UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                        TargetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                    else
                                        TargetFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                    end
                                end
                            end
                        end


                        if (EasyFramesDB.percentcolorpet) then

                            if (statusbar == PetFrameHealthBar) then
                                PetFrameHealthBar:SetStatusBarColor(r, g, b);
                            end
                        else
                            if (statusbar == PetFrameHealthBar) then
                                if (not UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickfriendr and EasyFramesDB.colorpickfriendg and EasyFramesDB.colorpickfriendb) then
                                        PetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickfriendr, EasyFramesDB.colorpickfriendg, EasyFramesDB.colorpickfriendb)
                                    else
                                        PetFrameHealthBar:SetStatusBarColor(1, 0, 0)
                                    end
                                end
                                if (UnitIsFriend("player", unit)) then
                                    if (EasyFramesDB.colorpickenemyr and EasyFramesDB.colorpickenemyg and EasyFramesDB.colorpickenemyb) then
                                        PetFrameHealthBar:SetStatusBarColor(EasyFramesDB.colorpickenemyr, EasyFramesDB.colorpickenemyg, EasyFramesDB.colorpickenemyb)
                                    else
                                        PetFrameHealthBar:SetStatusBarColor(0, 1, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            end




            hooksecurefunc("UnitFrameHealthBar_Update", colourx)
            hooksecurefunc("HealthBar_OnValueChanged", function(self)
                colourx(self, self.unit)
            end)
        end



        if (EasyFramesDB.playername) then
            PlayerName:Show()
            playernamecheck:SetChecked(true)
        else
            PlayerName:Hide()
        end

        if (EasyFramesDB.petname) then
            PetName:Show()
            petnamecheck:SetChecked(true)
        else
            PetName:Hide()
        end
        if (EasyFramesDB.targetoftarget) then
            TargetFrameToT:SetAlpha(100)
            targettotcheck:SetChecked(true)
        end

        if (EasyFramesDB.targetoffocus) then
            FocusFrameToT:SetAlpha(100)
            focustotcheck:SetChecked(true)
        end
        if (EasyFramesDB.playerspecialbar) then
            specialbarcheck:SetChecked(true)
        else
            local nooop = function() return end
            for _, objname in ipairs({
                "MonkHarmonyBar",
                "PriestBarFrame",
                "PaladinPowerBar",
                "ShardBarFrame",
            }) do
                local obj = _G[objname]
                if obj then
                    obj:Hide()
                    obj.Show = nooop
                end
            end
        end

        if (EasyFramesDB.classportraits) then
            Portraitcheck:SetChecked(true)
            hooksecurefunc("UnitFramePortrait_Update", function(self)
                if self.portrait then
                    if UnitIsPlayer(self.unit) then
                        local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
                        if t then
                            self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                            self.portrait:SetTexCoord(unpack(t))
                        end
                    else
                        self.portrait:SetTexCoord(0, 1, 0, 1)
                    end
                end
            end)
        else
        end

        if (EasyFramesDB.playerhitindi) then
            playerhitindi:SetChecked(true)
            PlayerHitIndicator:SetText(nil)
            PlayerHitIndicator.SetText = function() end
        end
        if (EasyFramesDB.pethitindi) then
            pethitindi:SetChecked(true)
            PetHitIndicator:SetText(nil)
            PetHitIndicator.SetText = function() end
        end


        if (EasyFramesDB.bartex == 1) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
        end
        if (EasyFramesDB.bartex == 2) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
        end
        if (EasyFramesDB.bartex == 3) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
        end
        if (EasyFramesDB.bartex == 4) then
        end
        if (EasyFramesDB.bartex == 5) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
        end
        if (EasyFramesDB.bartex == 6) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
        end
        if (EasyFramesDB.bartex == 7) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
        end
        if (EasyFramesDB.bartex == 8) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
        end
        if (EasyFramesDB.bartex == 9) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
        end
        if (EasyFramesDB.bartex == 10) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
        end
        if (EasyFramesDB.bartex == 11) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
        end
        if (EasyFramesDB.bartex == 12) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
        end
        if (EasyFramesDB.bartex == 13) then
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
        end


        if (EasyFramesDB.phformat == 1) then --percent
            local Player = "Player"
            function UpdateHealthValues(...)
                if (0 < UnitHealth(Player)) then
                    local Health = UnitHealth(Player)
                    local HealthMax = UnitHealthMax(Player)
                    local HealthPercent = (UnitHealth(Player) / UnitHealthMax(Player)) * 100
                    _G[Player .. "FrameHealthBar"].TextString:SetText(format("%.0f", HealthPercent) .. "%")
                end
            end

            hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", UpdateHealthValues)
        end
        if (EasyFramesDB.fhformat == 1) then --percent
            local Focus = "Focus"
            function UpdateHealthValues(...)
                if (0 < UnitHealth(Focus)) then
                    local Health = UnitHealth(Focus)
                    local HealthMax = UnitHealthMax(Focus)
                    local HealthPercent = (UnitHealth(Focus) / UnitHealthMax(Focus)) * 100
                    _G[Focus .. "FrameHealthBar"].TextString:SetText(format("%.0f", HealthPercent) .. "%")
                end
            end

            hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", UpdateHealthValues)
        end
        if (EasyFramesDB.thformat == 1) then --percent
            local Target = "Target"
            function UpdateHealthValues(...)
                if (0 < UnitHealth(Target)) then
                    local Health = UnitHealth(Target)
                    local HealthMax = UnitHealthMax(Target)
                    local HealthPercent = (UnitHealth(Target) / UnitHealthMax(Target)) * 100
                    _G[Target .. "FrameHealthBar"].TextString:SetText(format("%.0f", HealthPercent) .. "%")
                end
            end

            hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", UpdateHealthValues)
        end


        if (EasyFramesDB.phformat == 3) then --current health+maxhealth+percent
            local Player = "Player"
            function UpdateHealthValues(...)
                if (UnitHealth(Player) > 0) then
                    local Health = UnitHealth(Player)
                    local HealthMax = UnitHealthMax(Player)
                    local HealthPercent = (UnitHealth(Player) / UnitHealthMax(Player)) * 100

                    _G[Player .. "FrameHealthBar"].TextString:SetText(ReadableNumber(Health) .. " / " .. ReadableNumber(HealthMax) .. " (" .. string.format("%.0f", HealthPercent) .. "%)");
                end
            end

            hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", UpdateHealthValues)
        end


        if (EasyFramesDB.thformat == 3) then --current health+maxhealth+percent
            local Target = "Target"
            function UpdateHealthValues(...)
                if (UnitHealth(Target) > 0) then
                    local Health = UnitHealth(Target)
                    local HealthMax = UnitHealthMax(Target)
                    local HealthPercent = (UnitHealth(Target) / UnitHealthMax(Target)) * 100

                    _G[Target .. "FrameHealthBar"].TextString:SetText(ReadableNumber(Health) .. " / " .. ReadableNumber(HealthMax) .. " (" .. string.format("%.0f", HealthPercent) .. "%)");
                end
            end

            hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", UpdateHealthValues)
        end


        if (EasyFramesDB.fhformat == 3) then --current health+maxhealth+percent
            local Focus = "Focus"
            function UpdateHealthValues(...)
                if (UnitHealth(Focus) > 0) then
                    local Health = UnitHealth(Focus)
                    local HealthMax = UnitHealthMax(Focus)
                    local HealthPercent = (UnitHealth(Focus) / UnitHealthMax(Focus)) * 100

                    _G[Focus .. "FrameHealthBar"].TextString:SetText(ReadableNumber(Health) .. " / " .. ReadableNumber(HealthMax) .. " (" .. string.format("%.0f", HealthPercent) .. "%)");
                end
            end

            hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", UpdateHealthValues)
        end


        if (EasyFramesDB.buffsizebutton) then
            buffsizebutton:SetChecked(true)
            buffsizer:Show()
        else
            buffsizer:Hide()
        end

        hooksecurefunc("TargetFrame_UpdateAuraPositions", function(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth)
            if (EasyFramesDB.buffsizebutton) then
                local AURA_OFFSET = 2
                local LARGE_AURA_SIZE = EasyFramesDB.buffsize * EasyFramesDB.scaleselfbuffsize
                local SMALL_AURA_SIZE = EasyFramesDB.buffsize
                local size
                local offsetY = AURA_OFFSET
                local offsetX = AURA_OFFSET
                local rowWidth = 0
                local firstBuffOnRow = 1
                for i = 1, numAuras do
                    if (largeAuraList[i]) then
                        size = LARGE_AURA_SIZE
                        --offsetY = AURA_OFFSET + AURA_OFFSET
                        --offsetX = AURA_OFFSET + AURA_OFFSET
                    else
                        size = SMALL_AURA_SIZE
                    end
                    if (i == 1) then
                        rowWidth = size
                        self.auraRows = self.auraRows + 1
                    else
                        rowWidth = rowWidth + size + offsetX
                    end
                    if (rowWidth > maxRowWidth) then
                        updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY)
                        rowWidth = size
                        self.auraRows = self.auraRows + 1
                        firstBuffOnRow = i
                        offsetY = AURA_OFFSET
                    else
                        updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY)
                    end
                end
            end
        end)

        hooksecurefunc('TargetFrame_UpdateAuras', function(self)
            if (EasyFramesDB.buffsizebutton) then
                local frameStealable
                local frameName
                local icon
                local debuffType
                local selfName = self:GetName()
                local isEnemy = UnitIsEnemy(PlayerFrame.unit, self.unit)
                for i = 1, MAX_TARGET_BUFFS do
                    _, _, icon, _, debuffType = UnitBuff(self.unit, i)
                    frameName = selfName .. 'Buff' .. i
                    if (icon and (not self.maxBuffs or i <= self.maxBuffs)) then
                        frameStealable = _G[frameName .. 'Stealable']
                        if (isEnemy and debuffType == 'Magic') then
                            -- возможно здесь и есть диспельные бафы
                            frameStealable:Show()
                            frameStealable:SetHeight(EasyFramesDB.buffsize * EasyFramesDB.scaleselfbuffsize)
                            frameStealable:SetWidth(EasyFramesDB.buffsize * EasyFramesDB.scaleselfbuffsize)
                        else
                            frameStealable:Hide()
                        end
                    end
                end
            end
        end)
    end
end

-- create addon frame
local unserFrame = CreateFrame("Frame", "unserFrameAddon", UIParent)
unserFrame:SetScript("OnEvent", unserAddon.Init)
unserFrame:RegisterEvent("ADDON_LOADED")




-----------------------------
--- ##GUI FUNCTIONS##---------
-----------------------------
-- CreateGUI
function unserAddon:CreateGUI(frame)
    -- GUIGeneralFrame
    local title = unserAddon:CreateFont(GUIGeneralFrame, "title", "General Frame Scale", 20, -15, 15)

    local generalframescaleslider = unserAddon:CreateSlider(GUIGeneralFrame, "GeneralFrameScale", "General Frame Scale", 0.5, 2, EasyFramesDB.framescaleplayer, 60, -70)
    generalframescaleslider:SetScript("OnValueChanged", function(self, value)
        TargetFrame:SetScale(value)
        PlayerFrame:SetScale(value)
        FocusFrame:SetScale(value)
        EasyFramesDB.framescaletarget = value
        EasyFramesDB.framescaleplayer = value
        EasyFramesDB.framescalefocus = value
        getglobal(generalframescaleslider:GetName() .. 'Text'):SetText("Frame Scale: (" .. format("%.2f", value) .. ")");
    end)

    local title = unserAddon:CreateFont(GUIGeneralFrame, "title", "Classcolored Healthbars", 20, -320)

    local button = CreateFrame("CheckButton", "classcolorcheck", GUIGeneralFrame, "UICheckButtonTemplate")
    button.tooltip = 'some tooltip'
    button:ClearAllPoints()
    button:SetPoint("CENTER", -280, -80)
    _G[button:GetName() .. "Text"]:SetText("Classcolored Healthbars")
    function button:OnClick()
        EasyFramesDB.classcolor = button:GetChecked();
        ReloadUI();
    end

    button:SetScript("OnClick", button.OnClick)



    -- TargetFrame Settings
    local title = unserAddon:CreateFont(GUITargetFrame, "title", "Target Frame Scale", 20, -15, 16)


    --targetframescaleslider
    local targetscaleslider = unserAddon:CreateSlider(GUITargetFrame, "TargetScale", "TargetFrame Scale", 0.5, 2, EasyFramesDB.framescaletarget, 60, -70)
    targetscaleslider:SetScript("OnValueChanged", function(self, value)
        TargetFrame:SetScale(value)
        EasyFramesDB.framescaletarget = value
        getglobal(targetscaleslider:GetName() .. 'Text'):SetText("Target Frame Scale: (" .. format("%.2f", value) .. ")");
    end)

    local title = unserAddon:CreateFont(GUITargetFrame, "title", "Classcolored Target Healtbar", 20, -125)


    --targetclasscolorcheck
    local TargetClasscolorcheck = CreateFrame("CheckButton", "targetclasscolorcheck", GUITargetFrame, "UICheckButtonTemplate")
    TargetClasscolorcheck:ClearAllPoints()
    TargetClasscolorcheck:SetPoint("CENTER", -280, 105)
    _G[TargetClasscolorcheck:GetName() .. "Text"]:SetText("Classcolored Target Healthbar")
    function TargetClasscolorcheck:OnClick()
        EasyFramesDB.classcolortarget = TargetClasscolorcheck:GetChecked();
        ReloadUI();
    end

    TargetClasscolorcheck:SetScript("OnClick", TargetClasscolorcheck.OnClick)



    --FocusFrameSettings

    local title = unserAddon:CreateFont(GUIFocusFrame, "title", "Focus Frame Scale", 20, -15, 18)

    --focusframescaleslider
    local targetscaleslider2 = unserAddon:CreateSlider(GUIFocusFrame, "Target2Scale", "FocusFrame Scale", 0.5, 2, EasyFramesDB.framescalefocus, 60, -70)
    targetscaleslider2:SetScript("OnValueChanged", function(self, value)
        FocusFrame:SetScale(value)
        EasyFramesDB.framescalefocus = value
        getglobal(targetscaleslider2:GetName() .. 'Text'):SetText("Focus Frame ScaleFrame Scale: (" .. format("%.2f", value) .. ")");
    end)


    local title = unserAddon:CreateFont(GUIFocusFrame, "title", "Classcolored Focus Healtbar", 20, -125)


    --focustclasscolorcheck
    local FocusClasscolorcheck = CreateFrame("CheckButton", "focusclasscolorcheck", GUIFocusFrame, "UICheckButtonTemplate")
    FocusClasscolorcheck:ClearAllPoints()
    FocusClasscolorcheck:SetPoint("CENTER", -280, 105)
    _G[FocusClasscolorcheck:GetName() .. "Text"]:SetText("Classcolored Focus Healthbar")
    function FocusClasscolorcheck:OnClick()
        EasyFramesDB.classcolorFocus = FocusClasscolorcheck:GetChecked();
        ReloadUI();
    end

    FocusClasscolorcheck:SetScript("OnClick", FocusClasscolorcheck.OnClick)



    --Random Settings
    local title = unserAddon:CreateFont(GUIPlayerFrame, "title", "Show Player Name", 20, -15)
    local Unlock2 = CreateFrame("CheckButton", "playernamecheck", GUIPlayerFrame, "UICheckButtonTemplate")
    Unlock2:ClearAllPoints()
    Unlock2:SetPoint("CENTER", -280, 225)
    _G[Unlock2:GetName() .. "Text"]:SetText("Show Player Name")
    function Unlock2:OnClick()
        EasyFramesDB.playername = Unlock2:GetChecked();
        if (EasyFramesDB.playername) then
            PlayerName:Show()
            --            playernamecheck:SetChecked(true)
        else
            PlayerName:Hide()
        end
    end

    Unlock2:SetScript("OnClick", Unlock2.OnClick)

    --Random Settings
    local title = unserAddon:CreateFont(GUIPetFrame, "title", "Show Pet Name", 20, -15)
    local Unlock3 = CreateFrame("CheckButton", "petnamecheck", GUIPetFrame, "UICheckButtonTemplate")
    Unlock3:ClearAllPoints()
    Unlock3:SetPoint("CENTER", -280, 225)
    _G[Unlock3:GetName() .. "Text"]:SetText("Show Pet Name")
    function Unlock3:OnClick()
        EasyFramesDB.petname = Unlock3:GetChecked();
        if (EasyFramesDB.petname) then
            PetName:Show()
            --            petnamecheck:SetChecked(true)
        else
            PetName:Hide()
        end
    end

    Unlock3:SetScript("OnClick", Unlock3.OnClick)




    --playerclasscolorcheck
    local title = unserAddon:CreateFont(GUIPlayerFrame, "title", "Classcolored Player Healthbar", 20, -115)
    local PlayerClasscolorcheck = CreateFrame("CheckButton", "PlayerClasscolorcheck", GUIPlayerFrame, "UICheckButtonTemplate")
    PlayerClasscolorcheck:ClearAllPoints()
    PlayerClasscolorcheck:SetPoint("CENTER", -280, 115)
    _G[PlayerClasscolorcheck:GetName() .. "Text"]:SetText("Classcolored Player Healthbar")
    function PlayerClasscolorcheck:OnClick()
        EasyFramesDB.classcolorplayer = PlayerClasscolorcheck:GetChecked();
        ReloadUI();
    end

    PlayerClasscolorcheck:SetScript("OnClick", PlayerClasscolorcheck.OnClick)


    --playerpercentcolor
    local title = unserAddon:CreateFont(GUIPlayerFrame, "title", "Player Healthbarcolor based on current Health", 20, -215)
    local PlayerPercentcolorcheck = CreateFrame("CheckButton", "PlayerPercentcolorcheck", GUIPlayerFrame, "UICheckButtonTemplate")
    PlayerPercentcolorcheck:ClearAllPoints()
    PlayerPercentcolorcheck:SetPoint("CENTER", -280, 25)
    _G[PlayerPercentcolorcheck:GetName() .. "Text"]:SetText("Player Healthbarcolor based on current Health")
    function PlayerPercentcolorcheck:OnClick()
        EasyFramesDB.percentcolorplayer = PlayerPercentcolorcheck:GetChecked();
        ReloadUI();
    end

    PlayerPercentcolorcheck:SetScript("OnClick", PlayerPercentcolorcheck.OnClick)

    --petpercentcolor
    local title = unserAddon:CreateFont(GUIPetFrame, "title", "Pet Healthbarcolor based on current Health", 20, -215)
    local PetPercentcolorcheck = CreateFrame("CheckButton", "PetPercentcolorcheck", GUIPetFrame, "UICheckButtonTemplate")
    PetPercentcolorcheck:ClearAllPoints()
    PetPercentcolorcheck:SetPoint("CENTER", -280, 25)
    _G[PetPercentcolorcheck:GetName() .. "Text"]:SetText("Pet Healthbarcolor based on current Health")
    function PetPercentcolorcheck:OnClick()
        EasyFramesDB.percentcolorpet = PetPercentcolorcheck:GetChecked();
        ReloadUI();
    end

    PetPercentcolorcheck:SetScript("OnClick", PetPercentcolorcheck.OnClick)


    --targetpercentcolor
    local title = unserAddon:CreateFont(GUITargetFrame, "title", "Target Healthbarcolor based on current Health", 20, -215)
    local TargetPercentcolorcheck = CreateFrame("CheckButton", "TargetPercentcolorcheck", GUITargetFrame, "UICheckButtonTemplate")
    TargetPercentcolorcheck:ClearAllPoints()
    TargetPercentcolorcheck:SetPoint("CENTER", -280, 25)
    _G[TargetPercentcolorcheck:GetName() .. "Text"]:SetText("Target Healthbarcolor based on current Health")
    function TargetPercentcolorcheck:OnClick()
        EasyFramesDB.percentcolortarget = TargetPercentcolorcheck:GetChecked();
        ReloadUI();
    end

    TargetPercentcolorcheck:SetScript("OnClick", TargetPercentcolorcheck.OnClick)

    --targetTOTpercentcolor

    local TargetToTPercentcolorcheck = CreateFrame("CheckButton", "TargetToTPercentcolorcheck", GUITargetFrame, "UICheckButtonTemplate")
    TargetToTPercentcolorcheck:ClearAllPoints()
    TargetToTPercentcolorcheck:SetPoint("CENTER", 0, 25)
    _G[TargetToTPercentcolorcheck:GetName() .. "Text"]:SetText("Target of Target Healthbarcolor based on current Health")
    function TargetToTPercentcolorcheck:OnClick()
        EasyFramesDB.percentcolortargettot = TargetToTPercentcolorcheck:GetChecked();
        ReloadUI();
    end

    TargetToTPercentcolorcheck:SetScript("OnClick", TargetToTPercentcolorcheck.OnClick)


    --focuspercentcolor
    local title = unserAddon:CreateFont(GUIFocusFrame, "title", "Focus Healthbarcolor based on current Health", 20, -215)
    local FocusPercentcolorcheck = CreateFrame("CheckButton", "FocusPercentcolorcheck", GUIFocusFrame, "UICheckButtonTemplate")
    FocusPercentcolorcheck:ClearAllPoints()
    FocusPercentcolorcheck:SetPoint("CENTER", -280, 25)
    _G[FocusPercentcolorcheck:GetName() .. "Text"]:SetText("Focus Healthbarcolor based on current Health")
    function FocusPercentcolorcheck:OnClick()
        EasyFramesDB.percentcolorfocus = FocusPercentcolorcheck:GetChecked();
        ReloadUI();
    end

    FocusPercentcolorcheck:SetScript("OnClick", FocusPercentcolorcheck.OnClick)

    --focusTOTpercentcolor

    local FocusToTPercentcolorcheck = CreateFrame("CheckButton", "FocusToTPercentcolorcheck", GUIFocusFrame, "UICheckButtonTemplate")
    FocusToTPercentcolorcheck:ClearAllPoints()
    FocusToTPercentcolorcheck:SetPoint("CENTER", 0, 25)
    _G[FocusToTPercentcolorcheck:GetName() .. "Text"]:SetText("Target of Focus Healthbarcolor based on current Health")
    function FocusToTPercentcolorcheck:OnClick()
        EasyFramesDB.percentcolorfocustot = FocusToTPercentcolorcheck:GetChecked();
        ReloadUI();
    end

    FocusToTPercentcolorcheck:SetScript("OnClick", FocusToTPercentcolorcheck.OnClick)




    --ToT=?
    local title = unserAddon:CreateFont(GUITargetFrame, "title", "Show Target of Target Frame", 260, -15)
    local Unlock3 = CreateFrame("CheckButton", "targettotcheck", GUITargetFrame, "UICheckButtonTemplate")
    Unlock3:ClearAllPoints()
    Unlock3:SetPoint("CENTER", 10, 210)
    _G[Unlock3:GetName() .. "Text"]:SetText("Show Target of Target Frame")
    function Unlock3:OnClick()
        EasyFramesDB.targetoftarget = Unlock3:GetChecked();
        if (EasyFramesDB.targetoftarget) then
            TargetFrameToT:SetAlpha(100)
            --            targettotcheck:SetChecked(true)
        else
            TargetFrameToT:SetAlpha(0)
        end
    end

    Unlock3:SetScript("OnClick", Unlock3.OnClick)


    --FocusTot
    local title = unserAddon:CreateFont(GUIFocusFrame, "title", "Show Target of Focus Frame", 260, -15)
    local Unlock4 = CreateFrame("CheckButton", "focustotcheck", GUIFocusFrame, "UICheckButtonTemplate")
    Unlock4:ClearAllPoints()
    Unlock4:SetPoint("CENTER", 10, 210)
    _G[Unlock4:GetName() .. "Text"]:SetText("Show Target of Focus Frame")
    function Unlock4:OnClick()
        EasyFramesDB.targetoffocus = Unlock4:GetChecked();
        if (EasyFramesDB.targetoffocus) then
            FocusFrameToT:SetAlpha(100)
            --            focustotcheck:SetChecked(true)
        else
            FocusFrameToT:SetAlpha(0)
        end
    end

    Unlock4:SetScript("OnClick", Unlock4.OnClick)


    --targettot classcolor
    local TtotClasscolorcheck = CreateFrame("CheckButton", "Ttotclasscolorcheck", GUITargetFrame, "UICheckButtonTemplate")
    TtotClasscolorcheck:ClearAllPoints()
    TtotClasscolorcheck:SetPoint("CENTER", -80, 105)
    _G[TtotClasscolorcheck:GetName() .. "Text"]:SetText("Classcolored Target of Target Healthbar")
    function TtotClasscolorcheck:OnClick()
        EasyFramesDB.classcolorttot = TtotClasscolorcheck:GetChecked();
        ReloadUI();
    end

    TtotClasscolorcheck:SetScript("OnClick", TtotClasscolorcheck.OnClick)


    --focustot classcolor
    local FtotClasscolorcheck = CreateFrame("CheckButton", "Ftotclasscolorcheck", GUIFocusFrame, "UICheckButtonTemplate")
    FtotClasscolorcheck:ClearAllPoints()
    FtotClasscolorcheck:SetPoint("CENTER", -80, 105)
    _G[FtotClasscolorcheck:GetName() .. "Text"]:SetText("Classcolored Target of Focus Healthbar")
    function FtotClasscolorcheck:OnClick()
        EasyFramesDB.classcolorftot = FtotClasscolorcheck:GetChecked();
        ReloadUI();
    end

    FtotClasscolorcheck:SetScript("OnClick", FtotClasscolorcheck.OnClick)



    --harmonybar etc
    local title = unserAddon:CreateFont(GUIPlayerFrame, "title", "Show Player SpecialBar", 20, -290)
    local Unlock7 = CreateFrame("CheckButton", "specialbarcheck", GUIPlayerFrame, "UICheckButtonTemplate")
    Unlock7:ClearAllPoints()
    Unlock7:SetPoint("CENTER", -280, -50)
    _G[Unlock7:GetName() .. "Text"]:SetText("Show Player SpecialBar")
    function Unlock7:OnClick()
        EasyFramesDB.playerspecialbar = Unlock7:GetChecked();
        if (EasyFramesDB.playerspecialbar) then
            --            specialbarcheck:SetChecked(true)
            ReloadUI()
        else
            local nooop = function() return end
            for _, objname in ipairs({
                "MonkHarmonyBar",
                "PriestBarFrame",
                "PaladinPowerBar",
                "ShardBarFrame",
            }) do
                local obj = _G[objname]
                if obj then
                    obj:Hide()
                    obj.Show = nooop
                end
            end
        end
    end

    Unlock7:SetScript("OnClick", Unlock7.OnClick)


    --hitindicator

    local title = unserAddon:CreateFont(GUIPlayerFrame, "title", "PlayerFrame HitIndicators", 360, -15)
    local playerhitindi = CreateFrame("CheckButton", "playerhitindi", GUIPlayerFrame, "UICheckButtonTemplate")
    playerhitindi:ClearAllPoints()
    playerhitindi:SetPoint("CENTER", 60, 225)
    _G[playerhitindi:GetName() .. "Text"]:SetText("Hide Player Hitindicator")
    function playerhitindi:OnClick()
        EasyFramesDB.playerhitindi = playerhitindi:GetChecked();
        ReloadUI();
    end

    playerhitindi:SetScript("OnClick", playerhitindi.OnClick)

    --pethitindicator

    local title = unserAddon:CreateFont(GUIPetFrame, "title", "PetFrame HitIndicators", 360, -15)
    local pethitindi = CreateFrame("CheckButton", "pethitindi", GUIPetFrame, "UICheckButtonTemplate")
    pethitindi:ClearAllPoints()
    pethitindi:SetPoint("CENTER", 60, 225)
    _G[pethitindi:GetName() .. "Text"]:SetText("Hide Pet Hitindicator")
    function pethitindi:OnClick()
        EasyFramesDB.pethitindi = pethitindi:GetChecked();
        ReloadUI();
    end

    pethitindi:SetScript("OnClick", pethitindi.OnClick)



    --portraitclass
    local title = unserAddon:CreateFont(GUIGeneralFrame, "title", "Classportraits", 20, -380)
    local portraitcheck = CreateFrame("CheckButton", "Portraitcheck", GUIGeneralFrame, "UICheckButtonTemplate")
    portraitcheck:ClearAllPoints()
    portraitcheck:SetPoint("CENTER", -280, -130)
    _G[portraitcheck:GetName() .. "Text"]:SetText("Classicons instead of Portraits")
    function portraitcheck:OnClick()
        EasyFramesDB.classportraits = portraitcheck:GetChecked();
        ReloadUI();
    end

    portraitcheck:SetScript("OnClick", portraitcheck.OnClick)




    --bartexture
    local title = unserAddon:CreateFont(GUIGeneralFrame, "title", "Bar Texture Style", 345, -15)
    --dropdowntest
    if not DropDownMenuTest then
        CreateFrame("Frame", "DropDownMenuTest", GUIGeneralFrame, "UIDropDownMenuTemplate")
    end
    DropDownMenuTest:ClearAllPoints()
    DropDownMenuTest:SetPoint("CENTER", 150, 205)
    DropDownMenuTest:Show()

    local items = {
        "Ace", --1
        "Aluminium", --2
        "Banto", --3
        "Blizzard", --4
        "Charcoal", --5
        "Glaze", --6
        "LiteStep", --7
        "Minimalist", --8
        "Otravi", --9
        "Perl", --10
        "Smooth", --11
        "Striped", --12
        "Swag", --13
    }

    local function OnClick(self)
        UIDropDownMenu_SetSelectedID(DropDownMenuTest, self:GetID())
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 1) then
            EasyFramesDB.bartex = 1;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Ace");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 2) then
            EasyFramesDB.bartex = 2;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Aluminium");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 3) then
            EasyFramesDB.bartex = 3;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\banto");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 4) then
            EasyFramesDB.bartex = 4;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\blizzard");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 5) then
            EasyFramesDB.bartex = 5;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Charcoal");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 6) then
            EasyFramesDB.bartex = 6;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\glaze");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 7) then
            EasyFramesDB.bartex = 7;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\LiteStep");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 8) then
            EasyFramesDB.bartex = 8;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\Minimalist");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 9) then
            EasyFramesDB.bartex = 9;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\otravi");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 10) then
            EasyFramesDB.bartex = 10;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\perl");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 11) then
            EasyFramesDB.bartex = 11;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\smooth");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 12) then
            EasyFramesDB.bartex = 12;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\striped");
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest) == 13) then
            EasyFramesDB.bartex = 13;
            PlayerFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            PlayerFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            TargetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            TargetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            FocusFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            FocusFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            TargetFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            TargetFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            FocusFrameToTHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            FocusFrameToTManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            PetFrameManaBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
            PetFrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\EasyFrames\\Textures\\swag");
        end
    end


    local function initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for k, v in pairs(items) do
            info = UIDropDownMenu_CreateInfo()
            info.text = v
            info.value = v
            info.func = OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end

    --UIDropDownMenu_GetSelectedID(DropDownMenuTest)

    UIDropDownMenu_Initialize(DropDownMenuTest, initialize)
    UIDropDownMenu_SetWidth(DropDownMenuTest, 100);
    UIDropDownMenu_SetButtonWidth(DropDownMenuTest, 124)
    UIDropDownMenu_SetSelectedID(DropDownMenuTest, EasyFramesDB.bartex)
    UIDropDownMenu_JustifyText(DropDownMenuTest, "LEFT")





    --healthformat
    local title = unserAddon:CreateFont(GUIPlayerFrame, "title", "Player Healthbar Text Format", 295, -320)
    --healthformatdropdown
    if not DropDownMenuTest2 then
        CreateFrame("Frame", "DropDownMenuTest2", GUIPlayerFrame, "UIDropDownMenuTemplate")
    end
    DropDownMenuTest2:ClearAllPoints()
    DropDownMenuTest2:SetPoint("CENTER", 150, -100)
    DropDownMenuTest2:Show()

    local items2 = {
        "Percent", --1
        "Currenhealth + Maxhealth", --2
        "Currenhealth + Maxhealth + Percent", --3
    }

    local function OnClick(self)
        UIDropDownMenu_SetSelectedID(DropDownMenuTest2, self:GetID())
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest2) == 1) then
            EasyFramesDB.phformat = 1;
            ReloadUI()
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest2) == 2) then
            EasyFramesDB.phformat = 2;
            ReloadUI()
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest2) == 3) then
            EasyFramesDB.phformat = 3;
            ReloadUI()
        end
    end

    local function initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for k, v in pairs(items2) do
            info = UIDropDownMenu_CreateInfo()
            info.text = v
            info.value = v
            info.func = OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end

    --UIDropDownMenu_GetSelectedID(DropDownMenuTest)

    UIDropDownMenu_Initialize(DropDownMenuTest2, initialize)
    UIDropDownMenu_SetWidth(DropDownMenuTest2, 100);
    UIDropDownMenu_SetButtonWidth(DropDownMenuTest2, 124)
    UIDropDownMenu_SetSelectedID(DropDownMenuTest2, EasyFramesDB.phformat)
    UIDropDownMenu_JustifyText(DropDownMenuTest2, "LEFT")


    --healthformat
    local title = unserAddon:CreateFont(GUIFocusFrame, "title", "Focus Healthbar Text Format", 295, -320)
    --healthformatdropdown
    if not DropDownMenuTest3 then
        CreateFrame("Frame", "DropDownMenuTest3", GUIFocusFrame, "UIDropDownMenuTemplate")
    end
    DropDownMenuTest3:ClearAllPoints()
    DropDownMenuTest3:SetPoint("CENTER", 150, -100)
    DropDownMenuTest3:Show()
    local function OnClick(self)
        UIDropDownMenu_SetSelectedID(DropDownMenuTest3, self:GetID())
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest3) == 1) then
            EasyFramesDB.fhformat = 1;
            ReloadUI()
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest3) == 2) then
            EasyFramesDB.fhformat = 2;
            ReloadUI()
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest3) == 3) then
            EasyFramesDB.fhformat = 3;
            ReloadUI()
        end
    end

    local function initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for k, v in pairs(items2) do
            info = UIDropDownMenu_CreateInfo()
            info.text = v
            info.value = v
            info.func = OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end

    --UIDropDownMenu_GetSelectedID(DropDownMenuTest)

    UIDropDownMenu_Initialize(DropDownMenuTest3, initialize)
    UIDropDownMenu_SetWidth(DropDownMenuTest3, 100);
    UIDropDownMenu_SetButtonWidth(DropDownMenuTest3, 124)
    UIDropDownMenu_SetSelectedID(DropDownMenuTest3, EasyFramesDB.fhformat)
    UIDropDownMenu_JustifyText(DropDownMenuTest3, "LEFT")


    --healthformat
    local title = unserAddon:CreateFont(GUITargetFrame, "title", "Target Healthbar Text Format", 295, -320)
    --healthformatdropdown
    if not DropDownMenuTest4 then
        CreateFrame("Frame", "DropDownMenuTest4", GUITargetFrame, "UIDropDownMenuTemplate")
    end
    DropDownMenuTest4:ClearAllPoints()
    DropDownMenuTest4:SetPoint("CENTER", 150, -100)
    DropDownMenuTest4:Show()
    local function OnClick(self)
        UIDropDownMenu_SetSelectedID(DropDownMenuTest4, self:GetID())
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest4) == 1) then
            EasyFramesDB.thformat = 1;
            ReloadUI()
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest4) == 2) then
            EasyFramesDB.thformat = 2;
            ReloadUI()
        end
        if (UIDropDownMenu_GetSelectedID(DropDownMenuTest4) == 3) then
            EasyFramesDB.thformat = 3;
            ReloadUI()
        end
    end

    local function initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for k, v in pairs(items2) do
            info = UIDropDownMenu_CreateInfo()
            info.text = v
            info.value = v
            info.func = OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end

    --UIDropDownMenu_GetSelectedID(DropDownMenuTest)

    UIDropDownMenu_Initialize(DropDownMenuTest4, initialize)
    UIDropDownMenu_SetWidth(DropDownMenuTest4, 100);
    UIDropDownMenu_SetButtonWidth(DropDownMenuTest4, 124)
    UIDropDownMenu_SetSelectedID(DropDownMenuTest4, EasyFramesDB.thformat)
    UIDropDownMenu_JustifyText(DropDownMenuTest4, "LEFT")


    local test123
    if (EasyFramesDB.darkentextures) then test123 = EasyFramesDB.darkentextures else test123 = 1 end


    --darkenslider
    local title = unserAddon:CreateFont(GUIGeneralFrame, "title", "Darken Frame Textures", 20, -105)

    local darkenslider = unserAddon:CreateSliderx(GUIGeneralFrame, "darkvalue", "Darken Frame Textures", 0, 1, test123, 60, -155)
    darkenslider:SetScript("OnValueChanged", function(self, value)
        for i, v in pairs({
            PlayerFrameTexture, TargetFrameTextureFrameTexture, PetFrameTexture, FocusFrameTextureFrameTexture,
            TargetFrameToTTextureFrameTexture, FocusFrameToTTextureFrameTexture
        }) do
            v:SetVertexColor(value, value, value)
        end
        EasyFramesDB.darkentextures = value
        getglobal(darkenslider:GetName() .. 'Text'):SetText("Darken Value");
    end)




    --colorpicker

    function ShowColorPicker(r, g, b, changedCallback)
        ColorPickerFrame:SetColorRGB(r, g, b);
        ColorPickerFrame.hasOpacity = false
        ColorPickerFrame.previousValues = { r, g, b };
        ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc =
        changedCallback, changedCallback, changedCallback;
        ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
        ColorPickerFrame:Show();
    end

    local r, g, b = 1, 1, 1

    local function myColorCallback(restore)
        local newR, newG, newB
        if restore then
            -- The user bailed, we extract the old color from the table created by ShowColorPicker.
            newR, newG, newB = unpack(restore);
        else
            -- Something changed
            newR, newG, newB = ColorPickerFrame:GetColorRGB();
        end

        -- Update our internal storage.
        r, g, b = newR, newG, newB

        EasyFramesDB.colorpickfriendr = r
        EasyFramesDB.colorpickfriendg = g
        EasyFramesDB.colorpickfriendb = b


        -- And update any UI elements that use this color...
    end

    local function myColorCallbackx(restore)
        local newR, newG, newB
        if restore then
            -- The user bailed, we extract the old color from the table created by ShowColorPicker.
            newR, newG, newB = unpack(restore);
        else
            -- Something changed
            newR, newG, newB = ColorPickerFrame:GetColorRGB();
        end

        -- Update our internal storage.
        r, g, b = newR, newG, newB

        EasyFramesDB.colorpickenemyr = r
        EasyFramesDB.colorpickenemyg = g
        EasyFramesDB.colorpickenemyb = b


        -- And update any UI elements that use this color...
    end

    --friendcolor
    local title = unserAddon:CreateFont(GUIGeneralFrame, "title", "Default Friendly Healthbarcolor", 335, -200)
    local colorpick = unserAddon:CreateButton(GUIGeneralFrame, "colorpick", "Set color F", 80, 35, 335, -230)
    colorpick:SetScript("OnClick", function(self)
        ShowColorPicker(r, g, b, myColorCallback);
    end)

    local colorpick = unserAddon:CreateButton(GUIGeneralFrame, "dfhreset", "Reset color", 80, 35, 435, -230)
    colorpick:SetScript("OnClick", function(self)
        myColorCallback({ 0, 1, 0 });
    end)

    --enemycolor
    local title = unserAddon:CreateFont(GUIGeneralFrame, "title", "Default Enemy Healthbarcolor", 335, -300)
    local colorpick = unserAddon:CreateButton(GUIGeneralFrame, "colorpickx", "Set color E", 80, 35, 355, -330)
    colorpickx:SetScript("OnClick", function(self)
        ShowColorPicker(r, g, b, myColorCallbackx);
    end)

    local colorpick = unserAddon:CreateButton(GUIGeneralFrame, "dehreset", "Reset color", 80, 35, 435, -330)
    colorpick:SetScript("OnClick", function(self)
        myColorCallbackx({ 1, 0, 0 });
    end)




    local title = unserAddon:CreateFont(GUIGeneralFrame, "title", "Custom Target- and Focusbuffsize", 20, -200)
    local buffsizebutton = CreateFrame("CheckButton", "buffsizebutton", GUIGeneralFrame, "UICheckButtonTemplate")
    buffsizebutton:ClearAllPoints()
    buffsizebutton:SetPoint("CENTER", -280, 50)
    _G[buffsizebutton:GetName() .. "Text"]:SetText("Custom Buffsize")
    function buffsizebutton:OnClick()
        EasyFramesDB.buffsizebutton = buffsizebutton:GetChecked();
        if (EasyFramesDB.buffsizebutton) then
            buffsizer:Show()
            scaleselfbuffsizer:Show()
        else
            buffsizer:Hide()
            scaleselfbuffsizer:Hide()
        end
    end

    buffsizebutton:SetScript("OnClick", buffsizebutton.OnClick)



    local buffsizestart
    if (EasyFramesDB.buffsize) then buffsizestart = EasyFramesDB.buffsize else buffsizestart = 15 end

    local buffsizer = unserAddon:CreateSlidery(GUIGeneralFrame, "buffsizer", "Base buffsize", 10, 30, buffsizestart, 130, -235)
    buffsizer:SetScript("OnValueChanged", function(self, value)
        EasyFramesDB.buffsize = value
        getglobal(buffsizer:GetName() .. 'Text'):SetText("Base buffsize: (" .. format("%.2f", value) .. ")");
    end)


    -- Scale self buff size
    local scaleselfbuffsizestart
    if (EasyFramesDB.scaleselfbuffsize) then scaleselfbuffsizestart = EasyFramesDB.scaleselfbuffsize else scaleselfbuffsizestart = 1.4 end

    local scaleselfbuffsizer = unserAddon:CreateSliderz(GUIGeneralFrame, "scaleselfbuffsizer", "Scale self buffsize", 1, 2, scaleselfbuffsizestart, 130, -280)
    scaleselfbuffsizer:SetScript("OnValueChanged", function(self, value)
        EasyFramesDB.scaleselfbuffsize = value
        getglobal(scaleselfbuffsizer:GetName() .. 'Text'):SetText("Scale self buffsize: (" .. format("%.2f", value) .. ")");
    end)



    -- font greeting
    local title = unserAddon:CreateFont(EasyFrames.panel, "title", "|cff71C671EasyFrames", 50, -35, 25)
    local titlea = unserAddon:CreateFont(EasyFrames.panel, "titlea", "|cffbbbbbbby Ghettoboyy", 50, -65, 15)
end



-- CreateSlider
function unserAddon:CreateSlider(frame, name, text, slidermin, slidermax, slidervalue, x, y, template)
    if (template == nil) then
        template = "OptionsSliderTemplate"
    end

    local slider = CreateFrame("Slider", name, frame, template)
    slider:SetPoint("TOPLEFT", x, y)
    slider:SetMinMaxValues(slidermin, slidermax)
    slider:SetValue(slidervalue)

    getglobal(slider:GetName() .. 'Low'):SetText('0.5');
    getglobal(slider:GetName() .. 'High'):SetText('2');
    getglobal(slider:GetName() .. 'Text'):SetText("Frame Scale: (" .. format("%.2f", slidervalue) .. ")");
    return (slider)
end

-- createSlider2
function unserAddon:CreateSliderx(frame, name, text, slidermin, slidermax, slidervalue, x, y, template)
    if (template == nil)
    then template = "OptionsSliderTemplate"
    end

    local slider = CreateFrame("Slider", name, frame, template)
    slider:SetPoint("TOPLEFT", x, y)
    slider:SetMinMaxValues(slidermin, slidermax)
    slider:SetValue(slidervalue)

    getglobal(slider:GetName() .. 'Low'):SetText('Dark');
    getglobal(slider:GetName() .. 'High'):SetText('Bright');
    getglobal(slider:GetName() .. 'Text'):SetText("Darken Value");
    return (slider)
end

-- createSlider3
function unserAddon:CreateSlidery(frame, name, text, slidermin, slidermax, slidervalue, x, y, template)
    if (template == nil) then
        template = "OptionsSliderTemplate"
    end

    local slider = CreateFrame("Slider", name, frame, template)
    slider:SetPoint("TOPLEFT", x, y)
    slider:SetMinMaxValues(slidermin, slidermax)
    slider:SetValue(slidervalue)

    getglobal(slider:GetName() .. 'Low'):SetText(slidermin);
    getglobal(slider:GetName() .. 'High'):SetText(slidermax);
    getglobal(slider:GetName() .. 'Text'):SetText("Buffsize: (" .. format("%.2f", slidervalue) .. ")");
    return (slider)
end

-- createSlider4
function unserAddon:CreateSliderz(frame, name, text, slidermin, slidermax, slidervalue, x, y, template)
    if (template == nil) then
        template = "OptionsSliderTemplate"
    end

    local slider = CreateFrame("Slider", name, frame, template)
    slider:SetPoint("TOPLEFT", x, y)
    slider:SetMinMaxValues(slidermin, slidermax)
    slider:SetValue(slidervalue)

    getglobal(slider:GetName() .. 'Low'):SetText(slidermin);
    getglobal(slider:GetName() .. 'High'):SetText(slidermax);
    getglobal(slider:GetName() .. 'Text'):SetText("Self Buffsize Scale: (" .. format("%.2f", slidervalue) .. ")");
    return (slider)
end

-- CreateButton --
function unserAddon:CreateButton(frame, name, text, width, height, x, y, template)
    if (template == nil) then
        template = "OptionsButtonTemplate"
    end

    local button = CreateFrame("Button", name, frame, template)
    button:SetPoint("TOPLEFT", x, y) button:SetWidth(width)
    button:SetHeight(height)
    button:SetText(text)
    return (button)
end

-- CreateEditBox --
function unserAddon:CreateEditBox(frame, name, width, height, x, y)
    local editBox = CreateFrame("EditBox", name, frame, "InputBoxTemplate")
    editBox:SetPoint("TOPLEFT", x, y)
    editBox:SetWidth(width)
    editBox:SetHeight(height)
    editBox:SetAutoFocus(false)
    editBox:Show()
    return (editbox)
end

-- CreateFont --
function unserAddon:CreateFont(frame, name, text, x, y, size)
    if size == nil
    then size = 12
    end

    --    local fontString = frame:CreateFontString(name) fontString:SetPoint("TOPLEFT", x, y) fontString:SetFont("Fonts\\MORPHEUS.ttf", size, "") fontString:SetText(text)

    local fontString = frame:CreateFontString("ARTWORK")
    --    fontString.SetHeight(size)
    fontString:SetFontObject("GameFontNormal")
    fontString:SetPoint("TOPLEFT", x, y)
    fontString:SetText(text)

    -- the text for the header
    --    frame.headerText = frame:CreateFontString(nil,"ARTWORK","GameFontNormal")
    --    frame.headerText:SetPoint("LEFT",8,0)
    --    frame.headerText:SetText("This is headerText")
    --
    --    -- the text for the content
    --    frame.contentText = frame:CreateFontString(nil,"ARTWORK","GameFontHighlight")
    --    frame.contentText:SetPoint("LEFT",16,0) -- a little extra indent
    --    frame.contentText:SetText("This is contentText")

    return (fontString)
end

function unserAddon:Clear()
    editbox1:SetText("")
    editbox2:SetText("")
end

