Carry = {}

--[[ Functions ]]--
function Carry:Start(vehicle)
	if self.emote or self.vehicle then
		self:Stop()
		return
	end

	-- Check carryable.
	if not self:CanCarry(vehicle) then
		return
	end
	
	-- Cache vehicle.
	self.vehicle = vehicle

	-- Play the emote.
	self.emote = exports.emotes:Play({
		Dict = "anim@heists@box_carry@", Name = "idle", Flag = 49
	})
	
	-- Attach vehicle.
	local ped = PlayerPedId()
	local offset = vector3(0.0, 0.4, 0.0)
	local rotation = vector3(0, 0, 90)
	
	AttachEntityToEntity(vehicle, ped, -1, offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, false, false, true, true, 0, true)
end

function Carry:Stop()
	if self.emote then
		local id = self.emote
		self.emote = nil
		
		exports.emotes:Stop(id)
	end

	if self.vehicle then
		DetachEntity(self.vehicle, true, true)
		ActivatePhysics(self.vehicle)

		self.vehicle = nil
	end
end

function Carry:CanCarry(vehicle)
	local ped = PlayerPedId()
	return not IsVehicleOccupied(vehicle) and not IsPedInAnyVehicle(ped) and IsControlEnabled(0, 52)
end

--[[ Events ]]--
AddEventHandler("emotes:cancel", function(id)
	if id and Carry.emote == id then
		Carry:Stop()
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Carry.vehicle and not Carry:CanCarry(Carry.vehicle) then
			Carry:Stop()
		end
		Citizen.Wait(200)
	end
end)