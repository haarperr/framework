RegisterNetEvent("trucking-job:logJobStart")
AddEventHandler("trucking-job:logJobStart", function(jobName)
	local source = source

	exports.log:Add({
		source = source,
		verb = "started",
		extra = ("trucking job: %s"):format(jobName),
	})
end)

RegisterNetEvent("trucking-job:doProgressPayment")
AddEventHandler("trucking-job:doProgressPayment", function(progressDistance, jobName)
	local source = source
	
    if not exports.jobs:GetCurrentJob(source, "truck driver") then return end

    if progressDistance < 1 then return end

	local pay = math.floor(Config.DistanceMultiplier * progressDistance)

	exports.log:Add({
		source = source,
		verb = "progressed",
		extra = ("trucking job: %s - earning $%s"):format(jobName, pay),
	})
	
	if type(pay) == "number" then
		local paycheck = exports.character:Get(source, "paycheck")
		paycheck = paycheck + pay

		exports.character:Set(source, "paycheck", paycheck)

		TriggerClientEvent("notify:sendAlert", source, "inform", ("$%s has gone to your paycheck. You have $%s to collect."):format(exports.misc:FormatNumber(pay), exports.misc:FormatNumber(paycheck)), 8000)
	end
end)