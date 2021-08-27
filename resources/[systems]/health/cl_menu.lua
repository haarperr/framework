Menu = {}

--[[ Functions: Menu ]]--
function Menu:Init()
	self.loaded = true
	self:Invoke(false, "loadConfig", {
		effects = Config.Effects,
	})
end

function Menu:Invoke(target, method, ...)
	SendNUIMessage({
		invoke = {
			target = target,
			method = method,
			args = {...},
		}
	})
end

function Menu:Focus()
	if GetGameTimer() - (self.lastFocus or 0) < 20 then
		return
	end

	self.lastFocus = GetGameTimer()
	self:Invoke("main", "focus", 1000, 8000)
end

--[[ Commands ]]--
exports.chat:RegisterCommand("status", function()
	Menu:Focus()
end, {
	description = "Show your health buddy for a few seconds!",
})