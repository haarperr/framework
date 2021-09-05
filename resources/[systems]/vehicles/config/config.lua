Config = {
	Values = {
		GearShiftDownDelay = 800, -- How long, in milliseconds, the clutch will be forced to 0.0 after clutching down, preventing a double clutch.
	},
	Seats = {
		["seat_f"] = -1,
		["seat_r"] = 0,
		["seat_dside_f"] = -1,
		["seat_pside_f"] = 0,
		["seat_dside_r"] = 1,
		["seat_pside_r"] = 2,
		["seat_dside_r1"] = 3,
		["seat_pside_r1"] = 4,
		["seat_dside_r2"] = 5,
		["seat_pside_r2"] = 6,
		["seat_dside_r3"] = 7,
		["seat_pside_r3"] = 8,
		["seat_dside_r4"] = 9,
		["seat_pside_r4"] = 10,
		["seat_dside_r5"] = 11,
		["seat_pside_r5"] = 12,
		["seat_dside_r6"] = 13,
		["seat_pside_r6"] = 14,
		["seat_dside_r7"] = 15,
		["seat_pside_r7"] = 16,
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