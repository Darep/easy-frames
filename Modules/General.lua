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

local MODULE_NAME = "General"
local General = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db

local GetFramesHealthBar = EasyFrames.Utils.GetFramesHealthBar
local GetFramesManaBar = EasyFrames.Utils.GetFramesManaBar

local DEFAULT_BUFF_SIZE = 17


local function ClassColored(statusbar, unit)

    if (UnitIsPlayer(unit) and UnitClass(unit)) then
        -- player
        if (db.general.classColored) then
            local _, class, classColor

            _, class = UnitClass(unit)
            classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

            statusbar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
        else
            local colors

            if (UnitIsFriend("player", unit)) then
                colors = db.general.friendlyFrameDefaultColors
            else
                colors = db.general.enemyFrameDefaultColors
            end

            statusbar:SetStatusBarColor(colors[1], colors[2], colors[3])
        end
    else
        -- non player

        local colors

        local red, green, blue = UnitSelectionColor(unit)

        if (red == 0) then
            colors = db.general.friendlyFrameDefaultColors
        elseif (green == 0) then
            colors = db.general.enemyFrameDefaultColors
        else
            colors = db.general.neutralFrameDefaultColors
        end

--        if (UnitIsFriend("player", unit)) then
--            colors = db.general.friendlyFrameDefaultColors
--        elseif (UnitIsEnemy("player", unit)) then
--            colors = db.general.enemyFrameDefaultColors
--        else
--            colors = db.general.neutralFrameDefaultColors
--        end

        statusbar:SetStatusBarColor(colors[1], colors[2], colors[3])
    end
end


local function ClassPortraits(frame)
    if (UnitIsPlayer(frame.unit) and db.general.classPortraits) then
        local t = CLASS_ICON_TCOORDS[select(2, UnitClass(frame.unit))]

        if t then
            frame.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
            frame.portrait:SetTexCoord(unpack(t))
        end
    else
        SetPortraitTexture(frame.portrait, frame.unit)
        frame.portrait:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
    end
end


function General:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function General:OnEnable()
    self:SecureHook("UnitFrameHealthBar_Update", "MakeFramesColored")
    self:SecureHook("HealthBar_OnValueChanged", function(statusbar)
        self:MakeFramesColored(statusbar, statusbar.unit)
    end)

    self:SecureHook("UnitFramePortrait_Update", "MakeClassPortraits")

    self:SecureHook("TargetFrame_UpdateAuraPositions", "MakeCustomBuffSize")
    self:SecureHook("TargetFrame_UpdateAuras", "TargetFrame_UpdateAuras")

    if (db.general.barTexture ~= "Blizzard") then
        self:SetFrameBarTexture(db.general.barTexture)
    end

    self:SetBrightFramesBorder(db.general.brightFrameBorder)
end

function General:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetFramesColored()
    self:SetClassPortraits()

    if (db.general.barTexture ~= "Blizzard") then
        self:SetFrameBarTexture(db.general.barTexture)
    end

    self:SetBrightFramesBorder(db.general.brightFrameBorder)

    self:SetCustomBuffSize(db.general.customBuffSize)
end


function General:ResetFriendlyFrameDefaultColors()
    EasyFrames.db.profile.general.friendlyFrameDefaultColors = {0, 1, 0}
end

function General:ResetEnemyFrameDefaultColors()
    EasyFrames.db.profile.general.enemyFrameDefaultColors = {1, 0, 0}
end

function General:ResetNeutralFrameDefaultColors()
    EasyFrames.db.profile.general.neutralFrameDefaultColors = {1, 1, 0}
end



function General:SetFramesColored()
    local healthBars = GetFramesHealthBar()

    for _, statusbar in pairs(healthBars) do
        if (UnitIsConnected(statusbar.unit)) then
            ClassColored(statusbar, statusbar.unit)
        end
    end
end

function General:MakeFramesColored(statusbar, unit)
    if (unit ~= mouseover) then
        if (UnitIsConnected(unit) and unit == statusbar.unit) then
            ClassColored(statusbar, unit)
        end
    end
end


function General:SetClassPortraits()
    local frames = {
        PlayerFrame,
        TargetFrame,
        TargetFrameToT,
        FocusFrame,
        FocusFrameToT,
        PetFrame,
    }

    for _, frame in pairs(frames) do
        if frame.portrait then
            ClassPortraits(frame)
        end
    end
end

function General:MakeClassPortraits(frame)
    if frame.portrait then
        ClassPortraits(frame)
    end
end


function General:SetFrameBarTexture(value)
    local texture = Media:Fetch("statusbar", value)

    local healthBars = GetFramesHealthBar()
    local manaBars = GetFramesManaBar()

    for _, healthbar in pairs(healthBars) do
        healthbar:SetStatusBarTexture(texture)
        healthbar:GetStatusBarTexture():SetBlendMode("DISABLE")
    end

    for _, manabar in pairs(manaBars) do
        manabar:SetStatusBarTexture(texture)
    end
