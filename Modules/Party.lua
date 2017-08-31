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

local MODULE_NAME = "Party"
local Party = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")

local db

local UpdateHealthValues = EasyFrames.Utils.UpdateHealthValues
local UpdateManaValues = EasyFrames.Utils.UpdateManaValues
local PartyIterator = EasyFrames.Helpers.Iterator(EasyFrames.Utils.GetPartyFrames())

function Party:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Party:OnEnable()
    self:SetScale(db.party.scaleFrame)
    self:ShowName(db.party.showName)
    self:SetFrameNameFont()
    self:SetHealthBarsFont()
    self:SetManaBarsFont()
--    self:ShowPetFrames(db.party.showPetFrames)

    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateTextStringWithValues")
end

function Party:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetScale(db.party.scaleFrame)
    self:ShowName(db.party.showName)
    self:SetFrameNameFont()
    self:SetHealthBarsFont()
    self:SetManaBarsFont()
--    self:ShowPetFrames(db.party.showPetFrames)

    self:UpdateTextStringWithValues()
end

function Party:SetScale(value)
    PartyIterator(function(frame)
        frame:SetScale(value)
    end)
end

function Party:UpdateTextStringWithValues(statusBar)
    local frame = statusBar or PartyMemberFrame1HealthBar

    if (frame.unit == "party1" or frame.unit == "party2" or frame.unit == "party3" or frame.unit == "party4") then
        if (string.find(frame:GetName(), 'HealthBar')) then
            local healthFormat = db.party.healthFormat
            local customHealthFormat = db.party.customHealthFormat
            local customHealthFormatFormulas = db.party.customHealthFormatFormulas
            local useHealthFormatFullValues = db.party.useHealthFormatFullValues

            UpdateHealthValues(frame, healthFormat, customHealthFormat, customHealthFormatFormulas, useHealthFormatFullValues)
        elseif (string.find(frame:GetName(), 'ManaBar')) then
            local manaFormat = db.party.manaFormat
            local customManaFormat = db.party.customManaFormat
            local customManaFormatFormulas = db.party.customManaFormatFormulas
            local useManaFormatFullValues = db.party.useManaFormatFullValues

            UpdateManaValues(frame, manaFormat, customManaFormat, customManaFormatFormulas, useManaFormatFullValues)
        end
    end
end

function Party:ShowName(value)
    PartyIterator(function(frame)
        if (value) then
            frame.name:Show()
        else
            frame.name:Hide()
        end
    end)
end

function Party:SetHealthBarsFont()
    local fontSize = db.party.healthBarFontSize
    local fontFamily = Media:Fetch("font", db.party.healthBarFontFamily)

    PartyIterator(function(frame)
        local healthBar = _G[frame:GetName() .. "HealthBar"]

        healthBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
    end)
end

function Party:SetManaBarsFont()
    local fontSize = db.party.manaBarFontSize
    local fontFamily = Media:Fetch("font", db.party.manaBarFontFamily)

    PartyIterator(function(frame)
        local manaBar = _G[frame:GetName() .. "ManaBar"]

        manaBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
    end)
end

function Party:SetFrameNameFont()
    local fontFamily = Media:Fetch("font", db.party.partyNameFontFamily)
    local fontSize = db.party.partyNameFontSize
    local fontStyle = db.party.partyNameFontStyle

    PartyIterator(function(frame)
        frame.name:SetFont(fontFamily, fontSize, fontStyle)
    end)
end

function Party:ShowPetFrames(value)
    PartyIterator(function(frame)
        if (value) then
            _G[frame:GetName() .. "PetFrame"]:Show()
        else
            _G[frame:GetName() .. "PetFrame"]:Hide()
        end
    end)
end