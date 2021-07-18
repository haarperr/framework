local Debugging = false
local Dimensions = {}
local Entity = nil
local HitCoords = vector3(0, 0, 0)
local HitNormal = vector3(0, 0, 0)
local HasFocus = false

function Functions:ProcessDebugger()
	if PowerLevel < Config.Debugger.PowerLevel then return end

	if IsDisabledControlJustReleased(0, Config.Debugger.Key) and IsInputDisabled(0) then
		Debugging = not Debugging
		ToggleMenu()
	elseif IsDisabledControlJustReleased(0, Config.Debugger.FocusKey) and IsInputDisabled(0) then
		ToggleCursor()
	end

	if not Debugging then return end

	-- Crosshair.
	EnableCrosshairThisFrame()
	DisplaySniperScopeThisFrame()

	-- Objects.
	local objects = exports.oldutils:GetObjects()
	local pedCoords = GetEntityCoords(Ped)

	for k, object in ipairs(objects) do
		if #(GetEntityCoords(object) - pedCoords) > 50.0 then
			goto skip
		end
		-- TODO: Draw bounding box.
		::skip::
	end

	local data = {}

	-- Current object.
	local camCoords = GetFinalRenderedCamCoord()
	local camRot = GetFinalRenderedCamRot(0)
	local camForward = exports.misc:FromRotation(camRot + vector3(0, 0, 90))
	local rayTarget = camCoords + camForward * 1000.0
	local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, rayTarget.x, rayTarget.y, rayTarget.z, -1, Ped, 0)
	local retval, didHit, hitCoords, surfaceNormal, material, entity = GetShapeTestResultIncludingMaterial(rayHandle)
	local isEntity = didHit and DoesEntityExist(entity) and GetEntityType(entity) ~= 0

	data[#data + 1] = {"Coords (Ped)", {pedCoords.x, pedCoords.y, pedCoords.z, GetEntityHeading(Ped)}}
	data[#data + 1] = {"Coords (Camera)", {camCoords.x, camCoords.y, camCoords.z}}
	data[#data + 1] = {"Rotation (Camera)", {camRot.x, camRot.y, camRot.z}}

	if IsControlJustPressed(0, 288) then
		local prices = ""
		local total = 0
		local classes = {
			[0] = 0.4, --Compacts.
			[1] = 0.5, --Sedans.
			[2] = 1.0, --SUVs.
			[3] = 1.5, --Coupes.
			[4] = 1.0, --Muscle.
			[5] = 2.0, --Sports Classics.
			[6] = 2.0, --Sports.
			[7] = 8.0, --Super.
			[8] = 2.0, --Motorcycles.
			[9] = 1.0, --Off-road.
			[10] = 1.0, --Industrial.
			[11] = 1.0, --Utility.
			[12] = 1.0, --Vans.
			[13] = 0.33, --Cycles.
			[14] = 0.1, --Boats.
			[15] = 5.0, --Helicopters.
			[16] = 5.0, --Planes.
			[17] = 0.5, --Service.
			[18] = 0.0, --Emergency.
			[19] = 0.0, --Military.
			[20] = 0.4, --Commercial.
			[21] = 0.0, --Trains.
		}
		for model, info in pairs(exports.vehicles:GetVehicles()) do
			local modelHash = GetHashKey(model)
			while IsModelValid(modelHash) and not HasModelLoaded(modelHash) do
				RequestModel(modelHash)
				Citizen.Wait(0)
			end

			local vehicle = CreateVehicle(modelHash, 0.0, 0.0, 0.0, 0.0, false, false)
			local drag = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff")
			local driveForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
			local brakeForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeForce")
			local mass = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fMass")
			local monetaryValue = GetVehicleHandlingFloat(vehicle, "CHandlingData", "nMonetaryValue")

			local value = (math.max(1.0 - drag / 5.0, 0.0) + math.max(driveForce / 1.0, 0.0) + brakeForce + (mass / 1000.0)) * 1000 * classes[GetVehicleClass(vehicle)]
			value = math.floor((value / 1000.0)^2 * 1000.0)

			local string = ("[\"%s\"] = { Value = %s },\\n"):format(model, value)
			prices = prices..string
			print("done with "..model, string)

			total = total + 1

			DeleteVehicle(vehicle)
			SetModelAsNoLongerNeeded(modelHash)

			-- if total > 50 then break end
		end
		data[#data + 1] = { "Vehicle Prices", prices }
	end

	if Entity or didHit then
		if isEntity then
			HitCoords = hitCoords
			HitNormal = surfaceNormal
			Entity = entity
		end

		local speed = GetEntitySpeed(entity)
		local types = {
			[0] = "None",
			[1] = "Ped",
			[2] = "Vehicle",
			[3] = "Object",
		}

		local netId = 0
		if NetworkGetEntityIsNetworked(Entity) then
			netId = ObjToNet(Entity)
		end

		data[#data + 1] = { "Target" }
		data[#data + 1] = { "Entity", Entity or 0 }
		data[#data + 1] = { "Model", GetEntityModel(Entity) }
		data[#data + 1] = { "Material", material }
		data[#data + 1] = { "Type", types[GetEntityType(Entity) or 0] }

		data[#data + 1] = { "Transformation" }
		data[#data + 1] = { "Coords", ConvertVector(GetEntityCoords(Entity)) }
		data[#data + 1] = { "Rotation", ConvertVector(GetEntityRotation(Entity)) }

		data[#data + 1] = { "General" }
		data[#data + 1] = { "Owner", GetPlayerServerId(NetworkGetEntityOwner(Entity)) }
		data[#data + 1] = { "Net ID", netId }
		data[#data + 1] = { "Script", GetEntityScript(Entity) or 0 }
		data[#data + 1] = { "Health", ("%s/%s"):format(GetEntityHealth(Entity), GetEntityMaxHealth(Entity)) }

		data[#data + 1] = { "Other" }
		data[#data + 1] = { "Attached To", GetEntityAttachedTo(Entity) }
		data[#data + 1] = { "Has Collision", not GetEntityCollisionDisabled(Entity) }
		data[#data + 1] = { "Invincible", not GetEntityCanBeDamaged(Entity) }
		data[#data + 1] = { "Is Upright", IsEntityUpright(Entity) == 1 }
		data[#data + 1] = { "Submerged Level", GetEntitySubmergedLevel(Entity) }
		data[#data + 1] = { "Speed (KMH)", speed * 3.6 }
		data[#data + 1] = { "Speed (MPH)", speed * 2.236936 }

		if didHit then
			data[#data + 1] = { "Hit Coords", ConvertVector(hitCoords) }
			data[#data + 1] = { "Hit Normal", ConvertVector(surfaceNormal) }
		end

		local retval, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, p6, p7, drownProof = GetEntityProofs(Entity)
		local proofsAt = 24

		if retval then
			data[#data + 1] = { "Bullet Proof", bulletProof }
			data[#data + 1] = { "Fire Proof", fireProof }
			data[#data + 1] = { "Explosion Proof", explosionProof }
			data[#data + 1] = { "Collision Proof", collisionProof }
			data[#data + 1] = { "Melee Proof", meleeProof }
			data[#data + 1] = { "Drown Proof", drownProof }
		end

		local scale = 0.5
		DrawLine(HitCoords.x, HitCoords.y, HitCoords.z, HitCoords.x + HitNormal.x * scale, HitCoords.y + HitNormal.y * scale, HitCoords.z + HitNormal.z * scale, 255, 255, 255, 255)
		if not isEntity then
			DrawLine(hitCoords.x, hitCoords.y, hitCoords.z, hitCoords.x + surfaceNormal.x * scale, hitCoords.y + surfaceNormal.y * scale, hitCoords.z + surfaceNormal.z * scale, 255, 0, 0, 255)
		end

		if IsControlJustPressed(0, Config.Debugger.DeleteKey) then
			if NetworkGetEntityIsNetworked(Entity) then
				TriggerServerEvent("admin-tools:delete", ObjToNet(Entity))
			else
				DeleteEntity(Entity)
			end
		end
	end

	SendNUIMessage({ info = data })
end

function ToggleCursor()
	HasFocus = not HasFocus
	SetNuiFocus(HasFocus, HasFocus)
	SetNuiFocusKeepInput(false)
	SetPlayerControl(PlayerPedId(), not HasFocus, 0)
end
RegisterNUICallback("toggleCursor", function(data) ToggleCursor() end)

function ToggleMenu()
	SendNUIMessage( { open = Debugging } )

	if not Debugging and HasFocus then
		ToggleCursor()
	end
end

RegisterNUICallback("toggleMenu", function(data)
	Debugging = not Debugging
	ToggleMenu()
end)

function ConvertVector(vector)
	if type(vector) == "vector3" then
		return {vector.x, vector.y, vector.z}
	elseif type(vector) == "vector4" then
		return {vector.x, vector.y, vector.z, vector.w}
	end
end

function CopyToClipboard(text)
	SendNUIMessage({
		copy = text
	})
end
exports("CopyToClipboard", CopyToClipboard)
