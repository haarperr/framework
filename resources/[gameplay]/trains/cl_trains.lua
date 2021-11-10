local models = {
	"freight",
	"freightcar",
	"freightcar2",
	"freightgrain",
	"freightcont1",
	"freightcont2",
	"freighttrailer",
	"tankercar",
	"metrotrain",
	"freightgrain",
}

Citizen.CreateThread(function()
	for k, model in ipairs(models) do
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end
	end

	-- local vehicle = CreateMissionTrain(25, 523.067, -1177.32, 28.35, true)
	-- print(vehicle)

	-- while true do
	-- 	Citizen.Wait(1000)
	-- end
end)