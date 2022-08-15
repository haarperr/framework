Config = {
	GridSize = 3,
	Scrapper = {
		Action = {
			Duration = 10000,
			Label = "Scrapping...",
			UseWhileDead = false,
			CanCancel = true,
			Disarm = true,
			ControlDisables = {
				DisableMovement = false,
				DisableCarMovement = false,
				DisableMouse = false,
				DisableCombat = false,
			},
			Anim = {
				-- Dict = "pickup_object",
				-- Name = "pickup_low",
				Dict = "mini@strip_club@leaning@toss",
				Name = "toss_full",
				Flag = 1,
				Props = {
					{ Model = "prop_cs_cardbox_01", Bone = 4103, Offset = { 0.0, 1.0, 0.0, 0.0, 0.0, 0.0 } },
				},
			},
		},
		Markers = {
			Text = "Scrap",
			DrawRadius = 10.0,
			Radius = 2.0,
		},
		Scrappers = {
			-- La Puerta.
			{ Coords = vector4(-527.14099121094, -1706.0509033203, 19.322288513184, 63.281803131104) },

			-- La Mesa.
			{ Coords = vector4(935.30688476563, -1506.9722900391, 30.620820999146, 24.210508346558) },
			
			-- Greenwich Parkway.
			{ Coords = vector4(-1165.3070068359, -2037.1821289063, 13.388650894165, 334.13116455078) },

			--Sandy.
			{ Coords = vector4(2358.10986328125, 3139.121337890625, 48.20869445800781, 346.8075256347656) },
		},
	},
	Scrapping = {
		Action = {
			Duration = 1000,
			Label = "Picking up...",
			UseWhileDead = false,
			CanCancel = true,
			Disarm = true,
			ControlDisables = {
				DisableMovement = false,
				DisableCarMovement = false,
				DisableMouse = false,
				DisableCombat = false,
			},
			Anim = {
				-- Dict = "pickup_object",
				-- Name = "pickup_low",
				Dict = "pickup_object",
				Name = "pickup_low",
				Flag = 0,
			}
		},
		CarryEmote = {
			Dict = "anim@heists@box_carry@",
			Name = "idle",
			Flag = 49,
			Props = {
				{ Model = "", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 90.0 } },
			},
		},
		MaxDistance = 2.0,
		Props = {
			-- Oil & plastic.
			{ Model = "prop_oiltub_01", Items = { {"Scrap Plastic", 1, 2}, {"Dirty Oil", 2, 6} }, Offset = { -0.19, -0.12, -0.04, 0.0, 90.0, 0.0 } },
			{ Model = "prop_oiltub_02", Items = { {"Scrap Plastic", 1, 2}, {"Dirty Oil", 2, 6} }, Offset = { -0.19, -0.12, -0.04, 0.0, 90.0, 0.0 } },
			{ Model = "prop_oiltub_03", Items = { {"Scrap Plastic", 1, 2}, {"Dirty Oil", 4, 8} }, UseBox = true },
			{ Model = "prop_oiltub_04", Items = { {"Scrap Plastic", 1, 1}, {"Dirty Oil", 1, 10} }, UseBox = true },
			{ Model = "prop_oiltub_05", Items = { {"Scrap Plastic", 1, 2}, {"Dirty Oil", 2, 8} }, Offset = { -0.19, -0.12, -0.04, 0.0, 90.0, 0.0 } },
			
			-- Metal.
			{ Model = "prop_barrel_float_1", Items = { {"Scrap Metal", 1, 1} }, Offset = { 0.0, -0.18, 0.28, 0.0, 90.0, 0.0 } },
			{ Model = "prop_barrel_float_2", Items = { {"Scrap Metal", 1, 1} }, Offset = { 0.0, -0.18, 0.28, 0.0, 90.0, 0.0 } },
			{ Model = "prop_barrel_01a", Items = { {"Scrap Metal", 1, 1} }, Offset = { 0.0, -0.18, 0.28, 0.0, 0.0, 90.0 } },
			{ Model = "prop_barrel_03d", Items = { {"Scrap Metal", 1, 1} }, Offset = { 0.0, -0.18, 0.28, 0.0, 0.0, 90.0 } },
			{ Model = "prop_offroad_barrel01", Items = { {"Scrap Metal", 1, 31} }, Offset = { 0.0, -0.18, 0.28, 0.0, 0.0, 90.0 } },
			
			-- Oil & metal.
			{ Model = "prop_barrel_exp_01c", Items = { {"Scrap Metal", 1, 2}, {"Dirty Oil", 2, 8} }, Offset = { 0.0, -0.18, 0.28, 0.0, 0.0, 90.0 } },
			{ Model = "prop_barrel_exp_01a", Items = { {"Scrap Metal", 1, 2}, {"Dirty Oil", 2, 8} }, Offset = { 0.0, -0.18, 0.28, 0.0, 0.0, 90.0 } },
			
			-- Plastic.
			{ Model = "prop_barrel_02b", Items = { {"Scrap Plastic", 1, 3} }, Offset = { 0.0, -0.05, 0.24, 0.0, 0.0, 0.0 } },
			{ Model = "prop_oiltub_06", Items = { {"Scrap Plastic", 1, 1} }, UseBox = true },
			
			-- Scrap electronics.
			{ Model = "prop_rub_monitor", Items = { {"Electronics", 1, 1} }, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 90.0 } },
			
			-- Wood.
			{ Model = "prop_rub_planks_01", Items = { {"Wood", 1, 2} }, Offset = { 0.0, -0.14, -0.19, 90.0, -30.0, 90.0 } },
			{ Model = "prop_rub_planks_02", Items = { {"Wood", 1, 2} }, Offset = { 0.0, -0.14, -0.19, 90.0, -30.0, 90.0 } },
			{ Model = "prop_rub_planks_04", Items = { {"Wood", 1, 2} }, Offset = { 0.0, -0.14, -0.19, 90.0, -30.0, 90.0 } },
			
			-- Rubber.
			{ Model = "prop_rub_tyre_01", Items = { {"Rubber", 1, 1} }, Offset = { 0.0, -0.04, 0.2, 0.0, 0.0, 0.0 } },
			{ Model = "prop_rub_tyre_02", Items = { {"Rubber", 1, 1} }, Offset = { 0.0, -0.04, 0.2, 0.0, 0.0, 0.0 } },
			{ Model = "prop_rub_tyre_03", Items = { {"Rubber", 1, 1} }, Offset = { 0.0, -0.04, 0.2, 0.0, 0.0, 0.0 } }, -- More
	
			-- Fabric.
			{ Model = "prop_rub_carpart_05", Offset = { 0.0, 0.2, 0.0, -40.0, 0.0, 180.0 } },
		},
	},
}
