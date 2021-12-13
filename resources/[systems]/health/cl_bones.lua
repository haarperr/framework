Bone = {
	process = {
		damage = {},
		bleed = {},
		update = {},
	},
}

Bone.__index = Bone

--[[ Functions: Main ]]--
function Main:UpdateBones()
	local hasUpdated = false
	for boneId, bone in pairs(self.bones) do
		if bone:Update() then
			hasUpdated = true
		end
	end

	if hasUpdated then
		self:UpdateSnowflake()
	end
end

--[[ Functions: Bone ]]--
function Bone:Create(id, name)
	local instance = setmetatable({
		id = id,
		name = name,
		info = {},
		history = {},
		cache = {},
		temp = {},
	}, Bone)
	
	return instance
end

function Bone:SetInfo(key, value)
	self.info[key] = value
	Main:UpdateSnowflake()
end

function Bone:Update()
	local deltaTime = (GetGameTimer() - (self.lastUpdate or GetGameTimer())) / 1000.0
	self.lastUpdate = GetGameTimer()

	for name, func in pairs(self.process.update) do
		func(self)
	end

	local updatedHistory = self:UpdateHistory(deltaTime)

	if not Injury.isDead and not self.injured then
		self:AddHealth(deltaTime * 0.01)
	end

	return updatedHistory
end

function Bone:Heal()
	self.info = {}
	self.history = {}
	self.cache = {}

	self:UpdateInfo()
	Main:UpdateSnowflake()
end

function Bone:UpdateHistory(deltaTime)
	local hasUpdated = false
	local injured = false

	for i = #self.history, 1, -1 do
		local event = self.history[i] or {}
		local injury = Config.Injuries[event.name or false]
		local treatment = not injury and Config.Treatments[event.name or false]
		local lifetime = 300.0

		if injury then
			lifetime = injury.Lifetime or lifetime
			injured = true
		elseif treatment then
			lifetime = treatment.Lifetime or lifetime
		end

		local time = event.time + deltaTime / lifetime
		event.time = time

		if time > 1.0 then
			self:RemoveHistory(i)
			hasUpdated = true
		elseif math.abs((self.cache[i] or 0.0) - time) > 0.05 then
			self.cache[i] = time
			hasUpdated = true
		end
	end

	self.injured = injured
	
	return hasUpdated
end

function Bone:AddHistory(name)
	table.insert(self.history, {
		name = name,
		time = 0.0,
	})

	table.insert(self.cache, 0.0)

	if #self.history > 256 then
		self:RemoveHistory(1)
	end
end

function Bone:RemoveHistory(index)
	table.remove(self.history, 1)
	table.remove(self.cache, 1)
end

function Bone:AddTreatment(name)
	self:AddHistory(name)
	self:UpdateInfo()

	Main:UpdateSnowflake()
	Main:InvokeListener("TreatBone", self, name)
end

function Bone:AddHealth(amount)
	if not amount or amount < 0.0 then return end

	local health = self.info.health or 1.0

	health = math.min(health + amount, 1.0)

	if health > 0.999 then
		health = nil
	end
	
	self:SetInfo("health", health)
	self:UpdateInfo()
end

function Bone:TakeDamage(amount, injury)
	if GetPlayerInvincible(PlayerId()) or not amount or amount < 0.0001 then return end
	
	local settings = self:GetSettings()
	if not settings or settings.Fallback then return end

	for name, func in pairs(self.process.damage) do
		local result = func(self, amount)
		if result == false then
			return
		elseif type(result) == "number" then
			amount = result
		end
	end

	-- Log the injury.
	if injury and Config.Injuries[injury] then
		self:AddHistory(injury)
	end

	-- Cache current time.
	self.lastDamage = GetGameTimer()
	
	-- Update health.
	local health = self.info.health or 1.0
	health = math.min(math.max(health - amount, 0.0), 1.0)
	
	self:SetInfo("health", health)
	self:UpdateInfo()

	Main:AddEffect("Health", -amount * (settings.Modifier or 1.0))

	-- Trigger events.
	Main:InvokeListener("DamageBone", self, amount)

	TriggerServerEvent("health:damageBone", self.id, amount, injury)
end

function Bone:SpreadDamage(amount, falloff, falloff2, injury)
	local settings = self:GetSettings()
	if not settings or not settings.Nearby then return end

	self:TakeDamage(amount, injury)

	for _, id in ipairs(settings.Nearby) do
		local bone = Main.bones[id]
		if bone then
			bone:TakeDamage(amount * (falloff2 and GetRandomFloatInRange(falloff, falloff2) or falloff or 1.0))
		end
	end
end

function Bone:SetFracture(value)
	self:SetInfo("fractured", value)
	Main:SetEffect("Fracture", value and 1.0 or 0.0)
end

function Bone:GetSettings()
	return Config.Bones[self.id]
end

function Bone:UpdateInfo()
	Menu:Invoke("main", "updateInfo", self.name, self.info)
end

function Bone:GetGroup()
	local settings = bone:GetSettings()
	if not settings or not settings.Group then
		return nil
	end

	return settings.Group, Config.Groups[settings.Group]
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:UpdateBones()
		Citizen.Wait(1000)
	end
end)