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
local PartyIterator = EasyFrames.Helpers.Iterator(EasyFrames.Utils.GetPartyFrames())

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
--    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateTextStringWithValues")

    self:MoveFramesNames()
    self:MoveToTFrames()
    self:MovePlayerFrameBars()
    self:MoveTargetFrameBars()
    self:MoveFocusFrameBars()
    self:MovePetFrameBars()
    self:MovePartyFrameBars()
    self:MovePartyPetFrames()

    self:MovePlayerFramesBarsTextString()
    self:MoveTargetFramesBarsTextString()
    self:MoveFocusFramesBarsTextString()

    self:MoveLevelText()

    if (db.general.showWelcomeMessage) then
        print("|cff0cbd0cEasyFrames|cffffffff " .. L["loaded. Options:"] .. " |cff0cbd0c/ef")
    end
end

function Core:GetOriginalValues()
--    originalValues["PlayerNameSetPoint"] = PlayerName.SetPoint

--    originalValues["TargetFrameTextureFrameNameSetPoint"] = TargetFrame.name.SetPoint
--    originalValues["FocusFrameTextureFrameNameSetPoint"] = TargetFrame.name.SetPoint

--    originalValues["PlayerFrameHealthBarTextRightSetPoint"] = PlayerFrameHealthBar.RightText.SetPoint
--    originalValues["PlayerFrameHealthBarTextLeftSetPoint"] = PlayerFrameHealthBar.LeftText.SetPoint
--    originalValues["PlayerFrameHealthBarTextSetPoint"] = PlayerFrameHealthBar.TextString.SetPoint

--    originalValues["PlayerFrameManaBarTextSetPoint"] = PlayerFrameManaBar.TextString.SetPoint


--    originalValues["TargetFrameTextureFrameHealthBarTextRightSetPoint"] = TargetFrameHealthBar.RightText.SetPoint
--    originalValues["TargetFrameTextureFrameHealthBarTextLeftSetPoint"] = TargetFrameHealthBar.LeftText.SetPoint
--    originalValues["TargetFrameTextureFrameHealthBarTextSetPoint"] =  TargetFrameHealthBar.TextString.SetPoint
--
--    originalValues["TargetFrameTextureFrameManaBarTextSetPoint"] = TargetFrameManaBar.TextString.SetPoint


--    originalValues["FocusFrameTextureFrameHealthBarTextRightSetPoint"] = FocusFrameHealthBar.RightText.SetPoint
--    originalValues["FocusFrameTextureFrameHealthBarTextLeftSetPoint"] = FocusFrameHealthBar.LeftText.SetPoint
--    originalValues["FocusFrameTextureFrameHealthBarTextSetPoint"] = FocusFrameHealthBar.TextString.SetPoint
--
--    originalValues["FocusFrameTextureFrameManaBarTextSetPoint"] = FocusFrameManaBar.TextString.SetPoint


--    for i = 1, 4 do
--        originalValues["PartyMemberFrame".. i .. "HealthBarSetPoint"] = _G["PartyMemberFrame" .. i .. "HealthBar"].SetPoint
--        originalValues["PartyMemberFrame".. i .. "HealthBarTextSetPoint"] = _G["PartyMemberFrame" .. i .. "HealthBar"].TextString.SetPoint
--        originalValues["PartyMemberFrame".. i .. "HealthBarTextRightSetPoint"] = _G["PartyMemberFrame" .. i .. "HealthBar"].RightText.SetPoint
--        originalValues["PartyMemberFrame".. i .. "HealthBarTextLeftSetPoint"] = _G["PartyMemberFrame" .. i .. "HealthBar"].LeftText.SetPoint
--
--        originalValues["PartyMemberFrame".. i .. "ManaBarSetPoint"] = _G["PartyMemberFrame" .. i .. "ManaBar"].SetPoint
--        originalValues["PartyMemberFrame".. i .. "ManaBarTextSetPoint"] = _G["PartyMemberFrame" .. i .. "ManaBar"].TextString.SetPoint
--        originalValues["PartyMemberFrame".. i .. "ManaBarTextRightSetPoint"] = _G["PartyMemberFrame" .. i .. "ManaBar"].RightText.SetPoint
--        originalValues["PartyMemberFrame".. i .. "ManaBarTextLeftSetPoint"] = _G["PartyMemberFrame" .. i .. "ManaBar"].LeftText.SetPoint
--    end

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

    self:MoveRegion(PetFrame.name, "CENTER", PetFrame, "CENTER", 15, 19)

    PartyIterator(function(frame)
        local point, relativeTo, relativePoint, xOffset, yOffset = frame.name:GetPoint()

        Core:MoveRegion(frame.name, point, relativeTo, relativePoint, xOffset, yOffset - 3)
    end)
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

    self:MoveRegion(PlayerFrameAlternateManaBarText, "CENTER", PlayerFrameAlternateManaBar, "CENTER", 0, -1)

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
    TargetFrameTextureFrameDeadText:SetPoint("CENTER", TargetFrame, "CENTER", -50, 12)
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
    FocusFrameTextureFrameDeadText:SetPoint("CENTER", FocusFrame, "CENTER", -50, 12)
    FocusFrameTextureFrameDeadText.SetPoint = function() end

    FocusFrameManaBar:ClearAllPoints()
    FocusFrameManaBar:SetPoint("CENTER", FocusFrame, "CENTER", -51, -7)
    FocusFrameManaBar.SetPoint = function() end

    FocusFrameNumericalThreat:ClearAllPoints()
    FocusFrameNumericalThreat:SetPoint("CENTER", FocusFrame, "CENTER", 44, 48)
    FocusFrameNumericalThreat.SetPoint = function() end
