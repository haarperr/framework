Citizen.CreateThread(function()
	while true do
		if true then --exports.jobs:IsOnDuty(Job:lower()) then
			Citizen.Wait(100)
			
		else
			Citizen.Wait(5000)
		end
	end
end)

AddEventHandler("winery-job:clientStart", function()
	exports.instances:AddInstance(GetCurrentResourceName(), Config.Instance.outCoords, Config.Instance.id)
end)