--[[ Initialization ]]--
for habitat, settings in pairs(Config.Habitats) do
	settings.TotalChance = 0.0
	for fish, chance in pairs(settings.Fish) do
		settings.TotalChance = settings.TotalChance + chance
	end
end

--[[ Functions ]]--
function GetRandomFish(habitat)
	local settings = Config.Habitats[habitat]
	if not settings then return end

	local totalChance = settings.TotalChance
	local seed = math.floor(os.clock() * 1000)
	for fish, chance in pairs(settings.Fish) do
		totalChance = totalChance - chance

		math.randomseed(seed)
		if chance > math.random() * totalChance then
			return fish
		end
		seed = seed + 1
	end
end

--[[ Events ]]--
RegisterNetEvent("fishing:catch")
AddEventHandler("fishing:catch", function(slotId, habitat, peers)
	local source = source
	-- local habitatSettings = Config.Habitats[habitat]
	-- if not habitatSettings then return end

	local fish = GetRandomFish(habitat)
	if not fish then return end

	local slot = exports.inventory:GetSlot(source, slotId, true)
	if not slot or slot[1] ~= exports.inventory:GetItem("Fishing Rod").id then return end

	exports.log:Add({
		source = source,
		verb = "caught",
		noun = fish,
		extra = ("habitat: %s"):format(habitat),
		channel = "misc",
	})
	
	exports.inventory:DecayItem(source, slotId, math.random() * (Config.Durability[2] - Config.Durability[1]) + Config.Durability[1], true)
	exports.inventory:GiveItem(source, fish)
end)