end

function Core:MovePetFrameBars()
    local healthBar = PetFrameHealthBar
    local manaBar = PetFrameManaBar

    healthBar:SetHeight(13)
    healthBar:ClearAllPoints()
    healthBar:SetPoint("CENTER", PetFrame, "CENTER", 16, 3)
    healthBar.SetPoint = function() end

    manaBar:ClearAllPoints()
    manaBar:SetPoint("CENTER", PetFrame, "CENTER", 16, -8)
    manaBar.SetPoint = function() end


    healthBar.RightText:ClearAllPoints()
    healthBar.RightText:SetPoint("RIGHT", PetFrame, "TOPLEFT", 113, -23)
    healthBar.RightText.SetPoint = function() end

    healthBar.LeftText:ClearAllPoints()
    healthBar.LeftText:SetPoint("LEFT", PetFrame, "TOPLEFT", 46, -23)
    healthBar.LeftText.SetPoint = function() end

    healthBar.TextString:ClearAllPoints()
    healthBar.TextString:SetPoint("CENTER", healthBar, "CENTER", 0, 0)
    healthBar.TextString.SetPoint = function() end

    manaBar.TextString:ClearAllPoints()
    manaBar.TextString:SetPoint("CENTER", manaBar, "CENTER", 0, 0)
    manaBar.TextString.SetPoint = function() end
end

function Core:MovePlayerFramesBarsTextString()
    self:MoveRegion(PlayerFrameHealthBar.RightText, "RIGHT", PlayerFrame, "RIGHT", -8, 12)
    self:MoveRegion(PlayerFrameHealthBar.LeftText, "LEFT", PlayerFrame, "LEFT", 110, 12)
    self:MoveRegion(PlayerFrameHealthBar.TextString, "CENTER", PlayerFrame, "CENTER", 53, 12)

    self:MoveRegion(PlayerFrameManaBar.TextString, "CENTER", PlayerFrame, "CENTER", 53, -8)
end

function Core:MoveTargetFramesBarsTextString()
    self:MoveRegion(TargetFrameHealthBar.RightText, "RIGHT", TargetFrame, "RIGHT", -110, 12)
    self:MoveRegion(TargetFrameHealthBar.LeftText, "LEFT", TargetFrame, "LEFT", 8, 12)
    self:MoveRegion(TargetFrameHealthBar.TextString, "CENTER", TargetFrame, "CENTER", -50, 12)

    self:MoveRegion(TargetFrameManaBar.TextString, "CENTER", TargetFrame, "CENTER", -50, -8)
end

function Core:MoveFocusFramesBarsTextString()
    self:MoveRegion(FocusFrameHealthBar.RightText, "RIGHT", FocusFrame, "RIGHT", -110, 12)
    self:MoveRegion(FocusFrameHealthBar.LeftText, "LEFT", FocusFrame, "LEFT", 8, 12)
    self:MoveRegion(FocusFrameHealthBar.TextString, "CENTER", FocusFrame, "CENTER", -50, 12)

    self:MoveRegion(FocusFrameManaBar.TextString, "CENTER", FocusFrame, "CENTER", -50, -8)
end

function Core:MovePartyFrameBars()
    PartyIterator(function(frame)
        _G[frame:GetName() .. "Background"]:SetVertexColor(0, 0, 0, 0)

        local healthBar = _G[frame:GetName() .. "HealthBar"]
        local manaBar = _G[frame:GetName() .. "ManaBar"]

        healthBar:SetHeight(13)

        Core:MoveRegion(healthBar, "CENTER", frame, "CENTER", 16, 4)
        Core:MoveRegion(healthBar.TextString, "CENTER", healthBar, "CENTER", 0, 0)
        Core:MoveRegion(healthBar.RightText, "RIGHT", frame, "RIGHT", -12, 4)
        Core:MoveRegion(healthBar.LeftText, "LEFT", frame, "LEFT", 46, 4)

        Core:MoveRegion(manaBar, "CENTER", frame, "CENTER", 16, -8)
        Core:MoveRegion(manaBar.TextString, "CENTER", manaBar, "CENTER", 0, 0)
        Core:MoveRegion(manaBar.RightText, "RIGHT", frame, "RIGHT", -12, -8)
        Core:MoveRegion(manaBar.LeftText, "LEFT", frame, "LEFT", 46, -8)
    end)
end

function Core:MovePartyPetFrames()
    PartyIterator(function(frame)
        Core:MoveRegion(_G[frame:GetName() .. "PetFrame"], "TOPLEFT", frame, "TOPLEFT", 23, -37)
    end)
end

function Core:MoveLevelText()
    Core:MoveRegion(PlayerLevelText, "CENTER", -63, -17)
    Core:MoveRegion(TargetFrame.levelText, "CENTER", 63, -17)
    Core:MoveRegion(FocusFrame.levelText, "CENTER", 63, -17)
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
