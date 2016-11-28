local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")

local MODULE_NAME = "General"
local General = EasyFrames:NewModule(MODULE_NAME)
local db

function General:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function General:resetFriendlyTargetDefaultColors()
    EasyFrames.db.profile.general.friendlyTargetDefaultColors = {0, 1, 0}
end

function General:resetEnemyTargetDefaultColors()
    EasyFrames.db.profile.general.enemyTargetDefaultColors = {1, 0, 0}
end