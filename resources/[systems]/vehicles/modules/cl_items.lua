AddEventHandler("inventory:use", function(item, slot, cb)
	if item.category ~= "Vehicle" then return end

	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	local partName = item.part or item.name
	local part, dist = Parts:Find(partName, pedCoords)

	local repair = part and part.settings.Repair
	if not repair or not dist or dist > (repair.Dist or 3.0) then
		TriggerEvent("chat:notify", {
			text = "Cannot find that part...",
			class = "error",
		})
		return
	end

	Parts.repairing = {
		part = part,
		slot = slot and slot.id,
		vehicle = Parts.vehicle,
	}

	cb(repair.Duration or 3000, repair.Emote)
end)

AddEventHandler("inventory:useCancel", function(slotId, item, slot)
	if Parts.repairing then
		Parts.repairing = nil
	end
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	local repairing = Parts.repairing
	if not repairing or repairing.slot ~= slot.id or repairing.vehicle ~= Parts.vehicle then return end

	local part = repairing.part
	if not part then return end

	TriggerServerEvent("vehicles:setDamage", GetNetworkId(Parts.vehicle), part.id, slot.slot_id)
end)