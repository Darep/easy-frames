--[[
    Appreciate what others people do. (c) Usoltsev

    Copyright (c) <2016-2017>, Usoltsev <alexander.usolcev@gmail.com> All rights reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    Neither the name of the <EasyFrames> nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
    INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
    OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Core"
local Core = EasyFrames:NewModule(MODULE_NAME, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local db
local originalValues = {}

function Core:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Core:OnEnable()
    self:GetOriginalValues()

    self:RegisterEvent("GROUP_ROSTER_UPDATE", "EventHandler")
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "EventHandler")
    self:RegisterEvent("PLAYER_FOCUS_CHANGED", "EventHandler")
    self:RegisterEvent("UNIT_FACTION", "EventHandler")

    self:SecureHook("TargetFrame_CheckClassification", "CheckClassification")
    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateTextStringWithValues")

    self:MoveFramesNames()
    self:MoveToTFrames()
    self:MovePlayerFrameBars()
    self:MoveTargetFrameBars()
    self:MoveFocusFrameBars()
    self:MovePetFrameBars()

    self:MovePlayerFramesBarsTextString()
    self:MoveTargetFramesBarsTextString()
    self:MoveFocusFramesBarsTextString()

    if (db.general.showWelcomeMessage) then
        print("|cff0cbd0cEasyFrames|cffffffff " .. L["loaded. Options:"] .. " |cff0cbd0c/ef")
    end
end

function Core:GetOriginalValues()
    originalValues["PlayerNameSetPoint"] = PlayerName.SetPoint
    originalValues["TargetFrameTextureFrameNameSetPoint"] = TargetFrame.name.SetPoint
    originalValues["FocusFrameTextureFrameNameSetPoint"] = TargetFrame.name.SetPoint

    originalValues["PlayerFrameHealthBarTextRightSetPoint"] = PlayerFrameHealthBar.RightText.SetPoint
    originalValues["PlayerFrameHealthBarTextLeftSetPoint"] = PlayerFrameHealthBar.LeftText.SetPoint
    originalValues["PlayerFrameHealthBarTextSetPoint"] =  PlayerFrameHealthBar.TextString.SetPoint

    originalValues["PlayerFrameManaBarTextSetPoint"] =  PlayerFrameManaBar.TextString.SetPoint


    originalValues["TargetFrameTextureFrameHealthBarTextRightSetPoint"] = TargetFrameHealthBar.RightText.SetPoint
    originalValues["TargetFrameTextureFrameHealthBarTextLeftSetPoint"] = TargetFrameHealthBar.LeftText.SetPoint
    originalValues["TargetFrameTextureFrameHealthBarTextSetPoint"] =  TargetFrameHealthBar.TextString.SetPoint

    originalValues["TargetFrameTextureFrameManaBarTextSetPoint"] =  TargetFrameManaBar.TextString.SetPoint


    originalValues["FocusFrameTextureFrameHealthBarTextRightSetPoint"] = FocusFrameHealthBar.RightText.SetPoint
    originalValues["FocusFrameTextureFrameHealthBarTextLeftSetPoint"] = FocusFrameHealthBar.LeftText.SetPoint
    originalValues["FocusFrameTextureFrameHealthBarTextSetPoint"] =  FocusFrameHealthBar.TextString.SetPoint

    originalValues["FocusFrameTextureFrameManaBarTextSetPoint"] =  FocusFrameManaBar.TextString.SetPoint
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

function Core:MoveRegion(region, point, relativeTo, relativePoint, xOffset, yOffset)
    region:ClearAllPoints()

    region.SetPoint = originalValues[region:GetName() .. "SetPoint"]
    region:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)

    region.SetPoint = function() end
end

function Core:MovePlayerFrameName(point, relativeTo, relativePoint, xOffset, yOffset)
    self:MoveRegion(PlayerName, point or "CENTER", relativeTo or PlayerFrame, relativePoint or "CENTER", xOffset or 50, yOffset or 35)
end

function Core:MoveTargetFrameName(point, relativeTo, relativePoint, xOffset, yOffset)
    self:MoveRegion(TargetFrame.name, point or "CENTER", relativeTo or TargetFrame, relativePoint or "CENTER", xOffset or -50, yOffset or 35)
end

function Core:MoveFocusFrameName(point, relativeTo, relativePoint, xOffset, yOffset)
    self:MoveRegion(FocusFrame.name, point or "CENTER", relativeTo or FocusFrame, relativePoint or "CENTER", xOffset or -45, yOffset or 35)
end

function Core:MoveFramesNames()
    --Names
    self:MovePlayerFrameName()
    self:MoveTargetFrameName()
    self:MoveFocusFrameName()

    PetFrame.name:ClearAllPoints()
    PetFrame.name:SetPoint("CENTER", PetFrame, "CENTER", 15, 19)
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

    PlayerStatusTexture:SetHeight(69)

    PlayerFrameGroupIndicator:ClearAllPoints()
    PlayerFrameGroupIndicator:SetPoint("TOPLEFT", 34, 15)
    PlayerFrameGroupIndicatorLeft:SetAlpha(0)
    PlayerFrameGroupIndicatorRight:SetAlpha(0)
    PlayerFrameGroupIndicatorMiddle:SetAlpha(0)

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
    PetFrameHealthBar:SetHeight(13)
    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint("CENTER", PetFrame, "CENTER", 16, 4)
    PetFrameHealthBar.SetPoint = function() end

    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("CENTER", PetFrame, "CENTER", 16, -7)
    PetFrameManaBar.SetPoint = function() end


    PetFrameHealthBar.RightText:ClearAllPoints()
    PetFrameHealthBar.RightText:SetPoint("RIGHT", PetFrame, "TOPLEFT", 113, -23)
    PetFrameHealthBar.RightText.SetPoint = function() end

    PetFrameHealthBar.LeftText:ClearAllPoints()
    PetFrameHealthBar.LeftText:SetPoint("LEFT", PetFrame, "TOPLEFT", 46, -23)
    PetFrameHealthBar.LeftText.SetPoint = function() end

    PetFrameHealthBar.TextString:ClearAllPoints()
    PetFrameHealthBar.TextString:SetPoint("CENTER", PetFrameHealthBar, "CENTER", 0, 0)
    PetFrameHealthBar.TextString.SetPoint = function() end

    PetFrameManaBar.TextString:ClearAllPoints()
    PetFrameManaBar.TextString:SetPoint("CENTER", PetFrameManaBar, "CENTER", 0, 0)
    PetFrameManaBar.TextString.SetPoint = function() end
end

function Core:MovePlayerFramesBarsTextString()
    self:MoveRegion(PlayerFrameHealthBar.RightText, "RIGHT", PlayerFrame, "RIGHT", -8, 12)
    self:MoveRegion(PlayerFrameHealthBar.LeftText, "LEFT", PlayerFrame, "LEFT", 110, 12)
    self:MoveRegion(PlayerFrameHealthBar.TextString, "CENTER", PlayerFrame, "CENTER", 53, 12)

    self:MoveRegion(PlayerFrameManaBar.TextString, "CENTER", PlayerFrame, "CENTER", 53, -7)
end

function Core:MoveTargetFramesBarsTextString()
    self:MoveRegion(TargetFrameHealthBar.RightText, "RIGHT", TargetFrame, "RIGHT", -110, 12)
    self:MoveRegion(TargetFrameHealthBar.LeftText, "LEFT", TargetFrame, "LEFT", 8, 12)
    self:MoveRegion(TargetFrameHealthBar.TextString, "CENTER", TargetFrame, "CENTER", -50, 12)

    self:MoveRegion(TargetFrameManaBar.TextString, "CENTER", TargetFrame, "CENTER", -50, -7)
end

function Core:MoveFocusFramesBarsTextString()
    self:MoveRegion(FocusFrameHealthBar.RightText, "RIGHT", FocusFrame, "RIGHT", -110, 12)
    self:MoveRegion(FocusFrameHealthBar.LeftText, "LEFT", FocusFrame, "LEFT", 8, 12)
    self:MoveRegion(FocusFrameHealthBar.TextString, "CENTER", FocusFrame, "CENTER", -50, 12)

    self:MoveRegion(FocusFrameManaBar.TextString, "CENTER", FocusFrame, "CENTER", -50, -7)
end

local FrameList = { "Target", "Focus", "Player" }
function Core:UpdateTextStringWithValues()
    for i = 1, select("#", unpack(FrameList)) do
        local FrameName = (select(i, unpack(FrameList)))

        if (UnitPowerType(FrameName) == 0) then --mana
            _G[FrameName .. "FrameManaBar"].TextString:SetText(string.format("%.0f%%", (UnitPower(FrameName) / UnitPowerMax(FrameName)) * 100))
        elseif (UnitPowerType(FrameName) == 1 or UnitPowerType(FrameName) == 2 or UnitPowerType(FrameName) == 3 or UnitPowerType(FrameName) == 6) then
            _G[FrameName .. "FrameManaBar"].TextString:SetText(AbbreviateLargeNumbers(UnitPower(FrameName)))
        end

        if (UnitPowerMax(FrameName) == 0) then
            _G[FrameName .. "FrameManaBar"].TextString:SetText(" ")
        end
    end
end
