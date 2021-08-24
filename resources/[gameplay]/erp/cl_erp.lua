CurrentBed = nil
Role = 1
Position = 1

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while CurrentBed ~= nil do
			local emote = exports.emotes:GetCurrentEmote()

			if not emote then
				EndSex()
			end

			Citizen.Wait(1000)
		end

		while not exports.emotes:AreHandsUp() do
			Citizen.Wait(1000)
		end

		Citizen.Wait(500)

		local coords = GetEntityCoords(PlayerPedId())
		local nearestBed = nil
		
		for k, bed in ipairs(Config.Beds) do
			if #(coords - vector3(bed.x, bed.y, bed.z)) < 5.0 then
				nearestBed = bed
				break
			end
		end

		CurrentBed = nearestBed
		if CurrentBed ~= nil then
			local nearestPlayer = exports.oldutils:GetNearestPlayer(Config.Distance)
			if nearestPlayer ~= 0 then
				TriggerServerEvent("erp:startSex", nearestPlayer)
			end

			if IsDisabledControlJustPressed(0, 24) then
				Position = math.min(Position + 1, #Config.Positions)
				TriggerServerEvent("erp:changePosition", Position)
			elseif IsDisabledControlJustPressed(0, 25) then
				Position = math.max(Position - 1, 0)
				TriggerServerEvent("erp:changePosition", Position)
			end
		end
	end
end)

--[[ Functions ]]--
function ChangePosition(position)
	Position = position
	position = Config.Positions[Position][Role]
	position.Anim.IsErp = true

	local ped = PlayerPedId()
	local coords = CurrentBed + position.Offset

	exports.emotes:Stop(true)
	exports.emotes:Play(position.Anim)

	FreezeEntityPosition(ped, true)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z)
	SetEntityHeading(ped, coords.w)
end

function EndSex(fromServer)
	local ped = PlayerPedId()
	CurrentBed = nil
	FreezeEntityPosition(ped, false)

	exports.emotes:Stop()

	if not fromServer then
		TriggerServerEvent("erp:stopSex")
	end
end

--[[ Events ]]--
RegisterNetEvent("erp:startSex")
AddEventHandler("erp:startSex", function(role)
	Role = role

	if not CurrentBed then return end
	ChangePosition(Position)
end)

RegisterNetEvent("erp:stopSex")
AddEventHandler("erp:stopSex", function()
	EndSex(true)
end)

RegisterNetEvent("erp:changePosition")
AddEventHandler("erp:changePosition", function(position)
	ChangePosition(position)
end)

-- SetEntityCoords(PlayerPedId(), -796.26745605469, 338.46063232422, 220.43836975098)

-- EndSex()