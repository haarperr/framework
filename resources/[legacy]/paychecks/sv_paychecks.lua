--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.Interval * 60000)
		
		local payedCount = 0

		for i = 0, GetNumPlayerIndices() - 1 do
			local player = tonumber(GetPlayerFromIndex(i))
			local character = exports.character:GetCharacter(player)
			
			if character then
				local job = exports.jobs:GetCurrentJob(player)
				local pay = Config.DefaultPay
				local message = "Unemployed"

				if job then
					local rank = exports.jobs:GetRank(player, job.id)
					pay = job.Pay or pay
					if rank and rank.level and job.PayPerRank then
						pay = pay + (job.PayPerRank * (rank.Level - 1))
					end
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

	--exports.log:AddEarnings(source, "Paycheck", character.paycheck)
	exports.banking:AddBank(source, character.bank, character.paycheck, true)
	exports.character:Set(source, "paycheck", 0)
	--exports.character:Save(source, "paycheck", "bank")
end)

RegisterNetEvent("paychecks:purchaseLicense")
AddEventHandler("paychecks:purchaseLicense", function()
	local source = source
	local character = exports.character:GetCharacter(source)
	if not character then return end

	if exports.inventory:CanAfford(source, Config.LicenseCost, true, true) then
		extras = {
			["Character"] = exports.character:Get(source, "id"),
			["Name"] = exports.character:GetName(source),
			["ID"] = exports.character:Get(source, "license_text"),
			["DOB"] = exports.character:Get(source, "dob"),
		}
		result = exports.inventory:GiveItem(source, "License", 1, extras)
		if result[1] then
			exports.inventory:TakeMoney(source, Config.LicenseCost, true, true)
	
			TriggerClientEvent("chat:notify", source, { class = "success", text = "You purchased a new license." })

			exports.log:Add({
				source = source,
				verb = "purchased",
				noun = "license",
				extra = ("%s - $%s"):format(character.id or "?", Config.LicenseCost),
			})
		end
	else
		TriggerClientEvent("chat:notify", source, { class = "error", text = "You can't afford a new license." })
	end
end)

exports.chat:RegisterCommand("paycheck", function(source, args, command)
	local source = source
	local character = exports.character:GetCharacter(source)

	TriggerClientEvent("paychecks:receive", source, "Bank", exports.misc:FormatNumber(character.paycheck))
end, {
	help = "Check the amount in your paycheck",
}, 0)