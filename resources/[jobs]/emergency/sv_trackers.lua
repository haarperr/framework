GROUP_NAME = "emergency"

Models = {
	[`pdalamo`] = "cruiser",
	[`pdbuffalo`] = "cruiser",
	[`pdcara`] = "cruiser",
	[`pdstainer`] = "cruiser",
	[`spalamo`] = "cruiser",
	[`spbuffalo`] = "cruiser",
	[`spstainer`] = "cruiser",

	--[`pdinterceptor`] = "intercept",

	--[`pdbearcat`] = "armored",

	[`pdbike`] = "bike",
	[`spbike`] = "bike",

	[`bcfdbat`] = "ambulance",
	[`lsfd2`] = "ambulance",
	[`lsfd3`] = "ambulance",
	[`lsfdcmd`] = "ambulance",
	[`lsfdgresley`] = "ambulance",
	[`lsfdtruck`] = "ambulance",

	[`polmav`] = "heli",
	[`rsheli`] = "heli",

	[`predator`] = "boat",
}

exports.trackers:CreateGroup(GROUP_NAME, {
	delay = 2000,
	states = {
		[1] = { -- Peds.
			["ems"] = {
				Colour = 8,
			},
			["pd"] = {
				Colour = 3,
			},
			["federal"] = {
				Colour = 3,
			},
		},
		[2] = { -- Vehicles.
			["ambulance"] = {
				Colour = 8,
				Sprite = 750,
			},
			["cruiser"] = {
				Colour = 3,
			},
			["intercept"] = {
				Colour = 3,
				Sprite = 595,
			},
			["armored"] = {
				Colour = 3,
				Sprite = 800,
			},
			["bike"] = {
				Colour = 3,
				Sprite = 661,
			},
			["heli"] = {
				Colour = 3,
				Sprite = 64,
			},
			["boat"] = {
				Colour = 3,
				Sprite = 427,
			},
		}
	},
})

AddEventHandler("entityCreated", function(entity)
	if not DoesEntityExist(entity) then return end

	local model = GetEntityModel(entity)
	if not model then return end

	local state = Models[model]
	if state then
		exports.trackers:AddEntity(GROUP_NAME, entity, { state = state })
	end
end)