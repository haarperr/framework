exports.chat:RegisterCommand("a:revive", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target == 0 or target < -1 then return end

	exports.log:Add({
		source = source,
		target = target > 0 and target or nil,
		verb = "revived",
		noun = target == -1 and "all" or nil,
	})

	TriggerClientEvent("health:revive", target, true)
end, {
	description = "Revive somebody.",
	parameters = {
		{ name = "Target", help = "Who to revive?" },
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
	})

	TriggerClientEvent("health:slay", target)
end, {
	description = "Slay somebody.",
	parameters = {
		{ name = "Target", help = "Who to slay?" },
	}
}, -1, 25)

exports.chat:RegisterCommand("a:damage", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target == 0 or target < -1 then return end

	local weapon = tonumber(args[2]) or GetHashKey(args[2]:upper())
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
	})

	TriggerClientEvent("health:damage", target, weapon, bone)
end, {
	description = "Do damage to somebody.",
	parameters = {
		{ name = "Target", help = "Who to slay?" },
		{ name = "Weapon", help = "Which weapon is the source of damage." },
		{ name = "Bone", help = "Which bone to apply to (pelvis if blank)." },
	}
}, -1, 25)