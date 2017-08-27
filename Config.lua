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
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")


local pairs, unpack, type = pairs, unpack, type

local function getOpt(info)
    local ns = info.arg
    local key = info[#info]
    local val = EasyFrames.db.profile[ns][key]

    if type(val) == "table" then
        return unpack(val)
    else
        return val
    end
end

local function setOpt(info, value)
    local ns = info.arg
    local key = info[#info]
    EasyFrames.db.profile[ns][key] = value
end

local function getColor(info)
    return getOpt(info)
end

local function setColor(info, r, g, b)
    local ns = info.arg
    local key = info[#info]
    local color = {r, g, b}
    EasyFrames.db.profile[ns][key] = color

    EasyFrames:GetModule("General"):SetFramesColored()
end

local function getDeepOpt(info)
    local ns, opt = string.split(".", info.arg)
    local key = info[#info]
    local val = EasyFrames.db.profile[ns][opt][key]

    return val
end

local function getOptionName(name)
    return "EasyFrames" .. " - " .. name
end

local healthFormat = {
    ["1"] = L["Percent"], --1
    ["2"] = L["Current + Max"], --2
    ["3"] = L["Current + Max + Percent"], --3
    ["4"] = L["Current + Percent"], --4
    ["custom"] = L["Custom format"], --custom
}

local manaFormat = {
    ["1"] = L["Percent"], --1
    ["2"] = L["Smart"], --2
    ["custom"] = L["Custom format"], --custom
}

local fontStyle = {
    ["NONE"] = L["None"],
    ["OUTLINE"] = L["Outline"],
    ["THICKOUTLINE"] = L["Thickoutline"],
    ["MONOCHROME"] = L["Monochrome"]
}

local MIN_RANGE = 6
local MAX_RANGE = 18


local generalOptions = {
    name = getOptionName(L["Main options"]),
    desc = L["Main options"],
    type = "group",
    args = {
        desc = {
            type = "description",
            order = 1,
            name = L["In main options you can set the global options like colored frames, class portraits, etc"],
        },

        framesGroup = {
            type = "group",
            order = 2,
            name = "",
            inline = true,
            get = getOpt,
            set = setOpt,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Frames"]
                },

                description = {
                    type = "description",
                    order = 2,
                    name = L["Setting for unit frames"],
                },

                classColored = {
                    type = "toggle",
                    order = 3,
                    name = L["Class colored healthbars"],
                    desc = L["If checked frames becomes class colored.\n\n" ..
                            "This option excludes the option 'Healthbar color is based on the current health value'"],
                    disabled = function()
                        if (EasyFrames.db.profile.general.colorBasedOnCurrentHealth) then
                            return true
                        end
                    end,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetFramesColored()
                    end,
                    arg = "general"
                },

                colorBasedOnCurrentHealth = {
                    type = "toggle",
                    order = 4,
                    disabled = function()
                        if (EasyFrames.db.profile.general.classColored) then
                            return true
                        end
                    end,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetFramesColored()
                    end,
                    width = "double",
                    name = L["Healthbar color is based on the current health value"],
                    desc = L["Healthbar color is based on the current health value.\n\n" ..
                            "This option excludes the option 'Class colored healthbars'"],
                    arg = "general"
                },

                classPortraits = {
                    type = "toggle",
                    order = 5,
                    name = L["Class portraits"],
                    desc = L["Replaces the unit-frame portrait with their class icon"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetClassPortraits()
                    end,
                    arg = "general"
                },

                newLine = {
                    type = "description",
                    order = 6,
                    name = "",
                },

                hideOutOfCombat = {
                    type = "toggle",
                    order = 7,
                    name = L["Hide frames out of combat"],
                    desc = L["Hide frames out of combat (for example in resting)"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):HideFramesOutOfCombat()
                    end,
                    arg = "general"
                },

--                hideOutOfCombatWithFullHP = {
--                    type = "toggle",
--                    order = 8,
--                    name = L["Only if HP equal to 100%"],
--                    desc = L["Hide frames out of combat only if HP equal to 100%"],
--                    set = function(info, value)
--                        setOpt(info, value)
--                        EasyFrames:GetModule("General"):HideFramesOutOfCombat()
--                    end,
--                    disabled = function()
--                        local diabled = EasyFrames.db.profile.general.hideOutOfCombat
--                        if (diabled == false) then
--                            return true
--                        end
--                    end,
--                    arg = "general"
--                },

                hideOutOfCombatOpacity = {
                    type = "range",
                    order = 8,
                    name = L["Opacity of frames"],
                    desc = L["Opacity of frames when frames is hidden (in out of combat)"],
                    min = 0,
                    max = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):HideFramesOutOfCombat()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.general.hideOutOfCombat
                        if (diabled == false) then
                            return true
                        end
                    end,
                    isPercent = true,
                    arg = "general"
                },

                newLine2 = {
                    type = "description",
                    order = 9,
                    name = "",
                },

                barTexture = {
                    type = "select",
                    order = 10,
                    dialogControl = "LSM30_Statusbar",
                    name = L["Texture"],
                    desc = L["Set the frames bar Texture"],
                    values = Media:HashTable("statusbar"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetFrameBarTexture(value)
                    end,
                    arg = "general"
                },

                lightTexture = {
                    type = "toggle",
                    order = 11,
                    name = L["Use a light texture"],
                    desc = L["Use a brighter texture (like Blizzard's default texture)"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetLightTexture(value)
                    end,
                    arg = "general"
                },

                brightFrameBorder = {
                    type = "range",
                    order = 12,
                    name = L["Bright frames border"],
                    desc = L["You can set frames border bright/dark color. From bright to dark. 0 - dark, 100 - bright"],
                    min = 0,
                    max = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetBrightFramesBorder(value)
                    end,
                    isPercent = true,
                    arg = "general"
                },
            }
        },

        buffsGroup = {
            type = "group",
            order = 3,
            inline = true,
            name = "",
            get = getOpt,
            set = setOpt,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Buffs"],
                },

                description = {
                    type = "description",
                    order = 2,
                    name = L["Buffs settings (like custom buffsize, highlight dispelled buffs, etc)"],
                },

                customBuffSize = {
                    type = "toggle",
                    order = 3,
                    name = L["Turn on custom buffsize"],
                    desc = L["Turn on custom target and focus frames buffsize"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetCustomBuffSize(value)
                    end,
                    arg = "general"
                },

                buffSize = {
                    type = "range",
                    order = 4,
                    name = L["Buffsize"],
                    desc = L["Buffsize"],
                    min = 10,
                    max = 40,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetCustomBuffSize(true)
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.general.customBuffSize
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "general"
                },

                selfBuffSize = {
                    type = "range",
                    order = 5,
                    name = L["Self buffsize"],
                    desc = L["Buffsize that you create"],
                    min = 10,
                    max = 40,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetCustomBuffSize(true)
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.general.customBuffSize
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "general"
                },

                highlightDispelledBuff = {
                    type = "toggle",
                    order = 6,
                    name = L["Highlight dispelled buffs"],
                    desc = L["Highlight buffs that can be dispelled from target frame"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetHighlightDispelledBuff()
                    end,
                    arg = "general"
                },

                ifPlayerCanDispelBuff = {
                    type = "toggle",
                    order = 7,
                    name = L["Only if player can dispel them"],
                    desc = L["Highlight dispelled buffs only if player can dispel them"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetHighlightDispelledBuff()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.general.highlightDispelledBuff
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "general"
                },

                dispelledBuffScale = {
                    type = "range",
                    order = 8,
                    name = L["Dispelled buff scale"],
                    desc = L["Dispelled buff scale that can be dispelled from target frame"],
                    min = 1,
                    max = 1.5,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):TargetFrame_UpdateAuras(TargetFrame)
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.general.highlightDispelledBuff
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "general"
                },
            }
        },

        framesCorolsGroup = {
            type = "group",
            order = 4,
            inline = true,
            name = "",
            get = getColor,
            set = setColor,
            disabled = function()
                if (EasyFrames.db.profile.general.colorBasedOnCurrentHealth) then
                    return true
                end
            end,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Frames colors"],
                },

                description = {
                    type = "description",
                    order = 2,
                    name = L["In this section you can set the default colors for friendly, enemy and neutral frames"],
                },

                friendlyFrameDefaultColors = {
                    type = "color",
                    order = 3,
                    width = "double",
                    name = L["Set default friendly healthbar color"],
                    desc = L["You can set the default friendly healthbar color for frames"],
                    arg = "general"
                },

                friendlyFrameDefaultColorsReset = {
                    type = "execute",
                    order = 4,
                    name = L["Reset color to default"],

                    func = function()
                        EasyFrames:GetModule("General"):ResetFriendlyFrameDefaultColors()
                        EasyFrames:GetModule("General"):SetFramesColored()
                    end,
                },

                enemyFrameDefaultColors = {
                    type = "color",
                    order = 5,
                    width = "double",
                    name = L["Set default enemy healthbar color"],
                    desc = L["You can set the default enemy healthbar color for frames"],
                    arg = "general"
                },

                enemyTargetDefaultColorsReset = {
                    type = "execute",
                    order = 6,
                    name = L["Reset color to default"],

                    func = function()
                        EasyFrames:GetModule("General"):ResetEnemyFrameDefaultColors()
                        EasyFrames:GetModule("General"):SetFramesColored()
                    end,
                },

                neutralFrameDefaultColors = {
                    type = "color",
                    order = 7,
                    width = "double",
                    name = L["Set default neutral healthbar color"],
                    desc = L["You can set the default neutral healthbar color for frames"],
                    arg = "general"
                },

                neutralTargetDefaultColorsReset = {
                    type = "execute",
                    order = 8,
                    name = L["Reset color to default"],

                    func = function()
                        EasyFrames:GetModule("General"):ResetNeutralFrameDefaultColors()
                        EasyFrames:GetModule("General"):SetFramesColored()
                    end,
                },
            }
        },

        otherGroup = {
            type = "group",
            order = 5,
            inline = true,
            name = "",
            get = getOpt,
            set = setOpt,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Other"],
                },

                description = {
                    type = "description",
                    order = 2,
                    name = L["In this section you can set the settings like 'show welcome message' etc"],
                },

                showWelcomeMessage = {
                    type = "toggle",
                    order = 3,
                    name = L["Show welcome message"],
                    desc = L["Show welcome message when addon is loaded"],
                    arg = "general"
                },
            }
        },
    },
}

