local _, addon = ...

local EventHandler = {}
addon.EventHandler = EventHandler

local eventFrame = CreateFrame("Frame")
local initialized = false

local function CheckForActiveState()
	C_Timer.After(0, function()
		local _, _, difficultyID = GetInstanceInfo()

		if IsEncounterInProgress() or difficultyID == 8 then
			addon.BattleResTimer:Start()
		else
			addon.BattleResTimer:Stop()
		end
	end)
end

function EventHandler:Initialize()
	if initialized then
		error("EventHandler already initialized", 2)
	end

	eventFrame:RegisterEvent("ENCOUNTER_START")
	eventFrame:RegisterEvent("ENCOUNTER_END")
	eventFrame:RegisterEvent("CHALLENGE_MODE_START")
	eventFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	eventFrame:SetScript("OnEvent", function(self, event, ...)
		if EventHandler[event] then
			EventHandler[event](EventHandler, event, ...)
		end
	end)

	initialized = true

	CheckForActiveState()
end

function EventHandler:ENCOUNTER_START()
	addon.BattleResTimer:Start()
end

function EventHandler:ENCOUNTER_END()
	addon.BattleResTimer:Stop()
end

function EventHandler:CHALLENGE_MODE_START()
	addon.BattleResTimer:Start()
end

function EventHandler:CHALLENGE_MODE_COMPLETED()
	addon.BattleResTimer:Stop()
end

function EventHandler:PLAYER_ENTERING_WORLD()
	CheckForActiveState()
end

function EventHandler:ZONE_CHANGED_NEW_AREA()
	CheckForActiveState()
end
