Main = {}

--[[ Functions: Main ]]--
function Main:UseItem(item, slot, cb)
	local settings = Config.Items[item.name]
	if not settings then return end
	
	-- Get/check the vehicle.
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)
	if not DoesEntityExist(vehicle or 0) or GetPedInVehicleSeat(vehicle, -1) ~= ped then return end
	
	-- Check state.
	local state = (Entity(vehicle) or {}).state
	if not state then return end
	
	local stage = tonumber(state.stage) or 0
	if settings.Stage - 1 ~= stage then return end
	
	-- Get tier level.
	local class = GetVehicleClass(vehicle)
	local tierLevel = Config.Classes[class]
	local tier = Config.Tiers[tierLevel or false]
	
	-- Play emote.
	local emote = exports.emotes:Play(Config.Anim)
	
	-- Callback.
	cb()

	-- Close inventory.
	TriggerEvent("inventory:toggle", false)
	
	-- Play minigame.
	local success = exports.quickTime:Begin()
	-- local success = exports.quickTime:Begin(tier.QuickTime)
	
	-- Stop emote.
	exports.emotes:Stop(emote)
	
	-- Set state.
	if success then
		stage = stage + 1
		
		TriggerServerEvent("hotwire:setStage", NetworkGetNetworkIdFromEntity(vehicle), stage, slot.slot_id, item.name)
	end
end

--[[ Events ]]--
AddEventHandler("inventory:use", function(...)
	Main:UseItem(...)
end)