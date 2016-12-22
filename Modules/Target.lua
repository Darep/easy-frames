local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Target"
local Target = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db
local UpdateHealthValues = EasyFrames.Utils.UpdateHealthValues

function Target:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Target:OnEnable()
    self:SetScale(db.target.scaleFrame)
    self:ShowTargetFrameToT()

    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateHealthValues")
end

function Target:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:SetScale(db.target.scaleFrame)
    self:ShowTargetFrameToT()

    self:UpdateHealthValues()
end


function Target:SetScale(value)
    TargetFrame:SetScale(value)
end

function Target:UpdateHealthValues()
    local frame = "Target"
    local healthFormat = db.target.healthFormat

    UpdateHealthValues(frame, healthFormat)
end

function Target:ShowTargetFrameToT()
    if (db.target.showToTFrame) then
        TargetFrameToT:SetAlpha(100)
    else
        TargetFrameToT:SetAlpha(0)
    end
end