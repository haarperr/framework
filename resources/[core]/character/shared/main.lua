Main = {}

Main.ids = {}
Main.event = GetCurrentResourceName()..":"

function Main:GetCharacterById(id)
	if type(id) ~= "number" then return end
	
	return self.ids[id]
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	for k, v in pairs(Main) do
		if type(v) == "function" then
			exports(k, function(...)
				return Main[k](Main, ...)
			end)
		end
	end
end)