local playerOptions = {
    name = getOptionName(L["Player"]),
    type = "group",
    get = getOpt,
    set = setOpt,
    args = {
        desc = {
            type = "description",
            order = 1,
            name = L["In player options you can set scale player frame, healthbar text format, etc"],
        },

        scaleFrame = {
            type = "range",
            order = 2,
            name = L["Player frame scale"],
            desc = L["Scale of player unit frame"],
            min = 0.5,
            max = 2,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Player"):SetScale(value)
            end,
            arg = "player"
        },

        HPManaFormatOptions = {
            type = "group",
            order = 3,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["HP and MP bars"],
                },

                healthFormat = {
                    type = "select",
                    order = 2,
                    name = L["Player healthbar text format"],
                    desc = L["Set the player healthbar text format"],
                    values = healthFormat,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):UpdateTextStringWithValues()
                    end,
                    arg = "player"
                },

                healthBarFontFamily = {
                    order = 3,
                    name = L["Font family"],
                    desc = L["Healthbar font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):SetHealthBarsFont()
                    end,
                    arg = "player"
                },

                healthBarFontSize = {
                    type = "range",
                    order = 4,
                    name = L["Font size"],
                    desc = L["Healthbar font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):SetHealthBarsFont()
                    end,
                    arg = "player"
                },

                manaFormat = {
                    type = "select",
                    order = 5,
                    name = L["Player manabar text format"],
                    desc = L["Set the player manabar text format"],
                    values = manaFormat,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):UpdateTextStringWithValues(PlayerFrameManaBar)
                    end,
                    arg = "player"
                },

                manaBarFontFamily = {
                    order = 6,
                    name = L["Font family"],
                    desc = L["Manabar font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):SetManaBarsFont()
                    end,
                    arg = "player"
                },

                manaBarFontSize = {
                    type = "range",
                    order = 7,
                    name = L["Font size"],
                    desc = L["Manabar font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):SetManaBarsFont()
                    end,
                    arg = "player"
                },
            }
        },

        HPFormat = {
            type = "group",
            order = 4,
            inline = true,
            name = "",
            hidden = function()
                local healthFormat = EasyFrames.db.profile.player.healthFormat
                if (healthFormat == "custom") then
                    return false
                end

                return true
            end,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Custom format of HP"],
                },

                desc = {
                    type = "description",
                    order = 2,
                    name = L["You can set custom HP format. More information about custom HP format you can read on project site.\n\n" ..
                            "Formulas:"],
                },

                customHealthFormatFormulas = {
                    type = "group",
                    order = 3,
                    inline = true,
                    name = "",
                    get = getDeepOpt,
                    set = function(info, value)
                        local ns, opt = string.split(".", info.arg)
                        local key = info[#info]
                        EasyFrames.db.profile[ns][opt][key] = value

                        EasyFrames:GetModule("Player"):UpdateTextStringWithValues()
                    end,
                    args = {
                        gt1T = {
                            type = "input",
                            order = 1,
                            name = L["Value greater than 1000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],

                            arg = "player.customHealthFormatFormulas"
                        },
                        gt100T = {
                            type = "input",
                            order = 2,
                            name = L["Value greater than 100 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customHealthFormatFormulas"
                        },

                        gt1M = {
                            type = "input",
                            order = 3,
                            name = L["Value greater than 1 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customHealthFormatFormulas"
                        },

                        gt10M = {
                            type = "input",
                            order = 4,
                            name = L["Value greater than 10 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customHealthFormatFormulas"
                        },

                        gt100M = {
                            type = "input",
                            order = 5,
                            name = L["Value greater than 100 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customHealthFormatFormulas"
                        },

                        gt1B = {
                            type = "input",
                            order = 6,
                            name = L["Value greater than 1 000 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customHealthFormatFormulas"
                        },
                    }
                },

                useHealthFormatFullValues = {
                    type = "toggle",
                    order = 4,
                    name = L["Use full values of health"],
                    desc = L["By default all formulas use divider (for value eq 1000 and more it's 1000, for 1 000 000 and more it's 1 000 000, etc).\n\n" ..
                            "If checked formulas will use full values of HP (without divider)"],
                    arg = "player",
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):UpdateTextStringWithValues()
                    end,
                },

                customHealthFormat = {
                    type = "input",
                    order = 5,
                    width = "double",
                    name = L["Displayed HP by pattern"],
                    desc = L["You can use patterns:\n\n" ..
                            "%CURRENT% - return current health\n" ..
                            "%MAX% - return maximum of health\n" ..
                            "%PERCENT% - return percent of current/max health\n\n" ..
                            "All values are returned from formulas. For set abbreviation use formulas' fields"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):UpdateTextStringWithValues()
                    end,
                    arg = "player"
                },
            }
        },

        manaFormat = {
            type = "group",
            order = 5,
            inline = true,
            name = "",
            hidden = function()
                local manaFormat = EasyFrames.db.profile.player.manaFormat
                if (manaFormat == "custom") then
                    return false
                end

                return true
            end,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Custom format of mana"],
                },

                desc = {
                    type = "description",
                    order = 2,
                    name = L["You can set custom mana format. More information about custom mana format you can read on project site.\n\n" ..
                            "Formulas:"],
                },

                customManaFormatFormulas = {
                    type = "group",
                    order = 3,
                    inline = true,
                    name = "",
                    get = getDeepOpt,
                    set = function(info, value)
                        local ns, opt = string.split(".", info.arg)
                        local key = info[#info]
                        EasyFrames.db.profile[ns][opt][key] = value

                        EasyFrames:GetModule("Player"):UpdateTextStringWithValues(PlayerFrameManaBar)
                    end,
                    args = {
                        gt1T = {
                            type = "input",
                            order = 1,
                            name = L["Value greater than 1000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],

                            arg = "player.customManaFormatFormulas"
                        },
                        gt100T = {
                            type = "input",
                            order = 2,
                            name = L["Value greater than 100 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customManaFormatFormulas"
                        },

                        gt1M = {
                            type = "input",
                            order = 3,
                            name = L["Value greater than 1 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customManaFormatFormulas"
                        },

                        gt10M = {
                            type = "input",
                            order = 4,
                            name = L["Value greater than 10 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customManaFormatFormulas"
                        },

                        gt100M = {
                            type = "input",
                            order = 5,
                            name = L["Value greater than 100 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customManaFormatFormulas"
                        },

                        gt1B = {
                            type = "input",
                            order = 6,
                            name = L["Value greater than 1 000 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "player.customManaFormatFormulas"
                        },
                    }
                },

                useManaFormatFullValues = {
                    type = "toggle",
                    order = 4,
                    name = L["Use full values of mana"],
                    desc = L["By default all formulas use divider (for value eq 1000 and more it's 1000, for 1 000 000 and more it's 1 000 000, etc).\n\n" ..
                            "If checked formulas will use full values of mana (without divider)"],
                    arg = "player",
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):UpdateTextStringWithValues(PlayerFrameManaBar)
                    end,
                },

                customManaFormat = {
                    type = "input",
                    order = 5,
                    width = "double",
                    name = L["Displayed mana by pattern"],
                    desc = L["You can use patterns:\n\n" ..
                            "%CURRENT% - return current mana\n" ..
                            "%MAX% - return maximum of mana\n" ..
                            "%PERCENT% - return percent of current/max mana\n\n" ..
                            "All values are returned from formulas. For set abbreviation use formulas' fields"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):UpdateTextStringWithValues(PlayerFrameManaBar)
                    end,
                    arg = "player"
                },
            }
        },

        frameName = {
            type = "group",
            order = 6,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Player name"],
                },

                showName = {
                    type = "toggle",
                    order = 2,
                    name = L["Show player name"],
                    desc = L["Show player name"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowName(value)
                    end,
                    arg = "player"
                },

                showNameInsideFrame = {
                    type = "toggle",
                    order = 3,
                    name = L["Show player name inside the frame"],
                    desc = L["Show player name inside the frame"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowNameInsideFrame(value)
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.player.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "player"
                },

                newLine = {
                    type = "description",
                    order = 4,
                    name = "",
                },

                playerNameFontStyle = {
                    type = "select",
                    order = 5,
                    name = L["Font style"],
                    desc = L["Player name font style"],
                    values = fontStyle,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.player.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "player"
                },

                playerNameFontFamily = {
                    order = 6,
                    name = L["Font family"],
                    desc = L["Player name font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.player.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "player"
                },

                playerNameFontSize = {
                    type = "range",
                    order = 7,
                    name = L["Font size"],
                    desc = L["Player name font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.player.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "player"
                },

            }
        },

        showHideElements = {
            type = "group",
            order = 7,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Show or hide some elements of frame"],
                },

                showHitIndicator = {
                    type = "toggle",
                    order = 2,
                    width = "double",
                    name = L["Enable hit indicators"],
                    desc = L["Show or hide the damage/heal which you take on your unit frame"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowHitIndicator(value)
                    end,
                    arg = "player"
                },

                showSpecialbar = {
                    type = "toggle",
                    order = 3,
                    width = "double",
                    name = L["Show player specialbar"],
                    desc = L["Show or hide the player specialbar, like Paladin's holy power, Priest's orbs, Monk's harmony or Warlock's soul shards"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowSpecialbar(value)
                    end,
                    arg = "player"
                },

                showRestIcon = {
                    type = "toggle",
                    order = 4,
                    width = "double",
                    name = L["Show player resting icon"],
                    desc = L["Show or hide player resting icon when player is resting (e.g. in the tavern or in the capital)"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowRestIcon(value)
                    end,
                    arg = "player"
                },

                showStatusTexture = {
                    type = "toggle",
                    order = 5,
                    width = "double",
                    name = L["Show player status texture (inside the frame)"],
                    desc = L["Show or hide player status texture (blinking glow inside the frame when player is resting or in combat)"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowStatusTexture(value)
                    end,
                    arg = "player"
                },

                showAttackBackground = {
                    type = "toggle",
                    order = 6,
                    width = "double",
                    name = L["Show player combat texture (outside the frame)"],
                    desc = L["Show or hide player red background texture (blinking red glow outside the frame in combat)"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowAttackBackground(value)
                    end,
                    arg = "player"
                },

                attackBackgroundOpacity = {
                    type = "range",
                    order = 7,
                    name = L["Opacity"],
                    desc = L["Opacity of combat texture"],
                    min = 0.1,
                    max = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):SetAttackBackgroundOpacity(value)
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.player.showAttackBackground
                        if (diabled == false) then
                            return true
                        end
                    end,
                    isPercent = true,
                    arg = "player"
                },

                showGroupIndicator = {
                    type = "toggle",
                    order = 8,
                    width = "double",
                    name = L["Show player group number"],
                    desc = L["Show or hide player group number when player is in a raid group (over portrait)"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowGroupIndicator(value)
                    end,
                    arg = "player"
                },

                showRoleIcon = {
                    type = "toggle",
                    order = 9,
                    width = "double",
                    name = L["Show player role icon"],
                    desc = L["Show or hide player role icon when player is in a group"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Player"):ShowRoleIcon(value)
                    end,
                    arg = "player"
                },

            }
        },
    },
}

local targetOptions = {
    name = getOptionName(L["Target"]),
    type = "group",
    get = getOpt,
    set = setOpt,
    args = {
        desc = {
            type = "description",
            order = 1,
            name = L["In target options you can set scale target frame, healthbar text format, etc"],
        },

        scaleFrame = {
            type = "range",
            order = 2,
            name = L["Target frame scale"],
            desc = L["Scale of target unit frame"],
            min = 0.5,
            max = 2,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Target"):SetScale(value)
            end,
            arg = "target"
        },

        HPManaFormatOptions = {
            type = "group",
            order = 3,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["HP and MP bars"],
                },

                healthFormat = {
                    type = "select",
                    order = 2,
                    name = L["Target healthbar text format"],
                    desc = L["Set the target healthbar text format"],
                    values = healthFormat,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):UpdateTextStringWithValues()
                    end,
                    arg = "target"
                },

                healthBarFontFamily = {
                    order = 3,
                    name = L["Font family"],
                    desc = L["Healthbar font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):SetHealthBarsFont()
                    end,
                    arg = "target"
                },

                healthBarFontSize = {
                    type = "range",
                    order = 4,
                    name = L["Font size"],
                    desc = L["Healthbar font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):SetHealthBarsFont()
                    end,
                    arg = "target"
                },

                manaFormat = {
                    type = "select",
                    order = 5,
                    name = L["Target manabar text format"],
                    desc = L["Set the target manabar text format"],
                    values = manaFormat,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):UpdateTextStringWithValues(TargetFrameManaBar)
                    end,
                    arg = "target"
                },

                manaBarFontFamily = {
                    order = 6,
                    name = L["Font family"],
                    desc = L["Manabar font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):SetManaBarsFont()
                    end,
                    arg = "target"
                },

                manaBarFontSize = {
                    type = "range",
                    order = 7,
                    name = L["Font size"],
                    desc = L["Manabar font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):SetManaBarsFont()
                    end,
                    arg = "target"
                },

                reverseDirectionLosingHP = {
                    type = "toggle",
                    order = 8,
                    width = "double",
                    name = L["Reverse the direction of losing health/mana"],
                    desc = L["By default direction starting from right to left. If checked direction of losing health/mana will be from left to right"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):ReverseDirectionLosingHP(value)
                    end,
                    arg = "target"
                },
            }
        },

        HPFormat = {
            type = "group",
            order = 4,
            inline = true,
            name = "",
            hidden = function()
                local healthFormat = EasyFrames.db.profile.target.healthFormat
                if (healthFormat == "custom") then
                    return false
                end

                return true
            end,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Custom format of HP"],
                },

                desc = {
                    type = "description",
                    order = 2,
                    name = L["You can set custom HP format. More information about custom HP format you can read on project site.\n\n" ..
                            "Formulas:"],
                },

                customHealthFormatFormulas = {
                    type = "group",
                    order = 3,
                    inline = true,
                    name = "",
                    get = getDeepOpt,
                    set = function(info, value)
                        local ns, opt = string.split(".", info.arg)
                        local key = info[#info]
                        EasyFrames.db.profile[ns][opt][key] = value

                        EasyFrames:GetModule("Target"):UpdateTextStringWithValues()
                    end,
                    args = {
                        gt1T = {
                            type = "input",
                            order = 1,
                            name = L["Value greater than 1000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],

                            arg = "target.customHealthFormatFormulas"
                        },
                        gt100T = {
                            type = "input",
                            order = 2,
                            name = L["Value greater than 100 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customHealthFormatFormulas"
                        },

                        gt1M = {
                            type = "input",
                            order = 3,
                            name = L["Value greater than 1 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customHealthFormatFormulas"
                        },

                        gt10M = {
                            type = "input",
                            order = 4,
                            name = L["Value greater than 10 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customHealthFormatFormulas"
                        },

                        gt100M = {
                            type = "input",
                            order = 5,
                            name = L["Value greater than 100 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customHealthFormatFormulas"
                        },

                        gt1B = {
                            type = "input",
                            order = 6,
                            name = L["Value greater than 1 000 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customHealthFormatFormulas"
                        },
                    }
                },

                useHealthFormatFullValues = {
                    type = "toggle",
                    order = 4,
                    name = L["Use full values of health"],
                    desc = L["By default all formulas use divider (for value eq 1000 and more it's 1000, for 1 000 000 and more it's 1 000 000, etc).\n\n" ..
                            "If checked formulas will use full values of HP (without divider)"],
                    arg = "target",
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):UpdateTextStringWithValues()
                    end,
                },

                customHealthFormat = {
                    type = "input",
                    order = 5,
                    width = "double",
                    name = L["Displayed HP by pattern"],
                    desc = L["You can use patterns:\n\n" ..
                            "%CURRENT% - return current health\n" ..
                            "%MAX% - return maximum of health\n" ..
                            "%PERCENT% - return percent of current/max health\n\n" ..
                            "All values are returned from formulas. For set abbreviation use formulas' fields"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):UpdateTextStringWithValues()
                    end,
                    arg = "target"
                },
            }
        },

        manaFormat = {
            type = "group",
            order = 5,
            inline = true,
            name = "",
            hidden = function()
                local manaFormat = EasyFrames.db.profile.target.manaFormat
                if (manaFormat == "custom") then
                    return false
                end

                return true
            end,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Custom format of mana"],
                },

                desc = {
                    type = "description",
                    order = 2,
                    name = L["You can set custom mana format. More information about custom mana format you can read on project site.\n\n" ..
                            "Formulas:"],
                },

                customManaFormatFormulas = {
                    type = "group",
                    order = 3,
                    inline = true,
                    name = "",
                    get = getDeepOpt,
                    set = function(info, value)
                        local ns, opt = string.split(".", info.arg)
                        local key = info[#info]
                        EasyFrames.db.profile[ns][opt][key] = value

                        EasyFrames:GetModule("Target"):UpdateTextStringWithValues(TargetFrameManaBar)
                    end,
                    args = {
                        gt1T = {
                            type = "input",
                            order = 1,
                            name = L["Value greater than 1000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],

                            arg = "target.customManaFormatFormulas"
                        },
                        gt100T = {
                            type = "input",
                            order = 2,
                            name = L["Value greater than 100 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customManaFormatFormulas"
                        },

                        gt1M = {
                            type = "input",
                            order = 3,
                            name = L["Value greater than 1 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customManaFormatFormulas"
                        },

                        gt10M = {
                            type = "input",
                            order = 4,
                            name = L["Value greater than 10 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customManaFormatFormulas"
                        },

                        gt100M = {
                            type = "input",
                            order = 5,
                            name = L["Value greater than 100 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customManaFormatFormulas"
                        },

                        gt1B = {
                            type = "input",
                            order = 6,
                            name = L["Value greater than 1 000 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "target.customManaFormatFormulas"
                        },
                    }
                },

                useManaFormatFullValues = {
                    type = "toggle",
                    order = 4,
                    name = L["Use full values of mana"],
                    desc = L["By default all formulas use divider (for value eq 1000 and more it's 1000, for 1 000 000 and more it's 1 000 000, etc).\n\n" ..
                            "If checked formulas will use full values of mana (without divider)"],
                    arg = "target",
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):UpdateTextStringWithValues(TargetFrameManaBar)
                    end,
                },

                customManaFormat = {
                    type = "input",
                    order = 5,
                    width = "double",
                    name = L["Displayed mana by pattern"],
                    desc = L["You can use patterns:\n\n" ..
                            "%CURRENT% - return current mana\n" ..
                            "%MAX% - return maximum of mana\n" ..
                            "%PERCENT% - return percent of current/max mana\n\n" ..
                            "All values are returned from formulas. For set abbreviation use formulas' fields"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):UpdateTextStringWithValues(TargetFrameManaBar)
                    end,
                    arg = "target"
                },
            }
        },

        frameName = {
            type = "group",
            order = 6,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Target name"],
                },

                showName = {
                    type = "toggle",
                    order = 2,
                    name = L["Show target name"],
                    desc = L["Show target name"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):ShowName(value)
                    end,
                    arg = "target"
                },

                showNameInsideFrame = {
                    type = "toggle",
                    order = 3,
                    name = L["Show target name inside the frame"],
                    desc = L["Show target name inside the frame"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):ShowNameInsideFrame(value)
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.target.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "target"
                },

                newLine = {
                    type = "description",
                    order = 4,
                    name = "",
                },

                targetNameFontStyle = {
                    type = "select",
                    order = 5,
                    name = L["Font style"],
                    desc = L["Target name font style"],
                    values = fontStyle,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.target.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "target"
                },

                targetNameFontFamily = {
                    order = 6,
                    name = L["Font family"],
                    desc = L["Target name font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.target.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "target"
                },

                targetNameFontSize = {
                    type = "range",
                    order = 7,
                    name = L["Font size"],
                    desc = L["Target name font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.target.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "target"
                },

            }
        },

        showHideElements = {
            type = "group",
            order = 7,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Show or hide some elements of frame"],
                },

                showToTFrame = {
                    type = "toggle",
                    order = 2,
                    width = "double",
                    name = L["Show target of target frame"],
                    desc = L["Show target of target frame"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):ShowTargetFrameToT()
                    end,
                    arg = "target"
                },

                showTargetCastbar = {
                    type = "toggle",
                    order = 3,
                    width = "double",
                    name = L["Show blizzard's target castbar"],
                    desc = L["When you change this option you need to reload your UI (because it's Blizzard config variable). \n\nCommand /reload"],
                    set = function(info, value)
                        setOpt(info, value)
                        SetCVar("showTargetCastbar", value)
                    end,
                    arg = "target"
                },

                showAttackBackground = {
                    type = "toggle",
                    order = 4,
                    width = "double",
                    name = L["Show target combat texture (outside the frame)"],
                    desc = L["Show or hide target red background texture (blinking red glow outside the frame in combat)"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):ShowAttackBackground(value)
                    end,
                    arg = "target"
                },

                attackBackgroundOpacity = {
                    type = "range",
                    order = 5,
                    name = L["Opacity"],
                    desc = L["Opacity of combat texture"],
                    min = 0.1,
                    max = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Target"):SetAttackBackgroundOpacity(value)
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.target.showAttackBackground
                        if (diabled == false) then
                            return true
                        end
                    end,
                    isPercent = true,
                    arg = "target"
                },
            },
        },
    },
}

local focusOptions = {
    name = getOptionName(L["Focus"]),
    type = "group",
    get = getOpt,
    set = setOpt,
    args = {
        desc = {
            type = "description",
            order = 1,
            name = L["In focus options you can set scale focus frame, healthbar text format, etc"],
        },

        scaleFrame = {
            type = "range",
            order = 2,
            name = L["Focus frame scale"],
            desc = L["Scale of focus unit frame"],
            min = 0.5,
            max = 2,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):SetScale(value)
            end,
            arg = "focus"
        },

        header = {
            type = "header",
            order = 3,
            name = L["HP and MP bars"],
        },

        healthFormat = {
            type = "select",
            order = 4,
            name = L["Focus healthbar text format"],
            desc = L["Set the focus healthbar text format"],
            values = healthFormat,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):UpdateTextStringWithValues()
            end,
            arg = "focus"
        },

        healthBarFontFamily = {
            order = 5,
            name = L["Font family"],
            desc = L["Healthbar font family"],
            type = "select",
            dialogControl = 'LSM30_Font',
            values = Media:HashTable("font"),
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):SetHealthBarsFont()
            end,
            arg = "focus"
        },

        healthBarFontSize = {
            type = "range",
            order = 6,
            name = L["Font size"],
            desc = L["Healthbar font size"],
            min = MIN_RANGE,
            max = MAX_RANGE,
            step = 1,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):SetHealthBarsFont()
            end,
            arg = "focus"
        },

        reverseDirectionLosingHP = {
            type = "toggle",
            order = 7,
            width = "double",
            name = L["Reverse the direction of losing health/mana"],
            desc = L["By default direction starting from right to left. If checked direction of losing health/mana will be from left to right"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):ReverseDirectionLosingHP(value)
            end,
            arg = "focus"
        },

        HPFormat = {
            type = "group",
            order = 8,
            inline = true,
            name = "",
            hidden = function()
                local healthFormat = EasyFrames.db.profile.focus.healthFormat
                if (healthFormat == "custom") then
                    return false
                end

                return true
            end,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Custom format of HP"],
                },

                desc = {
                    type = "description",
                    order = 2,
                    name = L["You can set custom HP format. More information about custom HP format you can read on project site.\n\n" ..
                            "Formulas:"],
                },

                customHealthFormatFormulas = {
                    type = "group",
                    order = 3,
                    inline = true,
                    name = "",
                    get = getDeepOpt,
                    set = function(info, value)
                        local ns, opt = string.split(".", info.arg)
                        local key = info[#info]
                        EasyFrames.db.profile[ns][opt][key] = value

                        EasyFrames:GetModule("Focus"):UpdateTextStringWithValues()
                    end,
                    args = {
                        gt1T = {
                            type = "input",
                            order = 1,
                            name = L["Value greater than 1000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],

                            arg = "focus.customHealthFormatFormulas"
                        },
                        gt100T = {
                            type = "input",
                            order = 2,
                            name = L["Value greater than 100 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "focus.customHealthFormatFormulas"
                        },

                        gt1M = {
                            type = "input",
                            order = 3,
                            name = L["Value greater than 1 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "focus.customHealthFormatFormulas"
                        },

                        gt10M = {
                            type = "input",
                            order = 4,
                            name = L["Value greater than 10 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "focus.customHealthFormatFormulas"
                        },

                        gt100M = {
                            type = "input",
                            order = 5,
                            name = L["Value greater than 100 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "focus.customHealthFormatFormulas"
                        },

                        gt1B = {
                            type = "input",
                            order = 6,
                            name = L["Value greater than 1 000 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "focus.customHealthFormatFormulas"
                        },
                    }
                },

                useHealthFormatFullValues = {
                    type = "toggle",
                    order = 4,
                    name = L["Use full values of health"],
                    desc = L["By default all formulas use divider (for value eq 1000 and more it's 1000, for 1 000 000 and more it's 1 000 000, etc).\n\n" ..
                            "If checked formulas will use full values of HP (without divider)"],
                    arg = "focus",
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Focus"):UpdateTextStringWithValues()
                    end,
                },

                customHealthFormat = {
                    type = "input",
                    order = 5,
                    width = "double",
                    name = L["Displayed HP by pattern"],
                    desc = L["You can use patterns:\n\n" ..
                            "%CURRENT% - return current health\n" ..
                            "%MAX% - return maximum of health\n" ..
                            "%PERCENT% - return percent of current/max health\n\n" ..
                            "All values are returned from formulas. For set abbreviation use formulas' fields"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Focus"):UpdateTextStringWithValues()
                    end,
                    arg = "focus"
                },
            }
        },

        frameName = {
            type = "group",
            order = 9,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Focus name"],
                },

                showName = {
                    type = "toggle",
                    order = 2,
                    name = L["Show name of focus frame"],
                    desc = L["Show name of focus frame"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Focus"):ShowName(value)
                    end,
                    arg = "focus"
                },

                showNameInsideFrame = {
                    type = "toggle",
                    order = 3,
                    name = L["Show name of focus frame inside the frame"],
                    desc = L["Show name of focus frame inside the frame"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Focus"):ShowNameInsideFrame(value)
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.focus.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "focus"
                },

                newLine = {
                    type = "description",
                    order = 4,
                    name = "",
                },

                focusNameFontStyle = {
                    type = "select",
                    order = 5,
                    name = L["Font style"],
                    desc = L["Focus name font style"],
                    values = fontStyle,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Focus"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.focus.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "focus"
                },

                focusNameFontFamily = {
                    order = 6,
                    name = L["Font family"],
                    desc = L["Focus name font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Focus"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.focus.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "focus"
                },

                focusNameFontSize = {
                    type = "range",
                    order = 7,
                    name = L["Font size"],
                    desc = L["Focus name font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Focus"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.focus.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "focus"
                },

            }
        },

        header2 = {
            type = "header",
            order = 9,
            name = L["Show or hide some elements of frame"],
        },

        showToTFrame = {
            type = "toggle",
            order = 10,
            width = "double",
            name = L["Show target of focus frame"],
            desc = L["Show target of focus frame"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):ShowFocusFrameToT()
            end,
            arg = "focus"
        },

        showAttackBackground = {
            type = "toggle",
            order = 11,
            width = "double",
            name = L["Show focus combat texture (outside the frame)"],
            desc = L["Show or hide focus red background texture (blinking red glow outside the frame in combat)"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):ShowAttackBackground(value)
            end,
            arg = "focus"
        },

        attackBackgroundOpacity = {
            type = "range",
            order = 12,
            name = L["Opacity"],
            desc = L["Opacity of combat texture"],
            min = 0.1,
            max = 1,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):SetAttackBackgroundOpacity(value)
            end,
            disabled = function()
                local diabled = EasyFrames.db.profile.focus.showAttackBackground
                if (diabled == false) then
                    return true
                end
            end,
            isPercent = true,
            arg = "focus"
        },
    },
}

local petOptions = {
    name = getOptionName(L["Pet"]),
    type = "group",
    get = getOpt,
    set = setOpt,
    args = {
        desc = {
            type = "description",
            order = 1,
            name = L["In pet options you can set scale pet frame, show/hide pet name, enable/disable pet hit indicators, etc"],
        },

        scaleFrame = {
            type = "range",
            order = 2,
            name = L["Pet frame scale"],
            desc = L["Scale of pet unit frame"],
            min = 0.5,
            max = 2,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Pet"):SetScale(value)
            end,
            arg = "pet"
        },

        lockedMovableFrame = {
            type = "toggle",
            order = 3,
            name = L["Lock pet frame"],
            desc = L["Lock or unlock pet frame. When unlocked you can move frame using your mouse (draggable)"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Pet"):SetMovable(value)
            end,
            arg = "pet"
        },

        resetPosition = {
            type = "execute",
            order = 4,
            name = L["Reset position to default"],
            func = function()
                EasyFrames:GetModule("Pet"):ResetFramePosition()
            end,
        },

        HPManaFormatOptions = {
            type = "group",
            order = 5,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["HP and MP bars"],
                },

                healthFormat = {
                    type = "select",
                    order = 2,
                    name = L["Pet healthbar text format"],
                    desc = L["Set the pet healthbar text format"],
                    values = healthFormat,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):UpdateTextStringWithValues()
                    end,
                    arg = "pet"
                },

                healthBarFontFamily = {
                    order = 3,
                    name = L["Font family"],
                    desc = L["Healthbar font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):SetHealthBarsFont()
                    end,
                    arg = "pet"
                },

                healthBarFontSize = {
                    type = "range",
                    order = 4,
                    name = L["Font size"],
                    desc = L["Healthbar font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):SetHealthBarsFont()
                    end,
                    arg = "pet"
                },
            }
        },

        HPFormat = {
            type = "group",
            order = 6,
            inline = true,
            name = "",
            hidden = function()
                local healthFormat = EasyFrames.db.profile.pet.healthFormat
                if (healthFormat == "custom") then
                    return false
                end

                return true
            end,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Custom format of HP"],
                },

                desc = {
                    type = "description",
                    order = 2,
                    name = L["You can set custom HP format. More information about custom HP format you can read on project site.\n\n" ..
                            "Formulas:"],
                },

                customHealthFormatFormulas = {
                    type = "group",
                    order = 3,
                    inline = true,
                    name = "",
                    get = getDeepOpt,
                    set = function(info, value)
                        local ns, opt = string.split(".", info.arg)
                        local key = info[#info]
                        EasyFrames.db.profile[ns][opt][key] = value

                        EasyFrames:GetModule("Pet"):UpdateTextStringWithValues()
                    end,
                    args = {
                        gt1T = {
                            type = "input",
                            order = 1,
                            name = L["Value greater than 1000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],

                            arg = "pet.customHealthFormatFormulas"
                        },
                        gt100T = {
                            type = "input",
                            order = 2,
                            name = L["Value greater than 100 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "pet.customHealthFormatFormulas"
                        },

                        gt1M = {
                            type = "input",
                            order = 3,
                            name = L["Value greater than 1 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "pet.customHealthFormatFormulas"
                        },

                        gt10M = {
                            type = "input",
                            order = 4,
                            name = L["Value greater than 10 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "pet.customHealthFormatFormulas"
                        },

                        gt100M = {
                            type = "input",
                            order = 5,
                            name = L["Value greater than 100 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "pet.customHealthFormatFormulas"
                        },

                        gt1B = {
                            type = "input",
                            order = 6,
                            name = L["Value greater than 1 000 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "pet.customHealthFormatFormulas"
                        },
                    }
                },

                useHealthFormatFullValues = {
                    type = "toggle",
                    order = 4,
                    name = L["Use full values of health"],
                    desc = L["By default all formulas use divider (for value eq 1000 and more it's 1000, for 1 000 000 and more it's 1 000 000, etc).\n\n" ..
                            "If checked formulas will use full values of HP (without divider)"],
                    arg = "pet",
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):UpdateTextStringWithValues()
                    end,
                },

                customHealthFormat = {
                    type = "input",
                    order = 5,
                    width = "double",
                    name = L["Displayed HP by pattern"],
                    desc = L["You can use patterns:\n\n" ..
                            "%CURRENT% - return current health\n" ..
                            "%MAX% - return maximum of health\n" ..
                            "%PERCENT% - return percent of current/max health\n\n" ..
                            "All values are returned from formulas. For set abbreviation use formulas' fields"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):UpdateTextStringWithValues()
                    end,
                    arg = "pet"
                },
            }
        },


        frameName = {
            type = "group",
            order = 7,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Pet name"],
                },

                showName = {
                    type = "toggle",
                    order = 2,
                    width = "double",
                    name = L["Show pet name"],
                    desc = L["Show pet name"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):ShowName(value)
                    end,
                    arg = "pet"
                },

                newLine = {
                    type = "description",
                    order = 3,
                    name = "",
                },

                petNameFontStyle = {
                    type = "select",
                    order = 4,
                    name = L["Font style"],
                    desc = L["Pet name font style"],
                    values = fontStyle,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.pet.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "pet"
                },

                petNameFontFamily = {
                    order = 5,
                    name = L["Font family"],
                    desc = L["Pet name font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.pet.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "pet"
                },

                petNameFontSize = {
                    type = "range",
                    order = 6,
                    name = L["Font size"],
                    desc = L["Pet name font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Pet"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.pet.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "pet"
                },

            }
        },

        header = {
            type = "header",
            order = 8,
            name = L["Show or hide some elements of frame"],
        },

        showHitIndicator = {
            type = "toggle",
            order = 9,
            width = "double",
            name = L["Enable hit indicators"],
            desc = L["Show or hide the damage/heal which your pet take on pet unit frame"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Pet"):ShowHitIndicator(value)
            end,
            arg = "pet"
        },

        showStatusTexture = {
            type = "toggle",
            order = 10,
            width = "double",
            name = L["Show pet combat texture (inside the frame)"],
            desc = L["Show or hide pet red background texture (blinking red glow inside the frame in combat)"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Pet"):ShowStatusTexture(value)
            end,
            arg = "pet"
        },

        showAttackBackground = {
            type = "toggle",
            order = 11,
            width = "double",
            name = L["Show pet combat texture (outside the frame)"],
            desc = L["Show or hide pet red background texture (blinking red glow outside the frame in combat)"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Pet"):ShowAttackBackground(value)
            end,
            arg = "pet"
        },

        attackBackgroundOpacity = {
            type = "range",
            order = 12,
            name = L["Opacity"],
            desc = L["Opacity of combat texture"],
            min = 0.1,
            max = 1,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Pet"):SetAttackBackgroundOpacity(value)
            end,
            disabled = function()
                local diabled = EasyFrames.db.profile.pet.showAttackBackground
                if (diabled == false) then
                    return true
                end
            end,
            isPercent = true,
            arg = "pet"
        },
    },
}

local partyOptions = {
    name = getOptionName(L["Party"]),
    type = "group",
    get = getOpt,
    set = setOpt,
    args = {
        desc = {
            type = "description",
            order = 1,
            name = L["In party options you can set scale party frames, healthbar text format, etc"],
        },

        scaleFrame = {
            type = "range",
            order = 2,
            name = L["Party frames scale"],
            desc = L["Scale of party unit frames"],
            min = 0.5,
            max = 2,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Party"):SetScale(value)
            end,
            arg = "party"
        },

        header = {
            type = "header",
            order = 3,
            name = L["HP and MP bars"],
        },

        healthFormat = {
            type = "select",
            order = 4,
            name = L["Party healthbar text format"],
            desc = L["Set the party healthbar text format"],
            values = healthFormat,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Party"):UpdateTextStringWithValues()
            end,
            arg = "party"
        },

        healthBarFontFamily = {
            order = 5,
            name = L["Font family"],
            desc = L["Healthbar font family"],
            type = "select",
            dialogControl = 'LSM30_Font',
            values = Media:HashTable("font"),
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Party"):SetHealthBarsFont()
            end,
            arg = "party"
        },

        healthBarFontSize = {
            type = "range",
            order = 6,
            name = L["Font size"],
            desc = L["Healthbar font size"],
            min = MIN_RANGE,
            max = MAX_RANGE,
            step = 1,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Party"):SetHealthBarsFont()
            end,
            arg = "party"
        },

        HPFormat = {
            type = "group",
            order = 7,
            inline = true,
            name = "",
            hidden = function()
                local healthFormat = EasyFrames.db.profile.party.healthFormat
                if (healthFormat == "custom") then
                    return false
                end

                return true
            end,
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Custom format of HP"],
                },

                desc = {
                    type = "description",
                    order = 2,
                    name = L["You can set custom HP format. More information about custom HP format you can read on project site.\n\n" ..
                            "Formulas:"],
                },

                customHealthFormatFormulas = {
                    type = "group",
                    order = 3,
                    inline = true,
                    name = "",
                    get = getDeepOpt,
                    set = function(info, value)
                        local ns, opt = string.split(".", info.arg)
                        local key = info[#info]
                        EasyFrames.db.profile[ns][opt][key] = value

                        EasyFrames:GetModule("Party"):UpdateTextStringWithValues()
                    end,
                    args = {
                        gt1T = {
                            type = "input",
                            order = 1,
                            name = L["Value greater than 1000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],

                            arg = "party.customHealthFormatFormulas"
                        },
                        gt100T = {
                            type = "input",
                            order = 2,
                            name = L["Value greater than 100 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "party.customHealthFormatFormulas"
                        },

                        gt1M = {
                            type = "input",
                            order = 3,
                            name = L["Value greater than 1 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "party.customHealthFormatFormulas"
                        },

                        gt10M = {
                            type = "input",
                            order = 4,
                            name = L["Value greater than 10 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "party.customHealthFormatFormulas"
                        },

                        gt100M = {
                            type = "input",
                            order = 5,
                            name = L["Value greater than 100 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "party.customHealthFormatFormulas"
                        },

                        gt1B = {
                            type = "input",
                            order = 6,
                            name = L["Value greater than 1 000 000 000"],
                            desc = L["Formula converts the original value to the specified value.\n\n" ..
                                    "Description: for example formula is '%.fM'.\n" ..
                                    "The first part '%.f' is the formula itself, the second part 'M' is the abbreviation\n\n" ..
                                    "Example, value is 150550. '%.f' will be converted to '151' and '%.1f' to '150.6'"],
                            arg = "party.customHealthFormatFormulas"
                        },
                    }
                },

                useHealthFormatFullValues = {
                    type = "toggle",
                    order = 4,
                    name = L["Use full values of health"],
                    desc = L["By default all formulas use divider (for value eq 1000 and more it's 1000, for 1 000 000 and more it's 1 000 000, etc).\n\n" ..
                            "If checked formulas will use full values of HP (without divider)"],
                    arg = "party",
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Party"):UpdateTextStringWithValues()
                    end,
                },

                customHealthFormat = {
                    type = "input",
                    order = 5,
                    width = "double",
                    name = L["Displayed HP by pattern"],
                    desc = L["You can use patterns:\n\n" ..
                            "%CURRENT% - return current health\n" ..
                            "%MAX% - return maximum of health\n" ..
                            "%PERCENT% - return percent of current/max health\n\n" ..
                            "All values are returned from formulas. For set abbreviation use formulas' fields"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Party"):UpdateTextStringWithValues()
                    end,
                    arg = "party"
                },
            }
        },

        frameName = {
            type = "group",
            order = 9,
            inline = true,
            name = "",
            args = {
                header = {
                    type = "header",
                    order = 1,
                    name = L["Party frames names"],
                },

                showName = {
                    type = "toggle",
                    order = 2,
                    name = L["Show names of party frames"],
                    desc = L["Show names of party frames"],
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Party"):ShowName(value)
                    end,
                    arg = "party"
                },

                newLine = {
                    type = "description",
                    order = 4,
                    name = "",
                },

                partyNameFontStyle = {
                    type = "select",
                    order = 5,
                    name = L["Font style"],
                    desc = L["Party names font style"],
                    values = fontStyle,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Party"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.party.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "party"
                },

                partyNameFontFamily = {
                    order = 6,
                    name = L["Font family"],
                    desc = L["Party names font family"],
                    type = "select",
                    dialogControl = 'LSM30_Font',
                    values = Media:HashTable("font"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Party"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.party.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "party"
                },

                partyNameFontSize = {
                    type = "range",
                    order = 7,
                    name = L["Font size"],
                    desc = L["Party names font size"],
                    min = MIN_RANGE,
                    max = MAX_RANGE,
                    step = 1,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("Party"):SetFrameNameFont()
                    end,
                    disabled = function()
                        local diabled = EasyFrames.db.profile.party.showName
                        if (diabled == false) then
                            return true
                        end
                    end,
                    arg = "party"
                },

            }
        },

--        header2 = {
--            type = "header",
--            order = 9,
--            name = L["Show or hide some elements of frame"],
--        },
--
--        showPetFrames = {
--            type = "toggle",
--            order = 10,
--            width = "double",
--            name = L["Show party pet frames"],
--            desc = L["Show party pet frames"],
--            set = function(info, value)
--                setOpt(info, value)
--                EasyFrames:GetModule("Party"):ShowPetFrames(value)
--            end,
--            arg = "party"
--        },
    },
}

function EasyFrames:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames.Profiles)
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames.EasyFrames)
    else
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames.Profiles)
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames[input] or EasyFrames.optFrames.EasyFrames)
    end
end

function EasyFrames:SetupOptions()
    -- Frames in BlizOptions
    self.optFrames = {}

    -- General
    AceConfig:RegisterOptionsTable("EasyFrames", generalOptions)
    self.optFrames.EasyFrames = AceConfigDialog:AddToBlizOptions("EasyFrames", "EasyFrames")

    -- Player
    self:RegisterModuleOptions("Player", playerOptions, L["Player"])

    -- Target
    self:RegisterModuleOptions("Target", targetOptions, L["Target"])

    -- Focus
    self:RegisterModuleOptions("Focus", focusOptions, L["Focus"])

    -- Pet
    self:RegisterModuleOptions("Pet", petOptions, L["Pet"])

    -- Party
    self:RegisterModuleOptions("Party", partyOptions, L["Party"])

    -- Profiles
    self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))

    -- Commands
    self:RegisterChatCommand("easyframes", "ChatCommand")
    self:RegisterChatCommand("ef", "ChatCommand")
end

function EasyFrames:RegisterModuleOptions(name, optTable, displayName)
    AceConfig:RegisterOptionsTable(name, optTable)
    self.optFrames[name] = AceConfigDialog:AddToBlizOptions(name, displayName or name, "EasyFrames")
end