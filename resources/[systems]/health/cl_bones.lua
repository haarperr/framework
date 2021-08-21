Bone = {}
Bone.__index = Bone

function Bone:Create(id, name)
	local instance = setmetatable({
		id = id,
		name = name,
		info = {},
	}, Bone)
	
	return instance
end

function Bone:Heal()
	self.info = {}

	self:UpdateInfo()
end

function Bone:TakeDamage(amount)
	local health = self.info.health or 1.0
	health = math.min(math.max(health - amount, 0.0), 1.0)

	self.info.health = health
	self.lastDamage = GetGameTimer()

	self:UpdateInfo()

	Main:InvokeListener("DamageBone", self, amount)
end

function Bone:SpreadDamage(amount, falloff)
	local settings = self:GetSettings()
	if not settings or not settings.Nearby then return end

	self:TakeDamage(amount)

	for _, id in ipairs(settings.Nearby) do
		local bone = Main.bones[id]
		if bone then
			bone:TakeDamage(amount * (falloff or 1.0))
		end
	end
end

function Bone:GetSettings()
	return Config.Bones[self.id]
end

function Bone:UpdateInfo()
	Menu:Invoke("main", "updateInfo", self.name, self.info)
	
	local health = Main:GetHealth()
	
	Menu:Invoke("main", "updateEffect", "Health", health)
end