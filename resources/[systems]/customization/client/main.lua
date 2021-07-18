Main = {}

function Main:SetData(ped, data)
	local controller = Controller:Create()

	if not data then
		data = ped
	elseif ped and ped ~= PlayerPedId() then
		controller.ped = ped
	end

	controller:SetData(controller:ConvertData(data))
end

--[[ Events ]]--
RegisterNetEvent("customization:saved")
AddEventHandler("customization:saved", function(retval, result)
	local window = Editor.window
	if window then
		window:SetModel("saving", false)
	end

	if retval then
		Editor:Toggle(false)
	else
		UI:Notify({
			color = "red",
			message = result or "Error"
		})
	end
end)

AddEventHandler("character:selected", function(character)
	if not character then return end

	if character.appearance or character.features then
		Main:SetData({
			appearance = character.appearance,
			features = character.features,
		})
	else
		Editor:Toggle(true)
	end
end)

-- local c = GetEntityCoords(PlayerPedId()) + vector3(GetRandomFloatInRange(-2.0, 2.0), GetRandomFloatInRange(-2.0, 2.0), 0.0)
-- local ped = CreatePed(2, GetEntityModel(PlayerPedId()), c.x, c.y, c.z, 0, true, true)

-- Main:SetData(ped, {
-- 	appearance = character.appearance,
-- 	features = character.features,
-- })