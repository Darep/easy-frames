--[[
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

local MODULE_NAME = "Focus"
local Focus = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db
local originalValues = {}
local UpdateHealthValues = EasyFrames.Utils.UpdateHealthValues

function Focus:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Focus:OnEnable()
    self:GetOriginalValues()

    self:SetScale(db.focus.scaleFrame)
    self:ShowFocusFrameToT()
    self:SetHealthBarsFontSize(db.focus.healthBarFontSize)

    self:ShowAttackBackground(db.focus.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.focus.attackBackgroundOpacity)

    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateHealthValues")
end

function Focus:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetScale(db.focus.scaleFrame)
    self:ShowFocusFrameToT()
    self:SetHealthBarsFontSize(db.focus.healthBarFontSize)

    self:ShowAttackBackground(db.focus.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.focus.attackBackgroundOpacity)

    self:UpdateHealthValues()
end


function Focus:GetOriginalValues()
    originalValues["FocusFrameFlash"] = FocusFrameFlash.Show
end

function Focus:SetScale(value)
    FocusFrame:SetScale(value)
end

function Focus:UpdateHealthValues()
    local frame = "Focus"
    local healthFormat = db.focus.healthFormat
    local customHealthFormat = db.focus.customHealthFormat
    local customHealthFormatFormulas = db.focus.customHealthFormatFormulas
    local useHealthFormatFullValues = db.focus.useHealthFormatFullValues

    UpdateHealthValues(frame, healthFormat, customHealthFormat, customHealthFormatFormulas, useHealthFormatFullValues)
end

function Focus:ShowFocusFrameToT()
    if (db.focus.showToTFrame) then
        FocusFrameToT:SetAlpha(100)
    else
        FocusFrameToT:SetAlpha(0)
    end
end

function Focus:SetHealthBarsFontSize(value)
    FocusFrameHealthBar.TextString:SetFont(STANDARD_TEXT_FONT, value, "OUTLINE")
    FocusFrameManaBar.TextString:SetFont(STANDARD_TEXT_FONT, value, "OUTLINE")
end

function Focus:ShowAttackBackground(value)
    local noop = function() return end

    local frame = FocusFrameFlash

    if frame then
        if (value) then
            frame.Show = originalValues[frame:GetName()]

            if (UnitAffectingCombat("focus")) then
                frame:Show()
            end
        else
            frame:Hide()
            frame.Show = noop
        end
    end
end

function Focus:SetAttackBackgroundOpacity(value)
    FocusFrameFlash:SetAlpha(value)
end