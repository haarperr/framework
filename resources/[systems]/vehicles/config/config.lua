Config = {
	Driving = {
		FuelBurnRate = 0.000015,
	},
	FieldKit = {
		Anim = {
			Dict = "missmechanic",
			Name = "work2_base",
			Flag = 49,
			Duration = 6000,
			Props = {
				{ Model = "prop_tool_screwdvr01", Bone = 60309, Offset = { 0.0, 0.0, -0.1, 0.0, 0.0, 0.0 }},
			},
			DisableMovement = true,
		},
	},
	Navigation = {
		Doors = {
			Anim = { Dict = "pickup_object", Name = "putdown_low", Flag = 48, Duration = 1200 },
			Distances = {
				[-1] = 1.5,
				[4] = 2.0,
				[5] = 2.0,
			},
		}
	},
	Values = {
		GearShiftDownDelay = 800, -- How long, in milliseconds, the clutch will be forced to 0.0 after clutching down, preventing a double clutch.
	},
	Repair = {
		Energy = 0.05, -- How much energy is required and taken when switching parts or repairing.
		EnergyNearLift = 0.01, -- Same as energy, but while near a lift.
		SalvageChance = 0.8, -- The chance when, removing a broken part, they obtain its "salvage."
		Degradation = 0.1, -- How much random durability can be taken (from 0) from the part being removed.
		Engine = { -- Repairing the engine (using a Repair Kit, or other item definition where item.part == "Engine").
			ItemDurability = { 0.1, 0.15 }, -- Range of durability taken from the item used to repair.
			MaxHealth = 0.8, -- The health to set the engine when not near a lift.
		},
		CarJack = { -- Repairing tires (using a Car Jack).
			ItemDurability = { 0.05, 0.1 }, -- Range of durability taken from the item used to repair.
		},
	},
	Washing = {
		ItemDurability = 0.1, -- How much durability to take, scaled with vehicle dirt level.
	},
	DamageMults = {
		Base = 1.5,
		CarCollision = 2.0,
		WorldCollision = 1.0,
	},
	Stalling = {
		MinDamage = 20.0,
		StallTime = { 1000, 3000 },
	},
	Spinning = {
		CutChance = 0.5, -- Chance the engine will cut out while spinning out and stalling.
		LowSpeed = 30.0, -- How fast (MPH) the vehicle must be going to stall out in a vehicle collision.
		HighSpeed = 70.0, -- How fast (MPH) the vehicle must be going to stall out normally, when spinning out.
		DotProduct = 0.5, -- The minimum dot product before stalling, compared with the forward vector and velocity of the vehicle.
	},
	Locking = {
		Delay = 2000,
		Anim = {
			Flag = 48,
			Dict = "anim@mp_player_intmenu@key_fob@",
			Name = "fob_click",
			Duration = 1000,
		},
		-- Vehicle classes that cannot be locked.
		Blacklist = {
			[8] = true, -- Motorcycles
			[13] = true, -- Cycles
			[14] = true, -- Boats
		},
	},
	Towing = {
		Action  = {
			Anim = {
				Dict = "missexile3",
				Name = "ex03_dingy_search_case_base_michael",
				Flag = 48,
				DisableMovement = true,
			},
			Label = "Towing...",
			Duration = 4000,
			UseWhileDead = false,
			CanCancel = true,
			Disarm = true,
		},
		Beds = {
			[1353720154] = {
				Entry = vector3(0.0, -9.0, 0.0),
				Offset = vector3(0.0, -2.5, 1.0),
				Rot = vector3(0.0, 0.0, 0.0),
				Bone = 0,
			},
			[-777275802] = {
				Entry = vector3(0.0, -14.0, 0.0),
				Offset = vector3(0.0, 0.0, -0.5),
				Rot = vector3(0.0, 0.0, 0.0),
				Bone = 0,
			},
			[-1352468814] = {
				Entry = vector3(0.0, -10.0, 0.0),
				Offset = vector3(0.0, -1.0, 1.2),
				Rot = vector3(0.0, 0.0, 0.0),
				Bone = 0,
			},
		},
		Classes = {
			[0] = true, -- Compacts.
			[1] = true, -- Sedans.
			[2] = true, -- SUVs.
			[3] = true, -- Coupes.
			[4] = true, -- Muscle.
			[5] = true, -- Sports Classics.
			[6] = true, -- Sports.
			[7] = true, -- Super.
			[8] = true, -- Motorcycles.
			[9] = true, -- Off-road.
			[10] = true, -- Industrial.
			[11] = true, -- Utility.
			[12] = true, -- Vans.
			[13] = true, -- Cycles.
			[14] = false, -- Boats.
			[15] = false, -- Helicopters.
			[16] = false, -- Planes.
			[17] = false, -- Service.
			[18] = true, -- Emergency.
			[19] = false, -- Military.
			[20] = false, -- Commercial.
			[21] = false, -- Trains.
			[22] = true, -- Open Wheels.
		},
		Blacklist = {

		},
		Whitelist = {
			["buzzard"] = true,
			["buzzard2"] = true,
			["frogger"] = true,
			["frogger2"] = true,
			["maverick"] = true,
			["polmav"] = true,
		},
		Distance = 5.0,
	},
	Parts = {
		{
			-- Sends power to wheels and turn car?
			Name = "Axle",
			DamageMult = 0.5,
			Repair = {
				Duration = 9000,
				Emote = "mechfix2",
				Dist = 3.0,
			},
			Update = function(part, vehicle, health, handling)
				handling["fSteeringLock"] = handling["fSteeringLock"] * Lerp(0.7, 1.0, health)
				handling["fSuspensionReboundDamp"] = handling["fSuspensionReboundDamp"] * Lerp(0.9, 1.0, health)
				handling["fSuspensionCompDamp"] = handling["fSuspensionCompDamp"] * Lerp(0.9, 1.0, health)
				handling["fSuspensionForce"] = handling["fSuspensionForce"] * Lerp(0.8, 1.0, health)
				handling["fTractionCurveLateral"] = handling["fTractionCurveLateral"] * Lerp(1.0, 2.0, 1.0 - health)
			end,
		},
		{
			Name = "Engine",
			Bone = "engine",
			DamageMult = 0.5,
			Repair = {
				Duration = 7000,
				Emote = "mechfix",
			},
			Update = function(part, vehicle, health, handling)
				local health = (part.health or 1.0) * 1000.0

				health = health > 1.0 and health or -4000.0

				if not Damage.healths.engine or math.abs(Damage.healths.engine - health) > 1.0 then
					Damage.healths.engine = health
					Damage:UpdateVehicle()
				end

				handling["fInitialDriveMaxFlatVel"] = handling["fInitialDriveMaxFlatVel"] * Lerp(0.8, 1.0, health) * (MaxFlatModifier or 1.0)
			end,
			Parts = {
				{
					-- Uses coolant to prevent the engine from overheating.
					Name = "Radiator",
					Offset = vector3(0.0, 0.3, 0.0),
					Repair = {
						Duration = 7000,
						Emote = "mechfix",
					},
				},
				{
					-- Runs electrical components.
					Name = "Battery",
					Offset = vector3(-0.4, 0.0, 0.0),
					Repair = {
						Duration = 7000,
						Emote = "mechfix",
					},
				},
				{
					-- Recharges the battery.
					Name = "Alternator",
					Offset = vector3(-0.4, 0.3, 0.0),
					Repair = {
						Duration = 7000,
						Emote = "mechfix",
					},
				},
				{
					Name = "Transmission",
					Offset = vector3(0.0, -0.3, 0.0),
					Repair = {
						Duration = 7000,
						Emote = "mechfix",
					},
					Update = function(part, vehicle, health, handling)
						handling["fClutchChangeRateScaleUpShift"] = handling["fClutchChangeRateScaleUpShift"] * Lerp(0.2, 1.0, health)
						handling["fClutchChangeRateScaleDownShift"] = handling["fClutchChangeRateScaleDownShift"] * Lerp(0.2, 1.0, health)
					end,
				},
				{
					Name = "Fuel Injector",
					Offset = vector3(0.4, 0.0, 0.0),
					Condition = function(vehicle, parent)
						return GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume") > 0.01
					end,
					Repair = {
						Duration = 7000,
						Emote = "mechfix",
					},
					Update = function(part, vehicle, health, handling)
						handling["fInitialDriveMaxFlatVel"] = handling["fInitialDriveMaxFlatVel"] * Lerp(0.7, 1.0, health)
					end,
				},
			},
		},
		{
			Name = "Fuel Tank",
			Bone = "wheel_lr",
			Offset = vector3(0.0, 0.0, 0.4),
			Condition = function(vehicle, parent)
				return GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume") > 0.01
			end,
			Repair = {
				Duration = 9000,
				Emote = "mechfix3",
			},
		},
		{
			Name = "Muffler",
			Bone = {
				"exhaust_10",
				"exhaust_11",
				"exhaust_12",
				"exhaust_13",
				"exhaust_14",
				"exhaust_15",
				"exhaust_16",
				"exhaust_2",
				"exhaust_3",
				"exhaust_4",
				"exhaust_5",
				"exhaust_6",
				"exhaust_7",
				"exhaust_8",
				"exhaust_9",
				"exhaust",
			},
			Repair = {
				Duration = 9000,
				Emote = "mechfix2",
			},
		},
		{
			Name = "Tire",
			Update = function(part, vehicle, health, handling)
				handling["fTractionCurveLateral"] = handling["fTractionCurveLateral"] * Lerp(1.0, 1.15, 1.0 - health) * (TractionCurveModifier or 1.0)
				handling["fTractionLossMult"] = handling["fTractionLossMult"] * Lerp(1.0, 1.15, 1.0 - health) * (TractionLossModifier or 1.0)
			end,
			Bone = {
				"wheel_f",
				"wheel_lf",
				"wheel_lm1",
				"wheel_lm2",
				"wheel_lm3",
				"wheel_lr",
				"wheel_r",
				"wheel_rf",
				"wheel_rm1",
				"wheel_rm2",
				"wheel_rm3",
				"wheel_rr",
			},
			Parts = {
				{
					Name = "Brakes",
					Offset = vector3(0.0, 0.15, 0.15),
					Condition = function(vehicle, parent)
						local frontBias = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeBiasFront")
						local isFront = parent and parent.offset and parent.offset.y > 0.0

						return (frontBias >= 0.4 and frontBias <= 0.6) or (frontBias > 0.6 and isFront) or (frontBias < 0.4 and not isFront)
					end,
					Repair = {
						Duration = 9000,
						Emote = "mechfix2",
					},
					Update = function(part, vehicle, health, handling)
						handling["fBrakeForce"] = handling["fBrakeForce"] * Lerp(0.5, 1.0, health) * (BrakeModifier or 1.0)
					end,
				},
				{
					Name = "Shocks",
					Offset = vector3(-0.2, 0.0, 0.0),
					Repair = {
						Duration = 9000,
						Emote = "mechfix2",
					},
					Update = function(part, vehicle, health, handling)
						handling["fSuspensionReboundDamp"] = handling["fSuspensionReboundDamp"] * Lerp(0.8, 1.0, health)
						handling["fSuspensionCompDamp"] = handling["fSuspensionCompDamp"] * Lerp(0.8, 1.0, health)
						handling["fSuspensionForce"] = handling["fSuspensionForce"] * Lerp(0.7, 1.0, health)
					end,
				},
			},
			Repair = {
				Duration = 9000,
				Emote = "mechfix2",
			},
		},
	},
	Lifts = {
		-- Benny's Original Motorworks.
		{
			Coords = vector3(-223.23358154296875, -1330.025634765625, 30.890380859375),
			Radius = 5.0,
		},
		-- Power Autos.
		{
			Coords = vector3(-32.56019973754883, -1065.721923828125, 28.3964900970459),
			Radius = 5.0,
		},
		{
			Coords = vector3(-28.94982, -1041.479, 28.63313),
			Radius = 5.0,
		},
		-- Hayes Auto.
		{
			Coords = vector3(-1417.732421875, -445.36322021484375, 35.90966415405273),
			Radius = 3.0,
		},
		{
			Coords = vector3(-1411.4639892578125, -442.3568420410156, 36.01815414428711),
			Radius = 3.0,
		},
		{
			Coords = vector3(-1423.6483154296875, -449.8814392089844, 35.79834747314453),
			Radius = 3.0,
		},
		-- Axle's Auto Exotic
		{
			Coords = vector3(548.4117, -198.6528, 54.4932),
			Radius = 4.0,
		},
		{
			Coords = vector3(546.6074, -169.3336, 54.4932),
			Radius = 4.0,
		},
		-- Misfits
		{
			Coords = vector3(938.3289, -978.6039, 39.57885),
			Radius = 3.0,
		},
		{
			Coords = vector3(937.5081, -971.0195, 39.54307),
			Radius = 5.0,
		},
		{
			Coords = vector3(936.9544, -963.1901, 39.57978),
			Radius = 3.0,
		},
		-- Route 68
		{
			Coords = vector3(1182.947, 2639.162, 37.75383),
			Radius = 4.0,
		},
		{
			Coords = vector3(1174.344, 2640.017, 37.75383),
			Radius = 4.0,
		},
		-- Camel Tow
		{
			Coords = vector3(103.6603, 6622.68, 31.78729),
			Radius = 4.0,
		},
		{
			Coords = vector3(110.6344, 6628.121, 31.78729),
			Radius = 4.0,
		},
		-- Bike Shop
		{
			Coords = vector3(909.7156, 3562.485, 33.83509),
			Radius = 4.0,
		},
		{
			Coords = vector3(910.5926, 3567.384, 33.83507),
			Radius = 4.0,
		},
	},
	Flipping = {
		MaxDistance = 3.0,
		Action  = {
			Anim = {
				Dict = "anim@arena@prize_wheel@male",
				Name = "idle_spinning",
				Flag = 1,
				DisableMovement = true,
			},
			Label = "Flipping...",
			Duration = 20000,
			UseWhileDead = false,
			CanCancel = true,
			Disarm = true,
		},
	},
	AnchorAction = {
		Duration = 4000,
		UseWhileDead = false,
		CanCancel = false,
		Disarm = true,
		Anim = {
			Dict = "missexile3",
			Name = "ex03_dingy_search_case_base_michael",
			Flag = 48,
			Duration = 4000,
		},
	},
	Sirens = {
		Police = {
			[1] = false,
			[2] = "VEHICLES_HORNS_SIREN_1",
			[3] = "VEHICLES_HORNS_SIREN_2",
			[4] = "VEHICLES_HORNS_POLICE_WARNING", -- RESIDENT_VEHICLES_SIREN_PA20A_WAIL
		},
		Ambulance = {
			[1] = false,
			[2] = "RESIDENT_VEHICLES_SIREN_WAIL_01",
			[3] = "RESIDENT_VEHICLES_SIREN_QUICK_01",
			[4] = "VEHICLES_HORNS_AMBULANCE_WARNING",
		},
		Firetruck = {
			[1] = false,
			[2] = "RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01",
			[3] = "RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01",
			[4] = "VEHICLES_HORNS_FIRETRUCK_WARNING",
		},
		Bike = {
			[1] = false,
			[2] = "RESIDENT_VEHICLES_SIREN_WAIL_03",
			[3] = "RESIDENT_VEHICLES_SIREN_QUICK_03",
		},
		Agency = {
			[1] = false,
			[2] = "RESIDENT_VEHICLES_SIREN_WAIL_02",
			[3] = "RESIDENT_VEHICLES_SIREN_QUICK_02",
		},
	},
	Handling = {
		Fields = {
			["fMass"] = "float",
			["fInitialDragCoeff"] = "float",
			["fDownforceModifier"] = "float",
			["fPercentSubmerged"] = "float",
			["fDriveBiasFront"] = "float",
			["nInitialDriveGears"] = "integer",
			["fInitialDriveForce"] = "float",
			["fDriveInertia"] = "float",
			["fClutchChangeRateScaleUpShift"] = "float",
			["fClutchChangeRateScaleDownShift"] = "float",
			["fInitialDriveMaxFlatVel"] = "float",
			["fBrakeForce"] = "float",
			["fBrakeBiasFront"] = "float",
			["fHandBrakeForce"] = "float",
			["fSteeringLock"] = "float",
			["fTractionCurveMax"] = "float",
			["fTractionCurveMin"] = "float",
			["fTractionCurveLateral"] = "float",
			["fTractionSpringDeltaMax"] = "float",
			["fLowSpeedTractionLossMult"] = "float",
			["fCamberStiffnesss"] = "float",
			["fTractionBiasFront"] = "float",
			["fTractionLossMult"] = "float",
			["fSuspensionForce"] = "float",
			["fSuspensionCompDamp"] = "float",
			["fSuspensionReboundDamp"] = "float",
			["fSuspensionUpperLimit"] = "float",
			["fSuspensionLowerLimit"] = "float",
			["fSuspensionRaise"] = "float",
			["fSuspensionBiasFront"] = "float",
			["fAntiRollBarForce"] = "float",
			["fAntiRollBarBiasFront"] = "float",
			["fRollCentreHeightFront"] = "float",
			["fRollCentreHeightRear"] = "float",
			["fCollisionDamageMult"] = "float",
			["fWeaponDamageMult"] = "float",
			["fDeformationDamageMult"] = "float",
			["fEngineDamageMult"] = "float",
			["fPetrolTankVolume"] = "float",
			["fOilVolume"] = "float",
			["fSeatOffsetDistX"] = "float",
			["fSeatOffsetDistY"] = "float",
			["fSeatOffsetDistZ"] = "float",
			["nMonetaryValue"] = "integer",
		},
		Types = {
			["float"] = {
				getter = GetVehicleHandlingFloat,
				setter = function(vehicle, _type, fieldName, value)
					local value = tonumber(value)
					if value == nil then error("value not number") end

					SetVehicleHandlingFloat(vehicle, _type, fieldName, value + 0.0)
				end,
			},
			["integer"] = {
				getter = GetVehicleHandlingInt,
				setter = function(vehicle, _type, fieldName, value)
					local value = tonumber(value)
					if value == nil then error("value not number") end

					SetVehicleHandlingInt(vehicle, _type, fieldName, math.floor(value))
				end,
			},
		},
	},
	Taxis = {
		[`taxi`] = true,
	},
	TrafficLights = {
		[589548997] = true,
		[-945465914] = true,
		[1043035044] = true,
		[-655644382] = true,
		[865627822] = true,
		[-730685616] = true,
		[656557234] = true,
		[862871082] = true,
	},
}