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

local MODULE_NAME = "Player"
local Player = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")

local db

local UpdateHealthValues = EasyFrames.Utils.UpdateHealthValues
local UpdateManaValues = EasyFrames.Utils.UpdateManaValues
local ClassPortraits = EasyFrames.Utils.ClassPortraits
local DefaultPortraits = EasyFrames.Utils.DefaultPortraits

local OnShowHookScript = function(frame)
    frame:Hide()
end

local OnSetTextHookScript = function(frame, text, flag)
    if (flag ~= "EasyFramesHookSetText" and not db.player.showHitIndicator) then
        frame:SetText(nil, "EasyFramesHookSetText")
    end
end


function Player:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile

end

function Player:OnEnable()
    self:SetScale(db.player.scaleFrame)
    self:ShowName(db.player.showName)
    self:SetFrameNameFont()
    self:SetHealthBarsFont()
    self:SetManaBarsFont()
    self:ShowHitIndicator(db.player.showHitIndicator)
    self:ShowSpecialbar(db.player.showSpecialbar)
    self:ShowRestIcon(db.player.showRestIcon)
    self:ShowStatusTexture(db.player.showStatusTexture)
    self:ShowAttackBackground(db.player.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.player.attackBackgroundOpacity)
    self:ShowGroupIndicator(db.player.showGroupIndicator)
    self:ShowRoleIcon(db.player.showRoleIcon)

    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateTextStringWithValues")
    self:SecureHook("UnitFramePortrait_Update", "MakeClassPortraits")
end

function Player:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetScale(db.player.scaleFrame)
    self:MakeClassPortraits(PlayerFrame)
    self:ShowName(db.player.showName)
    self:SetFrameNameFont()
    self:SetHealthBarsFont()
    self:SetManaBarsFont()
    self:ShowHitIndicator(db.player.showHitIndicator)
    self:ShowSpecialbar(db.player.showSpecialbar)
    self:ShowRestIcon(db.player.showRestIcon)
    self:ShowStatusTexture(db.player.showStatusTexture)
    self:ShowAttackBackground(db.player.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.player.attackBackgroundOpacity)
    self:ShowGroupIndicator(db.player.showGroupIndicator)
    self:ShowRoleIcon(db.player.showRoleIcon)

    self:UpdateTextStringWithValues()
end


function Player:SetScale(value)
    PlayerFrame:SetScale(value)
end

function Player:MakeClassPortraits(frame)
    if (frame.unit == "player" and frame.portrait) then
        if (db.player.portrait == "2") then
            ClassPortraits(frame)
        else
            DefaultPortraits(frame)
        end
    end
end

function Player:ShowName(value)
    if (value) then
        PlayerName:Show()
    else
        PlayerName:Hide()
    end

    self:ShowNameInsideFrame(db.player.showNameInsideFrame)
end

function Player:ShowNameInsideFrame(value)
    local Core = EasyFrames:GetModule("Core")

    local HealthBarTexts = {
        PlayerFrameHealthBar.RightText,
        PlayerFrameHealthBar.LeftText,
        PlayerFrameHealthBar.TextString
    }

    for _, healthBar in pairs(HealthBarTexts) do
        local point, relativeTo, relativePoint, xOffset, yOffset = healthBar:GetPoint()

        if (value and db.player.showName) then
            Core:MovePlayerFrameName(nil, nil, nil, nil, 20)

            Core:MoveRegion(healthBar, point, relativeTo, relativePoint, xOffset, yOffset - 4)
        else
            Core:MovePlayerFrameName()

            Core:MoveRegion(healthBar, point, relativeTo, relativePoint, xOffset, 12)
        end
    end
end

function Player:ShowHitIndicator(value)
    local frame = PlayerHitIndicator

    if (not value) then
        frame:SetText(nil)

        if (not frame.EasyFramesHookSetText) then
            hooksecurefunc(frame, "SetText", OnSetTextHookScript)
            frame.EasyFramesHookSetText = true
        end
    end
end

