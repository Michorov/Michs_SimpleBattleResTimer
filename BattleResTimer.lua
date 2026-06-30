local _, addon = ...

local BattleResTimer = {}
addon.BattleResTimer = BattleResTimer

addon.PixelPerfect = LibStub("MichsPixelPerfectLib-1.0"):CreateScaler()
local PP = addon.PixelPerfect

local BATTLE_RES_SPELL_ID = 20484

local iconFrame

local previousCooldownStartTime
local ticker

function BattleResTimer:Initialize()
	iconFrame = CreateFrame("Frame", nil, UIParent)
	iconFrame:EnableMouse(false)

	iconFrame.icon = iconFrame:CreateTexture(nil, "ARTWORK")
	iconFrame.icon:SetAllPoints(iconFrame)
	iconFrame.icon:SetTexture("Interface\\Icons\\Spell_Nature_Reincarnation")
	iconFrame.icon:SetTexCoord(0.14, 0.86, 0.14, 0.86)

	iconFrame.cooldown = CreateFrame("Cooldown", nil, iconFrame, "CooldownFrameTemplate")
	iconFrame.cooldown:SetAllPoints(iconFrame)
	iconFrame.cooldown:SetDrawBling(false)
	iconFrame.cooldown:SetHideCountdownNumbers(true)
	iconFrame.cooldown:SetDrawEdge(true)
	iconFrame.cooldown:SetDrawSwipe(true)
	iconFrame.cooldown:SetReverse(false)
	iconFrame.cooldown.noCooldownCount = true
	iconFrame.cooldown:Clear()
	iconFrame.cooldown:EnableMouse(false)

	iconFrame.border = CreateFrame("Frame", nil, iconFrame, "BackdropTemplate")
	iconFrame.border:SetFrameLevel(iconFrame.border:GetFrameLevel() + 1)
	iconFrame.border:SetBackdropBorderColor(0, 0, 0, 1)
	iconFrame.border:SetPoint("TOPLEFT", iconFrame, "TOPLEFT")
	iconFrame.border:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT")
	iconFrame.border:EnableMouse(false)

	iconFrame.stacksText = iconFrame.border:CreateFontString(nil, "OVERLAY", "NumberFontNormalLarge")
	iconFrame.stacksText:SetText("")

	PP:RegisterForUpdate(function()
		self:UpdateSettings()
	end)

	iconFrame:Hide()
end

function BattleResTimer:UpdateSettings()
	iconFrame:SetSize(PP:ToUIScaled(40), PP:ToUIScaled(40))

	iconFrame.border:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = PP:ToUIScaled(1),
	})

	PP:CenterElement(iconFrame, UIParent, PP:ToUIScaled(0), PP:ToUIScaled(0))

	iconFrame.stacksText:SetFont(STANDARD_TEXT_FONT, PP:ScaleFont(12), "OUTLINE")
	iconFrame.stacksText:SetTextColor(1, 1, 1, 1)
	iconFrame.stacksText:ClearAllPoints()
	iconFrame.stacksText:SetPoint("BOTTOMRIGHT", iconFrame.border, "BOTTOMRIGHT", PP:ToUIScaled(-2), PP:ToUIScaled(1))
end

function BattleResTimer:Start()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end

	previousCooldownStartTime = nil
	self:UpdateBattleResState()

	iconFrame:Show()

	ticker = C_Timer.NewTicker(1, function()
		self:UpdateBattleResState()
	end)
end

function BattleResTimer:Stop()
	if ticker then
		ticker:Cancel()
		ticker = nil
	end

	self:Reset()
	iconFrame:Hide()
end

function BattleResTimer:Reset()
	previousCooldownStartTime = nil
	iconFrame.cooldown:Clear()
	iconFrame.stacksText:SetText("")
end

function BattleResTimer:UpdateBattleResState()
	local chargesInfo = C_Spell.GetSpellCharges(BATTLE_RES_SPELL_ID)

	if not chargesInfo then
		self:Reset()
		return
	end

	local currentCharges = chargesInfo.currentCharges or 0
	local cooldownStartTime = chargesInfo.cooldownStartTime or 0
	local cooldownDuration = chargesInfo.cooldownDuration or 0

	if currentCharges > 0 then
		iconFrame.stacksText:SetText(currentCharges)
	else
		iconFrame.stacksText:SetText("")
	end

	if cooldownStartTime <= 0 or cooldownDuration <= 0 then
		previousCooldownStartTime = nil
		iconFrame.cooldown:Clear()
		return
	end

	if cooldownStartTime ~= previousCooldownStartTime then
		previousCooldownStartTime = cooldownStartTime
		iconFrame.cooldown:Clear()
		iconFrame.cooldown:SetCooldown(cooldownStartTime, cooldownDuration)
	end
end
