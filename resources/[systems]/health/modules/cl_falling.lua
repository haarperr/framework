Falling = {
	speedBuffer = {},
	isFalling = false,
	bufferSize = 10,
	maxSpeed = 30.0,
	minSpeed = 1.0,
	fractureSpeed = 20.0,
}

--[[ Functions ]]--
function Falling:Update()
	local speed = GetEntitySpeed(Ped)

	table.insert(self.speedBuffer, speed)

	if #self.speedBuffer > self.bufferSize then
		table.remove(self.speedBuffer, 1)
	end
end

function Falling:GetAverageSpeed()
	local totalSpeed = 0.0
	for _, speed in ipairs(self.speedBuffer) do
		totalSpeed = totalSpeed + speed
	end
	return totalSpeed / #self.speedBuffer
end

--[[ Listeners ]]--
Main:AddListener("TakeDamage", function(weapon, boneId, data)
	if weapon ~= `WEAPON_FALL` then return end

	local speed = Falling:GetAverageSpeed()
	if speed < Falling.minSpeed then return end
	
	local damage = math.min((speed - Falling.minSpeed) / (Falling.maxSpeed - Falling.minSpeed), 1.0)
	local bone = Main:GetBone(boneId)
	if not bone or GetGameTimer() - (bone.lastDamage or 0) < 200 then return end
	
	if speed > Falling.fractureSpeed then
		bone.info.fractured = true
	end

	bone:SpreadDamage(damage, GetRandomFloatInRange(0.7, 0.9))
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Ped and DoesEntityExist(Ped) then
			Falling:Update()
		end
		Citizen.Wait(0)
	end
end)