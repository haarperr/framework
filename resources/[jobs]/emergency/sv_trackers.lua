GROUP_NAME = "emergency"

Models = {
	[`fbi`] = "cruiser",
	[`fbi2`] = "cruiser",
	[`pdalamo`] = "cruiser",
	[`pdbuffalo`] = "cruiser",
	[`pdcara`] = "cruiser",
	[`pdscout`] = "cruiser",
	[`pdstanier`] = "cruiser",
	[`pdtorence`] = "cruiser",
	[`pdbuffalo2`] = "cruiser",
	[`pdfugitive`] = "cruiser",
	[`spalamo`] = "cruiser",
	[`spbuffalo`] = "cruiser",
	[`spscout`] = "cruiser",
	[`spstanier`] = "cruiser",
	[`sptorence`] = "cruiser",
	[`spbuffalo2`] = "cruiser",
	[`spfugitive`] = "cruiser",

	--[`pdinterceptor`] = "intercept",

	--[`pdbearcat`] = "armored",

	[`pdbike`] = "bike",
	[`spbike`] = "bike",

	[`bcfdbat`] = "ambulance",
	[`lsfd3`] = "ambulance",
	[`lsfd4`] = "ambulance",
	[`lsfdcmd`] = "ambulance",
	[`lsfdtruck`] = "ambulance",
	[`lsmsgresley`] = "ambulance",
	[`lsmsspeedo`] = "ambulance",

	[`polmav`] = "heli",
	[`rsheli`] = "heli",

	[`predator`] = "boat",
}

exports.trackers:CreateGroup(GROUP_NAME, {
	delay = 2000,
	states = {
		[1] = { -- Peds.
			["paramedic"] = {
				Colour = 8,
			},
			["firefighter"] = {
				Colour = 6,
			},
			["lsms"] = {
				Colour = 7,
			},
			["lspd"] = {
				Colour = 18,
			},
			["bcso"] = {
				Colour = 10,
			},
			["sasp"] = {
				Colour = 29,
			},
			["doc"] = {
				Colour = 48,
			},
			["sams"] = {
				Colour = 82,
			},
			["sapr"] = {
				Colour = 25,
			},
			["opr"] = {
				Colour = 15,
			},
			["federal"] = {
				Colour = 46,
			},
			["state"] = {
				Colour = 47,
			},
			["panic"] = {
				Colour = 1,
			}
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