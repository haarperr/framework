AddEventHandler("inventory:use", function(source, item, slot)
	if item.armor then
		exports.inventory:TakeItem(source, item.name, 1, slot.slot_id)
	end
end)