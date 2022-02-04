--[[ Functions: Main ]]--
function Main.update:Ignition()
	
end

function Main:HasKey(vehicle)
	local playerContainer = exports.inventory:GetPlayerContainer(true)
	if not playerContainer then
		return false
	end

	if self.infoEntity ~= vehicle then
		return false
	end

	local vin = self.info["vin"]
	local slot = exports.inventory:ContainerFindFirst(playerContainer, "Vehicle Key", "return slot:GetField(1) == '"..vin.."'")

	return slot ~= nil
end

function Main:CanLock(vehicle)
	local class = GetVehicleClass(vehicle)
	if Config.Locking.Blacklist[class] then
		return false
	end

	return true
end

function Main:ToggleEngine()
	if not IsDriver then return end

	local netId = GetNetworkId(CurrentVehicle)
	if not netId then return end
	
	if not DoesVehicleHaveEngine(CurrentVehicle) then
		print("no engine")
		return
	end

	TriggerServerEvent("vehicles:toggleEnigne", netId)
end

function Main:ToggleLock()
	local vehicle = IsInVehicle and CurrentVehicle or NearestVehicle
	if not vehicle or not DoesEntityExist(vehicle) then return end

	-- Check lockable.
	if not self:CanLock(vehicle) then return end
	
	-- Check key.
	if not IsInVehicle and not self:HasKey(vehicle) then return end
	
	-- Request access.
	if not WaitForAccess(vehicle) then return end
	
	-- Play emote.
	ClearPedTasks(Ped)
	
	exports.emotes:Play(Config.Locking.Anim)
	
	-- Lock vehicle.
	local status = GetVehicleDoorsLockedForPlayer(vehicle, Player) ~= 1

	TriggerEvent("chat:notify", status and "Locked vehicle!" or "Unlocked vehicle!", "inform")

	SetVehicleDoorsLockedForAllPlayers(vehicle, status)

	-- Play sound.
	TriggerServerEvent("playSound3D", IsInVehicle and "lock" or "carlock")
end

--[[ Events ]]--
RegisterNetEvent("vehicles:toggleEngine", function(netId, state)
	local _netId = GetNetworkId(CurrentVehicle)
	if not _netId or _netId ~= netId then return end

	SetVehicleEngineOn(CurrentVehicle, state, false, true)
end)

--[[ Commands ]]--
RegisterCommand("+nsrp_ignition", function()
	if not IsControlEnabled(0, 51) then
		return
	end

	Main:ToggleEngine()
end, true)

RegisterKeyMapping("+nsrp_ignition", "Vehicles - Ignition", "keyboard", "i")

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, 182) and IsControlEnabled(0, 51) then
			Main:ToggleLock()
			Citizen.Wait(Config.Locking.Delay)
		else
			Citizen.Wait(0)
		end
	end
end)