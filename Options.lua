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

local function RegisterPositionXSetting(category)
	local function GetPositionX()
		return addon.Database:GetSettings().positionX
	end

	local function SetPositionX(value)
		addon.Database:GetSettings().positionX = value
		addon.BattleResTimer:UpdatePosition()
	end

	local setting = Settings.RegisterProxySetting(
		category,
		"MichsSimpleBattleResTimer_PositionX",
		Settings.VarType.Number,
		"Position X",
		addon.Database:GetDefaults().positionX,
		GetPositionX,
		SetPositionX
	)

	local options = Settings.CreateSliderOptions(-2000, 2000, 1)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)

	Settings.CreateSlider(category, setting, options, "Move the battle resurrection timer left or right.")
end

local function RegisterPositionYSetting(category)
	local function GetPositionY()
		return addon.Database:GetSettings().positionY
	end

	local function SetPositionY(value)
		addon.Database:GetSettings().positionY = value
		addon.BattleResTimer:UpdatePosition()
	end

	local setting = Settings.RegisterProxySetting(
		category,
		"MichsSimpleBattleResTimer_PositionY",
		Settings.VarType.Number,
		"Position Y",
		addon.Database:GetDefaults().positionY,
		GetPositionY,
		SetPositionY
	)

	local options = Settings.CreateSliderOptions(-2000, 2000, 1)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)

	Settings.CreateSlider(category, setting, options, "Move the battle resurrection timer up or down.")
end

local function RegisterWidthSetting(category)
	local function GetWidth()
		return addon.Database:GetSettings().width
	end

	local function SetWidth(value)
		addon.Database:GetSettings().width = value
		addon.BattleResTimer:UpdateSize()
		addon.BattleResTimer:UpdatePosition()
	end

	local setting = Settings.RegisterProxySetting(
		category,
		"MichsSimpleBattleResTimer_Width",
		Settings.VarType.Number,
		"Width",
		addon.Database:GetDefaults().width,
		GetWidth,
		SetWidth
	)

	local options = Settings.CreateSliderOptions(64, 300, 1)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)

	Settings.CreateSlider(category, setting, options, "Set the battle resurrection timer width.")
end

local function RegisterHeightSetting(category)
	local function GetHeight()
		return addon.Database:GetSettings().height
	end

	local function SetHeight(value)
		addon.Database:GetSettings().height = value
		addon.BattleResTimer:UpdateSize()
		addon.BattleResTimer:UpdatePosition()
	end

	local setting = Settings.RegisterProxySetting(
		category,
		"MichsSimpleBattleResTimer_Height",
		Settings.VarType.Number,
		"Height",
		addon.Database:GetDefaults().height,
		GetHeight,
		SetHeight
	)

	local options = Settings.CreateSliderOptions(22, 120, 1)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)

	Settings.CreateSlider(category, setting, options, "Set the battle resurrection timer height.")
end

local function RegisterBackgroundOpacitySetting(category)
	local function GetBackgroundOpacity()
		return addon.Database:GetSettings().backgroundOpacity
	end

	local function SetBackgroundOpacity(value)
		addon.Database:GetSettings().backgroundOpacity = value
		addon.BattleResTimer:UpdateBackground()
	end

	local setting = Settings.RegisterProxySetting(
		category,
		"MichsSimpleBattleResTimer_BackgroundOpacity",
		Settings.VarType.Number,
		"Opacity",
		addon.Database:GetDefaults().backgroundOpacity,
		GetBackgroundOpacity,
		SetBackgroundOpacity
	)

	local options = Settings.CreateSliderOptions(0, 1, 0.05)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
		return string.format("%d%%", math.floor(value * 100 + 0.5))
	end)

	Settings.CreateSlider(category, setting, options, "Set the battle resurrection timer background opacity.")
end

local function RegisterFontSizeSetting(category)
	local function GetFontSize()
		return addon.Database:GetSettings().fontSize
	end

	local function SetFontSize(value)
		addon.Database:GetSettings().fontSize = value
		addon.BattleResTimer:UpdateTextStyle()
	end

	local setting = Settings.RegisterProxySetting(
		category,
		"MichsSimpleBattleResTimer_FontSize",
		Settings.VarType.Number,
		"Size",
		addon.Database:GetDefaults().fontSize,
		GetFontSize,
		SetFontSize
	)

	local options = Settings.CreateSliderOptions(8, 64, 1)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)

	Settings.CreateSlider(category, setting, options, "Set the battle resurrection timer text size.")
end

function Options:Initialize()
	local category = Settings.RegisterVerticalLayoutCategory("Mich's Battle Res Timer")

	RegisterSectionHeader(category, "General")
	RegisterEnabledSetting(category)
	RegisterAlwaysShowSetting(category)

	RegisterSectionHeader(category, "Position")
	RegisterPositionXSetting(category)
	RegisterPositionYSetting(category)

	RegisterSectionHeader(category, "Panel")
	RegisterWidthSetting(category)
	RegisterHeightSetting(category)
	RegisterBackgroundOpacitySetting(category)

	RegisterSectionHeader(category, "Text")
	RegisterFontSizeSetting(category)

	Settings.RegisterAddOnCategory(category)
end
