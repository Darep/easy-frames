local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Player"
local Player = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db
local originalValues = {}
local UpdateHealthValues = EasyFrames.Utils.UpdateHealthValues


function Player:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile

end

function Player:OnEnable()
    self:GetOriginalValues()

    self:SetScale(db.player.scaleFrame)
    self:ShowName(db.player.showName)
    self:ShowHitIndicator(db.player.showHitIndicator)
    self:ShowSpecialbar(db.player.showSpecialbar)
    self:ShowRestIcon(db.player.showRestIcon)
    self:ShowStatusTexture(db.player.showStatusTexture)
    self:ShowAttackBackground(db.player.showAttackBackground)

    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateHealthValues")
end

function Player:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetScale(db.player.scaleFrame)
    self:ShowName(db.player.showName)
    self:ShowHitIndicator(db.player.showHitIndicator)
    self:ShowSpecialbar(db.player.showSpecialbar)
    self:ShowRestIcon(db.player.showRestIcon)
    self:ShowStatusTexture(db.player.showStatusTexture)
    self:ShowAttackBackground(db.player.showAttackBackground)

    self:UpdateHealthValues()
end


function Player:GetOriginalValues()
    originalValues["PlayerHitIndicator"] = PlayerHitIndicator.SetText

    originalValues["PlayerRestGlow"] = PlayerRestGlow.Show
    originalValues["PlayerRestIcon"] = PlayerRestIcon.Show

    originalValues["PlayerStatusGlow"] = PlayerStatusGlow.Show
    originalValues["PlayerStatusTexture"] = PlayerStatusTexture.Show

    originalValues["PlayerAttackGlow"] = PlayerAttackGlow.Show
    originalValues["PlayerAttackBackground"] = PlayerAttackBackground.Show
    originalValues["PlayerFrameFlash"] = PlayerFrameFlash.Show

    originalValues["PlayerFrameGroupIndicator"] = PlayerFrameGroupIndicator.Show
end

function Player:SetScale(value)
    PlayerFrame:SetScale(value)
end

function Player:ShowName(value)
    if (value) then
        PlayerName:Show()
    else
        PlayerName:Hide()
    end
end

function Player:ShowHitIndicator(value)
    if (value) then
        PlayerHitIndicator.SetText = originalValues["PlayerHitIndicator"]
    else
        PlayerHitIndicator:SetText(nil)
        PlayerHitIndicator.SetText = function() end
    end
end

function Player:ShowSpecialbar(value)
    local SpecialbarOnShow = function(frame)
        frame:Hide()
    end

    local _, englishClass = UnitClass("player");

    for _, objname in ipairs({
        "MonkHarmonyBarFrame",
        "PriestBarFrame",
        "PaladinPowerBarFrame",
        "WarlockPowerFrame",
        "EclipseBarFrame",
        "TotemFrame",
        "RuneFrame",
    }) do
        local frame = _G[objname]

        if (frame) and (englishClass == frame.class) then
            if (value) then
                self:Unhook(frame, "OnShow")
                frame:Show()
            else
                frame:Hide()
                self:HookScript(frame, "OnShow", SpecialbarOnShow)
            end
        end
    end
end

function Player:UpdateHealthValues()
    local frame = "Player"
    local healthFormat = db.player.healthFormat

    UpdateHealthValues(frame, healthFormat)
end

function Player:ShowRestIcon(value)
    local noop = function() return end

    for _, frame in pairs({
        PlayerRestGlow,
        PlayerRestIcon,
    }) do
        if frame then
            if (value) then
                frame.Show = originalValues[frame:GetName()]

                if (IsResting("player")) then
                    frame:Show()
                end
            else
                frame:Hide()
                frame.Show = noop
            end
        end
    end
end

function Player:ShowStatusTexture(value)
    local noop = function() return end

    for _, frame in pairs({
        PlayerStatusGlow,
        PlayerStatusTexture,
    }) do
        if frame then
            if (value) then
                frame.Show = originalValues[frame:GetName()]

                if (IsResting("player") or UnitAffectingCombat("player")) then
                    frame:Show()
                end
            else
                frame:Hide()
                frame.Show = noop
            end
        end
    end
end


function Player:ShowAttackBackground(value)
    local noop = function() return end

    for _, frame in pairs({
        PlayerAttackGlow,
        PlayerAttackBackground,
        PlayerFrameFlash,
    }) do
        if frame then
            if (value) then
                frame.Show = originalValues[frame:GetName()]

                if (UnitAffectingCombat("player")) then
                    frame:Show()
                end
            else
                frame:Hide()
                frame.Show = noop
            end
        end
    end
end

function Player:ShowGroupIndicator(value)
    local noop = function() return end

    for _, frame in pairs({
        PlayerFrameGroupIndicator
    }) do
        if frame then
            if (value) then
                frame.Show = originalValues[frame:GetName()]

                if (IsInRaid("player")) then
                    frame:Show()
                end
            else
                frame:Hide()
                frame.Show = noop
            end
        end
    end
end