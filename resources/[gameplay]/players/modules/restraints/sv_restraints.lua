Restraints = Restraints or {}

--[[ Functions: Restraints ]]--
function Restraints:UseItem(source, target, slotId)
	exports.emotes:PlayShared(source, target, Restraints.anims.cuffing)
	
	TriggerClientEvent("players:restrain", target)
end

--[[ Events: Net ]]--
RegisterNetEvent("players:restrain", function(slotId, target)
	local source = source

	if type(slotId) ~= "number" or type(target) ~= "number" or target <= 0 then return end

	Restraints:UseItem(source, target, slotId)
end)

RegisterNetEvent("players:resistRestrain", function()
	local source = sourec
end)