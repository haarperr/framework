Main = {
	gathering = false,
	site = nil,
	slot = nil,
	type = nil,
	emote = nil
}

--[[ Functions ]]--
function Main:Start(slot, gatheringType)
	if self.gathering then return end

	self.slot = slot.slot_id
	self.type = gatheringType

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	for siteId, _site in ipairs(Config[self.type].Sites) do
		if #(coords - _site.Coords) < _site.Radius then
			self.site = siteId
			break
		end
	end

	if not self.site then
		TriggerEvent("chat:notify", "You can't "..Config[self.type].Messages.Action.." here!", "error")
		return
	end

	local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = table.unpack(exports.oldutils:Raycast())

	if not retval or not Config[self.type].Materials[materialHash] or #(hitCoords - coords) > 2.0 then
		TriggerEvent("chat:notify", "You can't "..Config[self.type].Messages.Action.." that!", "error")
		return
	end

	self.gathering = true

	TriggerEvent("chat:notify", Config[self.type].Messages.Progress, "inform")

	self.emote = exports.emotes:Play(Config[self.type].Anim)
end

function Main:Update()
	Citizen.Wait(GetRandomIntInRange(6000, 8000))

	if not self.gathering then return end
	if not exports.quickTime:Begin(Config[self.type].QuickTime) then return end

	Citizen.Wait(200)

	if not self.gathering then return end

	local slotId = self.slot
	if not slotId then return end

	TriggerServerEvent("gathering:gather", self.site, slotId, self.type)

	self:Stop()
end

function Main:Stop()
	if not self.gathering then return end

	self.gathering = false
	self.site = nil
	self.slot = nil
	self.type = nil
	
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

function Main:isConfiguredItem(item)
	for gatherType, settings in pairs(Config) do
		if item == settings.Item then return gatherType end
	end
	return false
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.gathering then
			Main:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)

--[[ Events ]]--
AddEventHandler("inventory:use", function(item, slot, cb)
	if not Main:isConfiguredItem(item.name) then return end

	cb(1000)
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	local gatherType = Main:isConfiguredItem(item.name)
	if not gatherType then return end

	if Main.gathering then
		Main:Stop()
	else
		Main:Start(slot, gatherType)
	end
end)

AddEventHandler("inventory:updateSlot", function(containerId, slotId, slot, item)
	if slotId == Main.slot and (not item or not Main:isConfiguredItem(item.name)) then
		Main:Stop()
	end
end)

AddEventHandler("emotes:cancel", function(id)
	if Main.emote == id then
		Main:Stop()
	end
end)