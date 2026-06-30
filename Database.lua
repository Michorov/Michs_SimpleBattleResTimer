local _, addon = ...

local Database = {}
addon.Database = Database

local defaults = {
	enabled = true,
	alwaysShow = false,
	positionX = 0,
	positionY = 0,
	width = 96,
	height = 32,
	backgroundOpacity = 0.6,
	fontSize = 16,
}

function Database:Initialize()
	MichsSimpleBattleResTimerDB = MichsSimpleBattleResTimerDB or {}

	for key, value in pairs(defaults) do
		if MichsSimpleBattleResTimerDB[key] == nil then
			MichsSimpleBattleResTimerDB[key] = value
		end
	end

	self.settings = MichsSimpleBattleResTimerDB
end

function Database:GetSettings()
	return self.settings
end

function Database:GetDefaults()
	return defaults
end
