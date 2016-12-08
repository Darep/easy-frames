local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "General"
local General = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db

local function PlayerClassColored(statusbar, unit)
    local _, class, classColor

    _, class = UnitClass(unit)
    classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

    statusbar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
end

local function NonPlayerColored(statusbar, unit)
    local colors

    if (UnitIsFriend("player", unit)) then
        colors = db.general.friendlyTargetDefaultColors
    end

    if (not UnitIsFriend("player", unit)) then
        colors = db.general.enemyTargetDefaultColors
    end

    statusbar:SetStatusBarColor(colors[1], colors[2], colors[3])
end

local function PlayerClassPortraits(frame)
    local t = CLASS_ICON_TCOORDS[select(2, UnitClass(frame.unit))]
    if t then
        frame.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        frame.portrait:SetTexCoord(unpack(t))
    end
end

local function NonPlayerPortraits(frame)
    frame.portrait:SetTexCoord(0, 1, 0, 1)
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
end

function General:ResetFriendlyTargetDefaultColors()
    EasyFrames.db.profile.general.friendlyTargetDefaultColors = {0, 1, 0}
end

function General:ResetEnemyTargetDefaultColors()
    EasyFrames.db.profile.general.enemyTargetDefaultColors = {1, 0, 0}
end


function General:SetBrightFramesBorder(value)
    for i, t in pairs({
        PlayerFrameTexture, TargetFrameTextureFrameTexture, TargetFrameToTTextureFrameTexture,
        PetFrameTexture, FocusFrameTextureFrameTexture, FocusFrameToTTextureFrameTexture
    }) do
        t:SetVertexColor(value, value, value)
    end
end

function General:SetFramesColored()
    local frames = {
        PlayerFrameHealthBar,
        TargetFrameHealthBar,
        TargetFrameToTHealthBar,
        FocusFrameHealthBar,
        FocusFrameToTHealthBar,
        PetFrameHealthBar,
    }

    for _, statusbar in pairs(frames) do
        if (UnitIsConnected(statusbar.unit)) then

            if (UnitIsPlayer(statusbar.unit) and UnitClass(statusbar.unit) and db.general.classColored) then
                -- player
                PlayerClassColored(statusbar, statusbar.unit)
            else
                -- non player
                NonPlayerColored(statusbar, statusbar.unit)
            end
        end
    end
end

function General:MakeFramesColored(statusbar, unit)
    if (unit ~= mouseover) then

        if (UnitIsConnected(unit) and unit == statusbar.unit) then
            if (UnitIsPlayer(unit) and UnitClass(unit) and db.general.classColored) then
                PlayerClassColored(statusbar, unit)
            else
                NonPlayerColored(statusbar, unit)
            end

        end
    end
end

function General:SetClassPortraits()
--    if (db.general.classPortraits) then
--        self:SecureHook("UnitFramePortrait_Update", "ClassPortraits")
--    else
--        self:Unhook("UnitFramePortrait_Update", "ClassPortraits")
--    end
end

function General:MakeClassPortraits(frame)
    if frame.portrait then
        if (UnitIsPlayer(frame.unit) and db.general.classPortraits) then
            PlayerClassPortraits(frame)
        else
            NonPlayerPortraits(frame)
        end
    end
end