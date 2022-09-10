Config = {
	Debug = false,
	Anims = {
		Locking = {
			Dict = "anim@heists@keycard@",
			Name = "exit",
			Flag = 48,
			Duration = 900,
		},
		Lockpick = {
			Dict = "missmechanic",
			Name = "work2_base",
			Flag = 49,
			Props = {
				{ Model = "prop_tool_screwdvr01", Bone = 60309, Offset = { 0.0, 0.0, -0.1, 0.0, 0.0, 0.0 }},
			},
			DisableMovement = true,
			Duration = 6000,
		},
		Thermite = {
			Dict = "misstrevor2ig_7",
			Name = "plant_bomb",
			Flag = 0,
			DisableMovement = true,
			Duration = 6000,
		},
	},
}