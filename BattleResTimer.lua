local _, addon = ...

local BattleResTimer = {}
addon.BattleResTimer = BattleResTimer

addon.PixelPerfect = LibStub("MichsPixelPerfectLib-1.0"):CreateScaler()
local PP = addon.PixelPerfect

local PANEL_WIDTH = 96
local PANEL_HEIGHT = 32
local BACKGROUND_OPACITY = 0.6
local FONT_SIZE = 16

local timerFrame
local ticker

local function FormatCooldownTime(remainingTime)
	remainingTime = math.max(math.ceil(remainingTime or 0), 0)

	local minutes = math.floor(remainingTime / 60)
	local seconds = remainingTime % 60

	return string.format("%02d:%02d", minutes, seconds)
end

local function SetTimerText(remainingTime, currentCharges)
	currentCharges = currentCharges or 0

	local countText = tostring(currentCharges)
	if currentCharges > 0 then
		countText = string.format("|cFF00FF00%d|r", currentCharges)
	elseif ticker then
		countText = string.format("|cFFFF0000%d|r", currentCharges)
	end

	timerFrame.text:SetText(string.format("%s | %s", FormatCooldownTime(remainingTime), countText))
end

local function UpdateVisibility()
	local settings = addon.Database:GetSettings()
	if settings.enabled and (ticker or settings.alwaysShow) then
		timerFrame:Show()
	else
		timerFrame:Hide()
	end
end

function BattleResTimer:Initialize()
	timerFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	timerFrame:EnableMouse(false)

	timerFrame.text = timerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	timerFrame.text:SetText("00:00 | 0")
	timerFrame.text:SetTextColor(1, 1, 1, 1)
	timerFrame.text:SetPoint("CENTER", timerFrame, "CENTER")

	PP:RegisterForUpdate(function()
		self:UpdateSettings()
	end)
end

function BattleResTimer:UpdateSettings()
	timerFrame:SetSize(PP:ToUIScaled(PANEL_WIDTH), PP:ToUIScaled(PANEL_HEIGHT))
	timerFrame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = PP:ToUIScaled(1),
	})
	timerFrame:SetBackdropColor(0, 0, 0, BACKGROUND_OPACITY)
	timerFrame:SetBackdropBorderColor(0, 0, 0, math.min(BACKGROUND_OPACITY + 0.25, 1))

	timerFrame.text:SetFont(STANDARD_TEXT_FONT, PP:ScaleFont(FONT_SIZE), "OUTLINE")

	PP:CenterElement(timerFrame, UIParent, PP:ToUIScaled(0), PP:ToUIScaled(0))

	UpdateVisibility()
end

function BattleResTimer:Start()
	if not ticker then
		ticker = C_Timer.NewTicker(1, function()
			self:UpdateBattleResState()
		end)

		self:UpdateBattleResState()
	end

	UpdateVisibility()
end

function BattleResTimer:Stop()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end

	SetTimerText(0, 0)
	UpdateVisibility()
end

function BattleResTimer:UpdateBattleResState()
	local chargesInfo = C_Spell.GetSpellCharges(20484)

	if not chargesInfo then
		SetTimerText(0, 0)
		return
	end

	local currentCharges = chargesInfo.currentCharges or 0
	local cooldownStartTime = chargesInfo.cooldownStartTime or 0
	local cooldownDuration = chargesInfo.cooldownDuration or 0
	local remainingTime = 0

	if cooldownStartTime > 0 and cooldownDuration > 0 then
		remainingTime = cooldownStartTime + cooldownDuration - GetTime()
	end

	SetTimerText(remainingTime, currentCharges)
end
