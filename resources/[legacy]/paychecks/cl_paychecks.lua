--[[ Events ]]--
AddEventHandler("paychecks:clientStart", function()

	exports.interact:Register({
		id = "paychecks-1",
		name="Paycheck Collection",
		embedded = {
			{
				id = "paycheck",
				text = "Collect Paycheck",
			},
			{
				id = "licensePurchase",
				text = "Buy License",
				items = {
					{ name = "Bills", amount = 100 },
				}
			}
		},
		coords = Config.Coords,
		radius = Config.Radius,
	})

	AddEventHandler("interact:on_paycheck", function()
		TriggerServerEvent("paychecks:request")
	end)

	AddEventHandler("interact:on_licensePurchase", function()
		TriggerServerEvent("paychecks:purchaseLicense")
	end)

end)

RegisterNetEvent("paychecks:receive")
AddEventHandler("paychecks:receive", function(message, ...)
	TriggerEvent("chat:notify", { class="inform", text = Config.Messages[message]:format(...) })
end)