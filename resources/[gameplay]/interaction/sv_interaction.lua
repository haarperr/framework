Functions = {}

--[[ Events ]]--
RegisterNetEvent("interaction:send")
AddEventHandler("interaction:send", function(target, message, value)
	local source = source

	if not source then return end
	if value ~= nil and type(value) ~= "boolean" and type(value) ~= "number" then return end
	if type(target) ~= "number" or target <= 0 or not GetPlayerPed(target) then return end

	if not ValidMessages[message] then
		print(("[%s] invalid message '%s'"):format(source, message))
		return
	end

	local sourceInstance = exports.instances:GetPlayerInstance(source)
	local targetInstance = exports.instances:GetPlayerInstance(target)

	if sourceInstance ~= targetInstance then
		return
	end

	if Functions[message] then
		local result, _target, _value, loopback = Functions[message](source, target, value)
		if not result then return end

		if _target ~= nil then
			target = _target
		end
		if _value ~= nil then
			value = _value
		end
	end

	exports.log:Add({
		source = source,
		target = target,
		verb = "sent",
		noun = "message",
		extra = ('%s - %s'):format(message, tostring(value)),
		channel = "misc",
	})
	
	TriggerClientEvent("interaction:receive", target, source, message, value)
end)