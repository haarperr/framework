Config = {
	Values = {
		GearShiftDownDelay = 800, -- How long, in milliseconds, the clutch will be forced to 0.0 after clutching down, preventing a double clutch.
	},
	Parts = {
		{
			-- Sends power to wheels and turn car?
			Name = "Axle",
			Offset = function()

			end,
		},
		{
			Name = "Engine",
			Bone = "engine",
			Parts = {
				{
					-- Uses coolant to prevent the engine from overheating.
					Name = "Radiator",
					Offset = vector3(0.0, 0.2, 0.0),
				},
				{
					-- Uses coolant to prevent the engine from overheating.
					Name = "Air Filter",
					Offset = vector3(0.0, 0.4, 0.0),
				},
				{
					-- Runs electrical components.
					Name = "Battery",
					Offset = vector3(-0.4, 0.3, 0.0),
				},
				{
					-- Recharges the battery.
					Name = "Alternator",
					Offset = vector3(-0.2, 0.15, 0.0),
				},
				{
					Name = "Transmission",
					Offset = vector3(0.0, -0.3, 0.0),
				},
				{
					Name = "Fuel Injector",
					Offset = vector3(0.4, 0.0, 0.0),
					Condition = function(vehicle, parent)
						return GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume") > 0.01
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
		},
		{
			Name = "Tire",
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
				},
				{
					Name = "Shocks",
					Offset = vector3(-0.2, 0.0, 0.0),
				},
			},
		},
	},
	Lifts = {
		-- Power Autos.
		{
			Coords = vector3(-32.56019973754883, -1065.721923828125, 28.3964900970459),
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
	},
	Sirens = {
		[1] = false, -- Default siren.
		[2] = "VEHICLES_HORNS_SIREN_1",
		[3] = "VEHICLES_HORNS_SIREN_2",
		[4] = "VEHICLES_HORNS_POLICE_WARNING",
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
}