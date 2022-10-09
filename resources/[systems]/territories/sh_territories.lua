Quests = {}

function AddQuest(info)
	Citizen.CreateThread(function()
		Quests[info.id] = info
		exports.quests:Register(info)
	end)
end

function CheckName(name)
	name = exports.misc:FixText(name)
	if not name then return false end

	name = name:gsub(" +", " ")
	if name == "" or name == " " or name:len() <= 3 then
		return false
	end

	return true, name:upper()
end