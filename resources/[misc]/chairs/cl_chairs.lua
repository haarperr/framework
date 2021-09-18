Chairs = {}

--[[ Functions: Chair ]]--
function Chairs:Init()
	for model, bases in pairs(Models) do
		for base, info in pairs(bases) do
			local settings = Bases[base]
			if settings then
				exports.interact:Register({
					id = "chair-"..model.."_"..base,
					event = "chair",
					text = settings.Text or "Sit",
					model = model,
					base = base,
				})
			end
		end
	end
end

function Chairs:Update()
	local chair = self.chair
	if not chair then return end

	local entity = chair.entity
	local ped = PlayerPedId()

	-- Check entity.
	if not DoesEntityExist(entity) then
		self:Deactivate()
		return
	end

	-- Standing up.
	if IsDisabledControlJustReleased(0, 46) then
		self:Deactivate()
		return
	end

	-- First person toggle.
	if self.cam and IsControlJustReleased(0, 0) then
		if self.cam.isActive then
			self.cam:Deactivate()
			Citizen.Wait(0)
			SetFollowPedCamViewMode(4)
		else
			self.cam:Activate()
		end
	end

	-- Disable camera collisions.
	DisableCamCollisionForEntity(entity)

	-- Suppress interactions.
	if GetGameTimer() - (self.lastSuppress or 0) > 200 then
		exports.interact:Suppress()
		self.lastSuppress = GetGameTimer()
	end
end

function Chairs:Activate(entity, offset, rotation, anim, camera)
	local ped = PlayerPedId()
	
	-- Defaults.
	offset = offset or vector3(0.0, 0.0, 0.0)
	rotation = rotation or vector3(0.0, 0.0, 0.0)

	-- Cache.
	self.chair = {
		entity = entity,
		offset = offset,
		rotation = rotation,
		anim = anim,
		camera = camera,
		entered = GetEntityCoords(ped, true),
	}

	-- Trigger events.
	TriggerEvent("chairs:activate", entity)

	-- Emote.
	if anim then
		anim.BlendSpeed = 100.0

		self.emote = exports.emotes:Play(anim)
	end

	-- Create camera.
	if camera then
		local origin = GetOffsetFromEntityInWorldCoords(entity, camera.Offset.x, camera.Offset.y, camera.Offset.z)
		local target = GetOffsetFromEntityInWorldCoords(entity, camera.Target.x, camera.Target.y, camera.Target.z)

		local cam = Camera:Create()
		cam.coords = origin
		cam.rotation = ToRotation(Normalize(target - origin))
		cam.fov = camera.Fov

		self.cam = cam
		cam:Activate()
	end
	
	-- Update ped.
	FreezeEntityPosition(ped, true)
	AttachEntityToEntity(ped, entity, 0, offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, false, false, true)

	-- Update entity.
	FreezeEntityPosition(entity, true)
end

function Chairs:Deactivate()
	local chair = self.chair
	local entity = chair and chair.entity
	
	-- Update ped.
	local ped = PlayerPedId()
	FreezeEntityPosition(ped, false)
	DetachEntity(ped, true, true)
	SetEntityCoordsNoOffset(ped, chair.entered.x, chair.entered.y, chair.entered.z, true)

	-- Trigger events.
	TriggerEvent("chairs:deactivate", entity)
	
	-- Uncache chair.
	self.chair = nil

	-- Remove camera.
	if self.cam then
		self.cam:Destroy()
		self.cam = nil
	end

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Chairs.chair then
			Chairs:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Events ]]--
AddEventHandler("chairs:clientStart", function()
	Chairs:Init()
end)

AddEventHandler("interact:on_chair", function(interactable)
	local base = Bases[interactable.base]
	local model = (Models[interactable.model] or {})[interactable.base]

	if not base or not model then return end

	Chairs:Activate(interactable.entity, model.Offset, model.Rotation, model.Anim or base.Anim, model.Camera or base.Camera)
end)