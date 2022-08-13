--[[ Events ]]--
AddEventHandler("paychecks:clientStart", function()

	exports.interact:Register({
		id = "paychecks-1",
		embedded = {
			{
				id = "paycheck",
				text = "Collect Paycheck",
			}
		},
		coords = Config.Coords,
		radius = Config.Radius,
	})

	AddEventHandler("interact:on_paycheck", function()
		TriggerServerEvent("paychecks:request")
	end)

end)

RegisterNetEvent("paychecks:receive")
AddEventHandler("paychecks:receive", function(message, ...)
	TriggerEvent("chat:notify", { class="inform", text = Config.Messages[message]:format(...) })
end)