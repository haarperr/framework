Noclip = {}

RegisterNetEvent("admin-tools:toggleNoclip")
AddEventHandler("admin-tools:toggleNoclip", function(toggle)
	local source = source
	Noclip[source] = toggle
end)