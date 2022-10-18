Quests = {}

function AddQuest(info)
	Citizen.CreateThread(function()
		Quests[info.id] = info
		exports.quests:Register(info)
	end)
end