local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Target"
local Target = EasyFrames:NewModule(MODULE_NAME)
local db

function Target:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Target:OnEnable()

end

function Target:ResetFriendlyTargetDefaultColors()
    EasyFrames.db.profile.general.friendlyTargetDefaultColors = {0, 1, 0}
end

function Target:ResetEnemyTargetDefaultColors()
    EasyFrames.db.profile.general.enemyTargetDefaultColors = {1, 0, 0}
end