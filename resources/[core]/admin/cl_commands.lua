exports.chat:RegisterCommand("a:tp", function(source, args, command)
	local x, y, z, w = table.unpack(args)

	x = x and x:gsub(",", "")
	y = y and y:gsub(",", "")
	z = z and z:gsub(",", "")
	w = w and w:gsub(",", "")

	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)
	w = tonumber(w)

	if not x or not y or not z then
		TriggerEvent("chat:notify", {
			class = "error",
			text = "Invalid vector (XYZ)!",
		})
		return
	end
	
	local ped = PlayerPedId()
	SetEntityCoords(ped, x + 0.0, y + 0.0, z + 0.0)

	if w then
		SetEntityHeading(ped, w)
	end
end, {
	description = "Teleport to XYZ coordinates."
}, "Mod")