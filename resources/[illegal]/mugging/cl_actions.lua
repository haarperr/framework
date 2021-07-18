Actions = {}

--[[ Functions: Ped ]]--
function Ped:PerformAction(name)
	-- Get action.
	local action = Actions[name]
	if action == nil then return end

	-- Trigger event.
	TriggerServerEvent("mugging:performAction", self.netId, name)
	
	-- Invoke action.
	action(Actions, self, name)
end

function Ped:PlayAnimAction(anim, action)
	self:PlayAnim(anim)

	Citizen.Wait(200)

	while IsEntityPlayingAnim(self.entity, anim.Dict, anim.Name, 3) do
		Citizen.Wait(0)
	end

	self:CancelAction(action)
end

function Ped:CancelAction(name)
	if not DoesEntityExist(self.entity) then return end

	TriggerServerEvent("mugging:cancelAction", self.netId, name)
end

--[[ Functions: Actions ]]--
function Actions:Dance(ped, action)
	local dances = Config.Anims.Dances
	local dance = dances[GetRandomIntInRange(1, #dances)]

	ped:PlayAnimAction(dance, action)
end

function Actions:Knees(ped, action)
	ped:PlayAnimAction(Config.Anims.Knees, action)
end

function Actions:Keys(ped, action)
	local entity = ped.entity
	local playerPed = PlayerPedId()

	-- Check vehicle.
	local vehicle = GetVehiclePedIsIn(entity, true)
	
	if not vehicle or not DoesEntityExist(vehicle) then
		PlayPedAmbientSpeechNative(entity, "GENERIC_INSULT_MED", "SPEECH_PARAMS_STANDARD")
		return
	end

	-- Wait.
	Citizen.Wait(GetRandomIntInRange(500, 1000))
	
	-- Face player.
	exports.oldutils:RequestAccess(entity)
	if not IsPedFacingPed(entity, playerPed, 15.0) then
		TaskTurnPedToFaceEntity(entity, playerPed, 3000)
		Citizen.Wait(2000)
	end

	-- Check valid.
	local isValid, dist = Main:IsValidTarget(entity)
	if not isValid or dist > 3.0 then return end

	-- Do animation.
	ped:PlayAnimAction(Config.Anims.Give, action)

	Citizen.Wait(200)

	-- Check valid.
	local isValid, dist = Main:IsValidTarget(entity)
	if not isValid or dist > 3.0 then return end

	-- Give key.
	exports.vehicles:RequestKey(vehicle, "mug")

	ResetPedLastVehicle(entity)
	
	-- Destroy.
	ped:Destroy(true)
end

function Actions:Rob(ped, action)
	local entity = ped.entity
	local playerPed = PlayerPedId()

	-- Wait.
	Citizen.Wait(GetRandomIntInRange(500, 1000))

	-- Face ped.
	if not IsPedFacingPed(playerPed, entity, 15.0) then
		TaskTurnPedToFaceEntity(playerPed, entity, 3000)
		Citizen.Wait(2000)
	end
	
	-- Boost confidence.
	ped.confidence = 2.0

	-- Progress.
	local lastUpdate = GetGameTimer()
	
	exports.mythic_progbar:ProgressWithTickEvent({
		Anim = {
			Dict = "anim@gangops@facility@servers@bodysearch@",
			Name = "player_search",
			Flag = 30,
		},
		Label = "Robbing...",
		Duration = 7000,
		UseWhileDead = false,
		CanCancel = true,
		Disarm = true,
	}, function()
		if GetGameTimer() - lastUpdate < 500 then return end
		lastUpdate = GetGameTimer()

		-- Check entity.
		local isValid, dist = Main:IsValidTarget(entity)
		if not isValid or dist > 3.0 or (Entity(entity).state.mugging or 0) < 1 then
			exports.mythic_progbar:Cancel()
		end
	end, function(wasCancelled)
		exports.emotes:CancelEmote()
		ped:CancelAction(action)

		if wasCancelled then return end

		local isValid, dist = Main:IsValidTarget(entity)
		if not isValid or dist > 3.0 or GetGameTimer() - (Main.lastRob or 0.0) < 8000 then return end

		TriggerServerEvent("mugging:rob", ped.netId)
		Main.lastRob = GetGameTimer()
		ped:Destroy(true)
	end)
end

function Actions:Stay(ped, action)
	local entity = ped.entity
	exports.oldutils:RequestAccess(entity)

	ClearPedTasks(entity)
	TaskStandStill(entity, 60 * 1000)
	ped:PlayAnim(Config.Anims.HandsUp)
end

function Actions:Follow(ped, action)
	local entity = ped.entity
	local _entity = Entity(entity)
	local startTime = GetGameTimer()

	while DoesEntityExist(entity) and GetGameTimer() - startTime < 8000 and _entity.state.action ~= "Follow" do
		Citizen.Wait(0)
	end
	
	exports.oldutils:RequestAccess(entity)
	TaskFollowToOffsetOfEntity(entity, PlayerPedId(), 0.0, 0.0, 0.0, 1.0, -1, 5.0, 1)

	while _entity.state.action == "Follow" do
		Citizen.Wait(0)
	end

	ped:CancelAction(action)
end