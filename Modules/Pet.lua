local EasyFrames = LibStub("AceAddon-3.0"):GetAddon("EasyFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("EasyFrames")
local Media = LibStub("LibSharedMedia-3.0")

local MODULE_NAME = "Pet"
local Pet = EasyFrames:NewModule(MODULE_NAME, "AceHook-3.0")
local db
local originalValues = {}

function Pet:OnInitialize()
    self.db = EasyFrames.db
    db = self.db.profile
end

function Pet:OnEnable()
    self:ShowName(db.pet.showName)
    self:ShowHitIndicator(db.pet.showHitIndicator)
end

function Pet:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:ShowName(db.pet.showName)
    self:ShowHitIndicator(db.pet.showHitIndicator)
end


function Pet:GetOriginalValues()
    originalValues["PetHitIndicator"] = PetHitIndicator.SetText
end

function Pet:ShowName(value)
    if (value) then
        PetName:Show()
    else
        PetName:Hide()
    end
end

function Pet:ShowHitIndicator(value)
    if (value) then
        PetHitIndicator.SetText = originalValues["PetHitIndicator"]
    else
        PetHitIndicator:SetText(nil)
        PetHitIndicator.SetText = function() end
    end
end