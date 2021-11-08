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
	local navigation = {}
	self.navigation = navigation

	local options = {}
	local vehicle = nil
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	local door = nil
	local hood = false
	local trunk = false

	if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
		local seat = FindSeatPedIsIn(ped)
		door = seat + 1
		vehicle = CurrentVehicle

		-- Engine.
		if IsDriver then
			options[#options + 1] = {
				id = "vehicleEngine",
				text = "Ignition",
				icon = "car_rental",
			}
		end

		-- Doors.
		if IsDriver and ClassSettings and ClassSettings.InsideDoors then
			hood = true
			trunk = true

			-- Cargo bays!
			if DoesVehicleHaveBone(CurrentVehicle, "cargo_node") then
				options[#options + 1] = {
					id = "vehicleBay",
					text = "Cargo Bay",
					icon = "archive",
				}
			end
		end

		-- Update seats.
		local seats = GetVehicleModelNumberOfSeats(Model)
		local seatOptions = {}

		for seat = -1, seats - 2 do
			if self:CanGetInSeat(CurrentVehicle, seat) then
				seatOptions[#seatOptions + 1] = {
					id = "vehicleSeat"..seat,
					text = SeatNames[seat] or "Passenger "..(seat - 2),
					icon = "chair",
					seatIndex = seat,
				}
			end
		end

		options[#options + 1] = {
			id = "vehicleSeat",
			text = "Seat",
			icon = "airline_seat_recline_normal",
			sub = seatOptions,
		}
	elseif NearestVehicle and DoesEntityExist(NearestVehicle) then
		local nearestDoor, nearestDoorDist, nearestDoorCoords = GetClosestDoor(coords, NearestVehicle, false, true)
		if not nearestDoor then goto skipDoor end

		local doorIndex = Doors[nearestDoor]
		local doorOffset = GetOffsetFromEntityGivenWorldCoords(NearestVehicle, nearestDoorCoords)
		local doorNormal = #doorOffset > 0.001 and Normalize(vector3(doorOffset.x, doorOffset.y, 0.0)) or vector3(0.0, 0.0, 0.0)
		
		if doorIndex == 4 or doorIndex == 5 then
			doorOffset = doorOffset + doorNormal * 1.0
		end

		-- Citizen.CreateThread(function()
		-- 	for i = 1, 100 do
		-- 		local c = GetOffsetFromEntityInWorldCoords(NearestVehicle, doorOffset)
		-- 		DrawLine(c.x, c.y, c.z, coords.x, coords.y, coords.z, 255, 255, 0, 255)

		-- 		Citizen.Wait(0)
		-- 	end
		-- end)

		if #(GetOffsetFromEntityInWorldCoords(NearestVehicle, doorOffset) - coords) > (Config.Navigation.Doors.Distances[doorIndex] or Config.Navigation.Doors.Distances[-1]) then
			doorIndex = nil
		end

		hood = doorIndex == 4
		trunk = doorIndex == 5
		door = not hood and not trunk and doorIndex
		vehicle = NearestVehicle

		navigation.nearestDoor = doorIndex
		navigation.doorOffset = doorOffset

		::skipDoor::
	end

	-- Clear options.
	if not vehicle then
		self:CloseNavigation()
		return
	end

	-- Doors!
	if trunk and GetIsDoorValid(vehicle, 5) then
		options[#options + 1] = {
			id = "vehicleTrunk",
			text = "Trunk",
			icon = "inventory_2",
			doorIndex = 5,
		}
	end

	if hood and GetIsDoorValid(vehicle, 4) then
		options[#options + 1] = {
			id = "vehicleHood",
			text = "Hood",
			icon = "home_repair_service",
			doorIndex = 4,
		}
	end

	if door then
		options[#options + 1] = {
			id = "vehicleDoor",
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
		self:CloseNavigation()
	end
end

function Main:CloseNavigation()
	self.navigation = nil

	exports.interact:RemoveOption("vehicle")
end

function Main.update:Navigation()
	local navigation = self.navigation
	if not navigation then return end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	-- Check nearest door.
	local door = navigation.nearestDoor
	local doorOffset = navigation.doorOffset

	if doorOffset and #(GetOffsetFromEntityInWorldCoords(NearestVehicle, doorOffset) - coords) > (Config.Navigation.Doors.Distances[door] or Config.Navigation.Doors.Distances[-1]) then
		self:BuildNavigation()
	end
end

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	Main:BuildNavigation()
end)

Main:AddListener("Update", function()
	if not IsInVehicle then return end

	local func
	if IsDisabledControlJustPressed(0, 187) then
		func = RollDownWindow
	elseif IsDisabledControlJustPressed(0, 188) then
		func = RollUpWindow
	end

	if func then
		local windowIndex = FindSeatPedIsIn(Ped) + 1
		func(CurrentVehicle, windowIndex)
	end
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate", function(id, option)
	if not option.doorIndex and not option.seatIndex then return end

	local vehicle = GetVehicle()
	if not vehicle then return end

	if option.doorIndex then
		Main:ToggleDoor(vehicle, option.doorIndex)
		exports.emotes:Play(Config.Navigation.Doors.Anim)
	elseif option.seatIndex then
		SetPedIntoVehicle(PlayerPedId(), vehicle, option.seatIndex)
	end
end)

AddEventHandler("interact:onNavigate_vehicleEngine", function(option)
	Main:ToggleEngine()
end)

AddEventHandler("interact:onNavigate_vehicleBay", function(option)
	local vehicle = GetVehicle()
	if not vehicle then return end

	Main:ToggleBay(vehicle)
end)

AddEventHandler("interact:navigate", function(value)
	if not value then
		Main:CloseNavigation()
		return
	end

	Main:BuildNavigation()
end)