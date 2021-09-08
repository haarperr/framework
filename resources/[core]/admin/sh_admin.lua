Admin = {
	hooks = {},
	players = {},
	event = GetCurrentResourceName()..":",
}

function Admin:AddHook(type, message, callback)
	if self.hooks[type] == nil then
		self.hooks[type] = {}
	end
	self.hooks[type][message] = callback
end

function Admin:InvokeHook(type, message, ...)
	local func = (self.hooks[type] or {})[message]
	if func then
		func(...)
	end
	TriggerServerEvent(self.event.."invokeHook", type, message, ...)
end

function GetVehicles()
	
end