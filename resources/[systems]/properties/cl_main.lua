Main = {}

--[[ Functions ]]--
function Main:Init()
	for k, property in ipairs(Properties) do
		exports.entities:Register({
			id = "property-"..tostring(k),
			name = "Property "..tostring(property.id),
			coords = property.coords,
			radius = 1.0,
			navigation = {
				id = "property",
				text = "Property",
				icon = "house",
				sub = {
					{
						id = "enterProperty",
						text = "Enter",
						icon = "door_front",
					},
					{
						id = "knockProperty",
						text = "Knock",
						icon = "notifications",
					},
					{
						id = "lockProperty",
						text = "Toggle Lock",
						icon = "lock",
					},
					{
						id = "examineProperty",
						text = "Examine",
						icon = "search",
					},
				},
			},
		})
	end
end

--[[ Events ]]--
AddEventHandler("properties:clientStart", function()
	Main:Init()
end)