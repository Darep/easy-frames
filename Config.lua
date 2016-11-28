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
                    disabled = function()
                        if (EasyFrames.db.profile.general.coloredBaseOnCurrentHealth) then
                            return true
                        end
                    end,
                    name = L["Class colored healthbars"],
                    desc = L["If checked frames becomes class colored"],
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
                    width = "double",
                    name = L["Class portraits"],
                    desc = L["Replaces the unit-frame portrait of player-controlled characters with their class icon"],
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
                        print("change texture")
                        setOpt(info, value)
                    end,
                    arg = "general"
                },

                darkFrameBorder = {
                    type = "range",
                    name = L["Dark frame border"],
                    desc = L["You can set frame border bright/dark color. From bright to dark. 0 - bright, 100 - dark."],
                    min = 0,
                    max = 1,
                    set = function(info, value)
                        print("darkenTexture value is ", value)
                        setOpt(info, value)
                    end,
                    isPercent = true,
                    arg = "general"
                }
            }
        },

        customBuffSizeGroup = {
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
                    name = L["Buffsize"],
                },

                description = {
                    type = "description",
                    order = 2,
                    name = L["Use custom target and focustarget buffsize"],
                },

                customBuffSize = {
                    type = "toggle",
                    order = 3,
                    name = L["Turn on custom buffsize"],
                    desc = L["Turn on custom target and focustarget buffsize"],
                    arg = "general"
                },

                buffSize = {
                    type = "range",
                    name = L["Buffsize"],
                    desc = L["Buffsize"],
                    min = 10,
                    max = 30,
                    disabled = function()
                        local hide = EasyFrames.db.profile.general.customBuffSize
                        if (hide == false) then
                            return true
                        end
                    end,
                    arg = "general"
                },

                selfBuffSizeScale = {
                    type = "range",
                    name = L["Self buffsize scale"],
                    desc = L["Scale of self buffsize"],
                    min = 1,
                    max = 2,
                    disabled = function()
                        local hide = EasyFrames.db.profile.general.customBuffSize
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
                    name = L["In this section you can set the default colors for friendly/enemy target frames"],
                },

                friendlyTargetDefaultColors = {
                    type = "color",
                    order = 3,
                    width = "double",
                    name = L["Set default friendly healthbar color"],
                    desc = L["You can set the default friendly healthbar color for target frame"],

                    arg = "general"
                },

                friendlyTargetDefaultColorsReset = {
                    type = "execute",
                    order = 4,
                    name = L["Reset color to default"],

                    func = function()
                        EasyFrames:GetModule("General"):resetFriendlyTargetDefaultColors()
                    end,
                },

                enemyTargetDefaultColors = {
                    type = "color",
                    order = 5,
                    width = "double",
                    name = L["Set default enemy healthbar color"],
                    desc = L["You can set the default enemy healthbar color for target frame"],
                    arg = "general"
                },

                enemyTargetDefaultColorsReset = {
                    type = "execute",
                    order = 6,
                    name = L["Reset color to default"],

                    func = function()
                        EasyFrames:GetModule("General"):resetEnemyTargetDefaultColors()
                    end,
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
            arg = "player"
        },

        showHitIndicator = {
            type = "toggle",
            order = 7,
            width = "double",
            name = L["Enable hit indicators"],
            desc = L["Show or hide the damage/heal which you take on your unit frame"],
            arg = "player"
        },

        showSpecialbar = {
            type = "toggle",
            order = 8,
            width = "double",
            name = L["Show player specialbar"],
            desc = L["Show or hide the player specialbar, like Paladin's holy power, Priest's orbs, Monk's harmony or Warlock's soul shards"],
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
            arg = "pet"
        },

        showHitIndicator = {
            type = "toggle",
            order = 3,
            width = "double",
            name = L["Enable hit indicators"],
            desc = L["Show or hide the damage/heal which your pet take on pet unit frame"],
            arg = "pet"
        },
    },
}

function EasyFrames:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames.Profiles)
        InterfaceOptionsFrame_OpenToCategory(EasyFrames.optFrames.EasyFrames)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand("ef", "EasyFrames", input)
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