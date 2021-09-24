Parts = {}

Part = {}
Part.__index = Part

--[[ Functions: Parts ]]--
function Parts:Init(vehicle, hood)
	self:Destroy()

	self.vehicle = vehicle
	self.hood = hood
	self.parts = {}
	
	if not hood or GetVehicleDoorAngleRatio(vehicle, 4) > 0.5 then
		self:Build(Config.Parts, nil, hood)
	end
end

function Parts:Destroy()
	if self.parts then
		for partId, part in pairs(self.parts) do
			part:Destroy()
		end
	end

	self.parts = nil
	self.built = nil
	self.nearLift = nil
end

function Parts:Update()
	if not self.vehicle or not DoesEntityExist(self.vehicle) then return end

	if not self.lastUpdateLift or GetGameTimer() - self.lastUpdateLift > 1000 then
		local nearLift = false
		local vehicleCoords = GetEntityCoords(self.vehicle)
		
		for k, lift in ipairs(Config.Lifts) do
			if #(vehicleCoords - lift.Coords) < lift.Radius then
				nearLift = true
				break
			end
		end
		
		if self.nearLift ~= nearLift then
			if nearLift then
				self:Init(self.vehicle)
			else
				self:Destroy()
			end
			self.nearLift = nearLift
		end

		self.lastUpdateLift = GetGameTimer()
	end

	if self.parts then
		for partId, part in pairs(self.parts) do
			part:Draw()
		end
	end

	if self.hood then
		local isHoodOpen = GetVehicleDoorAngleRatio(self.vehicle, 4) > 0.5
		if self.built and not isHoodOpen then
			self:Destroy()
		elseif not self.built and isHoodOpen then
			self:Init(self.vehicle, true)
		end
	end
end

function Parts:Build(parts, parent, hood)
	self.built = true

	for _, info in ipairs(parts) do
		-- Check filter.
		if hood and info.Name ~= "Engine" then
			goto skipPart
		end
		
		-- Check conditions.
		if info.Condition and not info.Condition(self.vehicle, parent) then
			goto skipPart
		end
			
		-- Build parts from bones.
		local boneType = type(info.Bone)
		if boneType == "table" then
			for k, bone in ipairs(info.Bone) do
				local _boneType = type(bone)
				if _boneType == "string" then
					self:Create(info, bone, parent)
				elseif _boneType == "table" and bone.Name and (not bone.Condition or bone.Condition(self.vehicle, parent)) then
					self:Create(info, bone.Name, parent)
				end
			end
		else
			self:Create(info, info.Bone, parent)
		end

		::skipPart::
	end
end

function Parts:Create(info, boneName, parent)
	-- Inherit bones.
	if boneName == nil then
		boneName = parent and parent.boneName or -1
	end

	-- Get/find bone index.
	local boneIndex
	if type(boneName) == "string" then
		boneIndex = GetEntityBoneIndexByName(self.vehicle, boneName)
		if boneIndex == -1 then
			return
		end
	else
		boneIndex = boneName
	end

	-- Get offset from info.
	local offset = info.Offset
	if type(offset) == "function" then
		offset = offset(self.vehicle)
	end

	-- Fallback offset to zero.
	if offset == nil then
		offset = vector3(0.0, 0.0, 0.0)
	end

	-- Get positions of bones.
	local boneCoords = boneIndex == -1 and GetEntityCoords(self.vehicle) or GetEntityBonePosition_2(self.vehicle, boneIndex)
	local localCoords = GetOffsetFromEntityGivenWorldCoords(self.vehicle, boneCoords.x, boneCoords.y, boneCoords.z)

	-- Mirror offsets.
	if localCoords.x < -0.0001 then
		offset = vector3(offset.x * -1, offset.y, offset.z)
	end

	-- Convert bone offset to entity offset.
	if parent then
		offset = parent.offset + offset
	else
		offset = localCoords + offset
	end

	-- Create part.
	local id = GetHashKey(info.Name.."_"..(parent and parent.rootName or boneName))
	local part = setmetatable({
		boneIndex = boneIndex,
		boneName = boneName,
		rootName = parent and parent.rootName or boneName,
		id = id,
		name = info.Name,
		offset = offset,
	}, Part)
	
	self.parts[id] = part

	-- Create children.
	if info.Parts then
		self:Build(info.Parts, part)
	end

	-- Debug.
	print("Create", info.Name, boneName, id)
end

--[[ Functions: Part ]]--
function Part:Draw()
	if not self.label then
		local health = GetRandomFloatInRange(0.0, 1.0)
		local imgHtml = "<img src='nui://vehicles/icons/"..self.name:gsub("%s+", "")..".png' style='height: 32px !important; padding: 4px; filter: drop-shadow(0px 0px 2px rgba(0, 0, 0, 0.5))' />"
		local innerBarHtml = "<div style='position: absolute; width: 100%; bottom: 0%; top: "..((1.0 - health) * 100.0).."%; background: rgba(0, 255, 0, 0.8)'></div>"
		local barHtml = "<div style='position: relative; min-width: 8px; min-height: 100%; background: rgba(0, 0, 0, 0.4);'>"..innerBarHtml.."</div>"

		self.label = exports.interact:AddText({
			text = "<div style='display: flex'>"..imgHtml..barHtml.."</div>",
			transparent = true,
			entity = Parts.vehicle,
			offset = self.offset,
			distance = 20.0,
		})
	end
end

function Part:Destroy()
	if self.label then
		exports.interact:RemoveText(self.label)
	end
end

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	Parts:Destroy()
end)

Main:AddListener("UpdateNearestDoor", function(vehicle, door)
	if Parts.nearLift then return end

	if door == 4 then
		Parts:Init(vehicle, true)
	else
		Parts.hood = nil
		Parts:Destroy()
	end
end)

Main:AddListener("UpdateNearestVehicle", function(vehicle)
	Parts:Destroy()
	Parts.vehicle = vehicle
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Parts:Update()
		Citizen.Wait(0)
	end
end)