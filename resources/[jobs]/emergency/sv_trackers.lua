GROUP_NAME = "emergency"

Models = {
	[`pdcvpi`] = "cruiser",
	[`pdc8`] = "intercept",
	[`pdbearcat`] = "armored",
	[`harley`] = "bike",
	[`emsspeedo`] = "ambulance",
	[`rsheli`] = "heli",
}

exports.trackers:CreateGroup(GROUP_NAME, {
	delay = 2000,
	states = {
		[1] = { -- Peds.
			["ems"] = {
				Colour = 8,
			},
			["police"] = {
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