function Player:ShowSpecialbar(value)
    local SpecialbarOnShow = function(frame)
        frame:Hide()
    end

    local _, englishClass = UnitClass("player")
    local playerSpec = GetSpecialization()
    local frame

    if (englishClass == "SHAMAN") then
        frame = TotemFrame
    elseif (englishClass == "DEATHKNIGHT") then
        frame = RuneFrame
    elseif (englishClass == "MAGE" and playerSpec == SPEC_MAGE_ARCANE) then
        frame = MageArcaneChargesFrame
    elseif (englishClass == "MONK" ) then
        if (playerSpec == SPEC_MONK_BREWMASTER) then
            frame = MonkStaggerBar
        elseif (playerSpec == SPEC_MONK_WINDWALKER) then
            frame = MonkHarmonyBarFrame
        end
    elseif (englishClass == "PALADIN" and playerSpec == SPEC_PALADIN_RETRIBUTION) then
        frame = PaladinPowerBarFrame
    elseif (englishClass == "ROGUE") then
        frame = ComboPointPlayerFrame
    elseif (englishClass == "WARLOCK") then
        frame = WarlockPowerFrame
    end

    if (frame) then
        if (value) then
            self:Unhook(frame, "OnShow")

            frame:Show()
        else
            frame:Hide()

            self:HookScript(frame, "OnShow", SpecialbarOnShow)
        end
    end
end

function Player:UpdateTextStringWithValues(statusBar)
    local frame = statusBar or PlayerFrameHealthBar

    if (frame.unit == "player") then
        if (frame == PlayerFrameHealthBar) then
            local healthFormat = db.player.healthFormat
            local customHealthFormat = db.player.customHealthFormat
            local customHealthFormatFormulas = db.player.customHealthFormatFormulas
            local useHealthFormatFullValues = db.player.useHealthFormatFullValues

            UpdateHealthValues(frame, healthFormat, customHealthFormat, customHealthFormatFormulas, useHealthFormatFullValues)
        elseif (frame == PlayerFrameManaBar) then
            local manaFormat = db.player.manaFormat
            local customManaFormat = db.player.customManaFormat
            local customManaFormatFormulas = db.player.customManaFormatFormulas
            local useManaFormatFullValues = db.player.useManaFormatFullValues

            UpdateManaValues(frame, manaFormat, customManaFormat, customManaFormatFormulas, useManaFormatFullValues)
        end
    end
end

function Player:SetHealthBarsFont()
    local fontSize = db.player.healthBarFontSize
    local fontFamily = Media:Fetch("font", db.player.healthBarFontFamily)

    PlayerFrameHealthBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
end

function Player:SetManaBarsFont()
    local fontSize = db.player.manaBarFontSize
    local fontFamily = Media:Fetch("font", db.player.manaBarFontFamily)

    PlayerFrameManaBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
    PlayerFrameAlternateManaBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
end

function Player:SetFrameNameFont()
    local fontFamily = Media:Fetch("font", db.player.playerNameFontFamily)
    local fontSize = db.player.playerNameFontSize
    local fontStyle = db.player.playerNameFontStyle

    PlayerName:SetFont(fontFamily, fontSize, fontStyle)
end

function Player:ShowRestIcon(value)
    for _, frame in pairs({
        PlayerRestGlow,
        PlayerRestIcon,
    }) do
        if frame then
            if (value) then
                self:Unhook(frame, "Show")

                if (IsResting("player")) then
                    frame:Show()
                end
            else
                frame:Hide()

                self:SecureHook(frame, "Show", OnShowHookScript)
            end
        end
    end
end

function Player:ShowStatusTexture(value)
    for _, frame in pairs({
        PlayerStatusGlow,
        PlayerStatusTexture,
    }) do
        if frame then
            if (value) then
                self:Unhook(frame, "Show")

                if (IsResting("player") or UnitAffectingCombat("player")) then
                    frame:Show()
                end
            else
                frame:Hide()

                self:SecureHook(frame, "Show", OnShowHookScript)
            end
        end
    end
end


function Player:ShowAttackBackground(value)
    for _, frame in pairs({
        PlayerAttackGlow,
        PlayerAttackBackground,
        PlayerFrameFlash,
    }) do
        if frame then
            if (value) then
                self:Unhook(frame, "Show")

                if (UnitAffectingCombat("player")) then
                    frame:Show()
                end
            else
                frame:Hide()

                self:SecureHook(frame, "Show", OnShowHookScript)
            end
        end
    end
end

function Player:SetAttackBackgroundOpacity(value)
    PlayerFrameFlash:SetAlpha(value)
end

function Player:ShowGroupIndicator(value)
    local frame = PlayerFrameGroupIndicator

    if frame then
        if (value) then
            self:Unhook(frame, "Show")

            if (IsInRaid("player")) then
                frame:Show()
            end
        else
            frame:Hide()

            self:SecureHook(frame, "Show", OnShowHookScript)
        end
    end
end

function Player:ShowRoleIcon(value)
    local frame = PlayerFrameRoleIcon

    if frame then
        if (value) then
            self:Unhook(frame, "Show")

            if (IsInGroup("player")) then
                frame:Show()
            end
        else
            frame:Hide()

            self:SecureHook(frame, "Show", OnShowHookScript)
        end
    end
end