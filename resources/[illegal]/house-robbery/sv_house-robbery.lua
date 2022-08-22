Instances = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for id, cache in pairs(Instances) do
			if cache.isEmpty then
				if os.clock() - cache.time > Config.LockTime * 60.0 then
					ClearInstance(id)
				end
			else
				cache.time = os.clock()
			end
		end
		Citizen.Wait(5000)
	end
end)

--[[ Functions ]]--
function ClearInstance(instanceId)
	local cache = Instances[instanceId]
	if not cache then return end

	-- Remove the tasks.
	for taskId, task in pairs(cache.tasks) do
		exports.tasks:Remove(taskId)
	end

	-- Lock the property.
	exports.properties:ToggleLock(cache.property, false)

	-- Clear the cache.
	Instances[instanceId] = nil
end

--[[ Events ]]--
RegisterNetEvent("house-robbery:open")
AddEventHandler("house-robbery:open", function(slotId, propertyId)
	local source = source

	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId.slot_id, "GetItem")
	if not item then return end
	if item.name ~= Config.Item then return end

	exports.inventory:TakeItem(source, item.name, 1)
	math.randomseed(math.floor(os.clock() * 1000))

	-- Todo add property check.
	local property = exports.properties:GetProperty(propertyId)
	if not property or property.open or property.character_id then return end

	local settings = Config.Properties[property.type]
	if not settings then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "robbed",
		noun = "property",
		extra = ("id: %s"):format(propertyId),
	})
	
	exports.properties:ToggleLock(propertyId, true)
	
	TriggerClientEvent("properties:locked", source, true)

	local instanceId = "p"..propertyId
	
	-- Create the tasks.
	local tasks = {}

	for k, task in ipairs(settings.Tasks) do
		local taskId = instanceId.."_"..k
		tasks[taskId] = task
		exports.tasks:Add(taskId, task[1], task[2])
	end

	-- Cache the instance.
	Instances[instanceId] = { time = os.clock(), seed = os.time(), property = propertyId, tasks = tasks, isEmpty = true }
end)

-- RegisterNetEvent("house-robberies:makePed")
-- AddEventHandler("house-robberies:makePed", function(key, netId)
-- 	local source = source

-- 	if type(key) ~= "number" then return end

-- 	local instance = exports.instances:GetPlayerInstance(source)
-- 	if not instance then return end

-- 	local cache = Instances[instance.id]
-- 	if not cache then return end

-- 	cache.peds[key] = netId
-- end)

AddEventHandler("instances:playerEntered", function(source, id)
	local cache = Instances[id]
	if cache == nil then return end

	-- local instance = exports.instances:GetInstance(id)

	cache.isEmpty = false
	
	TriggerClientEvent("house-robbery:enter", source, cache)
end)

AddEventHandler("instances:playerExited", function(source, id)
	local cache = Instances[id]
	if cache == nil then return end

	TriggerClientEvent("house-robbery:exit", source, cache)

	local instance = exports.oldinstances:GetInstance(id)
	local isEmpty = true
	for k, v in pairs(instance.players) do
		isEmpty = false
		break
	end

	cache.isEmpty = isEmpty
end)