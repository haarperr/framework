--[[ Functions ]]--
local function setVehicleRotation(source, x, y)
	-- Get ped.
	local ped = GetPlayerPed(source)
	if not DoesEntityExist(ped or 0) then
		return false
	end

	-- Get vehicle.
	local vehicle = GetVehiclePedIsIn(ped)
	if not vehicle then
		return false
	end

	-- Flip vehicle.
	local heading = GetEntityHeading(vehicle)
	SetEntityRotation(vehicle, x, y, heading)
end

--[[ Commands ]]--
exports.chat:RegisterCommand("a:vehspawn", function(source, args, command, cb)
	local model = args[1]
	if not model then
		cb("error", "Invalid model!")
		return
	end

	-- Get ped.
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	
	-- Delete old vehicle.
	local currentVehicle = GetVehiclePedIsIn(ped)
	if currentVehicle and DoesEntityExist(currentVehicle) then
		DeleteEntity(currentVehicle)
	end

	-- Create new vehicle.
	local hash = GetHashKey(model)
	local heading = GetEntityHeading(ped)
	local vehicle = Main:Spawn(hash, coords, heading)

	-- Put ped into vehicle.
	SetPedIntoVehicle(ped, vehicle, -1)

	-- Log it.
	exports.log:Add({
		source = source,
		verb = "spawned",
		noun = "vehicle",
		extra = model,
		channel = "admin",
	})
end, {
	description = "Spawn a vehicle.",
	parameters = {
		{ name = "Model", description = "The vehicle model to spawn." },
	}
}, -1, 25)

exports.chat:RegisterCommand("a:flip", function(source, args, command, cb)
	if setVehicleRotation(source, 0.0, 180.0) then
		exports.log:Add({
			source = source,
			verb = "flipped",
			noun = "vehicle",
			channel = "admin",
		})
	else
		cb("error", "Must be in a vehicle!")
	end
end, {
	description = "Flip... your vehicle? Yes! Not unflip.",
}, -1, 25)

exports.chat:RegisterCommand("a:unflip", function(source, args, command, cb)
	if setVehicleRotation(source, 0.0, 0.0) then
		exports.log:Add({
			source = source,
			verb = "unflipped",
			noun = "vehicle",
			channel = "admin",
		})
	else
		cb("error", "Must be in a vehicle!")
	end
end, {
	description = "Unflip your vehicle if you're upside down.",
}, -1, 25)