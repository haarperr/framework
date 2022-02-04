exports.chat:RegisterCommand("a:vehlock", function(source, args, command, cb)
	local vehicle = IsInVehicle and CurrentVehicle or NearestVehicle
	if not vehicle or not DoesEntityExist(vehicle) then return end

	-- Request access.
	if not WaitForAccess(vehicle) then
		cb("error", "Couldn't obtain network access of the vehicle...")
		return
	end

	-- Check lockable.
	if not Main:CanLock(vehicle) then
		cb("error", "Vehicle cannot be locked!")
		return
	end

	-- Toggle lock.
	local status = GetVehicleDoorsLockedForPlayer(vehicle, Player) ~= 1

	cb("inform", status and "Locked vehicle!" or "Unlocked vehicle!")

	SetVehicleDoorsLockedForAllPlayers(vehicle, status)
end, {
	description = "Toggle the lock on a vehicle.",
}, "Admin")