Bone = {
	process = {
		damage = {},
		bleed = {},
		update = {},
	},
}

Bone.__index = Bone

--[[ Functions: Main ]]--
function Main.update:Bones()
	for boneId, bone in pairs(self.bones) do
		bone:Update()
	end
end

--[[ Functions: Bone ]]--
function Bone:Create(id, name)
	local instance = setmetatable({
		id = id,
		name = name,
		info = {},
	}, Bone)
	
	return instance
end

function Bone:SetInfo(key, value)
	self.info[key] = value
	Main:UpdateSnowflake()
end

function Bone:Update()
	for name, func in pairs(self.process.update) do
		func(self)
	end
end

function Bone:Heal()
	self.info = {}

	self:UpdateInfo()
	Main:UpdateSnowflake()
end

function Bone:TakeDamage(amount)
	if GetPlayerInvincible(PlayerId()) then return end
	
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

	local health = self.info.health or 1.0
	health = math.min(math.max(health - amount, 0.0), 1.0)

	self.lastDamage = GetGameTimer()
	
	self:SetInfo("health", health)
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