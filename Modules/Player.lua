local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Player"
local Player = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db
local originalValues = {}

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
end

function Player:GetOriginalValues()
    originalValues["PlayerHitIndicator"] = PlayerHitIndicator.SetText
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