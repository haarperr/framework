Config = {
	Tasks = {
		WashWall = {
			Label = "Clean",
			Action = {
				Anim = {
					Dict = "amb@world_human_maid_clean@",
					Name = "base",
					Flag = 1,
					Props = {
						{ Model = "prop_sponge_01", Bone = 28422, Offset = { 0.0, 0.0, -0.01, 90.0, 0.0, 0.0 } },
					},
					DisableMovement = true,
				},
				Label = "Cleaning...",
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 60000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					math.randomseed(math.floor(os.clock() * 1000))
					local amount = math.random(5, 10)
					exports.inventory:GiveItem(source, "Bills", amount)
					exports.log:AddEarnings(source, "Tasks", amount)
				end
			end,
		},
		Shower = {
			Label = "Shower",
			Action = {
				Anim = {
					Dict = "mp_safehouseshower@female@",
					Name = "shower_idle_a",
					Flag = 1,
					DisableMovement = true,
				},
				Label = "Showering...",
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 60000,
		},
		WaterDispenser = {
			Label = "Get Water",
			Action = {
				Label = "Getting Water...",
				Duration = 10000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 20000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					exports.inventory:GiveItem(source, "Water")
				end
			end,
		},
		Cook = {
			Label = "Cook",
			Action = {
				Anim = {
					Dict = "amb@prop_human_bbq@male@idle_a",
					Name = "idle_b",
					Flag = 1,
				},
				Label = "Cooking...",
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 60000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						"Beef",
						"Venison",
						"Apple",
						"Orange",
						"Tomato",
					}
					math.randomseed(math.floor(os.clock() * 1000))
					exports.inventory:GiveItem(source, items[math.random(1, #items)])
				end
			end,
		},
		Broom = {
			Label = "Broom",
			Action = {
				Anim = {
					Dict = "amb@world_human_janitor@male@idle_a",
					Name = "idle_a",
					Props = {
						{ Model = "prop_tool_broom", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 } },
					},
					Flag = 1,
					DisableMovement = true,
				},
				Label = "Sweeping...",
				Duration = 12000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 60000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					math.randomseed(math.floor(os.clock() * 1000))
					local amount = math.random(5, 10)
					exports.inventory:GiveItem(source, "Bills", amount)
					exports.log:AddEarnings(source, "Tasks", amount)
				end
			end,
		},
		Bed = {
			Label = "Search",
			Action = {
				Anim = {
					Dict = "missexile3",
					Name = "ex03_dingy_search_case_base_michael",
					Flag = 1,
				},
				Label = "Searching...",
				Duration = 25000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 60000 * 20,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						{ "Oxycodone", {1, 2}, 0.02 },
						{ "Cocaine", {1, 2}, 0.02 },
						{ "Water-Based Lubricant", {1, 2}, 0.5 },
						{ "Cigarette", {1, 3}, 0.5 },
						{ "Mobile Phone", {1, 1}, 0.01 },
						{ "Shank", {1, 1}, 0.001 },
						{ "Paperclip", {1, 2}, 0.1 },
					}

					exports.log:Add({
						source = source,
						verb = "searched",
						noun = "bed",
					})
					
					local didGive = false
					for k, item in ipairs(items) do
						math.randomseed(math.floor(os.clock() * 1000) + k * 782)
						if math.random() <= item[3] then
							local amount = item[2]
							if type(amount) == "table" then
								amount = math.random(amount[1], amount[2])
							end
							didGive = true
							exports.inventory:GiveItem(source, item[1], amount)
						end
					end
					if not didGive then
						local amount = math.random(50, 100)
						exports.inventory:GiveItem(source, "Bills", amount)
					end
				end
			end,
		},
		WashDishes = {
			Label = "Washing",
			Action = {
				Anim = {
					Dict = "missheistdocks2aleadinoutlsdh_2a_int",
					Name = "cleaning_wade",
					Flag = 1,
					DisableMovement = true,
				},
				Label = "Washing...",
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 30000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						{ "Plastic", 1, 0.25 },
						{ "Toothbrush", 1, 0.02 },
					}

					exports.log:Add({
						source = source,
						verb = "washed",
						noun = "dishes",
					})

					local didGive = false
					for k, item in ipairs(items) do
						math.randomseed(math.floor(os.clock() * 1000) + k * 782)
						if math.random() <= item[3] then
							local amount = item[2]
							if type(amount) == "table" then
								amount = math.random(amount[1], amount[2])
							end
							didGive = true
							exports.inventory:GiveItem(source, item[1], amount)
						end
					end
					if not didGive then
						TriggerClientEvent("notify:sendAlert", source, "inform", ("Nothing Found"))
					end
				end
			end,
		},
		WashDown = {
			Label = "Washing",
			Action = {
				Anim = {
					Dict = "missheistdocks2aleadinoutlsdh_2a_int",
					Name = "cleaning_wade",
					Flag = 1,
					DisableMovement = true,
				},
				Label = "Washing...",
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 30000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						{ "Scrap Metal", 1, 0.25 },
					}

					exports.log:Add({
						source = source,
						verb = "washed",
						noun = "gym",
					})

					local didGive = false
					for k, item in ipairs(items) do
						math.randomseed(math.floor(os.clock() * 1000) + k * 782)
						if math.random() <= item[3] then
							local amount = item[2]
							if type(amount) == "table" then
								amount = math.random(amount[1], amount[2])
							end
							didGive = true
							exports.inventory:GiveItem(source, item[1], amount)
						end
					end
					if not didGive then
						TriggerClientEvent("notify:sendAlert", source, "inform", ("Nothing Found"))
					end
				end
			end,
		},
		BoxSearch = {
			Label = "Search",
			Action = {
				Anim = {
					Dict = "missexile3",
					Name = "ex03_dingy_search_case_base_michael",
					Flag = 1,
				},
				Label = "Searching boxes...",
				Duration = 35000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 30000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						{ "Pliers", 1, 0.35 },
						{ "Screwdriver", 1, 0.25 },
						{ "Thermite", 1, 0.005 },
					}

					exports.log:Add({
						source = source,
						verb = "searched",
						noun = "box",
					})

					local didGive = false
					for k, item in ipairs(items) do
						math.randomseed(math.floor(os.clock() * 1000) + k * 782)
						if math.random() <= item[3] then
							local amount = item[2]
							if type(amount) == "table" then
								amount = math.random(amount[1], amount[2])
							end
							didGive = true
							exports.inventory:GiveItem(source, item[1], amount)
						end
					end
					if not didGive then
						TriggerClientEvent("notify:sendAlert", source, "inform", ("Nothing Found"))
					end
				end
			end,
		},
		Robbery = {
			Label = "Search",
			Action = {
				Anim = {
					Dict = "missexile3",
					Name = "ex03_dingy_search_case_base_michael",
					Flag = 1,
				},
				Label = "Searching...",
				Duration = 15000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 60000 * 60,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						{ "9mm Ammo", {1, 5}, 0.05 },
						{ "Bandage", {2, 7}, 0.1 },
						{ "Bills", {50, 100}, 0.1 },
						{ "Brown Keycard", 1, 0.0001 },
						{ "Coca Leaves", {8, 16}, 0.05 },
						-- { "Coca Seed", {5, 10}, 0.06 },
						{ "Diamond", {1, 2}, 0.02 },
						{ "Dime", {1,10}, 0.2 },
						{ "Even Die", 1, 0.0001 },
						{ "Gold Bar", 1, 0.0001 },
						{ "Green Keycard", 1, 0.0002 },
						{ "Hacking Tool", {1, 3}, 0.08 },
						{ "Jar", {1, 4}, 0.12 },
						{ "Machete", 1, 0.01 },
						{ "Mobile Phone", 1, 0.05 },
						{ "Nickel", {1,20}, 0.2 },
						{ "Odd Die", 1, 0.0001 },
						{ "Penny", {1,100}, 0.2 },
						{ "Pistol", 1, 0.008 },
						{ "Plastic", {4, 8}, 0.15 },
						{ "Quarter", {1,4}, 0.2 },
						{ "Red Keycard", 1, 0.0002 },
						{ "Scratch Off", {1,2}, 0.04 },
						{ "Valuable Goods", {1, 2}, 0.001 },
						{ "Weed Seed", {5, 10}, 0.07 },
						{ "Weed", {5, 10}, 0.08 },
					}

					exports.log:Add({
						source = source,
						verb = "robbed",
						noun = "house",
					})
					
					local didGive = false
					for k, item in ipairs(items) do
						math.randomseed(math.floor(os.clock() * 1000) + k * 782)
						if math.random() <= item[3] then
							local amount = item[2]
							if type(amount) == "table" then
								amount = math.random(amount[1], amount[2])
							end
							didGive = true
							exports.inventory:GiveItem(source, item[1], amount)
						end
					end
					if not didGive then
						local amount = math.random(50, 100)
						exports.inventory:GiveItem(source, "Bills", amount)
						exports.log:AddEarnings(source, "House Robbery", amount)
					end
				end
			end,
		},
		Weld = {
			Label = "Welding",
			Action = {
				Anim = {
					Scenario = "WORLD_HUMAN_WELDING",
					DisableMovement = true,
				},
				Label = "Repairing...",
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 30000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						{ "Screws", 1, 0.25 },
						{ "Scrap Aluminum", 1, 0.25 },
					}

					exports.log:Add({
						source = source,
						verb = "repaired",
						noun = "transformer",
					})

					local didGive = false
					for k, item in ipairs(items) do
						math.randomseed(math.floor(os.clock() * 1000) + k * 782)
						if math.random() <= item[3] then
							local amount = item[2]
							if type(amount) == "table" then
								amount = math.random(amount[1], amount[2])
							end
							didGive = true
							exports.inventory:GiveItem(source, item[1], amount)
						end
					end
					if not didGive then
						local amount = math.random(50, 100)
						exports.inventory:GiveItem(source, "Bills", amount)
						exports.log:AddEarnings(source, "Tasks", amount)
					end
				end
			end,
		},
		Landscape = {
			Label = "Landscaping",
			Action = {
				Anim = {
					Scenario = "WORLD_HUMAN_GARDENER_LEAF_BLOWER",
					DisableMovement = true,
				},
				Label = "Blowing leaves away...",
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 30000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						{ "Pumpkin Seed", 1, 0.1 },
						{ "Tomato Seed", 1, 0.1 },
						{ "Cabbage Seed", 1, 0.1 },
					}

					exports.log:Add({
						source = source,
						verb = "landscaped",
						noun = "grass",
					})

					local didGive = false
					for k, item in ipairs(items) do
						math.randomseed(math.floor(os.clock() * 1000) + k * 782)
						if math.random() <= item[3] then
							local amount = item[2]
							if type(amount) == "table" then
								amount = math.random(amount[1], amount[2])
							end
							didGive = true
							exports.inventory:GiveItem(source, item[1], amount)
						end
					end
					if not didGive then
						local amount = math.random(50, 100)
						exports.inventory:GiveItem(source, "Bills", amount)
						exports.log:AddEarnings(source, "Tasks", amount)
					end
				end
			end,
		},
		Yoga = {
			Label = "Yoga",
			Action = {
				Anim = {
					Scenario = "WORLD_HUMAN_YOGA",
					DisableMovement = true,
				},
				Label = "Practicing yoga...",
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 60000,
		},
	},
	Points = {
		-- Prison: Workout.
		{ "WashDown", vector4(1742.3125, 2482.134521484375, 45.74069213867187, 30.83689498901367) },
		{ "WashDown", vector4(1746.361572265625, 2478.791748046875, 45.74065780639648, 312.45233154296875) },
		{ "WashWall", vector4(1749.0751953125, 2484.142578125, 45.74065780639648, 298.7015075683594) },
		{ "Yoga", vector4(1743.007080078125, 2480.65576171875, 45.75935745239258, 299.0469055175781) },
		-- Prison: Cafeteria and Kitchen.
		{ "WashDishes", vector4(1778.31298828125, 2564.42236328125, 45.67305374145508, 358.5112609863281) },
		{ "WashWall", vector4(1784.906982421875, 2560.8896484375, 45.67305755615234, 181.0423583984375) },
		{ "Cook", vector4(1777.4788818359375, 2561.876220703125, 45.67304611206055, 87.64872741699219) },
		{ "Cook", vector4(1781.1783447265625, 2564.276611328125, 45.67305374145508, 358.593505859375) },
		{ "Broom", vector4(1778.26513671875, 2547.620849609375, 45.67304992675781, 351.6233825683594) },
		-- Prison: Bed.
		{ "Bed", vector4(1748.21142578125, 2489.554931640625, 45.74065017700195, 115.00933074951172) },
		{ "Bed", vector4(1777.7144775390625, 2483.791015625, 45.74065017700195, 298.03216552734375) },
		{ "Bed", vector4(1768.2901611328125, 2478.36962890625, 45.74065780639648, 297.44647216796875) },
		{ "Bed", vector4(1754.372802734375, 2493.28515625, 45.74065399169922, 120.23528289794922) },
		-- Prison: Box.
		{ "BoxSearch", vector4(1787.8841552734375, 2564.288330078125, 45.67304229736328, 359.6025085449219) },
		{ "BoxSearch", vector4(1747.3831787109375, 2475.370361328125, 45.74060821533203, 207.76742553710935) },
		-- Prison: Infirmary.
		{ "WashWall", vector4(1768.1290283203125, 2599.034912109375, 45.72981262207031, 357.1125793457031) },
		-- Prison: Water.
		{ "WaterDispenser", vector4(1841.0802001953127, 2591.391357421875, 46.01428985595703, 0.17953316867351) },
		{ "WaterDispenser", vector4(1768.1290283203125, 2599.034912109375, 45.72981262207031, 357.1125793457031) },
		{ "WaterDispenser", vector4(1763.81494140625, 2574.21923828125, 45.7298469543457, 89.12178039550781) },
		-- MRPD.
		{ "WaterDispenser", vector4(463.1131286621094, -979.3531494140624, 30.68968391418457, 273.9939270019531) },
		{ "WaterDispenser", vector4(473.914794921875, -988.2869873046876, 26.27343559265136, 181.22850036621097) },
		{ "WaterDispenser", vector4(465.051513671875, -988.0109252929688, 34.97170257568359, 93.6449737548828) },
		{ "WaterDispenser", vector4(440.97894287109375, -994.229248046875, 34.97172164916992, 177.10462951660156) },
		{ "WaterDispenser", vector4(439.9554443359375, -999.5549926757812, 34.97012710571289, 179.07289123535156) },
		-- Davis.
		{ "WaterDispenser", vector4(361.6973571777344, -1594.7164306640625, 29.29203796386718, 50.67141342163086) },
		{ "WaterDispenser", vector4(383.16363525390625, -1605.3228759765625, 29.29203414916992, 50.3371353149414) },
		-- Sandy.
		{ "WaterDispenser", vector4(1846.7664794921875, 3686.22509765625, 38.07137680053711, 124.71986389160156) },
		-- Paleto.
		{ "WaterDispenser", vector4(-443.95751953125, 6011.09423828125, 31.71636009216308, 225.95425415039065) },
		{ "WaterDispenser", vector4(-431.12542724609375, 5992.30224609375, 31.71605682373047, 225.2588043212891) },
		{ "WaterDispenser", vector4(-439.3061828613281, 6005.48876953125, 31.71631622314453, 12.52519702911377) },
		-- La Mesa.
		{ "WaterDispenser", vector4(843.8786010742188, -1291.28125, 24.32033920288086, 320.464599609375) },
		{ "WaterDispenser", vector4(832.7557983398438, -1282.6800537109375, 24.32034111022949, 273.74847412109375) },
		{ "WaterDispenser", vector4(835.30224609375, -1309.16748046875, 28.23318672180175, 185.71261596679688) },
		-- Cayo Perico: Villa
		{ "Landscape", vector4(4984.11962890625, -5735.578125, 20.04571723937988, 297.7596435546875) },
		{ "Landscape", vector4(5044.587890625, -5770.005859375, 15.7563362121582, 23.53479194641113) },
		{ "Yoga", vector4(5027.65673828125, -5762.033203125, 15.77170753479003, 322.9723205566406) },
		{ "WaterDispenser", vector4(5021.27294921875, -5806.23828125, 17.47768974304199, 29.84697532653808) },
		-- Cayo Perico: Power Sub-Station
		{ "Weld", vector4(4478.935546875, -4593.03076171875, 5.5574893951416, 222.88539123535156) },
		{ "Weld", vector4(4486.4189453125, -4583.37255859375, 5.55360603332519, 308.5042724609375) },
	},
}