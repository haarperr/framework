exports.chat:RegisterCommand("a:revive", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target == 0 or target < -1 then return end

	exports.log:Add({
		source = source,
		target = target > 0 and target or nil,
		verb = "revived",
		noun = target == -1 and "all" or nil,
		channel = "admin",
	})

	TriggerClientEvent("health:revive", target, true)
end, {
	description = "Revive somebody.",
	parameters = {
		{ name = "Target", description = "Who to revive?" },
	}
}, -1, 25)

exports.chat:RegisterCommand("a:slay", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target == 0 or target < -1 then return end

	exports.log:Add({
		source = source,
		target = target > 0 and target or nil,
		verb = "slayed",
		noun = target == -1 and "all" or nil,
		channel = "admin",
	})

	TriggerClientEvent("health:slay", target)
end, {
	description = "Slay somebody.",
	parameters = {
		{ name = "Target", description = "Who to slay?" },
	}
}, -1, 25)

exports.chat:RegisterCommand("a:damage", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target == 0 or target < -1 then return end

	local weapon = args[2] and (tonumber(args[2]) or GetHashKey(args[2]:upper())) or GetHashKey("WEAPON_PISTOL")
	if not weapon then return end

	local bone = tonumber(args[3]) or args[3]
	if type(bone) == "string" then
		bone = bone:lower()
		for boneId, _bone in pairs(Config.Bones) do
			if _bone.Name:lower():find(bone) then
				bone = boneId
			end
		end
	end
	
	if not tonumber(bone) then bone = 11816 end

	exports.log:Add({
		source = source,
		target = target > 0 and target or nil,
		verb = "damaged",
		noun = target == -1 and "all" or nil,
		extra = ("weapon: %s - bone: %s"):format(weapon, bone),
		channel = "admin",
	})

	TriggerClientEvent("health:damage", target, weapon, bone)
end, {
	description = "Do damage to somebody.",
	parameters = {
		{ name = "Target", description = "Who are you damaging?" },
		{ name = "Weapon", description = "Which weapon is the source of damage (default = WEAPON_PISTOL)." },
		{ name = "Bone", description = "Which bone to apply to (default = pelvis)." },
	}
}, -1, 25)

exports.chat:RegisterCommand("a:armorup", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target == 0 or target < -1 then return end

	local flag = 1 << (tonumber(args[2]) or 1)
	local amount = math.min(math.max(tonumber(args[3]) or 1.0, 0.0), 1.0)

	exports.log:Add({
		source = source,
		target = target > 0 and target or nil,
		verb = "armored",
		noun = target == -1 and "all" or nil,
		extra = ("flag: %s - amount: %s"):format(flag, amount),
		channel = "admin",
	})

	TriggerClientEvent("health:addArmor", target, flag)
end, {
	description = "Force armor onto somebody.",
	parameters = {
		{ name = "Target", description = "Person to give the armor to." },
		{ name = "Flag", description = "Where to add the armor (1 = normal, 2 = heavy, 3 = head, default = 1)." },
		{ name = "Amount", description = "How much armor to add (default = 1.0)." },
	}
}, -1, 25)