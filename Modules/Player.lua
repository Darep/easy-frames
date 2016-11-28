local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")

local MODNAME = "Player"
local Player = EasyFrames:NewModule(MODNAME)

----------------------------
-- Upvalues
-- GLOBALS: CastingBarFrame
local unpack = unpack

local db, getOptions, castBar

local defaults = {
}

local getOpt, setOpt, getColor, setColor
do
--    local function setOpt(info, value)
--        db[info[#info]] = value
--        Player:ApplySettings()
--    end

    local function getOpt(info)
        local ns,opt = string.split(".", info.arg)
        local val = EasyFrames.db.profile[ns][opt]

        if type(val) == "table" then
            return unpack(val)
        else
            return val
        end
    end

    function setOpt(info, value)
        local ns,opt = string.split(".", info.arg)
        EasyFrames.db.profile[ns][opt] = value
        EasyFrames:ApplySettings()
    end

    local options
    function getOptions()
        if not options then
            options = {
                type = "group",
                args = {
                    player = {
                        type = "group",
                        order = 2,
                        -- inline = true,
                        name = L["Name player"],
                        get = getOpt,
                        set = setOpt,
                        args = {
                            barTexture = {
                                type = "toggle",
                                name = L["showName"],
                                --                            desc = L["showName long tooltip"],
                                order = 1,
                                arg = "player.showName",
                            },
                        },
                    }
                },
            }
        end
        return options
    end
end

function Player:OnInitialize()
--    self.db = EasyFrames.db:RegisterNamespace(MODNAME, defaults)
--    db = EasyFrames.db.profile

--    self:SetEnabledState(EasyFrames:GetModuleEnabled(MODNAME))
--    EasyFrames:RegisterModuleOptions(MODNAME, getOptions, L["Player"])

--    self.Bar = EasyFrames.CastBarTemplate:new(self, "player", MODNAME, L["Player"], db)
--    castBar = self.Bar.Bar
end