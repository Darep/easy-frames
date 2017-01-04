
local EasyFrames = LibStub("AceAddon-3.0"):NewAddon("EasyFrames", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")
local db

local function ReadableNumber(num, places)
    local ret
    -- local placeValue = ("%%.%d1f"):format(places or 0)
    if not num then
        return 0
    elseif num >= 1000000000 then
        ret = string.format("%.0f", num / 1000000000) .. "B" -- billion
    elseif num >= 100000000 then
        ret = string.format("%.3s", num) .. "M" -- millions > 100
    elseif num >= 10000000 then
        ret = string.format("%.2s", num) .. "M" -- million > 10
    elseif num >= 1000000 then
        ret = string.format("%.4s", num) .. "T" -- million > 1
    elseif num >= 100000 then
        ret = string.format("%.3s", num) .. "T" -- thousand > 100
    elseif num >= 10000 then
        ret = string.format("%.0f", num / 1000) .. "T" -- thousand
    else
        ret = num -- hundreds
    end
    return ret
end


local defaults = {
    profile = {
        general = {
            classColored = true,
            coloredBaseOnCurrentHealth = false,
            customBuffSize = true,
            buffSize = 20,
            selfBuffSize = 28,
            highlightDispelledBuff = true,
            classPortraits = true,
            barTexture = "Blizzard",
            brightFrameBorder = 1,
            friendlyFrameDefaultColors = {0, 1, 0},
            enemyFrameDefaultColors = {1, 0, 0},
            neutralFrameDefaultColors = {1, 1, 0},
            showWelcomeMessage = true,
        },

        player = {
            scaleFrame = 1.2,
            healthFormat = "3",
            showName = true,
            showHitIndicator = true,
            showSpecialbar = true,
        },

        target = {
            scaleFrame = 1.2,
            healthFormat = "3",
            showToTFrame = true,
        },

        focus = {
            scaleFrame = 1.2,
            healthFormat = "3",
            showToTFrame = true,
        },

        pet = {
            showName = true,
            showHitIndicator = true,
        },
    }
}

Media:Register("bartexture", "Ace", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\Ace")
Media:Register("bartexture", "Aluminium", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\Aluminium")
Media:Register("bartexture", "Banto", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\banto")
Media:Register("bartexture", "Blizzard", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\blizzard")
Media:Register("bartexture", "Charcoal", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\Charcoal")
Media:Register("bartexture", "Glaze", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\glaze")
Media:Register("bartexture", "LiteStep", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\LiteStep")
Media:Register("bartexture", "Minimalist", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\Minimalist")
Media:Register("bartexture", "Otravi", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\otravi")
Media:Register("bartexture", "Perl", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\perl")
Media:Register("bartexture", "Smooth", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\smooth")
Media:Register("bartexture", "Striped", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\striped")
Media:Register("bartexture", "Swag", "Interface\\AddOns\\EasyFrames\\Textures\\StatusBarTexture\\swag")


Media:Register("frames", "default", "Interface\\AddOns\\EasyFrames\\Textures\\TargetingFrame\\UI-TargetingFrame")
Media:Register("frames", "minus", "Interface\\AddOns\\EasyFrames\\Textures\\TargetingFrame\\UI-TargetingFrame-Minus")
Media:Register("frames", "elite", "Interface\\AddOns\\EasyFrames\\Textures\\TargetingFrame\\UI-TargetingFrame-Elite")
Media:Register("frames", "rareelite", "Interface\\AddOns\\EasyFrames\\Textures\\TargetingFrame\\UI-TargetingFrame-Rare-Elite")
Media:Register("frames", "rare", "Interface\\AddOns\\EasyFrames\\Textures\\TargetingFrame\\UI-TargetingFrame-Rare")


function EasyFrames:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("EasyFramesDB", defaults, true)

    self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
    self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

    db = self.db.profile

    self:SetupOptions()
end


function EasyFrames:OnProfileChanged(event, database, newProfileKey)
    self.db = database
    db = self.db.profile

    for _, v in self:IterateModules() do
        if (v.OnProfileChanged) then
            v:OnProfileChanged(database)
        end
    end
end

EasyFrames.Utils = {};
function EasyFrames.Utils.UpdateHealthValues(frame, healthFormat)
    if (healthFormat == "1") then
        -- Percent
        if (UnitHealth(frame) > 0) then
            local HealthPercent = (UnitHealth(frame) / UnitHealthMax(frame)) * 100

            _G[frame .. "FrameHealthBar"].TextString:SetText(format("%.0f", HealthPercent) .. "%")
        end

    elseif (healthFormat == "2") then
        -- Current + Max

        if (UnitHealth(frame) > 0) then
            local Health = UnitHealth(frame)
            local HealthMax = UnitHealthMax(frame)

            _G[frame .. "FrameHealthBar"].TextString:SetText(ReadableNumber(Health) .. " / " .. ReadableNumber(HealthMax));
        end
    else
        -- Current + Max + Percent

        if (UnitHealth(frame) > 0) then
            local Health = UnitHealth(frame)
            local HealthMax = UnitHealthMax(frame)
            local HealthPercent = (UnitHealth(frame) / UnitHealthMax(frame)) * 100

            _G[frame .. "FrameHealthBar"].TextString:SetText(ReadableNumber(Health) .. " / " .. ReadableNumber(HealthMax) .. " (" .. string.format("%.0f", HealthPercent) .. "%)");
        end
    end
end

function EasyFrames.Utils.GetFramesHealthBar()
    return {
        PlayerFrameHealthBar,
        TargetFrameHealthBar,
        TargetFrameToTHealthBar,
        FocusFrameHealthBar,
        FocusFrameToTHealthBar,
        PetFrameHealthBar,
    }
end

function EasyFrames.Utils.GetFramesManaBar()
    return {
        PlayerFrameManaBar,
        TargetFrameManaBar,
        TargetFrameToTManaBar,
        FocusFrameManaBar,
        FocusFrameToTManaBar,
        PetFrameManaBar,
    }
end


