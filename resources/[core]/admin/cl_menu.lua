Menu = {}

function Menu:Toggle(value)
	if value == nil then
		value = not Navigation.isOpen
	end
	
	if value and not exports.user:IsMod() then return end

	if value then
		Navigation:Open("Admin", Config.Options)
	else
		Navigation:Close()
	end

	self.isOpen = value
end

--[[ Commands ]]--
RegisterKeyMapping("+nsrp_admin", "Admin - Menu", "KEYBOARD", "HOME")
RegisterCommand("+nsrp_admin", function(source, args, command)
	Menu:Toggle()
end, true)

--[[ NUI Callbacks ]]--
RegisterNUICallback("init", function(data)
	Menu:Init()
end)