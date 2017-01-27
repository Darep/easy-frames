--[[
    Appreciate what others people do.

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

local EasyFrames = LibStub("AceAddon-3.0"):NewAddon("EasyFrames", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")
local db

local function CustomReadableNumber(num, format, useFullValues)
    local ret

    if not num then
        return 0
    elseif num >= 1000000000 then
        ret = string.format(format["gt1B"], num / (useFullValues or 1000000000))  -- num > 1 000 000 000
    elseif num >= 100000000 then
        ret = string.format(format["gt100M"], num / (useFullValues or 1000000)) -- num > 100 000 000
    elseif num >= 10000000 then
        ret = string.format(format["gt10M"], num / (useFullValues or 1000000)) -- num > 10 000 000
    elseif num >= 1000000 then
        ret = string.format(format["gt1M"], num / (useFullValues or 1000000)) -- num > 1 000 000
    elseif num >= 100000 then
        ret = string.format(format["gt100T"], num / (useFullValues or 1000)) -- num > 100 000
    elseif num >= 1000 then
        ret = string.format(format["gt1T"], num / (useFullValues or 1000)) -- num > 1000
    else
        ret = num -- num < 1000
    end
    return ret
end

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
            buffSize = 22,
            selfBuffSize = 28,
            highlightDispelledBuff = true,
            dispelledBuffScale = 1,
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
            useHealthFormatFullValues = false,
            customHealthFormatFormulas = {
                ["gt1T"] = "%.fk",
                ["gt100T"] = "%.fk",
                ["gt1M"] = "%.1fM",
                ["gt10M"] = "%.fM",
                ["gt100M"] = "%.fM",
                ["gt1B"] = "%.fB",
            },
            customHealthFormat = "%CURRENT% / %MAX% (%PERCENT%%)",
            showName = true,
            showHitIndicator = true,
            showSpecialbar = true,
            showRestIcon = true,
            showStatusTexture = false,
            showAttackBackground = true,
            attackBackgroundOpacity = 0.7,
            showGroupIndicator = true,
            showRoleIcon = false,
        },

        target = {
            scaleFrame = 1.2,
            healthFormat = "3",
            useHealthFormatFullValues = false,
            customHealthFormatFormulas = {
                ["gt1T"] = "%.fk",
                ["gt100T"] = "%.fk",
                ["gt1M"] = "%.1fM",
                ["gt10M"] = "%.fM",
                ["gt100M"] = "%.fM",
                ["gt1B"] = "%.fB",
            },
            customHealthFormat = "%CURRENT% / %MAX% (%PERCENT%%)",
            showToTFrame = true,
            showAttackBackground = false,
            attackBackgroundOpacity = 0.7,
            showTargetCastbar = false,
        },

        focus = {
            scaleFrame = 1.2,
            healthFormat = "3",
            useHealthFormatFullValues = false,
            customHealthFormatFormulas = {
                ["gt1T"] = "%.fk",
                ["gt100T"] = "%.fk",
                ["gt1M"] = "%.1fM",
                ["gt10M"] = "%.fM",
                ["gt100M"] = "%.fM",
                ["gt1B"] = "%.fB",
            },
            customHealthFormat = "%CURRENT% / %MAX% (%PERCENT%%)",
            showToTFrame = true,
            showAttackBackground = false,
            attackBackgroundOpacity = 0.7,
        },

        pet = {
            showName = true,
            showHitIndicator = true,
            showStatusTexture = true,
            showAttackBackground = true,
            attackBackgroundOpacity = 0.7,
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

Media:Register("misc", "player-status", "Interface\\AddOns\\EasyFrames\\Textures\\TargetingFrame\\UI-Player-Status")
--Media:Register("frames", "target-nomana", "Interface\\AddOns\\EasyFrames\\Textures\\TargetingFrame\\UI-SmallTargetingFramex-NoMana")


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
function EasyFrames.Utils.UpdateHealthValues(frame, healthFormat, customHealthFormat, customHealthFormatFormulas, useHealthFormatFullValues)
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

    elseif (healthFormat == "3") then
        -- Current + Max + Percent

        if (UnitHealth(frame) > 0) then
            local Health = UnitHealth(frame)
            local HealthMax = UnitHealthMax(frame)
            local HealthPercent = (UnitHealth(frame) / UnitHealthMax(frame)) * 100

            _G[frame .. "FrameHealthBar"].TextString:SetText(ReadableNumber(Health) .. " / " .. ReadableNumber(HealthMax) .. " (" .. string.format("%.0f", HealthPercent) .. "%)");
        end

    elseif (healthFormat == "4") then
        -- Current + Percent

        if (UnitHealth(frame) > 0) then
            local Health = UnitHealth(frame)
            local HealthPercent = (UnitHealth(frame) / UnitHealthMax(frame)) * 100

            _G[frame .. "FrameHealthBar"].TextString:SetText(ReadableNumber(Health) .. " (" .. string.format("%.0f", HealthPercent) .. "%)");
        end

    elseif (healthFormat == "custom") then
        -- Own format

        if (UnitHealth(frame) > 0) then
            local Health = UnitHealth(frame)
            local HealthMax = UnitHealthMax(frame)
            local HealthPercent = (UnitHealth(frame) / UnitHealthMax(frame)) * 100

            local useFullValues = false
            if (useHealthFormatFullValues) then
                useFullValues = 1
            end

            Health = CustomReadableNumber(Health, customHealthFormatFormulas, useFullValues)
            HealthMax = CustomReadableNumber(HealthMax, customHealthFormatFormulas, useFullValues)

            local Result = string.gsub(string.gsub(string.gsub(customHealthFormat, "%%PERCENT%%", string.format("%.0f", HealthPercent)), "%%MAX%%", HealthMax), "%%CURRENT%%", Health)

            _G[frame .. "FrameHealthBar"].TextString:SetText( Result );
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


