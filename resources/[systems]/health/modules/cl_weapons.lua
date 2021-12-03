--[[ Damage Types --
	0 = unknown (or incorrect weaponHash)
	1 =  no damage (flare,snowball, petrolcan)
	2 = melee
	3 = bullet
	4 = force ragdoll fall
	5 = explosive (RPG, Railgun, grenade)
	6 = fire(molotov)
	8 = fall(WEAPON_HELI_CRASH)
	10 = electric
	11 = barbed wire
	12 = extinguisher
	13 = gas
	14 = water cannon(WEAPON_HIT_BY_WATER_CANNON)
]]--

local funcs = {
	[2] = function(bone, weapon, weaponDamage)
		-- Melee.
		bone:TakeDamage(0.1)
	end,
	[3] = function(bone, weapon, weaponDamage)
		-- Bullets.
		local damageRatio = weaponDamage / 100.0
	
		bone:TakeDamage(damageRatio)
		bone:ApplyBleed(damageRatio * Config.Blood.BleedMult)
	end,
	[5] = function(bone, weapon, weaponDamage)
		-- Explosions.
		bone:SpreadDamage(0.4, 0.3, 0.6)
		bone:ApplyBleed(1.0)

		Main:AddEffect("Concussion", 1.0)
		Main:AddEffect("Blood", GetRandomFloatInRange(0.3, 0.4))
	end,
	[6] = function(bone, weapon, weaponDamage)
		-- Fire.
		bone = Main:GetRandomBone()
		bone:TakeDamage(0.01)
	end,
	[10] = function(bone, weapon, weaponDamage)
		-- Electric.
		if weapon == `WEAPON_STUNGUN` then
			bone:TakeDamage(GetRandomFloatInRange(0.1, 0.2))
			bone:ApplyBleed(GetRandomFloatInRange(0.1, 0.2))

			Main:AddEffect("Fatigue", GetRandomFloatInRange(0.2, 0.3))
		end
	end,
	[13] = function(bone, weapon, weaponDamage)
		-- Gas.
		
	end,
}

function Main.update:Fire()
	local isOnFire = not Injury.isInjured and IsEntityOnFire(Ped)
	if self.isOnFire ~= isOnFire then
		if isOnFire then
			Config.Anims.Burning.Force = true
			self.burningEmote = exports.emotes:Play(Config.Anims.Burning)
		elseif self.burningEmote then
			exports.emotes:Stop(self.burningEmote)
			self.burningEmote = nil
		end

		self.isOnFire = isOnFire
	end
end

Main:AddListener("TakeDamage", function(weapon, boneId, data)
	if not IsWeaponValid(weapon) then return end
	
	local bone = Main:GetBone(boneId)
	if not bone or GetGameTimer() - (bone.lastDamage or 0) < 50 then print("ignoring damage, too soon") return end
	
	local weaponDamage = GetWeaponDamage(weapon) or 0.0
	local damageType = GetWeaponDamageType(weapon) or 0
	local func = funcs[damageType]

	print("damage type", damageType, "bone", bone and bone.Name)

	if func then
		func(bone, weapon, weaponDamage)
	end
end)