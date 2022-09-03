Deliveries = {}

--[[ Initialization ]]--

--[[ Threads ]]--

--[[ Functions ]]--

--[[ Events ]]--
AddEventHandler("deliveries:start", function()
	Deliveries = exports.cache:Get("Deliveries") or Deliveries
end)

AddEventHandler("deliveries:stop", function()
	exports.cache:Set("Deliveries", Deliveries)
end)

RegisterNetEvent("jobs:clocked")
AddEventHandler("jobs:clocked", function(name, source, onDuty)
	if not onDuty then return end

	local job = exports.jobs:GetCurrentJob(source, true)

	local delivery = job.Delivery
	if not delivery then return end

	local actives = Deliveries[name]
	if actives == nil then
		actives = {}
		Deliveries[name] = actives
	end

	local active = actives[source]

	if active == nil then
		active = {
			destinations = {}
		}
		
		if delivery.Properties then
			local properties = {}
			for i = 1, delivery.Properties.Max or 32 do
				local property = exports.properties:GetRandomProperty()
				if
					not properties[property.id] and
					(not delivery.Properties.Radius or #(vector3(property.x, property.y, property.z) - delivery.Center) < delivery.Properties.Radius) and
					(not delivery.Properties.Types or delivery.Properties.Types[property.type])
				then
					local id = #active.destinations + 1
					active.destinations[id] = { id = id, property = property.id }
					properties[property.id] = true
				end
			end
		end

		if delivery.Destinations then
			for _, coords in ipairs(delivery.Destinations) do
				local id = #active.destinations + 1
				active.destinations[id] = { id = id, coords = coords }
			end
		end
		
		actives[source] = active
	end
	
	TriggerClientEvent("deliveries:update", source, active)
end)

RegisterNetEvent("deliveries:finishDelivery")
AddEventHandler("deliveries:finishDelivery", function(id, name)
	local source = source

	local deliveries = Deliveries[name]
	if not deliveries then return end

	local delivery = deliveries[source]
	if not delivery then return end
	
	local job = exports.jobs:GetCurrentJob(source)
	if not job then return end

	local deliverySettings = job.Delivery
	if not deliverySettings then return end

	local destination = delivery.destinations[id]
	if not destination or destination.complete then return end
	destination.complete = true

	exports.log:Add({
		source = source,
		verb = "delivered",
		extra = ("job: %s"):format(name),
	})
	
	local pay = deliverySettings.Pay
	if type(pay) == "number" then
		local paycheck = exports.character:Get(source, "paycheck")
		paycheck = paycheck + deliverySettings.Pay
		exports.character:Set(source, "paycheck", paycheck)
		TriggerClientEvent("chat:notify", source, {
			class = "inform",
			text = ("$%s has gone to your paycheck. You have $%s to collect."):format(exports.misc:FormatNumber(deliverySettings.Pay), exports.misc:FormatNumber(paycheck)),
		})
	end
end)

--[[ Commands ]]--
RegisterCommand("deliveries:clearCache", function(source, args, command)
	if source ~= 0 then return end
	Deliveries = {}
	TriggerClientEvent("deliveries:clearCache", -1)
	print("Delivery cache cleared")
end)