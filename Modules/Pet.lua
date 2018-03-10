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

local MODULE_NAME = "Pet"
local Pet = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")

local db

local UpdateHealthValues = EasyFrames.Utils.UpdateHealthValues
local UpdateManaValues = EasyFrames.Utils.UpdateManaValues

local OnShowHookScript = function(frame)
    frame:Hide()
end

local OnSetTextHookScript = function(frame, text, flag)
    if (flag ~= "EasyFramesHookSetText" and not db.pet.showHitIndicator) then
        frame:SetText(nil, "EasyFramesHookSetText")
    end
end


function Pet:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Pet:OnEnable()
    self:SetScale(db.pet.scaleFrame)
    self:PreSetMovable()
    self:SetMovable(db.pet.lockedMovableFrame)

    self:SetHealthBarsFont()

    self:ShowName(db.pet.showName)
    self:SetFrameNameFont()
    self:SetManaBarsFont()
    self:ShowHitIndicator(db.pet.showHitIndicator)

    self:ShowStatusTexture(db.pet.showStatusTexture)
    self:ShowAttackBackground(db.pet.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.pet.attackBackgroundOpacity)

    self:SecureHook("PetFrame_Update", "PetFrameUpdate")
    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateTextStringWithValues")
end

function Pet:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetScale(db.pet.scaleFrame)
    self:PreSetMovable()
    self:SetMovable(db.pet.lockedMovableFrame)

    self:SetHealthBarsFont()

    self:ShowName(db.pet.showName)
    self:SetFrameNameFont()
    self:SetManaBarsFont()
    self:ShowHitIndicator(db.pet.showHitIndicator)

    self:ShowStatusTexture(db.pet.showStatusTexture)
    self:ShowAttackBackground(db.pet.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.pet.attackBackgroundOpacity)

    self:UpdateTextStringWithValues()
end


function Pet:PetFrameUpdate(frame, override)
    if ((not PlayerFrame.animating) or (override)) then
        if (UnitIsVisible(frame.unit) and PetUsesPetFrame() and not PlayerFrame.vehicleHidesPet) then
            if (frame:IsShown()) then
                UnitFrame_Update(frame);
            else
                frame:Show();
            end
            --frame.flashState = 1;
            --frame.flashTimer = PET_FLASH_ON_TIME;
            if (UnitPowerMax(frame.unit) == 0) then
                PetFrameTexture:SetTexture(Media:Fetch("frames", "nomana"));
                PetFrameManaBarText:Hide();
            else
                PetFrameTexture:SetTexture(Media:Fetch("frames", "smalltarget"));
            end
            PetAttackModeTexture:Hide();

            RefreshDebuffs(frame, frame.unit, nil, nil, true);

            PetFrame.portrait:SetTexCoord(0, 1, 0, 1)

            if (db.pet.customPoints) then
                frame:ClearAllPoints()
                frame:SetPoint(unpack(db.pet.customPoints))
            end
        else
            if InCombatLockdown() then
                return
            end

            frame:Hide();
        end
    end
end

function Pet:SetScale(value)
    PetFrame:SetScale(value)
end

function Pet:PreSetMovable()
    local frame = PetFrame

    frame:SetScript("OnMouseDown", function(frame, button)
        if not db.pet.lockedMovableFrame and button == "LeftButton" and not frame.isMoving then
            frame:StartMoving();
            frame.isMoving = true;
        end
    end)
    frame:SetScript("OnMouseUp", function(frame, button)
        if not db.pet.lockedMovableFrame and button == "LeftButton" and frame.isMoving then
            frame:StopMovingOrSizing();
            frame.isMoving = false;

            db.pet.customPoints = {frame:GetPoint()}
        end
    end)
    frame:SetScript("OnHide", function(frame)
        if ( not db.pet.lockedMovableFrame and frame.isMoving ) then
            frame:StopMovingOrSizing();
            frame.isMoving = false;
        end
    end)
end

function Pet:SetMovable(value)
    PetFrame:SetMovable(not value)
end

function Pet:ResetFramePosition()
    local frame = PetFrame;

    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 90, -65)

    db.pet.customPoints = false
end

function Pet:UpdateTextStringWithValues(statusBar)
    local frame = statusBar or PetFrameHealthBar

    if (frame.unit == "pet") then
        if (frame == PetFrameHealthBar) then
            local healthFormat = db.pet.healthFormat
            local customHealthFormat = db.pet.customHealthFormat
            local customHealthFormatFormulas = db.pet.customHealthFormatFormulas
            local useHealthFormatFullValues = db.pet.useHealthFormatFullValues

            UpdateHealthValues(frame, healthFormat, customHealthFormat, customHealthFormatFormulas, useHealthFormatFullValues)
        elseif (frame == PetFrameManaBar) then
            local manaFormat = db.pet.manaFormat
            local customManaFormat = db.pet.customManaFormat
            local customManaFormatFormulas = db.pet.customManaFormatFormulas
            local useManaFormatFullValues = db.pet.useManaFormatFullValues

            UpdateManaValues(frame, manaFormat, customManaFormat, customManaFormatFormulas, useManaFormatFullValues)
        end
    end
end

function Pet:SetHealthBarsFont()
    local fontSize = db.pet.healthBarFontSize
    local fontFamily = Media:Fetch("font", db.pet.healthBarFontFamily)

    PetFrameHealthBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
end

function Pet:SetManaBarsFont()
    local fontSize = db.pet.manaBarFontSize
    local fontFamily = Media:Fetch("font", db.pet.manaBarFontFamily)

    PetFrameManaBar.TextString:SetFont(fontFamily, fontSize, "OUTLINE")
end

function Pet:ShowName(value)
    if (value) then
        PetName:Show()
    else
        PetName:Hide()
    end
end

function Pet:SetFrameNameFont()
    local fontFamily = Media:Fetch("font", db.pet.petNameFontFamily)
    local fontSize = db.pet.petNameFontSize
    local fontStyle = db.pet.petNameFontStyle

    PetName:SetFont(fontFamily, fontSize, fontStyle)
end

function Pet:ShowHitIndicator(value)
    local frame = PetHitIndicator

    if (not value) then
        frame:SetText(nil)

        if (not frame.EasyFramesHookSetText) then
            hooksecurefunc(frame, "SetText", OnSetTextHookScript)
            frame.EasyFramesHookSetText = true
        end
    end
end

function Pet:ShowStatusTexture(value)
    local frame = PetAttackModeTexture

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

function Pet:ShowAttackBackground(value)
    local frame = PetFrameFlash

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

function Pet:SetAttackBackgroundOpacity(value)
    PetFrameFlash:SetAlpha(value)
end