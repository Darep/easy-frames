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

local MODULE_NAME = "Target"
local Target = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db
local originalValues = {}
local UpdateHealthValues = EasyFrames.Utils.UpdateHealthValues

function Target:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Target:OnEnable()
    self:GetOriginalValues()

    self:SetScale(db.target.scaleFrame)
    self:ShowTargetFrameToT()
    self:ShowName(db.target.showName)
    self:SetHealthBarsFont()

    self:ReverseDirectionLosingHP(db.target.reverseDirectionLosingHP)

    self:ShowAttackBackground(db.target.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.target.attackBackgroundOpacity)

    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateHealthValues")
end

function Target:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetScale(db.target.scaleFrame)
    self:ShowTargetFrameToT()
    self:ShowName(db.target.showName)
    self:SetHealthBarsFont()

    self:ReverseDirectionLosingHP(db.target.reverseDirectionLosingHP)

    self:ShowAttackBackground(db.target.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.target.attackBackgroundOpacity)

    self:UpdateHealthValues()
end


function Target:GetOriginalValues()
    originalValues["TargetFrameFlash"] = TargetFrameFlash.Show
end

function Target:SetScale(value)
    TargetFrame:SetScale(value)
end

function Target:UpdateHealthValues()
    local frame = "Target"
    local healthFormat = db.target.healthFormat
    local customHealthFormat = db.target.customHealthFormat
    local customHealthFormatFormulas = db.target.customHealthFormatFormulas
    local useHealthFormatFullValues = db.target.useHealthFormatFullValues

    UpdateHealthValues(frame, healthFormat, customHealthFormat, customHealthFormatFormulas, useHealthFormatFullValues)
end

function Target:ShowTargetFrameToT()
    if (db.target.showToTFrame) then
        TargetFrameToT:SetAlpha(100)
    else
        TargetFrameToT:SetAlpha(0)
    end
end

function Target:ShowName(value)
    if (value) then
        TargetFrame.name:Show()
    else
        TargetFrame.name:Hide()
    end

    self:ShowNameInsideFrame(db.target.showNameInsideFrame)
end

function Target:ShowNameInsideFrame(value)
    local Core = EasyFrames:GetModule("Core")

    local HealthBarTexts = {
        TargetFrameHealthBar.RightText,
        TargetFrameHealthBar.LeftText,
        TargetFrameHealthBar.TextString
    }

    for _, healthBar in pairs(HealthBarTexts) do
        local point, relativeTo, relativePoint, xOffset, yOffset = healthBar:GetPoint()

        if (value and db.player.showName) then
            Core:MoveTargetFrameName(nil, nil, nil, nil, 20)

            Core:MoveRegion(healthBar, point, relativeTo, relativePoint, xOffset, yOffset - 4)
        else
            Core:MoveTargetFrameName()

            Core:MoveRegion(healthBar, point, relativeTo, relativePoint, xOffset, 12)
        end
    end
end

function Target:SetHealthBarsFont()
    local fontSize = db.target.healthBarFontSize
    local fontFamily = Media:Fetch("font", db.target.healthBarFontFamily)

    TargetFrameHealthBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
    TargetFrameManaBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
end

function Target:ReverseDirectionLosingHP(value)
    TargetFrameHealthBar:SetReverseFill(value)
    TargetFrameManaBar:SetReverseFill(value)
end

function Target:ShowAttackBackground(value)
    local noop = function() return end

    local frame = TargetFrameFlash

    if frame then
        if (value) then
            frame.Show = originalValues[frame:GetName()]

            if (UnitAffectingCombat("target")) then
                frame:Show()
            end
        else
            frame:Hide()
            frame.Show = noop
        end
    end
end

function Target:SetAttackBackgroundOpacity(value)
    TargetFrameFlash:SetAlpha(value)
end