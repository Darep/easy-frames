
local EasyFrames = LibStub("AceAddon-3.0"):NewAddon("EasyFrames", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")
local db


local defaults = {
    profile = {
        general = {
            classColored = true,
            coloredBaseOnCurrentHealth = false,
            customBuffSize = true, -- buffsizebutton
            buffSize = 20, -- buffsize
            selfBuffSizeScale = 1.4, -- scaleselfbuffsize
            classPortraits = true,
            barTexture = "Blizzard", -- bartex
            darkFrameBorder = 0, -- darkentextures
            friendlyTargetDefaultColors = {0, 1, 0},
            enemyTargetDefaultColors = {1, 0, 0},
        },

        player = {
            scaleFrame = 1.2, -- framescaleplayer
            healthFormat = "3",
            showName = true, -- playername
            showHitIndicator = true, -- playerhitindi
            showSpecialbar = true, -- playerspecialbar

            classColored = true, -- classcolorplayer
            coloredBaseOnCurrentHealth = false, -- percentcolorplayer
        },

        target = {
            scaleFrame = 1.2, -- framescaletarget
            healthFormat = "3",
            showToTFrame = true, -- targetoftarget

            classColored = true, -- classcolortarget
            classColoredToT = true, -- classcolorttot
            coloredBaseOnCurrentHealth = false, -- percentcolortarget
            coloredToTBaseOnCurrentHealth = false, -- percentcolortargettot
        },

        focus = {
            scaleFrame = 1.2, -- framescalefocus
            healthFormat = "3",
            showFrameToT = true, -- targetoffocus

            classColored = true, -- classcolorFocus
            classColoredToT = true, -- classcolorftot
            coloredBaseOnCurrentHealth = false, -- percentcolorfocus
            coloredToTBaseOnCurrentHealth = false, -- percentcolorfocustot
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


function EasyFrames:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("EasyFramesDB", defaults, true)
    db = self.db.profile

    self:SetupOptions()
end

--function EasyFrames:GetModuleEnabled(module)
--    return db.modules[module]
--end



