Bone = {
	Process = {
		Damage = {},
		Bleed = {},
	},
}

Bone.__index = Bone

function Bone:Create(id, name)
	local instance = setmetatable({
		id = id,
		name = name,
		info = {},
	}, Bone)
	
	return instance
end

function Bone:Update()
	local bleed = self.info.bleed or 0.0
	if bleed > 0.001 then
		-- local blood = Main:GetEffect("Blood")
		Main:AddEffect("Blood", bleed * 0.01)
	end
end

function Bone:Heal()
	self.info = {}

	self:UpdateInfo()
end

function Bone:TakeDamage(amount)
	local settings = self:GetSettings()
	if not settings or settings.Fallback then return end

	for name, func in pairs(self.Process.Damage) do
		local result = func(self, amount)
		if result == false then
			return
		elseif type(result) == "number" then
			amount = result
		end
	end

	local health = self.info.health or 1.0
	health = math.min(math.max(health - amount, 0.0), 1.0)

	self.info.health = health
	self.lastDamage = GetGameTimer()

	self:UpdateInfo()

	Main:AddEffect("Health", -amount * (settings.Modifier or 1.0))
	Main:InvokeListener("DamageBone", self, amount)
end

function Bone:SpreadDamage(amount, falloff, falloff2)
	local settings = self:GetSettings()
	if not settings or not settings.Nearby then return end

	self:TakeDamage(amount)

	for _, id in ipairs(settings.Nearby) do
		local bone = Main.bones[id]
		if bone then
			bone:TakeDamage(amount * (falloff2 and GetRandomFloatInRange(falloff, falloff2) or falloff or 1.0))
		end
	end
end

function Bone:ApplyBlead(amount)
	for name, func in pairs(self.Process.Bleed) do
		local result = func(self, amount)
		if result == false then
			return
		elseif type(result) == "number" then
			amount = result
		end
	end

	self.info.bleed = math.min((self.info.bleed or 0.0) + 0.1, 1.0)
end

function Bone:SetFracture(value)
	self.info.fractured = value
	
	Main:SetEffect("Fracture", value and 1.0 or 0.0)
end

function Bone:GetSettings()
	return Config.Bones[self.id]
end

function Bone:UpdateInfo()
	Menu:Invoke("main", "updateInfo", self.name, self.info)
	
	Main.snowflake = Main.snowflake + 1
end