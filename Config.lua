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
    --        EasyFrames:ApplySettings()
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

local function getOptionName(name)
    return "EasyFrames" .. " - " .. name
end

local healthFormat = {
    ["1"] = L["Percent"], --1
    ["2"] = L["Current + Max"], --2
    ["3"] = L["Current + Max + Percent"], --3
}

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
                    desc = L["If checked frames becomes class colored"],
                    disabled = function()
                        if (EasyFrames.db.profile.general.coloredBaseOnCurrentHealth) then
                            return true
                        end
                    end,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetFramesColored()
                    end,
                    arg = "general"
                },

                coloredBaseOnCurrentHealth = {
                    type = "toggle",
                    order = 4,
                    disabled = function()
                        return true
--                        if (EasyFrames.db.profile.general.classColored) then
--                            return true
--                        end
                    end,
                    width = "double",
                    name = L["Healthbar color based on current health. IN DEVELOPMENT..."],
                    desc = L["Frames healthbar color based on his current health"],
                    arg = "general"
                },

                classPortraits = {
                    type = "toggle",
                    order = 5,
--                    width = "double",
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

                barTexture = {
                    type = "select",
                    order = 7,
                    dialogControl = "LSM30_Statusbar",
                    name = L["Texture"],
                    desc = L["Set the frames bar Texture"],
                    values = Media:HashTable("bartexture"),
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetFrameBarTexture(value)
                    end,
                    arg = "general"
                },

                brightFrameBorder = {
                    type = "range",
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
                }
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
                    min = 20,
                    max = 40,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetCustomBuffSize(true)
                    end,
                    disabled = function()
                        local hide = EasyFrames.db.profile.general.customBuffSize
                        if (hide == false) then
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
                    min = 20,
                    max = 40,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):SetCustomBuffSize(true)
                    end,
                    disabled = function()
                        local hide = EasyFrames.db.profile.general.customBuffSize
                        if (hide == false) then
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

                dispelledBuffScale = {
                    type = "range",
                    order = 7,
                    name = L["Dispelled buff scale"],
                    desc = L["Dispelled buff scale that can be dispelled from target frame"],
                    min = 1,
                    max = 1.5,
                    set = function(info, value)
                        setOpt(info, value)
                        EasyFrames:GetModule("General"):TargetFrame_UpdateAuras(TargetFrame)
                    end,
                    disabled = function()
                        local hide = EasyFrames.db.profile.general.highlightDispelledBuff
                        if (hide == false) then
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

        newLine = {
            type = "description",
            order = 3,
            name = "",
        },

        healthFormat = {
            type = "select",
            order = 4,
            name = L["Player healthbar text format"],
            desc = L["Set the player healthbar text format"],
            values = healthFormat,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Player"):UpdateHealthValues()
            end,
            arg = "player"
        },

        newLine2 = {
            type = "description",
            order = 5,
            name = "",
        },

        showName = {
            type = "toggle",
            order = 6,
            width = "double",
            name = L["Show player name"],
            desc = L["Show player name"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Player"):ShowName(value)
            end,
            arg = "player"
        },

        showHitIndicator = {
            type = "toggle",
            order = 7,
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
            order = 8,
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
            order = 9,
            width = "double",
            name = L["Show player resting icon"],
            desc = L["Show or hide the player resting icon when player is resting (e.g. in the tavern or in the capital)"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Player"):ShowRestIcon(value)
            end,
            arg = "player"
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

        newLine = {
            type = "description",
            order = 3,
            name = "",
        },

        healthFormat = {
            type = "select",
            order = 4,
            name = L["Target healthbar text format"],
            desc = L["Set the target healthbar text format"],
            values = healthFormat,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Target"):UpdateHealthValues()
            end,
            arg = "target"
        },

        newLine2 = {
            type = "description",
            order = 5,
            name = "",
        },

        showToTFrame = {
            type = "toggle",
            order = 6,
            width = "double",
            name = L["Show target of target frame"],
            desc = L["Show target of target frame"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Target"):ShowTargetFrameToT()
            end,
            arg = "target"
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

        newLine = {
            type = "description",
            order = 3,
            name = "",
        },

        healthFormat = {
            type = "select",
            order = 4,
            name = L["Focus healthbar text format"],
            desc = L["Set the focus healthbar text format"],
            values = healthFormat,
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):UpdateHealthValues()
            end,
            arg = "focus"
        },

        newLine2 = {
            type = "description",
            order = 5,
            name = "",
        },

        showToTFrame = {
            type = "toggle",
            order = 6,
            width = "double",
            name = L["Show target of focus frame"],
            desc = L["Show target of focus frame"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Focus"):ShowFocusFrameToT()
            end,
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
            name = L["In pet options you can show/hide pet name, enable/disable pet hit indicators"],
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

        showHitIndicator = {
            type = "toggle",
            order = 3,
            width = "double",
            name = L["Enable hit indicators"],
            desc = L["Show or hide the damage/heal which your pet take on pet unit frame"],
            set = function(info, value)
                setOpt(info, value)
                EasyFrames:GetModule("Pet"):ShowHitIndicator(value)
            end,
            arg = "pet"
        },
    },
}

function EasyFrames:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames.Profiles)
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames.EasyFrames)
    else
--        LibStub("AceConfigCmd-3.0").HandleCommand(EasyFrames, "ef", input)
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames.Profiles)
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames[input])
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