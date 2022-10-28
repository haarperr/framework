Config = {
	Debug = false,
	GridSize = 4,
	MaxDistance = 5.0,
	Controls = {
		Place = 24,
		Cancel = 25,
		FineTune = 21,
		RotateR = 44,
		RotateL = 46,
		VariantR = 96,
		VariantL = 97,
	},
	Placing = {
		Anim = {
			Dict = "pickup_object",
			Name = "putdown_low",
			Flag = 0,
			Duration = 1500,
		},
	},
	Pickup = {
		MaxDistance = 3.0,
		Anim = {
			Dict = "pickup_object",
			Name = "putdown_low",
			Flag = 0,
			Duration = 1500,
		},
	},
	HarvestDistance = 2.15,
	Harvesting = {
		Anim = {
			Sequence = {
				{
					Dict = "amb@world_human_gardener_plant@male@enter",
					Name = "enter",
					Flag = 0,
					DisableMovement = true,
					BlendOut = 2.0,
					Delay = 3000,
				},
				{
					Dict = "amb@world_human_gardener_plant@male@base",
					Name = "base",
					Flag = 0,
					DisableMovement = true,
					BlendSpeed = 2.0,
					Delay = 2000,
				},
				{
					Dict = "amb@world_human_gardener_plant@male@exit",
					Name = "exit",
					Flag = 0,
					DisableMovement = true,
					BlendIn = 2.0,
				},
			}
		},
		Label = "Harvesting...",
		Duration = 9000,
		UseWhileDead = false,
		CanCancel = true,
		Disarm = false,
	},
}
