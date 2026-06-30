local _, addon = ...

local BattleResTimer = {}
addon.BattleResTimer = BattleResTimer

addon.PixelPerfect = LibStub("MichsPixelPerfectLib-1.0"):CreateScaler()
local PP = addon.PixelPerfect

local iconFrame

function BattleResTimer:Initialize()
	iconFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	iconFrame.icon = iconFrame:CreateTexture(nil, "ARTWORK")
	iconFrame.icon:SetAllPoints(iconFrame)
	iconFrame.icon:SetTexture("Interface\\Icons\\Spell_Nature_Reincarnation")
	iconFrame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	PP:RegisterForUpdate(function()
		self:UpdateSettings()
	end)
end

function BattleResTimer:UpdateSettings()
	iconFrame:SetSize(PP:ToUIScaled(40), PP:ToUIScaled(40))

	PP:CenterElement(iconFrame, UIParent, PP:ToUIScaled(0), PP:ToUIScaled(0))

	iconFrame:Show()
end
