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