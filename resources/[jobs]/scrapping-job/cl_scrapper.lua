Markers = {}

--[[ Events ]]--
AddEventHandler("onClientResourceStart", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return end

	-- Initialization.
	for k, scrapper in ipairs(Config.Scrapper.Scrappers) do
		local coords = scrapper.Coords
		local id = "Scrapper"..tostring(k)
		local marker = exports.markers:CreateUsable(GetCurrentResourceName(), vector3(coords.x, coords.y, coords.z), id, Config.Scrapper.Markers.Text, Config.Scrapper.Markers.DrawRadius, Config.Scrapper.Markers.Radius)
		
		AddEventHandler("markers:use_"..id, function()
			if not Carrying then return end
			Config.Scrapper.Action.Snap = coords
			local carrying = Carrying
			
			exports.emotes:Stop(true)
			exports.mythic_progbar:Progress(Config.Scrapper.Action, function(wasCancelled)
				if wasCancelled then return end
				TriggerServerEvent("scrapping:scrap", carrying.index)
				return 
			end)
		end)
	
		table.insert(Markers, marker)
	end
end)