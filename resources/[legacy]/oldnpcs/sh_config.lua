Config = {
	EnableDebug = false,
	GridSize = 4,
	InteractDistance = 2.0,
	GenericDialogue = {
		["NEVERMIND"] = {
			text = "Nevermind.",
			next = "INIT",
			dialogue = "Alright. Need anything else?",
		},
	},
}

function Debug(...)
	if not Config.EnableDebug then return end
	print(...)
end