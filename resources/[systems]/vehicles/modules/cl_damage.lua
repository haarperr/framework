Damage = {
	info = {},
	cache = {},
	process = {},
	healths = {},
}

--[[ Functions: Main ]]--
function Main:TakeDamage(name, amount)
	local part = Config.Parts[name]
	if not part then return end

	local damage = self.info and self.info.damage
	if not damage then
		damage = {}
		self.info.damage = damage
	end

	local value = damage[name] or 1.0
	value = math.min(math.max(value - amount, 0.0), 1.0)
	
	if part.Update then
		local retval = part.Update(value, Handling)
		if retval then
			value = retval
		end
	end
	
	damage[name] = value

	-- if name == "Engine" then
	-- 	Damage.healths.engine = value * 1000.0
	-- 	Damage:UpdateVehicle()
	-- end

	print("Set damage", name, value)
end

--[[ Functions: Damage ]]--
function Damage:Init(info)
	if not info.damage then return end

	self.healths = self:GetHealths(vehicle)
	self.cache = self.healths

	print("init?")
end

function Main.update:Damage()
	-- local driveForce = Handling:GetDefault("fInitialDriveForce")
	-- Handling:SetField("fInitialDriveForce", driveForce * 1.5)
	
	-- Testing: faulty fuel injector?
	-- local d = self.nextChoke and GetGameTimer() - self.nextChoke
	-- local max = 2000.0
	-- if not d or d > max then
	-- 	self.nextChoke = GetGameTimer() + GetRandomIntInRange(5000, 10000)
	-- 	d = 0.0
	-- end
	-- local t = math.min(math.max(math.abs(d) / max, 0.0), 1.0) * 0.8 + 0.2
	-- if t < 0.99 then
	-- 	SetVehicleCurrentRpm(CurrentVehicle, Rpm * t)
	-- end

	if not IsDriver then return end
	
	local engine = Parts:Find("Engine")
	if not engine then return end

	-- Overheating.
	local temperatureDamage = OverheatRate and OverheatRate > 0.01 and (
		math.pow(((Rpm - 0.2) / 0.8) * math.min(TemperatureRatio, 1.0) * math.min(OverheatRate, 1.0), 2.0)
	) or 0.0

	local temperatureDelta = 1000.0 / DeltaTime * temperatureDamage * 0.001
	if temperatureDamage > 0.001 then
		engine:Damage(temperatureDelta)
	end

	-- Damage factor.
	SetVehicleAudioBodyDamageFactor(CurrentVehicle, temperatureDamage)
	SetVehicleAudioEngineDamageFactor(CurrentVehicle, temperatureDamage)
end

function Damage:GetHealths(vehicle)
	return {
		body = GetVehicleBodyHealth(vehicle),
		engine = GetVehicleEngineHealth(vehicle),
		petrol = GetVehiclePetrolTankHealth(vehicle),
	}
end

function Damage:UpdateVehicle()
	if not self.healths then
		self.healths = {}
	end

	SetVehicleBodyHealth(CurrentVehicle, self.healths.body or 1000.0)
	SetVehicleEngineHealth(CurrentVehicle, self.healths.engine or 1000.0)
	SetVehiclePetrolTankHealth(CurrentVehicle, self.healths.petrol or 1000.0)

	print("Updating", json.encode(self.healths))
end

--[[ Events ]]--
AddEventHandler("onEntityDamaged", function(data)
	if not IsDriver or data.victim ~= CurrentVehicle or not data.weapon then return end

	local attackerType = data.attacker ~= Ped and GetEntityType(data.attacker or 0) or 0

	-- Get current healths.
	local healths = Damage:GetHealths(CurrentVehicle)

	-- Get delta healths.
	local deltas = {}
	for name, value in pairs(healths) do
		deltas[name] = math.max((Damage.cache[name] or 1000.0) - value, 0.0)
		Damage.cache[name] = value
	end

	-- Calculate out damage direction.
	local direction
	if attackerType == 0 then
		direction = LastVelocity
	else
		local coords = GetEntityCoords(data.attacker)
		direction = Normalize(coords - Coords)
	end

	-- Random direction.
	if not direction then
		local rad = GetRandomFloatInRange(0.0, 2.0 * math.pi)
		direction = vector3(math.cos(rad), math.sin(rad), 0.0)
	end

	-- Debug: draw damage direction.
	-- Citizen.CreateThread(function()
	-- 	for i = 1, 100 do
	-- 		DrawLine(Coords.x, Coords.y, Coords.z + 1.0, Coords.x + direction.x * 10.0, Coords.y + direction.y * 10.0, Coords.z + direction.z * 10.0 + 1.0, 255, 0, 0, 255)
	-- 		Citizen.Wait(0)
	-- 	end
	-- end)

	-- Process damage functions.
	for name, func in pairs(Damage.process) do
		print("processing", name, func)
		func(Damage, data, deltas, direction)
	end

	-- Update vehicle's health.
	Damage:UpdateVehicle()

	-- Events.
	-- Main:InvokeListener("TakeDamage", data.weapon, data, Damage.deltas)
end)

-- AddEventHandler("vehicles:start", function()
-- 	local vehicle = GetVehiclePedIsIn(PlayerPedId())
-- 	if not DoesEntityExist(vehicle) then return end

-- 	Damage.healths = Damage:GetHealths(vehicle)
-- end)

--[[ Events: Net ]]--
RegisterNetEvent("vehicles:fix", function()
	if not CurrentVehicle then return end

	SetVehicleFixed(CurrentVehicle)
	Parts:Restore()
end)