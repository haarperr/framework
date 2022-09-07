Dailies = {}

function Dailies:Random()
	math.randomseed(math.floor(os.clock() * 1000))

	local quests = {}
	local count = 0
	for id, _ in pairs(Quests) do
		--print(id, _)
		quests[#quests + 1] = id
		count = count + 1
	end

	return quests[math.random(1, count)]
end

function Dailies:GetFaction(name)
	if self.factions == nil then
		return
	end

	return self.factions[name]
end

function Dailies:GetCharacter(id)
	if self.characters == nil then
		return
	end

	return self.characters[id]
end