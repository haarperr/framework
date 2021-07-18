local focusEnabled = false
local enabledControls = {
	249, -- Push to talk
	137, -- Radio
}
local movementControls = {
	-- On foot.
	30,
	31,
	32,
	33,
	34,
	35,
	-- Vehicles.
	59,
	60,
	61,
	62,
	63,
	64,
	71,
	72,
	76,
}

function DisableControls(movement)
	DisableAllControlActions(0)
	DisableAllControlActions(1)
	DisableAllControlActions(2)
	DisableAllControlActions(25)
	DisableAllControlActions(26)
	for k, v in ipairs(enabledControls) do
		EnableControlAction(0, v, true)
	end
	if movement then
		for k, v in ipairs(movementControls) do
			EnableControlAction(0, v, true)
		end
	end
end
exports("DisableControls", DisableControls)