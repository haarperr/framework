mythic_action = {
	Name = "",
	Duration = 0,
	Label = "",
	UseWhileDead = false,
	CanCancel = true,
	Disarm = true,
	Snap = nil,
	Anim = {
		Dict = nil,
		Name = nil,
		Flag = 0,
		Task = nil,
	},
}

local isDoingAction = false
local wasCancelled = false

function Progress(action, finish)
	Process(action, nil, nil, finish)
end

function ProgressWithStartEvent(action, start, finish)
	Process(action, start, nil, finish)
end

function ProgressWithTickEvent(action, tick, finish)
	Process(action, nil, tick, finish)
end

function ProgressWithStartAndTick(action, start, tick, finish)
	Process(action, start, tick, finish)
end

function Process(action, start, tick, finish)
	mythic_action = action
	
	local ped = PlayerPedId()
	local snap = action.Snap
	local state = LocalPlayer.state or {}
	local isDead = state.immobile

	if not isDead or mythic_action.UseWhileDead then
		if not isDoingAction then
			isDoingAction = true
			wasCancelled = false
			
			if mythic_action.Anim ~= nil and not isDead then
				if type(mythic_action.Anim) == "table" then
					mythic_action.Anim.IgnoreLoopCorrection = true
				end

				exports.emotes:Play(mythic_action.Anim, function(finished)
					if not finished then
						Cancel()
					end
				end)
			end

			if mythic_action.Disarm then
				TriggerEvent("disarmed")
			end

			SendNUIMessage({
				action = "mythic_progress",
				duration = mythic_action.Duration,
				label = mythic_action.Label
			})

			Citizen.CreateThread(function ()
				if start ~= nil then
					start()
				end
				while isDoingAction do
					Citizen.Wait(1)
					ped = PlayerPedId()

					if tick ~= nil then
						tick()
					end
					if snap ~= nil then
						SetEntityCoordsNoOffset(ped, snap.x, snap.y, snap.z, true, true, true)
						if snap.w then
							SetEntityHeading(ped, snap.w)
						end
					end
					if IsControlJustPressed(0, 177) and mythic_action.CanCancel then
						TriggerEvent("mythic_progbar:client:cancel")
					end
					local state = LocalPlayer.state or {}
					if state.immobile and not mythic_action.UseWhileDead then
						TriggerEvent("mythic_progbar:client:cancel")
					end
				end
				exports.emotes:Stop()
				if finish ~= nil then
					finish(wasCancelled)
				end
			end)
		else
			TriggerEvent("chat:notify", "You're already doing something!", "error")
		end
	else
		TriggerEvent("chat:notify", "You can't do that while you're down!", "error")
	end
end

function Cancel()
	isDoingAction = false
	wasCancelled = true

	SendNUIMessage({
		action = "mythic_progress_cancel"
	})
end
exports("Cancel", Cancel)

function Finish()
	isDoingAction = false
end
exports("Finish", Finish)