-- { Dict = "mp_arresting", Name = "idle", Flag = 0 },
Restraints = Restraints or {}

--[[ Functions: Restraints ]]--
function Restraints:Start(name)
	if self.active then return end
	
	self.active = true

	LocalPlayer.state.restrained = name
end

function Restraints:Stop()
	if not self.active then return end
	
	self.active = nil

	LocalPlayer.state.restrained = nil
end

function Restraints:Update()
	if self.active and not self.emote then
		print("play emote")
		self.emote = exports.emotes:Play(self.anims.cuffed)
	elseif not self.active and self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

function Restraints:UseItem(item, slot)
	local player, playerPed, playerDist = GetNearestPlayer()
	if not player or playerDist > Config.MaxDist then return end
	
	TriggerServerEvent("players:restrain", slot.slot_id, GetPlayerServerId(player))
end

--[[ Events: Net ]]--
RegisterNetEvent("players:restrain", function()
	
end)

--[[ Events ]]--
AddEventHandler("emotes:cancel", function(id)
	if Restraints.emote == id then
		Restraints.emote = nil
	end
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	if Restraints.items[item.name] then
		Restraints:UseItem(item, slot)

		cb()
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, 46) then
			if Restraints.active then
				Restraints:Stop()
			else
				Restraints:Start()
			end
		end
		Restraints:Update()
		Citizen.Wait(0)
	end
end)