Main = Main or {}

--[[ Functions ]]--
function Main:Init()
	self.markers = {}
	
	for k, site in ipairs(Config.Sites) do
		exports.interact:Register({
			id = "wheelchair-"..k,
			coords = site.Retrival,
			radius = 0.5,
			embedded = {
				{
					id = "wheelchair1-"..k,
					text = "Spawn Wheelchair",
					event = "spawnWheelchair",
					site = k,
				},
				{
					id = "wheelchair2-"..k,
					text = "Store Wheelchair",
					event = "storeWheelchair",
					site = k,
				},
			},
		})
	end
end

--[[ Events ]]--
AddEventHandler(Main.event.."clientStart", function()
	Main:Init()
end)

AddEventHandler("interact:on_spawnWheelchair", function(interactable)
	-- Check faction. TODO: update for 2.0.
	-- if not exports.jobs:IsInEmergency() then
	--  TriggerEvent("chat:notify", "Missing faction!", "error")
	-- 	return
	-- end
	
	-- Check site.
	local site = Config.Sites[interactable.site or false]
	if not site then return end

	-- Check vehicles. TODO: update for 2.0.
	for _, vehicle in ipairs(exports.utils:GetVehicles()) do
		if #(GetEntityCoords(vehicle) - vector3(site.Spawn.x, site.Spawn.y, site.Spawn.z)) < 1.0 then
			-- TriggerEvent("chat:notify", "The spawn is blocked!", "error")
			return
		end
	end

	-- Spawn vehicle.
	TriggerServerEvent(Main.event.."spawn", interactable.site)
end)

AddEventHandler("interact:on_storeWheelchair", function(interactable)
	-- Check faction. TODO: update for 2.0.
	-- if not exports.jobs:IsInEmergency() then
	-- 	exports.mythic_notify:SendAlert("error", "Missing faction!", 7000)
	-- 	return
	-- end
	
	-- Check site.
	local site = Config.Sites[interactable.site or false]
	if not site then return end

	-- Check vehicles. TODO: update for 2.0.
	local vehicle = nil
	for _, _vehicle in ipairs(exports.utils:GetVehicles()) do
		if #(GetEntityCoords(_vehicle) - vector3(site.Spawn.x, site.Spawn.y, site.Spawn.z)) < 2.0 and GetEntityModel(_vehicle) == Config.Model then
			vehicle = _vehicle
			break
		end
	end

	-- Turn in the vehicle.
	if vehicle and NetworkGetEntityIsNetworked(vehicle) then
		TriggerServerEvent(Main.event.."store", NetworkGetNetworkIdFromEntity(vehicle))
	else
		-- exports.mythic_notify:SendAlert("error", "No wheelchair...", 7000)
	end
end)