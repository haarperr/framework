Restraints = Restraints or {}
Restraints.players = {}

--[[ Functions: Restraints ]]--
function Restraints:UseItem(source, target, slotId)
	exports.emotes:PlayShared(source, target, Restraints.anims.cuffing)

	self.players[target] = 1
	
	TriggerClientEvent("players:restrainBegin", target)

	Citizen.SetTimeout(3000, function()
		Restraints:Finish(source, target)
	end)

	return true
end

function Restraints:Finish(source, target)
	local state = self.players[target]
	self.players[target] = nil
	
	if state == 2 then
		return
	end

	TriggerClientEvent("players:restrainFinish", target)
end

--[[ Events: Net ]]--
RegisterNetEvent("players:restrain", function(slotId, target)
	local source = source

	if type(slotId) ~= "number" or type(target) ~= "number" or target <= 0 then return end

	if Restraints:UseItem(source, target, slotId) then
		exports.log:Add({
			source = source,
			target = target,
			verb  = "restrained",
		})
	end
end)

RegisterNetEvent("players:restrainResist", function()
	local source = source
	
	if Restraints.players[source] ~= 1 then return end
	Restraints.players[source] = 2

	exports.log:Add({
		source = source,
		verb = "resisted",
		noun = "restraints",
	})
end)