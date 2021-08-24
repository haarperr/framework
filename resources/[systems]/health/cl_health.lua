Main = {
	bones = {},
	listeners = {},
	effects = {},
	snowflake = 0,
	snowflakeSynced = 0,
}

--[[ Functions ]]--
-- function Main:TakeDamage(weapon, bone, damage)
	
-- 	local isWeapon = IsWeaponValid(weapon)
-- end

function Main:Init()
	for boneId, settings in pairs(Config.Bones) do
		if settings.Name and not settings.Fallback then
			self.bones[boneId] = Bone:Create(boneId, settings.Name)
		end
	end
end

function Main:Update()
	Ped = PlayerPedId()

	if self.ped ~= Ped then
		self.ped = Ped

		SetPedMaxHealth(Ped, 1000)
		SetEntityHealth(Ped, 1000)
	end

	if IsPedDeadOrDying(Ped) then
		ResurrectPed(Ped)
		ClearPedTasksImmediately(Ped)
	end
end

function Main:Sync()
	local payload = {
		effects = {},
		info = {},
	}
	
	-- Get effects.
	for _, effect in ipairs(Config.Effects) do
		local value = self.effects[effect.Name] or effect.Default or 0.0
		if math.abs(value - effect.Default) > 0.001 then
			payload.effects[effect.Name] = value
		end
	end
	
	-- Get bone info.
	local next = next
	for boneId, bone in pairs(self.bones) do
		if next(bone.info) ~= nil then
			payload.info[boneId] = bone.info
		end
	end
	
	-- Update cache.
	self.snowflakeSynced = self.snowflake
	self.lastSync = GetGameTimer()

	-- Check payload.
	local result, retval = IsPayloadValid(payload)
	if not result then
		print(("Ignoring invalid payload (%s)"):format(retval))
		return
	end
	
	-- Sync to server.
	TriggerServerEvent("health:sync", payload)
	
	-- Debug.
	print("Updating snowflake", self.snowflake)
	TriggerEvent("chat:addMessage", { text = json.encode(payload) })
end

function Main:Restore(data)
	for _, effect in pairs(Config.Effects) do
		self:SetEffect(effect.Name, data.effects and data.effects[effect.Name] or effect.Default or 0.0)
	end
	
	for boneId, bone in pairs(self.bones) do
		bone.info = data.info and data.info[boneId] or data.info[tostring(boneId)] or {}
		bone:UpdateInfo()
	end
end

function Main:UpdateBones()
	for boneId, bone in pairs(self.bones) do
		bone:Update()
	end
end

function Main:AddListener(_type, cb)
	local listeners = self.listeners[_type]
	if not listeners then
		listeners = {}
		self.listeners[_type] = listeners
	end

	listeners[cb] = true
end

function Main:InvokeListener(_type, ...)
	if not self.loaded then return end

	local listeners = self.listeners[_type]
	if not listeners then return false end

	for func, _ in pairs(listeners) do
		func(...)
	end

	return true
end

function Main:GetBone(boneId)
	local settings = Config.Bones[boneId or false]
	if not settings then return end
	
	if settings.Fallback then
		settings = Config.Bones[settings.Fallback]
		if not settings then return end
	end

	return self.bones[boneId]
end

function Main:UpdateInfo()
	local info = {}

	for boneId, bone in pairs(self.bones) do
		info[bone.name] = bone.info
	end

	Menu:Invoke("main", "updateInfo", info)

	self.snowflake = self.snowflake + 1
end

function Main:SetEffect(name, value)
	if not self.loaded then return end

	value = math.min(math.max(value, 0.0), 1.0)
	self.effects[name] = value
	Menu:Invoke("main", "updateEffect", name, value)
	Menu:Invoke(false, "setOverlay", name, value)

	self.snowflake = self.snowflake + 1
end

function Main:GetEffect(name)
	return self.effects[name] or 0.0
end

function Main:AddEffect(name, amount)
	local effect = self.effects[name] or 0.0
	self:SetEffect(name, effect + amount)
end

function Main:ResetEffects()
	for _, effect in ipairs(Config.Effects) do
		self:SetEffect(effect.Name, effect.Default or 0.0)
	end
end

function Main:ResetInfo()
	ClearPedBloodDamage(Ped)

	for boneId, bone in pairs(self.bones) do
		bone.info = {}
	end

	self:UpdateInfo()
end

--[[ Events ]]--
AddEventHandler("health:clientStart", function()
	Main:Init()
end)

AddEventHandler("health:start", function()
	Main.loaded = true

	while not Menu.loaded do
		Citizen.Wait(0)
	end

	local data = exports.character:Get("health")
	if data then
		Main:Restore(data)
	end
end)

AddEventHandler("character:selected", function(character)
	if not character then
		Main:ResetInfo()
		Main:ResetEffects()
		Main.loaded = nil

		return
	end

	Main.loaded = true

	if character.health then
		Main:Restore(character.health)
	end
end)

AddEventHandler("onEntityDamaged", function(data)
	if data.victim ~= Ped or not data.weapon then return end
	
	local maxHealth = GetPedMaxHealth(Ped)
	local health = GetEntityHealth(Ped)
	local rawDamage = maxHealth - health

	SetEntityHealth(Ped, maxHealth)

	-- local weaponDamage = GetWeaponDamage(data.weapon)
	-- local damageRatio = (weaponDamage or rawDamage or 0) / Config.MaxHealth

	Main:InvokeListener("TakeDamage", data.weapon, data.pedBone or 11816, data)
end)

--[[ Events: Net ]]--
RegisterNetEvent("health:revive", function(resetEffects)
	Main:ResetInfo()
	
	if resetEffects then
		Main:ResetEffects()
	end
end)

RegisterNetEvent("health:slay", function()
	self:SetEffect("Health", 0.0)
end)

RegisterNetEvent("health:damage", function(weapon, bone)
	Main:InvokeListener("TakeDamage", weapon, bone, {})
end)

RegisterNetEvent("health:addEffect", function(name, amount)
	if name then
		Main:AddEffect(name, amount)
	else
		for _, effect in ipairs(Config.Effects) do
			Main:AddEffect(effect.Name, 1.0)
		end
	end
end)

RegisterNetEvent("health:resetEffects", function()
	Main:ResetEffects()
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("init", function(data, cb)
	Menu:Init()
	Main:ResetEffects()

	cb(true)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:UpdateBones()
		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Main.loaded and Main.snowflake ~= Main.snowflakeSynced then
			Main:Sync()
		end

		Citizen.Wait(Config.Saving.Cooldown)
	end
end)