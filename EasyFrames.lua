
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
            classColored = true, -- classcolorplayer, classcolortarget, classcolorttot, classcolorFocus, classcolorftot
            coloredBaseOnCurrentHealth = false, -- percentcolorplayer, percentcolortarget, percentcolortargettot, percentcolorfocus, percentcolorfocustot
            customBuffSize = true, -- buffsizebutton
            buffSize = 20, -- buffsize
            selfBuffSize = 28, -- scaleselfbuffsize
            highlightDispelledBuff = true,
            classPortraits = true, -- classportraits
            barTexture = "Blizzard", -- bartex
            brightFrameBorder = 1, -- darkentextures
            friendlyFrameDefaultColors = {0, 1, 0},
            enemyFrameDefaultColors = {1, 0, 0},
            neutralFrameDefaultColors = {1, 1, 0},
            showWelcomeMessage = true,
        },

        player = {
            scaleFrame = 1.2, -- framescaleplayer
            healthFormat = "3", -- phformat
            showName = true, -- playername
            showHitIndicator = true, -- playerhitindi
            showSpecialbar = true, -- playerspecialbar
        },

        target = {
            scaleFrame = 1.2, -- framescaletarget
            healthFormat = "3", -- thformat
            showToTFrame = true, -- targetoftarget
        },

        focus = {
            scaleFrame = 1.2, -- framescalefocus
            healthFormat = "3", -- fhformat
            showToTFrame = true, -- targetoffocus
        },

        pet = {
            showName = true, -- petname
            showHitIndicator = true, -- pethitindi
        },
    }
}

Media:Register("bartexture", "Ace", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Ace")
Media:Register("bartexture", "Aluminium", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Aluminium")
Media:Register("bartexture", "Banto", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Banto")
Media:Register("bartexture", "Blizzard", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Blizzard")
Media:Register("bartexture", "Charcoal", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Charcoal")
Media:Register("bartexture", "Glaze", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Glaze")
Media:Register("bartexture", "LiteStep", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\LiteStep")
Media:Register("bartexture", "Minimalist", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Minimalist")
Media:Register("bartexture", "Otravi", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Otravi")
Media:Register("bartexture", "Perl", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Perl")
Media:Register("bartexture", "Smooth", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Smooth")
Media:Register("bartexture", "Striped", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Striped")
Media:Register("bartexture", "Swag", "Interface\\AddOns\\EasyFrames\\Textures\\FramesBarTextures\\Swag")


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

function EasyFrames:OnEnable()

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


