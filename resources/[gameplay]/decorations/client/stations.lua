function Decoration:OpenStation()
	-- Cache station.
	Main.station = self
end

function Decoration:EnterStation()
	-- Check occupied.
	if self.player then
		TriggerEvent("chat:notify", {
			class = "error",
			text = "It's occupied!",
		})
		return
	end

	-- Get settings.
	local settings = self:GetSettings()
	if not settings then return end

	local station = settings.Station
	if not station then return end

	local entity = self.entity
	if not entity then return end

	-- Move to magnet.
	if station.Magnet then
		local coords = GetOffsetFromEntityInWorldCoords(entity, station.Magnet.Offset)
		local heading = GetEntityHeading(entity) + station.Magnet.Heading

		if not MoveToCoords(coords, heading, true, 5000) then return end
	end

	-- Play anim.
	local anim = station.Anim
	if anim and anim.In then
		exports.emotes:PerformEmote(anim.In)
	end

	-- Check occupied, again.
	if self.player then
		return
	end

	-- Events.
	TriggerServerEvent(Main.event.."enterStation", self.id)
end

function Decoration:LeaveStation(skipEvent)
	local settings = self:GetSettings()
	local station = settings and settings.Station

	-- Play anim.
	local anim = station and station.Anim
	if anim and anim.Out then
		exports.emotes:PerformEmote(anim.Out)
	end

	-- Cancel emote.
	exports.emotes:CancelEmote()

	-- Clear cache.
	Main.station = nil

	-- Events.
	if not skipEvent then
		TriggerServerEvent(Main.event.."exitStation")
	end
end

--[[ Events ]]--
AddEventHandler("inventory:focused", function(value)
	if not value and Main.station then
		Main.station:LeaveStation()
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."enterStation", function(id, success)
	local decoration = Main.decorations[id or false]
	if not decoration then return end

	if success then
		decoration:OpenStation()
	else
		decoration:LeaveStation(true)
	end
end)