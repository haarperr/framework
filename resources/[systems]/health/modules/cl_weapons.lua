Main:AddListener("TakeDamage", function(weapon, boneId, data)
	if not IsWeaponValid(weapon) then return end

	local weaponDamage = GetWeaponDamage(data.weapon)
	if weaponDamage < 0.01 then return end
	
	local damageRatio = weaponDamage / 100.0

	local bone = Main:GetBone(boneId)
	if not bone or GetGameTimer() - (bone.lastDamage or 0) < 200 then return end

	bone:TakeDamage(damageRatio)
	bone:ApplyBlead(0.1)
end)