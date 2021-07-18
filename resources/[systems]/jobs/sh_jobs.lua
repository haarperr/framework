Jobs = {}

--[[ Functions ]]--
function CanTarget(source, target, name)
	local info = Jobs[name]
	if not info then return false end

	local user, targetUser = exports.user:GetUser(source), exports.user:GetUser(target)
	if not user or not targetUser then return false end

	if (user.power_level or 0) >= Config.PowerLevel then
		return true
	end

	if info.Master then
		for _, master in ipairs(info.Master) do
			local masterFaction = exports.character:GetFaction(source, name)
			if masterFaction then
				return true
			end
		end
	end

	return GetPower(source, name) > GetPower(target, name)
end
exports("CanTarget", CanTarget)

function GetPower(source, name)
	local info = Jobs[name]
	if not info then return -1 end

	local faction = exports.character:GetFaction(source, name)
	if not faction then return -1 end

	return faction[1] or 0
end
exports("GetPower", GetPower)

function GetRank(source, name)
	return GetRankFromPower(name, GetPower(source, name))
end
exports("GetRank", GetRank)

function GetRankFromPower(name, power)
	local job = Jobs[name]
	if not job then return end

	local rank = nil
	for k, v in pairs(job.Ranks) do
		if tonumber(power) >= tonumber(v) and (rank == nil or job.Ranks[rank] < v) then
			rank = k
		end
	end
	return rank
end
exports("GetRankFromPower", GetRankFromPower)

function GetPowerFromRank(name, rank)
	local job = Jobs[name]
	if not job then return -1 end

	for k, v in pairs(job.Ranks) do
		if k:lower() == rank then
			return v
		end
	end
	return -1
end
exports("GetPowerFromRank", GetPowerFromRank)

--[[ Resource Events ]]--
AddEventHandler("jobs:start", function()
	if GetResourceState("cache") ~= "started" then return end

	Jobs = exports.cache:Get("Jobs") or {}

	-- print(GetPower(1, "Scrapper"))
	-- print(GetRankFromPower("Scrapper", 9999))
	-- print(GetPower(1, "Scrapper"))
	-- print(CanTarget(2, 2, "Scrapper"))
end)

AddEventHandler("jobs:stop", function()
	if GetResourceState("cache") ~= "started" then return end
	
	exports.cache:Set("Jobs", Jobs)
end)