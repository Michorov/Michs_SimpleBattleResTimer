local _, addon = ...

local BattleResTimer = {}
addon.BattleResTimer = BattleResTimer

local iconFrame

function BattleResTimer:Initialize()
	iconFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	iconFrame.icon = iconFrame:CreateTexture(nil, "ARTWORK")
	iconFrame.icon:SetAllPoints(iconFrame)
	iconFrame.icon:SetTexture("Interface\\Icons\\Spell_Nature_Reincarnation")
	iconFrame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	self:UpdateSettings()
end

function BattleResTimer:UpdateSettings()
	iconFrame:SetSize(40, 40)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("CENTER", UIParent, "CENTER")

	iconFrame:Show()
end
