Menu = {}

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