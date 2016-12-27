local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Core"
local Core = EasyFrames:NewModule(MODULE_NAME, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local db

function Core:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Core:OnEnable()
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "EventHandler")
    self:RegisterEvent("PLAYER_FOCUS_CHANGED", "EventHandler")
--    self:RegisterEvent("UNIT_FACTION", "EventHandler")

    PlayerFrameTexture:SetTexture(Media:Fetch("frames", "default"))

    self:SecureHook("TargetFrame_CheckClassification", "CheckClassification")
    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateTextStringWithValues")

    self:HideFramesElements()

    self:MoveFramesNames()
    self:MoveToTFrames()
    self:MovePlayerFrameBars()
    self:MoveTargetFrameBars()
    self:MoveFocusFrameBars()
    self:MovePetFrameBars()

    self:SetFramesBarsFont()
    self:MovePlayerFramesBarsTextString()
    self:MoveTargetFramesBarsTextString()
    self:MoveFocusFramesBarsTextString()
    --    self:MovePetFramesBarsTextString()

    if (db.general.showWelcomeMessage) then
        print("|cff0cbd0cEasyFrames|cffffffff " .. L["loaded. Options:"] .. " |cff0cbd0c/ef")
    end
end


function Core:EventHandler()
    TargetFrameNameBackground:SetVertexColor(0, 0, 0, 0.0)
    TargetFrameNameBackground:SetHeight(18)
--    TargetFrameBackground:SetHeight(41)

    FocusFrameNameBackground:SetVertexColor(0, 0, 0, 0.0)
    FocusFrameNameBackground:SetHeight(18)
--    FocusFrameBackground:SetHeight(41)
end


function Core:CheckClassification(frame, forceNormalTexture)
    local classification = UnitClassification(frame.unit);

    frame.Background:SetHeight(41)

    --[[
    frame.nameBackground:Show();
    frame.manabar:Show();
    frame.manabar.TextString:Show();
    frame.threatIndicator:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash");
	]] --
    if (forceNormalTexture) then
        frame.borderTexture:SetTexture(Media:Fetch("frames", "default"));
    elseif (classification == "minus") then
        frame.borderTexture:SetTexture(Media:Fetch("frames", "minus"));
        frame.nameBackground:Hide();
        frame.Background:SetHeight(31)
        frame.manabar:Hide();
        frame.manabar.TextString:Hide();
        forceNormalTexture = true;
    elseif (classification == "worldboss" or classification == "elite") then
        frame.borderTexture:SetTexture(Media:Fetch("frames", "elite"));
    elseif (classification == "rareelite") then
        frame.borderTexture:SetTexture(Media:Fetch("frames", "rareelite"));
    elseif (classification == "rare") then
        frame.borderTexture:SetTexture(Media:Fetch("frames", "rare"));
    else
        frame.borderTexture:SetTexture(Media:Fetch("frames", "default"));
        forceNormalTexture = true;
    end
end

function Core:HideFramesElements()
    local noop = function() return end

    for _, objname in ipairs({
        "PlayerAttackGlow",
        "PlayerRestGlow",
        "PlayerRestIcon",
        "PlayerStatusGlow",
        "PlayerStatusTexture",
        "PlayerAttackBackground",
        "PlayerFrameGroupIndicator",
        "PlayerFrameFlash",
        "PlayerFrameRoleIcon",

        "TargetFrameFlash",

        "FocusFrameFlash",

        "PetAttackModeTexture",
        "PetFrameFlash",
    }) do
        local obj = _G[objname]
        if obj then
            obj:Hide()
            obj.Show = noop
        end
    end
end

function Core:MoveFramesNames()
    --Names
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("CENTER", PlayerFrame, "CENTER", 50, 35)
    PlayerName.SetPoint = function() end

    TargetFrame.name:ClearAllPoints()
    TargetFrame.name:SetPoint("CENTER", TargetFrame, "CENTER", -50, 35)
    TargetFrame.name.SetPoint = function() end

    FocusFrame.name:ClearAllPoints()
    FocusFrame.name:SetPoint("CENTER", FocusFrame, "CENTER", -45, 35)
    FocusFrame.name.SetPoint = function() end

    PetFrame.name:ClearAllPoints()
    PetFrame.name:SetPoint("CENTER", PetFrame, "CENTER", 15, 15)
    PetFrame.name.SetPoint = function() end
end

function Core:MoveToTFrames()
    --ToT move
    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint("CENTER", TargetFrame, "CENTER", 60, -45)

    FocusFrameToT:ClearAllPoints()
    FocusFrameToT:SetPoint("CENTER", FocusFrame, "CENTER", 60, -45)
end

function Core:MovePlayerFrameBars()
    --Player bars
    PlayerFrameHealthBar:SetHeight(27)
    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetPoint("CENTER", PlayerFrame, "CENTER", 50, 14)
    PlayerFrameHealthBar.SetPoint = function() end

    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint("CENTER", PlayerFrame, "CENTER", 51, -7)
    PlayerFrameManaBar.SetPoint = function() end
end

function Core:MoveTargetFrameBars()
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
end

function Core:MoveFocusFrameBars()
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
end

function Core:MovePetFrameBars()
    --Player Pet bars
    PetFrameHealthBar:SetHeight(10)
    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint("CENTER", PetFrame, "CENTER", 16, 1)
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
end

function Core:SetFramesBarsFont()
    PlayerFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    PlayerFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    TargetFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    TargetFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    FocusFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    FocusFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    PetFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
    PetFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
end

function Core:MovePlayerFramesBarsTextString()
    PlayerFrameHealthBar.TextString:ClearAllPoints()
    PlayerFrameHealthBar.TextString:SetPoint("CENTER", PlayerFrame, "CENTER", 53, 12)
    PlayerFrameHealthBar.TextString.SetPoint = function() end

    PlayerFrameManaBar.TextString:ClearAllPoints()
    PlayerFrameManaBar.TextString:SetPoint("CENTER", PlayerFrame, "CENTER", 53, -7)
    PlayerFrameManaBar.TextString.SetPoint = function() end
end

function Core:MoveTargetFramesBarsTextString()
    TargetFrameHealthBar.TextString:ClearAllPoints()
    TargetFrameHealthBar.TextString:SetPoint("CENTER", TargetFrame, "CENTER", -53, 12)
    TargetFrameHealthBar.TextString.SetPoint = function() end

    TargetFrameManaBar.TextString:ClearAllPoints()
    TargetFrameManaBar.TextString:SetPoint("CENTER", TargetFrame, "CENTER", -50, -7)
    TargetFrameManaBar.TextString.SetPoint = function() end
end

function Core:MoveFocusFramesBarsTextString()
    FocusFrameHealthBar.TextString:ClearAllPoints()
    FocusFrameHealthBar.TextString:SetPoint("CENTER", FocusFrame, "CENTER", -53, 12)
    FocusFrameHealthBar.TextString.SetPoint = function() end

    FocusFrameManaBar.TextString:ClearAllPoints()
    FocusFrameManaBar.TextString:SetPoint("CENTER", FocusFrame, "CENTER", -50, -7)
    FocusFrameManaBar.TextString.SetPoint = function() end
end

local FrameList = { "Target", "Focus", "Player" }
function Core:UpdateTextStringWithValues()
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
end
