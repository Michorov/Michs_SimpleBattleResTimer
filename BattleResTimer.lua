local _, addon = ...

local BattleResTimer = {}
addon.BattleResTimer = BattleResTimer

addon.PixelPerfect = LibStub("MichsPixelPerfectLib-1.0"):CreateScaler()
local PP = addon.PixelPerfect

local iconFrame

function BattleResTimer:Initialize()
	iconFrame = CreateFrame("Button", nil, UIParent)
	iconFrame.icon = iconFrame:CreateTexture(nil, "ARTWORK")
	iconFrame.icon:SetAllPoints(iconFrame)
	iconFrame.icon:SetTexture("Interface\\Icons\\Spell_Nature_Reincarnation")
	iconFrame.icon:SetTexCoord(0.14, 0.86, 0.14, 0.86)

	iconFrame.cooldown = CreateFrame("Cooldown", nil, iconFrame, "CooldownFrameTemplate")
	iconFrame.cooldown:SetAllPoints(iconFrame)
	iconFrame.cooldown:SetDrawBling(false)
	iconFrame.cooldown:SetHideCountdownNumbers(true)
	iconFrame.cooldown.noCooldownCount = true
	iconFrame.cooldown:Clear()

	iconFrame.border = CreateFrame("Frame", nil, iconFrame, "BackdropTemplate")
	iconFrame.border:SetFrameLevel(iconFrame.border:GetFrameLevel() + 1)

	iconFrame.stacksText = iconFrame.border:CreateFontString(nil, "OVERLAY", "NumberFontNormalLarge")
	iconFrame.stacksText:SetText("0")

	PP:RegisterForUpdate(function()
		self:UpdateSettings()
	end)
end

function BattleResTimer:UpdateSettings()
	iconFrame:SetSize(PP:ToUIScaled(40), PP:ToUIScaled(40))

	iconFrame.icon:ClearAllPoints()
	iconFrame.icon:SetAllPoints(iconFrame)

	iconFrame.cooldown:SetDrawEdge(true)
	iconFrame.cooldown:SetDrawSwipe(true)
	iconFrame.cooldown:SetReverse(false)

	iconFrame.border:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = PP:ToUIScaled(1),
	})
	iconFrame.border:SetBackdropBorderColor(0, 0, 0, 1)
	iconFrame.border:ClearAllPoints()
	iconFrame.border:SetPoint("TOPLEFT", iconFrame, "TOPLEFT")
	iconFrame.border:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT")

	PP:CenterElement(iconFrame, UIParent, PP:ToUIScaled(0), PP:ToUIScaled(0))

	iconFrame.stacksText:SetFont(STANDARD_TEXT_FONT, PP:ScaleFont(12), "OUTLINE")
	iconFrame.stacksText:SetTextColor(1, 1, 1, 1)
	iconFrame.stacksText:ClearAllPoints()
	iconFrame.stacksText:SetPoint("BOTTOMRIGHT", iconFrame.border, "BOTTOMRIGHT", PP:ToUIScaled(-2), PP:ToUIScaled(1))

	iconFrame:Show()
end
