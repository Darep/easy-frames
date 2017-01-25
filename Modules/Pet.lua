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

    self:ShowStatusTexture(db.pet.showStatusTexture)
    self:ShowAttackBackground(db.pet.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.pet.attackBackgroundOpacity)
end

function Pet:OnProfileChanged(newDB)
    self.db = newDB
    db = self.db.profile

    self:ShowName(db.pet.showName)
    self:ShowHitIndicator(db.pet.showHitIndicator)

    self:ShowStatusTexture(db.pet.showStatusTexture)
    self:ShowAttackBackground(db.pet.showAttackBackground)
    self:SetAttackBackgroundOpacity(db.pet.attackBackgroundOpacity)
end


function Pet:GetOriginalValues()
    originalValues["PetHitIndicator"] = PetHitIndicator.SetText

    originalValues["PetAttackModeTexture"] = PetAttackModeTexture.Show
    originalValues["PetFrameFlash"] = PetFrameFlash.Show
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

function Pet:ShowStatusTexture(value)
    local noop = function() return end

    local frame = PetAttackModeTexture

    if frame then
        if frame then
            if (value) then
                frame.Show = originalValues[frame:GetName()]

                if (UnitAffectingCombat("player")) then
                    frame:Show()
                end
            else
                frame:Hide()
                frame.Show = noop
            end
        end
    end
end

function Pet:ShowAttackBackground(value)
    local noop = function() return end

    local frame = PetFrameFlash

    if frame then
        if (value) then
            frame.Show = originalValues[frame:GetName()]

            if (UnitAffectingCombat("player")) then
                frame:Show()
            end
        else
            frame:Hide()
            frame.Show = noop
        end
    end
end

function Pet:SetAttackBackgroundOpacity(value)
    PetFrameFlash:SetAlpha(value)
end