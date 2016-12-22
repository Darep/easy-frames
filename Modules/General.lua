local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "General"
local General = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db

local GetFramesHealthBar = EasyFrames.Utils.GetFramesHealthBar
local GetFramesManaBar = EasyFrames.Utils.GetFramesManaBar


local function ClassColored(statusbar, unit)

    if (UnitIsPlayer(unit) and UnitClass(unit) and db.general.classColored) then
        -- player

        local _, class, classColor

        _, class = UnitClass(unit)
        classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

        statusbar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
    else
        -- non player

        local colors

        if (UnitIsFriend("player", unit)) then
            colors = db.general.friendlyFrameDefaultColors
        elseif (UnitIsEnemy("player", unit)) then
            colors = db.general.enemyFrameDefaultColors
        else
            colors = db.general.neutralFrameDefaultColors
        end

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
    self:SecureHook("TargetFrame_UpdateAuras", "ShowStealableBuff")

    self:SetFrameBarTexture(db.general.barTexture)

    self:SetBrightFramesBorder(db.general.brightFrameBorder)
end

function General:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetFramesColored()
    self:SetClassPortraits()
    self:SetFrameBarTexture(db.general.barTexture)
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
    local healthBars = GetFramesHealthBar()
    local manaBars = GetFramesManaBar()

    for _, healthbar in pairs(healthBars) do
        if (UnitIsConnected(healthbar.unit)) then
            healthbar:SetStatusBarTexture(Media:Fetch("bartexture", value))
        end
    end

    for _, manabar in pairs(manaBars) do
        if (UnitIsConnected(manabar.unit)) then
            manabar:SetStatusBarTexture(Media:Fetch("bartexture", value))
        end
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

    local DEFAULT_BUFF_SIZE = 17

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

function General:MakeCustomBuffSize(frame, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth)
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
                updateFunc(frame, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY)
                rowWidth = size
                frame.auraRows = frame.auraRows + 1
                firstBuffOnRow = i
                offsetY = AURA_OFFSET
            else
                updateFunc(frame, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY)
            end
        end
    end
end

function General:ShowStealableBuff(frame)
    local frameStealable, frameName, icon, debuffType, _
    local selfName = frame:GetName()
    local isEnemy = UnitIsEnemy(PlayerFrame.unit, frame.unit)

    for i = 1, MAX_TARGET_BUFFS do
        _, _, icon, _, debuffType = UnitBuff(frame.unit, i)
        frameName = selfName .. 'Buff' .. i
        if (icon and (not frame.maxBuffs or i <= frame.maxBuffs)) then
            frameStealable = _G[frameName .. 'Stealable']
            if (isEnemy and debuffType == 'Magic') then
                frameStealable:Show()

                if (db.general.customBuffSize) then
                    frameStealable:SetHeight(db.general.buffSize * 1.4)
                    frameStealable:SetWidth(db.general.buffSize * 1.4)
                end
            else
                frameStealable:Hide()
            end
        end
    end
end