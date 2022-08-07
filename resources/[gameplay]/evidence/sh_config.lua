Config = {
	Debug = false,
	GridSize = 1,
	DecayTime = 60.0 * 30.0,
	PickupDistance = 1.6,
	GunResidueLifetime = 30 * 60 * 1000,
	DrawRadius = 32.0,
	BloodSplash = {
		MinSpread = 0.6,
		MaxSpread = 10.0,
		MaxSpeed = 50.0,
		Deviation = 0.2,
	},
	CasingSpread = 1.2,
	MinCasingDist = 0.8,
	MaxCasingDist = 1.8,
	MaxDistance = 16.0,
	ImpactSize = 0.1,
	CasingSize = 0.1,
	BleachRange = 3.5,
	Forensics = {
		vector3(486.77587890625, -993.2560424804688, 30.68962860107422), -- MRPD.
		vector3(311.9853515625, -562.702392578125, 43.28402328491211),
	},
	Excluded = {
		[GetHashKey("WEAPON_PETROLCAN")] = true,
		[GetHashKey("WEAPON_FIREEXTINGUISHER")] = true,
	},
	Types = {
		[0] = {
			Name = "Impact",
			Marker = {
				Color = { r = 37, g = 132, b = 255 },
				Offset = 0.1,
				Scale = 0.1,
				Type = 2,
				Text = function(item)
					local caliber = exports.weapons:GetAmmo(item.extra[1])
					if type(caliber) == "table" then
						return caliber[2]
					else
						return caliber
					end
				end,
			},
			Register = function(source, extra)
				return Config.Types[1].Register(source, extra)
			end,
		},
		[1] = {
			Name = "Casing",
			Marker = {
				Color = { r = 255, g = 198, b = 37 },
				Offset = 0.1,
				Scale = 0.1,
				Type = 23,
				Text = function(item)
					local caliber = exports.weapons:GetAmmo(item.extra[1])
					if type(caliber) == "table" then
						return caliber[1]
					else
						return caliber
					end
				end,
			},
			Register = function(source, extra)
				if not extra then return end
				
				local _extra
				if type(extra) ~= "table" then return end
				_extra = {}
				
				-- Weapons.
				if extra.weapon then
					_extra[1] = extra.weapon
				end

				-- Serials.
				if extra.slot then
					local slot = exports.inventory:GetSlot(source, extra.slot, true)
					if slot then
						local slotExtra = slot[4]
						if slotExtra then
							_extra[2] = math.abs(GetHashKey(tostring(slotExtra[1])))
						end
					end
				end
				return true, _extra
			end,
			Pickup = function(self, item)
				local ammo = exports.weapons:GetAmmo(item.extra[1]) or "Unknown"
				local seed = item.extra[2]
				local id = ""

				if type(ammo) == "table" then
					ammo = ammo[1]
				end

				for i = 1, 24 do
					math.randomseed(seed)
					seed = math.random(0, 2147483647)

					local char
					if math.random() > 0.5 then
						char = "-"
					else
						char = "."
					end
					id = id..char
				end

				local data = { ("%s %s - %s"):format(ammo, self.Name, GetId()), id }

				return data
			end,
		},
		[2] = {
			Name = "Impression",
			Marker = {
				Color = { r = 55, g = 255, b = 48 },
				Offset = 0.1,
				Scale = 0.7,
				Type = 25,
			},
		},
		[3] = {
			Name = "Blood",
			Marker = {
				Color = { r = 237, g = 43, b = 33 },
				Offset = 0.1,
				Scale = 0.4,
				Type = 23,
			},
			Register = function(source, extra)
				local characterId = exports.character:Get(source, "id")
				if not characterId then return false end
				
				return true, { characterId }
			end,
			Pickup = function(self, item)
				return { ("Dried Blood - %s"):format(GetId()) }
			end,
		},
		[4] = {
			Name = "Drug Residue",
			Marker = {
				Color = { r = 43, g = 237, b = 33 },
				Offset = 0.1,
				Scale = 0.2,
				Type = 25,
			},
			Register = function(source, extra)
				if not extra or type(extra.drug) ~= "string" then return end
				return true, { extra.drug }
			end,
			Pickup = function(self, item)
				return { ("%s Residue - %s"):format((item.extra[1] or "Drug"), GetId()) }
			end,
		},
	},
	PickupAction = {
		Anim = {
			Dict = "pickup_object",
			Name = "pickup_low",
			Flag = 0,
			ShowEvidence = true,
		},
		Label = "Picking up...",
		Duration = 2000,
		UseWhileDead = false,
		CanCancel = true,
		Disarm = true,
	},
	CleanAction = {
		Anim = {
			Dict = "missfbi3_waterboard",
			Name = "waterboard_loop_player",
			Flag = 1,
			Blend = 10.0,
			Props = {
				{ Model = "w_am_jerrycan", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0 }},
			},
			ShowEvidence = true,
		},
		Label = "Cleaning...",
		Duration = 5000,
		UseWhileDead = false,
		CanCancel = true,
		Disarm = true,
	},
}

function Debug(...)
	if not Config.Debug then return end
	print(...)
end