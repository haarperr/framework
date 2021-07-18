local Config = {
	Key = 243,
	Distance = 30.0,
	MinSize = 0.2,
	MaxSize = 0.4,
	Offset = vector3(0.0, 0.0, 0.8),
}

local LastNotify = 0
local AwaitingJobs = false
local Cached = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not IsDisabledControlPressed(0, Config.Key) do
			Citizen.Wait(0)
		end

		Citizen.Wait(0)

		if GetGameTimer() - LastNotify > 10000 then
			TriggerServerEvent("interaction:stare")
		end
		
		local ped = PlayerPedId()
		local peds = exports.oldutils:GetPeds()
		local pedCoords = GetEntityCoords(ped)
		local isNoclip = GetResourceState("admin-tools") == "started" and exports["admin-tools"]:IsNoclipping()
		local range = Config.Distance

		if isNoclip then
			pedCoords = GetFinalRenderedCamCoord()
			range = 500.0
		end

		for k, ped in ipairs(peds) do
			if IsPedAPlayer(ped) and IsEntityVisible(ped) and IsPedHuman(ped) then
				local coords = GetPedBoneCoords(ped, 0x796E)
				local dist = #(coords - pedCoords)

				if dist < range then
					local id = GetPlayerServerId(NetworkGetEntityOwner(ped))
					exports.oldutils:Draw3DText(coords + Config.Offset, tostring(id), 4, math.max(math.min(1.0 - dist / range, 1.0), 0.0) * (Config.MaxSize - Config.MinSize) + Config.MinSize, 1, 1)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if IsDisabledControlJustPressed(0, Config.Key) then
			AwaitingJobs = true
			TriggerServerEvent("interaction:requestJobs")
		elseif IsDisabledControlJustReleased(0, Config.Key) then
			AwaitingJobs = false
			exports.hud:Commit("hideScoreboard")
		end

		Citizen.Wait(0)
	end
end)

RegisterNetEvent("interaction:receiveJobs")
AddEventHandler("interaction:receiveJobs", function(data)
	if not AwaitingJobs then return end

	AwaitingJobs = false
	Cached = (#data > 0 and data) or Cached

	local factions = {}
	for k, v in ipairs(Cached) do
		local job, count = table.unpack(v)
		local color = "white"

		if job ~= "Population" then
			if count == 0 then
				count = "None"
				color = "red"
			elseif count > 0 and count <= 2 then
				count = "Light Presence"
				color = "orange"
			elseif count > 2 and count <= 5 then
				count = "Medium Presence"
				color = "yellow"
			elseif count > 5 and count <= 10 then
				count = "Heavy Presence"
				color = "green"
			elseif count > 10 then
				count = "Very Heavy Presence"
				color = "green"
			end
		end

		factions[k] = {
			name = job,
			count = ("<span style='color: %s'>%s</span>"):format(color, count),
		}
	end

	exports.hud:Commit("setScoreboard", factions)
end)