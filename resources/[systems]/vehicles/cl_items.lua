RepairingComponent = nil

local upgrades = {}

--[[ Functions ]]--
function RegisterItems()
	exports.inventory:RegisterCondition("Hotwire Kit", CanUseKit)
	exports.inventory:RegisterCondition("Repair Kit", CanUseRepairKit)
	exports.inventory:RegisterCondition("Advanced Repair Kit", CanUseAdvancedRepairKit)

	exports.inventory:RegisterAction("Repair Kit", Config.Repairing.Action)
	exports.inventory:RegisterAction("Advanced Repair Kit", Config.Repairing.AdvancedAction)

	for _, upgrade in ipairs(Config.Upgrades.Items) do
		for i = 1, upgrade.Max do
			local itemName = upgrade.Name.." Level "..tostring(i)
			local eventName = "inventory:use_"..upgrade.Name.."Level"..tostring(i)
			
			exports.inventory:RegisterCondition(itemName, CanUseUpgrade)
			exports.inventory:RegisterAction(itemName, Config.Upgrades.Action)

			upgrades[itemName] = upgrade

			RegisterNetEvent(eventName)
			AddEventHandler(eventName, UseUpgrade)
		end
	end
end

function UseUpgrade(item, slot)
	if not DoesEntityExist(Repairing) then return end

	local upgrade = upgrades[item.name]
	if not upgrade then return end

	local itemLevel = tonumber(item.name:sub(item.name:len()))
	if not itemLevel then
		error("Upgrade level not a number for item: "..tostring(item.name))
	end

	if not exports.oldutils:RequestAccess(Repairing) then
		print("Upgrade failed to request access of vehicle")
		return
	end

	TriggerServerEvent("vehicles:upgrade", slot)

	SetVehicleModKit(Repairing, 0)
	SetVehicleMod(Repairing, upgrade.Mod, itemLevel - 1, false)

	exports.mythic_notify:SendAlert("success", "Upgrade successful!", 7000)
end

function CanUseUpgrade(item)
	if not DoesEntityExist(Repairing) then
		exports.mythic_notify:SendAlert("error", "You must be visualizing to upgrade!", 7000)
		return false
	end

	local hasFaction = false
	for _, faction in ipairs({ "mechanic", "tuner" }) do
		if exports.character:HasFaction(faction) then
			hasFaction = true
			break
		end
	end
	if not hasFaction then
		exports.mythic_notify:SendAlert("error", "You are unable to install these parts!", 7000)
		return false
	end

	local upgrade = upgrades[item.name]
	if not upgrade then return end

	local itemLevel = tonumber(item.name:sub(item.name:len()))
	if not itemLevel then
		error("Upgrade level not a number for item: "..tostring(item.name))
	end

	local numMods = GetNumVehicleMods(Repairing, upgrade.Mod)
	local mod = GetVehicleMod(Repairing, upgrade.Mod) + 1

	if mod >= itemLevel or itemLevel > numMods then
		exports.mythic_notify:SendAlert("error", "You cannot change out that part!", 7000)
		return false
	end
	
	return true
end

function CanUseItems(ped, vehicle)
	return DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped and not Hotwiring and not HasKey(vehicle)
end

function CanUseKit()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)

	return CanUseItems(ped, vehicle)
end

function CanUseLockpick()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local canUse = false

	if not DoesEntityExist(vehicle) then
		local nearestVehicle = exports.oldutils:GetNearestVehicle()
		if not DoesEntityExist(nearestVehicle) then return false end

		local pedCoords = GetEntityCoords(ped)
		local doorPos = GetEntryPositionOfDoor(nearestVehicle, 0)
		if not doorPos or #(doorPos - vector3(0.0, 0.0, 0.0)) < 0.01 then
			doorPos = GetEntityCoords(vehicle)
		end

		canUse = #(pedCoords - doorPos) < 2.0

		return canUse
	end

	return CanUseItems(ped, vehicle)
end

function CanUseRepairKit()
	local ped = PlayerPedId()

	if GetVehiclePedIsIn(ped, false) ~= 0 then return end

	local vehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return false end

	local vehicleCoords = GetEntityCoords(vehicle)
	
	local boneIndex = GetEntityBoneIndexByName(vehicle, "engine")
	if boneIndex == -1 then return end
	
	local pedCoords = GetEntityCoords(ped)
	local coords = GetWorldPositionOfEntityBone(vehicle, boneIndex)

	if #(coords - pedCoords) > Config.Repairing.EngineDistance then return false end
	if not exports.oldutils:RequestAccess(vehicle) then return false end

	SetVehicleDoorOpen(vehicle, 4, false, false)
	
	return true
end

function CanUseAdvancedRepairKit()
	if not DoesEntityExist(Repairing) or not LookingAt then
		exports.mythic_notify:SendAlert("error", "You must be visualizing to do this!", 7000)
		return false
	end

	local hasFaction = false
	for _, faction in ipairs({ "mechanic", "tuner" }) do
		if exports.character:HasFaction(faction) then
			hasFaction = true
			break
		end
	end
	if not hasFaction then
		exports.mythic_notify:SendAlert("error", "You are not trained to use these tools!", 7000)
		return false
	end

	local ped = PlayerPedId()
	-- local pedCoords = GetEntityCoords(ped)
	local vehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return false end

	local vehicleCoords = GetEntityCoords(vehicle)
	
	if not exports.oldutils:RequestAccess(vehicle) then return false end

	if not LookingAt then return end
	local component = Config.Repairing.Components[LookingAt]
	if not component then return end

	local part = Config.Repairing.Parts[component.Repair]
	if not part then return end

	if not exports.inventory:HasItem(part.Item) then
		exports.mythic_notify:SendAlert("error", "You're missing something!", 7000)
		return
	end

	RepairingComponent = LookingAt
	SetVehicleDoorOpen(vehicle, 4, false, false)
	
	return true
end

--[[ Events ]]--
AddEventHandler("inventory:loaded", function()
	RegisterItems()
end)

RegisterNetEvent("inventory:use_Lockpick")
AddEventHandler("inventory:use_Lockpick", function(item, slot)
	if not CanUseLockpick() then return end
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	if DoesEntityExist(vehicle) then
		ProcessHotwire(vehicle, 1, slot)
	else
		ProcessLockpick(exports.oldutils:GetNearestVehicle())
	end
end)

RegisterNetEvent("inventory:use_HotwireKit")
AddEventHandler("inventory:use_HotwireKit", function(item, slot)
	ProcessHotwire(GetVehiclePedIsIn(PlayerPedId()), 2, slot)
end)

RegisterNetEvent("inventory:use_RepairKit")
AddEventHandler("inventory:use_RepairKit", function(item, slot)
	local vehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return end
	if not exports.oldutils:RequestAccess(vehicle) then return end
	
	Repair(vehicle, true, false, slot)
end)

RegisterNetEvent("inventory:use_AdvancedRepairKit")
AddEventHandler("inventory:use_AdvancedRepairKit", function(item, slot)
	local vehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return end
	if not exports.oldutils:RequestAccess(vehicle) then return end
	
	Repair(vehicle, false, false, slot)
end)

AddEventHandler("vehicles:start", function()
	RegisterItems()
end)