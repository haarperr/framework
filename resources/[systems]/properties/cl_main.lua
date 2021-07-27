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

		if property.garage then
			exports.entities:Register({
				id = "garage-"..tostring(k),
				name = "Property "..tostring(property.id).." Garage",
				coords = property.garage,
				radius = 3.0,
				navigation = {
					id = "garage",
					text = "Garage",
					icon = "garage",
				},
			})
		end
	end
end

--[[ Events ]]--
AddEventHandler("properties:clientStart", function()
	Main:Init()
end)