Main = {
	bones = {},
	listeners = {},
}

--[[ Functions ]]--
-- function Main:TakeDamage(weapon, bone, damage)
	
-- 	local isWeapon = IsWeaponValid(weapon)
-- end

function Main:Init()
	for boneId, settings in pairs(Config.Bones) do
		if settings.Name then
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

function Main:AddListener(_type, cb)
	local listeners = self.listeners[_type]
	if not listeners then
		listeners = {}
		self.listeners[_type] = listeners
	end

	listeners[cb] = true
end

function Main:InvokeListener(_type, ...)
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

function Main:GetHealth()
	local health = 1.0

	for boneId, bone in pairs(self.bones) do
		health = health - (1.0 - (bone.info.health or 1.0)) * 0.5
		if health < 0.0 then
			break
		end
	end

	return math.min(math.max(health, 0.0), 1.0)
end

function Main:UpdateInfo()
	local info = {}

	for boneId, bone in pairs(self.bones) do
		info[bone.name] = bone.info
	end

	Menu:Invoke("main", "updateInfo", info)
	
	local health = Main:GetHealth()
	
	Menu:Invoke("main", "updateEffect", "Health", health)
end

function Main:Heal()
	for boneId, bone in pairs(self.bones) do
		bone.info = {}
	end
	self:UpdateInfo()
end

--[[ Events ]]--
AddEventHandler("health:clientStart", function()
	Main:Init()
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

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)