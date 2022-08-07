--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.Interval * 60000)
		
		local payedCount = 0

		for i = 0, GetNumPlayerIndices() - 1 do
			local player = tonumber(GetPlayerFromIndex(i))
			local character = exports.character:GetCharacter(player)
			
			if character then
				local job = exports.jobs:GetCurrentJob(character.id)
				local pay = Config.DefaultPay
				local message = "Unemployed"

				if job then
					pay = job.Pay or pay
					message = "Employed"
				end

				pay = pay * Config.PayMultiplier

				local currentPaycheck = exports.character:Get(player, "paycheck")

				if currentPaycheck then
					exports.character:Set(player, "paycheck", currentPaycheck + pay)
					--exports.character:Save(player, "paycheck")

					TriggerClientEvent("paychecks:receive", player, message)

					exports.log:Add({
						source = player,
						verb = "received",
						noun = "paycheck",
						extra = ("%s - $%s"):format(character.id or "?", pay),
					})
					
					payedCount = payedCount + 1
				end
			end
		end

		if payedCount > 0 then
			print(("[PAYCHECKS] Making %s payouts..."):format(payedCount))
		end
	end
end)

--[[ Events ]]--
RegisterNetEvent("paychecks:request")
AddEventHandler("paychecks:request", function()
	local source = source
	local character = exports.character:GetCharacter(source)
	if not character or character.paycheck <= 0 then return end

	TriggerClientEvent("paychecks:receive", source, "Received", exports.misc:FormatNumber(character.paycheck))

	--exports.log:AddEarnings(source, "Paycheck", character.paycheck)
	exports.character:Set(source, "bank", character.bank + character.paycheck)
	exports.character:Set(source, "paycheck", 0)
	--exports.character:Save(source, "paycheck", "bank")
end)

exports.chat:RegisterCommand("paycheck", function(source, args, command)
	local source = source
	local character = exports.character:GetCharacter(source)

	TriggerClientEvent("paychecks:receive", source, "Bank", exports.misc:FormatNumber(character.paycheck))
end, {
	help = "Check the amount in your paycheck",
}, 0)