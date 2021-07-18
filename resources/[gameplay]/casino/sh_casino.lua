Casino = {
	games = {}
}

function Casino:Init()
	for _, game in ipairs(self.games) do
		if game.Init then
			game:Init()
		end
	end
end

function Casino:Update()
	local props
	for _, game in ipairs(self.games) do
		if game.Update and (not game.nextUpdate or GetGameTimer() > game.nextUpdate) then
			if not props then
				props = exports.oldutils:GetObjects()
			end
			local delay = game:Update(props)
			if delay then
				game.nextUpdate = GetGameTimer() + delay
			end
		end
	end
end

function Casino:Register(game)
	table.insert(self.games, game)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Casino:Update()
		Citizen.Wait(0)
	end
end)