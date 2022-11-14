Dailies = {}
Quests = {}

--[[ Functions ]]--
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

--[[ Events ]]--
RegisterNetEvent("playertasks:requestStatus")
AddEventHandler("playertasks:requestStatus", function(input)
	local source = source

	local data = nil

	if input == "dailies" then
		local characterId = exports.character:Get(source, "id")
		if not characterId then return end

		data = {
			character = Dailies:GetCharacter(characterId),
		}

		if data.character == nil then
			data.character = Dailies:Random()

			local characters = Dailies.characters
			if not characters then
				characters = {}
				Dailies.characters = characters
			end
			characters[characterId] = data.character
		end
	end

	TriggerClientEvent("playertasks:receiveStatus", source, data)
end)

RegisterNetEvent("playertasks:startDaily")
AddEventHandler("playertasks:startDaily", function()
	local source = source

	-- Get the character id.
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	-- Get the daily.
	local dailyCharacter = Dailies:GetCharacter(characterId)

	-- Check the daily.
	if dailyCharacter == nil then return end

	-- Get the quest.
	local quest = exports.quests:Get((Quests[dailyCharacter] or {}).id)
	if not quest then return end
	
	-- Check the quest.
	local hasQuest = quest:Has(source)
	if hasQuest then return end

	-- Start the quest.
	quest:Start(source)

	TriggerClientEvent("npcs:invoke", source, "TASKS_JAEGER", {
		{ "GotoStage", "INIT" },
		{ "InvokeDialogue" },
		{ "Say", "Good luck." },
	})
end)
