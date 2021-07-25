Main = {
	entities = {},
}

--[[ Functions ]]--
function Main:Update()
	
end

function Main:CacheObject(entity)

end

function Main:CacheAll()

end

function Main:RemoveAll()
	self.entities = {}

	for _, entity in ipairs(GetAllObjects()) do
		DeleteEntity(entity)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
AddEventHandler("objectManager:start", function()
	Main:CacheAll()
end)

AddEventHandler("entityCreating", function(...)
	
end)

AddEventHandler("entityCreated", function(entity)
	if not entity or not DoesEntityExist(entity) then return end

	local owner = NetworkGetEntityOwner(entity)

end)

AddEventHandler("entityRemoved", function()
end)

--[[ Commands ]]--
RegisterCommand("deleteAll", function(source, args, command)
	if source ~= 0 then return end

	Main:RemoveAll()
end, true)