end


function General:SetBrightFramesBorder(value)
    for i, t in pairs({
        PlayerFrameTexture, TargetFrameTextureFrameTexture, TargetFrameToTTextureFrameTexture,
        PetFrameTexture, FocusFrameTextureFrameTexture, FocusFrameToTTextureFrameTexture
    }) do
        t:SetVertexColor(value, value, value)
    end
end

function General:SetCustomBuffSize(value)

    local frames = {
        TargetFrame,
        FocusFrame
    }

    for _, frame in pairs(frames) do
        local LARGE_AURA_SIZE = db.general.selfBuffSize
        local SMALL_AURA_SIZE = db.general.buffSize

        local buffSize = DEFAULT_BUFF_SIZE
        local frameName
        local icon
        local caster
        local _
        local selfName = frame:GetName()

--        if (frame.unit == 'target') then
--            buffSize = DEFAULT_BUFF_SIZE * db.target.scaleFrame
--        end

--        if (frame.unit == 'focus') then
--            buffSize = DEFAULT_BUFF_SIZE * db.focus.scaleFrame
--        end

        for i = 1, MAX_TARGET_BUFFS do
            _, _, icon, _, _, _, _, caster = UnitBuff(frame.unit, i)
            frameName = selfName .. 'Buff' .. i

            if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
                if (value) then
                    if (caster == 'player') then
                        buffSize = LARGE_AURA_SIZE
                    else
                        buffSize = SMALL_AURA_SIZE
                    end
                end

                _G[frameName]:SetHeight(buffSize)
                _G[frameName]:SetWidth(buffSize)
            end
        end
    end
end

function General:MakeCustomBuffSize(frame, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, _, mirrorAurasVertically)
    if (db.general.customBuffSize) then
        local AURA_OFFSET = 2
        local LARGE_AURA_SIZE = db.general.selfBuffSize
        local SMALL_AURA_SIZE = db.general.buffSize
        local size
        local offsetY = AURA_OFFSET
        local offsetX = AURA_OFFSET
        local rowWidth = 0
        local firstBuffOnRow = 1

        for i = 1, numAuras do
            if (largeAuraList[i]) then
                size = LARGE_AURA_SIZE
                offsetY = AURA_OFFSET + 1
                offsetX = AURA_OFFSET + 1
            else
                size = SMALL_AURA_SIZE
            end

            if (i == 1) then
                rowWidth = size
                frame.auraRows = frame.auraRows + 1
            else
                rowWidth = rowWidth + size + offsetX
            end

            if (rowWidth > maxRowWidth) then
                updateFunc(frame, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically)
                rowWidth = size
                frame.auraRows = frame.auraRows + 1
                firstBuffOnRow = i
                offsetY = AURA_OFFSET
            else
                updateFunc(frame, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically)
            end
        end
    end
end

function General:SetHighlightDispelledBuff()
    if (db.general.highlightDispelledBuff) then
        self:TargetFrame_UpdateAuras(TargetFrame)
    else
        self:TargetFrame_UpdateAuras(TargetFrame, true)
    end
end

function General:TargetFrame_UpdateAuras(frame, forceHide)
    local buffFrame, frameStealable, frameName, icon, debuffType, isStealable, _
    local selfName = frame:GetName()
    local isEnemy = UnitIsEnemy(PlayerFrame.unit, frame.unit)

    for i = 1, MAX_TARGET_BUFFS do
        _, _, icon, _, debuffType, _, _, _, isStealable = UnitBuff(frame.unit, i)
        frameName = selfName .. 'Buff' .. i
        if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
            buffFrame = _G[frameName]

            -- Buffs on top
            if (i == 1 and frame.buffsOnTop) then
                local point, relativeTo, relativePoint, xOffset, yOffset = buffFrame:GetPoint()

                buffFrame:ClearAllPoints()
                buffFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset + 8)
            end

            -- Stealable buffs
            if (db.general.highlightDispelledBuff or forceHide) then
                frameStealable = _G[frameName .. 'Stealable']

                local allCanSteal = true
                if (db.general.ifPlayerCanDispelBuff) then
                    allCanSteal = isStealable
                end

                if (isEnemy and debuffType == 'Magic' and allCanSteal and not forceHide) then
                    local buffSize

                    if (db.general.customBuffSize) then
                        buffSize = db.general.buffSize * db.general.dispelledBuffScale
                    else
                        buffSize = DEFAULT_BUFF_SIZE * db.general.dispelledBuffScale
                    end

                    buffFrame:SetHeight(buffSize)
                    buffFrame:SetWidth(buffSize)

                    frameStealable:Show()
                    frameStealable:SetHeight(buffSize * 1.4)
                    frameStealable:SetWidth(buffSize * 1.4)
                elseif (forceHide) then
                    frameStealable:Hide()
                end
            end
        end
    end
end