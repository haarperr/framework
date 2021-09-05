Damage = {
	cache = {},
	process = {},
	healths = {},
}

function Damage.process:Main(deltas)
	deltas.engine = (deltas.engine + deltas.body) * 10.0
	deltas.body = 0.0
	
	for name, delta in pairs(deltas) do
		print(name, delta)
	end
end

function Main.update:Damage()
	-- local driveForce = Handling:GetDefault("fInitialDriveForce")
	-- Handling:SetField("fInitialDriveForce", driveForce * 1.5)
end

--[[ Functions ]]--
function Damage:GetHealths(vehicle)
	return {
		body = GetVehicleBodyHealth(vehicle),
		engine = GetVehicleEngineHealth(vehicle),
		petrol = GetVehiclePetrolTankHealth(vehicle),
	}
end

function Damage:UpdateVehicle()
	SetVehicleBodyHealth(CurrentVehicle, self.healths.body or 1000.0)
	SetVehicleEngineHealth(CurrentVehicle, self.healths.engine or 1000.0)
	SetVehiclePetrolTankHealth(CurrentVehicle, self.healths.petrol or 1000.0)

	print("Updating", json.encode(self.healths))
end

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	Damage.healths = Damage:GetHealths(vehicle)
	Damage.cache = Damage.healths
end)

--[[ Events ]]--
AddEventHandler("onEntityDamaged", function(data)
	if not IsDriver or data.victim ~= CurrentVehicle or not data.weapon then return end

	local attackerType = GetEntityType(data.attacker or 0)
	if attackerType == 0 then
		Damage:UpdateVehicle()
		return
	end

	-- Get current healths.
	local healths = Damage:GetHealths(CurrentVehicle)

	-- Get delta healths.
	local deltas = {}
	for name, value in pairs(healths) do
		deltas[name] = math.max((Damage.cache[name] or 1000.0) - value, 0.0)
		Damage.cache[name] = value
	end

	-- Process damage functions.
	for name, func in pairs(Damage.process) do
		func(Damage, deltas)
	end

	-- Process deltas.
	for name, delta in pairs(deltas) do
		local value = (tonumber(Damage.healths[name]) or 1000.0) - delta
		Damage.healths[name] = value
	end

	-- Debug.
	print(json.encode(deltas), json.encode(data))
	
	-- Update vehicle's health.
	Damage:UpdateVehicle()

	-- Events.
	Main:InvokeListener("TakeDamage", data.weapon, data, Damage.deltas)
end)

AddEventHandler("vehicles:start", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	if not DoesEntityExist(vehicle) then return end

	Damage.healths = Damage:GetHealths(vehicle)
end)