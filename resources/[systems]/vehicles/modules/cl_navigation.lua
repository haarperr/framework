--[[ Functions ]]--
local function GetVehicle()
	local vehicle = IsDriver and CurrentVehicle or NearestVehicle
	if vehicle and DoesEntityExist(vehicle) then
		return vehicle
	end
	return false
end

--[[ Functions: Main ]]--
function Main:BuildNavigation()
	local options = {}
	local vehicle = nil
	local ped = PlayerPedId()

	local door = nil
	local hood = false
	local trunk = false

	if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
		if IsDriver then
			
		end

		door = FindSeatPedIsIn(ped) + 1
		vehicle = CurrentVehicle
	elseif NearestVehicle and DoesEntityExist(NearestVehicle) then
		hood = NearestDoor == 4
		trunk = NearestDoor == 5
		door = not hood and not trunk and NearestDoor
		vehicle = NearestVehicle
	end

	-- Clear options.
	if not vehicle then
		exports.interact:RemoveOption("vehicle")
		return
	end

	-- Doors!
	if trunk and GetIsDoorValid(vehicle, 5) then
		options[#options + 1] = {
			id = "vehicleToggleDoor",
			text = "Trunk",
			icon = "inventory_2",
			doorIndex = 5,
		}
	end

	if hood and GetIsDoorValid(vehicle, 4) then
		options[#options + 1] = {
			id = "vehicleToggleDoor",
			text = "Hood",
			icon = "home_repair_service",
			doorIndex = 4,
		}
	end

	if door then
		options[#options + 1] = {
			id = "vehicleToggleDoor",
			text = "Door",
			icon = "door_back",
			doorIndex = door,
		}
	end

	-- Update navigation.
	if #options > 0 then
		exports.interact:AddOption({
			id = "vehicle",
			icon = "drive_eta",
			text = "Vehicle",
			sub = options,
		})
	else
		exports.interact:RemoveOption("vehicle")
	end
end

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	Main:BuildNavigation()
end)

Main:AddListener("UpdateNearestVehicle", function(vehicle)
	Main:BuildNavigation()
end)

Main:AddListener("UpdateNearestDoor", function(vehicle, door)
	Main:BuildNavigation()
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate_vehicleToggleDoor", function(option)
	if not option.doorIndex then return end

	local vehicle = GetVehicle()
	if not vehicle then return end

	Main:ToggleDoor(vehicle, option.doorIndex)
end)