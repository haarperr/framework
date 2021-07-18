Debug = {}

--[[ Functions: Debug ]]--
function Debug:Enable(value)
	if value then
		local window = CodeEditor:Create({
			prepend = {
				type = "q-icon",
				name = "minimize",
				click = {
					event = "close",
				},
			},
			style = {
				["width"] = "50vmin",
				["height"] = "60vmin",
				["right"] = "2vmin",
				["top"] = "5vmin",
				["z-index"] = 100,
			},
		}, function(window, code)
			local result, data = pcall(load("return { "..code.." }"))
			if not result then
				error(data)
			end
		
			Debug:SetObject(data)
		end)

		window:OnClick("close", function(self)
			UI:Focus(false)
		end)

		self.window = window
	else
		self.window:Destroy()
	end

	self.enabled = value
end

function Debug:Update()
	-- Draw objects.
	for gridId, grid in pairs(Main.cached) do
		for id, object in pairs(grid) do
			object:DrawDebug()
		end
	end

	-- Input.
	if IsDisabledControlJustPressed(0, 212) then
		UI:Focus(true)
	end
end

function Debug:SetObject(data)
	if self.object then
		self.object:Destroy()
	end

	self.object = Object:Create(data)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Debug.enabled then
			Debug:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("entities:debug", function(source, args, command)
	Debug:Enable(not Debug.enabled)

	TriggerEvent("chat:notify", {
		class = "inform",
		text = ("%s debugging entities!"):format(Debug.enabled and "Started" or "Stopped")
	})
end, {
	powerLevel = 50,
})

-- TEST.
-- Citizen.CreateThread(function()
-- 	Main:Register({
-- 		id = "atest-root",
-- 		name = "Custom Robbery",
-- 		coords = vector3(102.4376449584961, -1359.858642578125, 29.34237098693847),
-- 		rotation = vector3(0.0, 0.0, 55.06447982788086),
-- 		children = {
-- 			{
-- 				id = "test-1",
-- 				name = "Keypad",
-- 				coords = vector3(86.16974639892578, -1355.211669921875, 29.2707405090332),
-- 				rotation = vector3(0,0,0),
-- 				model = `prop_ld_keypad_01`,
-- 				interactable = {
-- 					id = "parent-id",
-- 					text = "Parent 1",
-- 					embedded = {
-- 						{
-- 							id = "child-1",
-- 							text = "Child 1",
-- 							items = {
-- 								{ name = "Bills", amount = 100 },
-- 							},
-- 							factions = { "some faction" }
-- 						},
-- 						{
-- 							id = "child-2",
-- 							text = "Child 2",
-- 							items = {
-- 								{ name = "Crowbar", amount = 1, hidden = true },
-- 							}
-- 						},
-- 					},
-- 					coords = coords,
-- 					radius = radius,
-- 					entity = self,
-- 				},
-- 				navigation = {
	
-- 				},
-- 				items = {
	
-- 				},
-- 				callback = function()
	
-- 				end,
-- 			},
-- 			{
-- 				id = "abc",
-- 				coords = vector3(86.16974639892578, -1355.211669921875, 30.2707405090332),
-- 				children = {
-- 					{
-- 						id = "llllll",
-- 						coords = vector3(86.16974639892578, -1356.211669921875, 30.2707405090332),
-- 					}
-- 				}
-- 			},
-- 			{
-- 				id = "zdioqpwe",
-- 				coords = vector3(86.16974639892578, -1355.211669921875, 31.2707405090332),
-- 			},
-- 			{
-- 				id = "dqwepow",
-- 				coords = vector3(86.16974639892578, -1355.211669921875, 32.2707405090332),
-- 			},
-- 		},
-- 	})
-- end)