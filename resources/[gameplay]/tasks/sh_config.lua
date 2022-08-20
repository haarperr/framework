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
			Cooldown = 90000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					math.randomseed(math.floor(os.clock() * 1000))
					local time = (math.random(1, 5))
					exports.jail:AddTime(source, -time)
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
			Cooldown = 90000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					math.randomseed(math.floor(os.clock() * 1000))
					local time = (math.random(1, 5))
					exports.jail:AddTime(source, -time)
				end
			end,
		},
		WaterDispenser = {
			Label = "Get Water",
			Action = {
				Label = "Getting Water...",
				Duration = 10000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 45000,
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
			Cooldown = 90000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					math.randomseed(math.floor(os.clock() * 1000))
					local time = (math.random(1, 5))
					exports.jail:AddTime(source, -time)
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
				Duration = 30000,
				Disarm = true,
				CanCancel = true,
			},
			Cooldown = 90000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					math.randomseed(math.floor(os.clock() * 1000))
					local time = (math.random(1, 5))
					exports.jail:AddTime(source, -time)
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
						{ "Water-Based Lubricant", {1, 2}, 0.05 },
						{ "Mobile Phone", {1, 1}, 0.05 },
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
						local amount = math.random(10, 50)
						exports.inventory:GiveItem(source, "One Dollar", amount)
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
			Cooldown = 90000,
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

					local time = (math.random(1, 5))
					exports.jail:AddTime(source, -time)
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
			Cooldown = 90000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					local items = {
						{ "Plastic", 1, 0.25 },
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

					local time = (math.random(1, 5))
					exports.jail:AddTime(source, -time)
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
						{ "Bandage", {2, 7}, 0.1 },
						{ "One Dollar", {10, 50}, 0.1 },
						-- { "Coca Seed", {5, 10}, 0.06 },
						{ "Cracked USB", 1, 0.01 },
						{ "Diamond", {1, 2}, 0.02 },
						{ "Diamond Hammer", 1, 0.01 },
						{ "Dime", {1,10}, 0.2 },
						{ "Hacking Tool", {1, 3}, 0.08 },
						{ "Jar", {1, 4}, 0.12 },
						{ "Machete", 1, 0.01 },
						{ "Mobile Phone", 1, 0.05 },
						{ "Nickel", {1,20}, 0.2 },
						{ "Penny", {1,100}, 0.2 },
						{ "Plastic", {4, 8}, 0.15 },
						{ "Quarter", {1,4}, 0.2 },
						{ "Red Keycard", 1, 0.0002 },
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
						local amount = math.random(10, 50)
						exports.inventory:GiveItem(source, "One Dollar", amount)
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
						local amount = math.random(10, 50)
						exports.inventory:GiveItem(source, "One Dollar", amount)
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
						local amount = math.random(10, 50)
						exports.inventory:GiveItem(source, "One Dollar", amount)
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
			Cooldown = 90000,
			Result = function(source, wasCancelled)
				if wasCancelled then return end
				if source then
					math.randomseed(math.floor(os.clock() * 1000))
					local time = (math.random(1, 5))
					exports.jail:AddTime(source, -time)
				end
			end,
		},
	},
	Points = {
		-- Prison: Workout.
		{ "WashDown", vector4(1767.858642578125, 2598.8037109375, 45.79794692993164, 287.9361267089844) },
		{ "WashDown", vector4(1772.51318359375, 2598.754638671875, 45.79794692993164, 274.0845947265625) },
		{ "WashDown", vector4(1769.61376953125, 2590.609619140625, 45.79799652099609, 176.1097412109375) },
		--{ "WashWall", vector4(1749.0751953125, 2484.142578125, 45.74065780639648, 298.7015075683594) },
		--{ "WashWall", vector4(1752.712890625, 2480.013916015625, 49.69031143188476, 112.93594360351564) },
		{ "Yoga", vector4(1763.38134765625, 2598.412841796875, 45.79794311523437, 13.29598808288574) },
		{ "Broom", vector4(1771.5538330078125, 2593.297607421875, 45.79800796508789, 195.1168670654297) },
		-- Prison: Cafeteria and Kitchen.
		{ "WashDishes", vector4(1776.2271728515625, 2597.943115234375, 45.79794311523437, 91.95055389404295) },
		{ "WashWall", vector4(1779.870849609375, 2594.18994140625, 45.79794692993164, 355.3447875976563) },
		{ "Cook", vector4(1777.9041748046875, 2596.588134765625, 45.79799652099609, 274.0499267578125) },
		--{ "Cook", vector4(1777.4788818359375, 2561.876220703125, 45.67304611206055, 87.64872741699219) },
		--{ "Cook", vector4(1781.1783447265625, 2564.276611328125, 45.67305374145508, 358.593505859375) },
		--{ "Broom", vector4(1778.26513671875, 2547.620849609375, 45.67304992675781, 351.6233825683594) },
		-- Prison: Bed.
		{ "Bed", vector4(1789.7808837890625, 2585.061767578125, 45.79793930053711, 183.72720336914065) },
		{ "Bed", vector4(1769.06201171875, 2574.6435546875, 45.79794311523437, 356.7606506347656) },
		{ "Bed", vector4(1769.58984375, 2586.446044921875, 50.54985809326172, 1.36685121059417) },
		{ "Bed", vector4(1786.413818359375, 2601.616943359375, 50.54978942871094, 272.98016357421875) },
		{ "Bed", vector4(1781.17236328125, 2568.318115234375, 50.54978561401367, 91.04426574707033) },
		-- Prison: Box.
		--{ "BoxSearch", vector4(1787.8841552734375, 2564.288330078125, 45.67304229736328, 359.6025085449219) },
		--{ "BoxSearch", vector4(1747.3831787109375, 2475.370361328125, 45.74060821533203, 207.76742553710935) },
		-- Prison: Infirmary.
		--{ "WashWall", vector4(1768.1290283203125, 2599.034912109375, 45.72981262207031, 357.1125793457031) },
		{ "WashDown", vector4(1779.5504150390625, 2557.265380859375, 45.79785919189453, 213.7288360595703) },
		{ "Broom", vector4(1779.6513671875, 2561.79296875, 45.79785919189453, 356.9254150390625) },
		{ "Broom", vector4(1785.5013427734375, 2555.660400390625, 45.79792404174805, 172.87991333007812) },
		-- Prison: Shower.
		{ "Shower", vector4(1762.6414794921875, 2581.96923828125, 45.79799652099609, 277.9789123535156) },
		{ "WashWall", vector4(1760.6099853515625, 2584.679931640625, 45.79800415039062, 91.34064483642578) },
		{ "WashWall", vector4(1766.30322265625, 2578.52978515625, 45.79800415039062, 271.37841796875) },
		-- Prison: Water.
		{ "WaterDispenser", vector4(1765.7059326171875, 2599.26171875, 45.79799652099609, 358.27001953125) },
		{ "WaterDispenser", vector4(1781.3092041015625, 2594.374267578125, 50.54985427856445, 314.5218200683594) },
		--{ "WaterDispenser", vector4(1763.81494140625, 2574.21923828125, 45.7298469543457, 89.12178039550781) },
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
		{ "WaterDispenser", vector4(-440.21478271484375, 6009.42724609375, 32.28871536254883, 219.3275146484375) },
		{ "WaterDispenser", vector4(-451.6120910644531, 6001.4990234375, 32.2886962890625, 54.55283737182617) },
		{ "WaterDispenser", vector4(-446.7051086425781, 6008.154296875, 27.58151626586914, 315.9067687988281) },
		{ "WaterDispenser", vector4(-442.52825927734375, 5994.7470703125, 27.58149147033691, 234.59979248046875) },
		{ "WaterDispenser", vector4(-442.52825927734375, 5994.7470703125, 27.58149147033691, 234.59979248046875) },
		{ "WaterDispenser", vector4(-442.55224609375, 6004.11962890625, 36.99568176269531, 48.59518814086914) },
		-- PDM.
		{ "WaterDispenser", vector4(-27.53786087036132, -1088.2333984375, 27.27437210083007, 332.6189270019531) },
		--[[ Cayo Perico: Villa
		{ "Landscape", vector4(4984.11962890625, -5735.578125, 20.04571723937988, 297.7596435546875) },
		{ "Landscape", vector4(5044.587890625, -5770.005859375, 15.7563362121582, 23.53479194641113) },
		{ "Yoga", vector4(5027.65673828125, -5762.033203125, 15.77170753479003, 322.9723205566406) },
		{ "WaterDispenser", vector4(5021.27294921875, -5806.23828125, 17.47768974304199, 29.84697532653808) },
		-- Cayo Perico: Power Sub-Station
		{ "Weld", vector4(4478.935546875, -4593.03076171875, 5.5574893951416, 222.88539123535156) },
		{ "Weld", vector4(4486.4189453125, -4583.37255859375, 5.55360603332519, 308.5042724609375) },--]]
	},
}
