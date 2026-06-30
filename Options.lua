local _, addon = ...

local Options = {}
addon.Options = Options

local function RegisterSectionHeader(category, name)
	local initializer = CreateSettingsListSectionHeaderInitializer(name)
	Settings.RegisterInitializer(category, initializer)
end

local function RegisterEnabledSetting(category)
	local function GetEnabled()
		return addon.Database:GetSettings().enabled
	end

	local function SetEnabled(value)
		addon.Database:GetSettings().enabled = value
		addon.BattleResTimer:UpdateSettings()
	end

	local setting = Settings.RegisterProxySetting(
		category,
		"MichsSimpleBattleResTimer_Enabled",
		Settings.VarType.Boolean,
		"Enabled",
		addon.Database:GetDefaults().enabled,
		GetEnabled,
		SetEnabled
	)

	Settings.CreateCheckbox(category, setting, "Enable the battle resurrection timer.")
end

local function RegisterAlwaysShowSetting(category)
	local function GetAlwaysShow()
		return addon.Database:GetSettings().alwaysShow
	end

	local function SetAlwaysShow(value)
		addon.Database:GetSettings().alwaysShow = value
		addon.BattleResTimer:UpdateSettings()
	end

	local setting = Settings.RegisterProxySetting(
		category,
		"MichsSimpleBattleResTimer_AlwaysShow",
		Settings.VarType.Boolean,
		"Always Show",
		addon.Database:GetDefaults().alwaysShow,
		GetAlwaysShow,
		SetAlwaysShow
	)

	Settings.CreateCheckbox(category, setting, "Show the battle resurrection timer even when no encounter or Mythic+ run is active.")
end

function Options:Initialize()
	local category = Settings.RegisterVerticalLayoutCategory("Mich's Battle Res Timer")

	RegisterSectionHeader(category, "General")
	RegisterEnabledSetting(category)
	RegisterAlwaysShowSetting(category)

	Settings.RegisterAddOnCategory(category)
end
