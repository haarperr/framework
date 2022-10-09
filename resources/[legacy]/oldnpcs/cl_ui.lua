IsOpen = false
InputCallback = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not IsOpen do
			CurrentDialogue = nil
			Citizen.Wait(200)
		end
		
		local playerPed = PlayerPedId()

		if CurrentDialogue then
			local info = Info[CurrentDialogue] or {}
			local ped = info.ped
			if ped and DoesEntityExist(ped) then
				local dist = #(GetEntityCoords(ped) - GetEntityCoords(playerPed))
				if dist > Config.InteractDistance then
					ToggleMenu(false)
				end
			else
				ToggleMenu(false)
			end
		end

		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function ToggleMenu(toggle)
	if toggle == IsOpen then return end

	SendNUIMessage({
		display = toggle,
		playAudio = toggle,
	})

	IsOpen = toggle

	SetNuiFocusKeepInput(false)
	SetNuiFocus(toggle, toggle)

	if not toggle then
		SetTalking(false)
	end
end

function SetDialogue(key, value)
	if key == "options" then
		local newValue = {}
		for k, v in ipairs(value) do
			newValue[k] = {
				id = v.id,
				text = v.text,
			}
		end
		value = newValue
	end
	SendNUIMessage({
		set = {
			key = key,
			value = value,
			input = false,
		}
	})
end

function SetTalking(value)
	if CurrentDialogue then
		local info = Info[CurrentDialogue] or {}
		local ped = info.ped
		if ped and DoesEntityExist(ped) then
			if value then
				PlayFacialAnim(ped, "mic_chatter", "mp_facial")
			else
				PlayFacialAnim(ped, "mood_normal_1", "facials@gen_male@variations@normal")
			end
		end
	end
end

--[[ NUI Callbacks ]]--
RegisterNUICallback("selectOption", function(data)
	local id = data.id
	if id == -1 then
		ToggleMenu(false)
		return
	end

	local response = Responses[id]
	if response then
		response.info:ResponseCallback(response.response)
	end
end)

RegisterNUICallback("input", function(data)
	local value = data.value
	local callback = InputCallback
	SendNUIMessage({
		input = false,
	})
	if callback then
		InputCallback = nil
		callback(value)
	end
end)

RegisterNUICallback("setTalking", function(data)
	SetTalking(data.value)
end)

--[[ Commands ]]--
RegisterCommand("closedialogue", function()
	IsOpen = true
	ToggleMenu(false)
end, true)