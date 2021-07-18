Decorations = Decorations or {}
Decorations.event = GetCurrentResourceName()..":"

--[[ Functions ]]--
function Decorations:AddEvent(suffix, routine, isNet)
	local eventName = self.event..suffix

	if isNet then
		RegisterNetEvent(eventName)
	end

	AddEventHandler(eventName, routine)
end

--[[ Events ]]--
Decorations:AddEvent("start", function()
	Decorations:Init()
end)