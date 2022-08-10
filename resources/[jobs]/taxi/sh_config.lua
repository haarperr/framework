Config = {
	Debug = true,
	DefaultMeterRate = 50.0,
	SecondsAfterStartingFareBeforeWarningsOccur = 30,
	SecondsBetweenTooFarWarnings = 15,
	MaxTooFareWarningsAllowed = 3,
	MaxSpeedAllowedInMPH = 100,
	SecondsOverMaxSpeedAllowedInMPHToCancel = 15,
	SecondsBetweenSpeedWarnings = 5,
	SecondsOutOfVehicleBeforeCancel = 30,
	MaxFareTimeInMinutes = 30,
	Taxis = {
		["taxi"] = true,
		["stretch"] = true,
		["patriot2"] = true,
	},
	WaitingScenarios = { 
		"WORLD_HUMAN_TOURIST_MOBILE", 
		--"WORLD_HUMAN_SMOKING", 
		"WORLD_HUMAN_STAND_IMPATIENT", 
		"WORLD_HUMAN_STAND_MOBILE", 
		"WORLD_HUMAN_TOURIST_MAP",
		"WORLD_HUMAN_TOURIST_MOBILE" 
	},
	WaitingAnim = {
		Dict = "taxi_hail",
		Name = "hail_taxi",
		Flag = 48,
		BlendSpeed = 1.0,
		Rate = 0.0,
	},
	Messages = {
		GettingClose = {
			"Looks like we're getting close.",
			"Getting close message #2",
			"Getting close message #3",
			"Getting close message #4",
			"Getting close message #5",
		},
		AlmostThere = {
			"Hey, we're almost there!",
			"Almost there message #2",
			"Almost there message #3",
			"Almost there message #4",
			"Almost there message #5",
		},
		ArrivedAtDestination = {
			"This is my stop.",
			"This is fine right here, thanks.",
			"You can drop me off here.",
			"I'll walk from here. thanks for the ride!",
			"Arrived at destination message #5",
		},
		TooFar = {
			"Too far message #1",
			"Too far message #2",
			"Too far message #3",
			"Too far message #4",
			"Too far message #5",
		},
		TooFast = {
			"Too fast message #1",
			"Too fast message #2",
			"Too fast message #3",
			"Too fast message #4",
			"Too fast message #5",
		}
	}
}

for k, v in pairs(Config.Taxis) do
	Config.Taxis[GetHashKey(k)] = v
end