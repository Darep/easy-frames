local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Focus"
local Focus = EasyFrames:NewModule(MODULE_NAME)
local db

function Focus:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Focus:OnEnable()

end

function Focus:ResetFriendlyTargetDefaultColors()
    EasyFrames.db.profile.general.friendlyTargetDefaultColors = {0, 1, 0}
end

function Focus:ResetEnemyTargetDefaultColors()
    EasyFrames.db.profile.general.enemyTargetDefaultColors = {1, 0, 0}
end