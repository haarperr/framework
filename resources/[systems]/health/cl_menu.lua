Menu = {}

function Menu:Invoke(target, method, ...)
	SendNUIMessage({
		invoke = {
			target = target,
			method = method,
			args = {...},
		}
	})
end