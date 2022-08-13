Instances = {}
Players = {}

--[[ Functions ]]--
function CreateInstance(id, instance, source)
	Instances[id] = {
		id = id,
		players = instance.players or {},
		outCoords = instance.outCoords or vector4(0.0, 0.0, 0.0, 0.0),
		inCoords = instance.inCoords or vector4(0.0, 0.0, 0.0, 0.0),
	}

	JoinInstance(id, source)
	TriggerEvent("oldinstances:created", id)
end
exports("CreateInstance", CreateInstance)

function JoinInstance(id, source)
	if not source then return end

	if GetResourceState("interaction") == "started" and (exports.interaction:IsEscorting(source) or exports.interaction:IsBeingEscorted(source)) then return end

	local instance = Instances[id]
	if not instance then return end

	exports.log:Add({
		source = source,
		verb = "joined",
		noun = "instance",
		extra = ("id: %s"):format(id),
	})

	Players[source] = id
	instance.players[tostring(source)] = true

	for player, _ in pairs(instance.players) do
		TriggerClientEvent("oldinstances:playerEntered", tonumber(player), source)
	end
	TriggerClientEvent("oldinstances:join", source, instance)
	TriggerEvent("oldinstances:playerEntered", source, id)
end
exports("JoinInstance", JoinInstance)

function LeaveInstance(id, source)
	local instance = Instances[id]
	if not instance then return end

	if Players[source] ~= id then return end

	exports.log:Add({
		source = source,
		verb = "left",
		noun = "instance",
		extra = ("id: %s"):format(id),
	})

	instance.players[tostring(source)] = nil
	Players[source] = nil

	for player, _ in pairs(instance.players) do
		TriggerClientEvent("oldinstances:playerExited", tonumber(player), source)
	end
	TriggerClientEvent("oldinstances:left", source)
	TriggerEvent("oldinstances:playerExited", source, id)
end
exports("LeaveInstance", LeaveInstance)

function DoesInstanceExist(id)
	return Instances[id] ~= nil
end
exports("DoesInstanceExist", DoesInstanceExist)

function IsInstanced(source)
	return Players[source] ~= nil
end
exports("IsInstanced", IsInstanced)

function GetPlayerInstance(source)
	return Players[source]
end
exports("GetPlayerInstance", GetPlayerInstance)

function GetInstance(id)
	return Instances[id] or {}
end
exports("GetInstance", GetInstance)

--[[ Events ]]--
RegisterNetEvent("oldinstances:left")
AddEventHandler("oldinstances:left", function()
	local source = source
	if not Players[source] then return end

	LeaveInstance(Players[source], source)
end)

RegisterNetEvent("oldinstances:join")
AddEventHandler("oldinstances:join", function(id)
	local source = source
	JoinInstance(id, source)
end)

AddEventHandler("playerDropped", function()
	local source = source
	local instance = Players[source]

	if instance then
		LeaveInstance(instance, source)
	end
end)