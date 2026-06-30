local addonName, addon = ...

local BattleResTimer = {}
addon.BattleResTimer = BattleResTimer

local BATTLE_RES_SPELL_ID = 20484
local BATTLE_RES_FALLBACK_ICON = "Interface\\Icons\\Spell_Nature_Reincarnation"

local iconFrame

local function GetBattleResIcon()
	if C_Spell and C_Spell.GetSpellTexture then
		return C_Spell.GetSpellTexture(BATTLE_RES_SPELL_ID)
	end

	return BATTLE_RES_FALLBACK_ICON
end

function BattleResTimer:Initialize()
	iconFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	iconFrame:SetSize(40, 40)
	iconFrame:SetPoint("CENTER", UIParent, "CENTER")

	iconFrame.icon = iconFrame:CreateTexture(nil, "ARTWORK")
	iconFrame.icon:SetAllPoints(iconFrame)
	iconFrame.icon:SetTexture(GetBattleResIcon())
	iconFrame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
end
