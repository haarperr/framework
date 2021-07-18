Messages = {}
Items = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 182) and IsInputDisabled(0) and CanDo() then
			TriggerEvent("interaction:toggleLock")
		end
	end
end)

--[[ Functions ]]--
function GetPlayer(distance)
	-- return GetPlayerServerId(PlayerId())
	return exports.oldutils:GetNearestPlayer(distance)
end

function NobodyNearby(text)
	exports.mythic_notify:SendAlert("error", "There's nobody to "..text.."!", 7000)
end

function CanUse(distance, text)
	local player = GetPlayer(distance)
	if player == 0 then
		NobodyNearby(text)
		return false
	else
		return true
	end
end

function SendMessage(target, message, value)
	TriggerServerEvent("interaction:send", target, message, value)
end
exports("SendMessage", SendMessage)

function CanDo()
	return not exports.health:IsPedDead(PlayerPedId()) and
		exports.character:IsSelected() and
		not exports.vehicles:IsInTrunk() and
		IsHandcuffed ~= true
end
exports("CanDo", CanDo)

local function RegisterItems()
	for k, v in pairs(Items) do
		exports.inventory:RegisterCondition(k, v)
	end
end

--[[ Events ]]--
RegisterNetEvent("interaction:receive")
AddEventHandler("interaction:receive", function(source, message, value)
	if Messages[message] then
		Messages[message](source, message, value)
	end
end)

AddEventHandler("interaction:start", function()
	RegisterItems()
end)

AddEventHandler("inventory:loaded", function()
	RegisterItems()
end)

--[[ Commands ]]--
RegisterCommand("fade", function()
	DoScreenFadeIn(0)
end)