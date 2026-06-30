local _, addon = ...

local BattleResTimer = {}
addon.BattleResTimer = BattleResTimer

addon.PixelPerfect = LibStub("MichsPixelPerfectLib-1.0"):CreateScaler()
local PP = addon.PixelPerfect

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

function BattleResTimer:UpdatePosition()
	local settings = addon.Database:GetSettings()
	PP:CenterElement(timerFrame, UIParent, PP:ToUIScaled(settings.positionX), PP:ToUIScaled(settings.positionY))
end

function BattleResTimer:UpdateSize()
	local settings = addon.Database:GetSettings()

	timerFrame:SetSize(PP:ToUIScaled(settings.width), PP:ToUIScaled(settings.height))
	timerFrame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = PP:ToUIScaled(1),
	})

	self:UpdateBackground()
end

function BattleResTimer:UpdateBackground()
	local settings = addon.Database:GetSettings()
	local backgroundOpacity = settings.backgroundOpacity

	if backgroundOpacity <= 0 then
		timerFrame:SetBackdropColor(0, 0, 0, 0)
		timerFrame:SetBackdropBorderColor(0, 0, 0, 0)
		return
	end

	local borderOpacity = math.min(backgroundOpacity + 0.25, 1)

	timerFrame:SetBackdropColor(0, 0, 0, backgroundOpacity)
	timerFrame:SetBackdropBorderColor(0, 0, 0, borderOpacity)
end

function BattleResTimer:UpdateTextStyle()
	local settings = addon.Database:GetSettings()
	timerFrame.text:SetFont(STANDARD_TEXT_FONT, PP:ScaleFont(settings.fontSize), "OUTLINE")
end

function BattleResTimer:UpdateSettings()
	self:UpdateSize()
	self:UpdatePosition()
	self:UpdateTextStyle()

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
