local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Player"
local Player = EasyFrames:NewModule(MODULE_NAME)
local db

function Player:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Player:OnEnable()

end

function Player:SetScale(value)
    PlayerFrame:SetScale(value)
end