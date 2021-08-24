IsOpen = false
IsEmoting = false
IsTyping = false
AppHooks = {}
DaysOfWeek = {
	[0] = "Sunday",
	[1] = "Monday",
	[2] = "Tuesday",
	[3] = "Wednesday",
	[4] = "Thursday",
	[5] = "Friday",
	[6] = "Saturday",
}
Months = {
	[0] = "January",
	[1] = "February",
	[2] = "March",
	[3] = "April",
	[4] = "May",
	[5] = "June",
	[6] = "July",
	[7] = "August",
	[8] = "September",
	[9] = "October",
	[10] = "November",
	[11] = "December",
}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if
			(
				IsControlJustReleased(0, 244) and
				(GetResourceState("interaction") ~= "started" or exports.interaction:CanDo()) and
				(GetResourceState("inventory") ~= "started" or HasItem())
			) or (
				IsOpen and
				IsDisabledControlJustReleased(0, 200)
			)
		then
			TriggerEvent("disarmed")
			ToggleMenu(not IsOpen)
			local anim
			if IsOpen then
				IsEmoting = true
				exports.emotes:Play(Config.Open.Anim, function(wasCanceled)
					if wasOpen and IsOpen then
						IsEmoting = false
						ToggleMenu(false)
					end
				end)
			end
		end
		if IsOpen then
			if (GetResourceState("interaction") == "started" and not exports.interaction:CanDo()) or ((GetResourceState("inventory") == "started" and not exports.inventory:HasItem("Mobile Phone"))) then
				ToggleMenu(false)
			else
				exports.oldutils:DisableControls(not IsTyping)
				SendNUIMessage({
					setTime = true,
					minutes = GetClockMinutes(),
					hours = GetClockHours(),
					weekday = DaysOfWeek[GetClockDayOfWeek()],
					day = GetClockDayOfMonth() + 1,
					month = Months[GetClockMonth()],
					year = 1650 + GetClockYear(),
				})
			end
		end
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function ToggleMenu(toggle)
	SetNuiFocus(toggle, toggle)
	SetNuiFocusKeepInput(toggle)
	IsOpen = toggle

	if toggle then
		local character = exports.character:GetCharacter()
	end

	SendNUIMessage({
		display = toggle
	})
	if not toggle and IsEmoting then
		exports.emotes:Play(Config.Close.Anim)
	end
end
exports("ToggleMenu", ToggleMenu)

function LoadApp(app, payload, forceOpen)
	if not HasItem() then return end
	
	if forceOpen then
		SendNUIMessage({
			app = app,
			payload = payload,
		})
	else
		SendNUIMessage({
			loaded = {
				app = app,
				payload = payload,
			}
		})
	end
end

function HasItem()
	return exports.inventory:HasItem("Mobile Phone")
end

--[[ Events ]]--
RegisterNUICallback("close", function()
	ToggleMenu(false)
end)

RegisterNUICallback("focus", function(data)
	IsTyping = data.focus
	SetNuiFocusKeepInput(not IsTyping)
end)

RegisterNUICallback("loadApp", function(data)
	print("loading app", json.encode(data))

	local app = data.app
	if not app then
		error("Loading appless app!")
		return
	end

	local payload = {}

	if AppHooks[app] then
		payload = AppHooks[app](data.content)
		if payload == false then return end
	end

	LoadApp(app, payload)
end)

RegisterNetEvent("phone:sendPayload")
AddEventHandler("phone:sendPayload", function(app, payload, forceOpen)
	LoadApp(app, payload, forceOpen)
end)

RegisterNetEvent("inventory:use_MobilePhone")
AddEventHandler("inventory:use_MobilePhone", function()
	exports.inventory:ToggleMenu(false)
	ToggleMenu(true)
end)

RegisterNetEvent("character:switch")
AddEventHandler("character:switch", function()
	SendNUIMessage({
		app = false,
		forced = true,
	})
end)

--[[ Commands ]]--
RegisterCommand("closephone", function()
	ToggleMenu(false)
end, true)