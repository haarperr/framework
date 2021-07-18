Quests = {}

function AddQuest(info)
	Citizen.CreateThread(function()
		Quests[info.id] = info
		exports.quests:Register(info)
	end)
end

function IsInGang(source)
	return exports.character:GetFaction(source or false, "gang") ~= nil
end

function IsGangLeader(source)
	local faction, name = GetGangFaction(source or false)
	if not faction then return false end

	return (faction.level or 0) >= 100
end

function GetGangFaction(source)
	local faction = exports.character:GetFaction(source or false, "gang")
	local name = nil

	if faction and faction.extra then
		name = faction.extra.name
	end

	return faction, name
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