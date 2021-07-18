local LastExecuted = ""

function Functions:ProcessAssertion()
	if IsDisabledControlPressed(0, 19) and IsDisabledControlJustPressed(0, 81) then
		local text = exports.oldutils:KeyboardInput("Lua", LastExecuted, 512)
		if not text then return end

		LastExecuted = text
		local success, error = pcall(load(text))
		print(success, error)
	end
end