Stretcher = {
	speed = 0.0,
	models = {
		[`stretcher`] = {},
		[`stryker_M1`] = {},
		[`mxpro`] = { Offset = vector3(0.0, -1.0, 1.2) },
		[`stryker_M1_coroner`] = {},
		-- [`stretcher_basket`] = {},
	},
	controls = {
		1,
		21,
		22,
		24,
		25,
		30,
		34,
		35,
	},
}

function Stretcher:Activate(vehicle)
	if IsEntityAttachedToAnyPed(vehicle) then return end

	local model = GetEntityModel(vehicle)

	local info = self.models[model]
	if not info then return end

	-- Request access.
	if not WaitForAccess(vehicle) then return end

	local ped = PlayerPedId()
	local boneIndex = GetEntityBoneIndexByName(vehicle, "bonnet")
	local pos = info.Offset or vector3(0.0, 1.3, -0.42)
	local rot = info.Rotation or vector3(0.0, 0.0, 180.0)

	-- Check distance to offset.
	local magnet = GetEntityBonePosition_2(vehicle, boneIndex)
	local coords = GetEntityCoords(ped)

	if #(vector2(coords.x, coords.y) - vector2(magnet.x, magnet.y)) > 1.0 or math.abs(coords.z - magnet.z) > 1.5 then
		return
	end

	-- Update stretcher.
	SetVehicleExtra(vehicle, 1, false)
	SetVehicleExtra(vehicle, 2, true)

	-- Attach stretcher to ped.
	AttachEntityToEntity(vehicle, ped, -1, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, false, false, true, true, 0, true)

	-- Cache stuff.
	self.vehicle = vehicle
	self.startTime = GetGameTimer()
end

function Stretcher:Deactivate()
	local ped = PlayerPedId()
	local vehicle = self.vehicle

	WaitForAccess(vehicle)

	SetVehicleExtra(vehicle, 1, true)
	SetVehicleExtra(vehicle, 2, false)
	
	if IsEntityAttachedToEntity(vehicle, ped) then
		DetachEntity(vehicle, true, true)
	end
	
	self.vehicle = nil
	self.startTime = nil
	self.lastUpdate = nil

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

function Stretcher:Update()
	local ped = PlayerPedId()
	local vehicle = self.vehicle

	-- Check ped.
	if IsPedRagdoll(ped) or not IsEntityAttachedToEntity(vehicle, ped) or (IsDisabledControlJustReleased(0, 23) and GetGameTimer() - self.startTime > 1000) then
		self:Deactivate()
		return
	end

	local deltaTime = self.lastUpdate and (GetGameTimer() - self.lastUpdate) / 1000.0 or 0
	local heading = GetGameplayCamRelativeHeading()
	local horizontal = GetDisabledControlNormal(0, 30) --(IsDisabledControlPressed(0, 34) and -1.0) or (IsDisabledControlPressed(0, 35) and 1.0) or 0.0
	local vertical = GetControlNormal(0, 31)

	self.lastUpdate = GetGameTimer()
	self.speed = Lerp(self.speed, horizontal * vertical * 0.5, deltaTime * 2.0)

	-- Disable input.
	for _, control in ipairs(self.controls) do
		DisableControlAction(0, control)
	end
	
	-- Update heading.
	SetGameplayCamRelativeHeading(heading + self.speed)

	-- Force view mode.
	if GetFollowPedCamViewMode() ~= 4 then
		SetFollowPedCamViewMode(4)
	end

	-- Play emote.
	if not self.emote or not exports.emotes:IsPlaying(self.emote) then
		self.emote = exports.emotes:Play({ Dict = "anim@heists@box_carry@", Name = "idle", Flag = 49 })
	end
end

function Stretcher:GetSettings(vehicle)
	return vehicle and DoesEntityExist(vehicle) and self.models[GetEntityModel(vehicle)]
end

--[[ Exports ]]--
exports("IsStretcher", function(vehicle)
	return Stretcher:GetSettings(vehicle) ~= nil
end)

exports("GetStretcher", function(vehicle)
	return Stretcher:GetSettings(vehicle)
end)

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	if Stretcher.models[GetEntityModel(vehicle)] then
		local ped = PlayerPedId()
		ClearPedTasksImmediately(ped)
	end
end)

Main:AddListener("ActivateStretcher", function(vehicle)
	Stretcher:Activate(vehicle)
end)

--[[ Events ]]--
AddEventHandler("vehicles:clientStart", function()
	for model, settings in pairs(Stretcher.models) do
		exports.interact:Register({
			id = "stretcher-"..model,
			model = model,
			text = "Lay",
			event = "activateStretcher"
		})
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Stretcher.vehicle then
			Stretcher:Update()
		end
		Citizen.Wait(0)
	end
end)