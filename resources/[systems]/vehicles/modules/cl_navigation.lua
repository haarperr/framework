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
	if not ClassSettings then return end

	local options = {}
	local vehicle = nil
	local ped = PlayerPedId()

	local door = nil
	local hood = false
	local trunk = false

	if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
		if IsDriver and ClassSettings.InsideDoors then
			hood = true
			trunk = true

			if DoesVehicleHaveBone(CurrentVehicle, "cargo_node") then
				options[#options + 1] = {
					id = "vehicleToggleBay",
					text = "Cargo Bay",
					icon = "archive",
				}
			end
		end

		local seats = GetVehicleModelNumberOfSeats(Model)
		local seatOptions = {}

		for seatIndex = -1, seats - 2 do
			if self:CanGetInSeat(CurrentVehicle, seatIndex) then
				seatOptions[#seatOptions + 1] = {
					id = "vehicleSeat"..seatIndex,
					text = SeatNames[seatIndex] or "Passenger "..(seatIndex - 2),
					icon = "chair",
					seatIndex = seatIndex,
				}
			end
		end

		options[#options + 1] = {
			id = "vehicleSeat",
			text = "Seat",
			icon = "airline_seat_recline_normal",
			sub = seatOptions,
		}

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
			id = "vehicleToggleTrunk",
			text = "Trunk",
			icon = "inventory_2",
			doorIndex = 5,
		}
	end

	if hood and GetIsDoorValid(vehicle, 4) then
		options[#options + 1] = {
			id = "vehicleToggleHood",
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
AddEventHandler("interact:onNavigate", function(id, option)
	if not option.doorIndex and not option.seatIndex then return end

	local vehicle = GetVehicle()
	if not vehicle then return end

	if option.doorIndex then
		Main:ToggleDoor(vehicle, option.doorIndex)
	elseif option.seatIndex then
		SetPedIntoVehicle(PlayerPedId(), vehicle, option.seatIndex)
	end
end)

AddEventHandler("interact:onNavigate_vehicleToggleBay", function(option)
	local vehicle = GetVehicle()
	if not vehicle then return end

	Main:ToggleBay(vehicle)
end)