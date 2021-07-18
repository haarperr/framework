IsTeleporting = false
Teleporters = {}

--[[ Functions ]]--
function Register(id, text, coords, target)
	Create(id.."_1", text or Config.DefaultText, coords, target)
	Create(id.."_2", text or Config.DefaultText, target, coords)
end
exports("Register", Register)

function Create(id, text, coords, target)
	exports.interact:Register({
		id = id,
		text = text,
		coords = vector3(coords.x, coords.y, coords.z),
		radius = Config.Radius,
		event = "teleport",
	})

	Teleporters[id] = target
end

function TeleportTo(target)
	if IsTeleporting then return end
	IsTeleporting = true

	DoScreenFadeOut(Config.FadeTime)
	Citizen.Wait(Config.FadeTime)

	local ped = PlayerPedId()
	local wasVisible = IsEntityVisible(ped)

	FreezeEntityPosition(ped, true)
	SetEntityCoords(ped, target.x, target.y, target.z)
	SetEntityHeading(ped, target.w or 0.0)

	if wasVisible then
		SetEntityVisible(ped, false)
	end

	local hasGround, groundZ = false
	local startTime = GetGameTimer()

	while not hasGround and GetGameTimer() - startTime < 5000 do
		Citizen.Wait(1)
		hasGround, groundZ = GetGroundZFor_3dCoord(target.x, target.y, target.z)
	end

	if hasGround then
		SetEntityCoords(ped, vector3(target.x, target.y, groundZ))
	end

	DoScreenFadeIn(Config.FadeTime)
	FreezeEntityPosition(ped, false)

	if wasVisible then
		SetEntityVisible(ped, true)
	end

	IsTeleporting = false
end
exports("TeleportTo", TeleportTo)

--[[ Events ]]--
AddEventHandler("teleporters:clientStart", function()
	for k, teleporter in ipairs(Config.Teleporters) do
		Register("tp-"..k, teleporter.Text, teleporter.From, teleporter.To)
	end
end)

AddEventHandler("teleporters:stop", function()
	for id, target in pairs(Teleporters) do
		exports.interact:Destroy(id)
	end
end)

AddEventHandler("interact:on_teleport", function(interactable)
	local target = Teleporters[interactable.id]
	if target then
		TeleportTo(target)
	end
end)