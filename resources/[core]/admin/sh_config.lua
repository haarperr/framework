Config = {
	Options = {
		{
			label = "Player",
			caption = "Player options",
			icon = "person",
			options = {
				{ label = "God Mode", hook = "godmode", caption = "Never take damage", checkbox = false },
				{ label = "Invisibility", hook = "invisibility", caption = "Go invisible for other players", checkbox = false },
				{ label = "Set Model", hook = "setModel", caption = "Set a specific model by string" },
				{ label = "Appearance", hook = "viewAppearance", caption = "Open the character appearance editor" },
				{ label = "Slay", hook = "slay", caption = "Kill yourself" },
				{ label = "Revive", hook = "revive", caption = "Heal yourself" },
			},
		},
		{
			label = "Vehicle",
			caption = "Vehicle options",
			icon = "commute",
			options = {
				{ label = "Repair", hook = "repairVehicle", caption = "Instantly and completely fix your vehicle" },
				{ label = "Clean", hook = "cleanVehicle", caption = "Make your vehicle squeeky clean" },
				{ label = "Enter", hook = "enterVehicle", caption = "Teleport yourself into the nearest vehicle" },
				{ label = "Exit", hook = "exitVehicle", caption = "Teleport yourself out of the vehicle" },
			},
		},
		{
			label = "Tools",
			caption = "Testing and miscallenous",
			icon = "build",
			options = {
				{ label = "Player Blips", hook = "playerBlips", caption = "View blips on the map of other players", checkbox = false },
				{ label = "Entity Debugger", hook = "debuggerEntity", caption = "View entity info", checkbox = false },
				{ label = "Player Debugger", hook = "debuggerPlayer", caption = "View player info", checkbox = false },
				{ label = "Shooting Visualizer", hook = "viewShooting", caption = "Watch shots being fired", checkbox = false },
			},
		},
	},
}