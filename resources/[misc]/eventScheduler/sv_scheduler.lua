function Execute(event)
	exports.GHMattiMySQL:QueryAsync(("CALL %s()"):format(event.Call))
	print("[EVENTSCHEDULER] Executing event "..event.Call)

	if event.Timing > 0 then
		Citizen.Wait(event.Timing * 60000)
		Execute(event)
	end
end

--[[ Events ]]--
AddEventHandler("eventScheduler:start", function()
	for _, event in ipairs(Events) do
		Citizen.CreateThread(function()
			Execute(event)
		end)
	end
end)