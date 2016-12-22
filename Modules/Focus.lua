local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Focus"
local Focus = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db
local UpdateHealthValues = EasyFrames.Utils.UpdateHealthValues

function Focus:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Focus:OnEnable()
    self:SetScale(db.focus.scaleFrame)
    self:ShowFocusFrameToT()

    self:SecureHook("TextStatusBar_UpdateTextStringWithValues", "UpdateHealthValues")
end

function Focus:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:ShowFocusFrameToT()
    self:SetScale(db.focus.scaleFrame)

    self:UpdateHealthValues()
end


function Focus:SetScale(value)
    FocusFrame:SetScale(value)
end

function Focus:UpdateHealthValues()
    local frame = "Focus"
    local healthFormat = db.focus.healthFormat

    UpdateHealthValues(frame, healthFormat)
end

function Focus:ShowFocusFrameToT()
    if (db.focus.showToTFrame) then
        FocusFrameToT:SetAlpha(100)
    else
        FocusFrameToT:SetAlpha(0)
    end
end