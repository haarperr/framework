RegisterNetEvent("notify:sendAlert")
AddEventHandler("notify:sendAlert", function(type, text, length, style)
	SendAlert(type, text, length, style)
end)

RegisterNetEvent("notify:sendUniqueAlert")
AddEventHandler("notify:sendUniqueAlert", function(id, type, text, length, style)
	SendUniqueAlert(id, type, text, length, style)
end)

RegisterNetEvent("notify:persistentAlert")
AddEventHandler("notify:persistentAlert", function(action, id, type, text, style, removable)
	PersistentAlert(action, id, type, text, style, removable)
end)

function SendAlert(type, text, length, style)
	SendNUIMessage({
		type = type,
		text = text,
		length = length,
		style = style
	})
end

function SendUniqueAlert(id, type, text, length, style)
	SendNUIMessage({
		id = id,
		type = type,
		text = text,
		style = style
	})
end

function PersistentAlert(action, id, type, text, style, removable)
	if action:upper() == "START" then
		if removable then
			local control = 73
			Citizen.CreateThread(function()
				while true do
					DisableControlAction(0, control, true)
					if IsDisabledControlJustPressed(0, control) then
						PersistentAlert("END", id)
						break
					end
					Citizen.Wait(0)
				end
			end)
			text = text..("<br><br>[%s] <span style='color: #FFA6A6'>Close</span>"):format(GetControlInstructionalButton(2, control, 1):sub(3))
		end
		
		SendNUIMessage({
			persist = action,
			id = id,
			type = type,
			text = text,
			style = style
		})
	elseif action:upper() == "END" then
		SendNUIMessage({
			persist = action,
			id = id
		})
	end
end