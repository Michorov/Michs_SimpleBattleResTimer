local _, addon = ...

local EventHandler = {}
addon.EventHandler = EventHandler

local eventFrame = CreateFrame("Frame")
local initialized = false

function EventHandler:Initialize()
	if initialized then
		error("EventHandler already initialized", 2)
	end

	eventFrame:RegisterEvent("ENCOUNTER_START")
	eventFrame:RegisterEvent("ENCOUNTER_END")
	eventFrame:RegisterEvent("CHALLENGE_MODE_START")
	eventFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")

	eventFrame:SetScript("OnEvent", function(self, event, ...)
		if EventHandler[event] then
			EventHandler[event](EventHandler, event, ...)
		end
	end)

	initialized = true

	C_Timer.After(0, function()
		local _, _, difficultyID = GetInstanceInfo()

		if IsEncounterInProgress() or difficultyID == 8 then
			addon.BattleResTimer:Start()
		end
	end)
end

function EventHandler:ENCOUNTER_START()
	print("ENCOUNTER_START")
	addon.BattleResTimer:Start()
end

function EventHandler:ENCOUNTER_END()
	print("ENCOUNTER_END")
	addon.BattleResTimer:Stop()
end

function EventHandler:CHALLENGE_MODE_START()
	print("CHALLENGE_MODE_START")
	addon.BattleResTimer:Start()
end

function EventHandler:CHALLENGE_MODE_COMPLETED()
	print("CHALLENGE_MODE_COMPLETED")
	addon.BattleResTimer:Stop()
end
