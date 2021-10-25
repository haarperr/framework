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

function Main:EnterShell(id)
	local shell = Config.Shells[id]
	if not shell then
		error(("shell does not exist (%s)"):format(id))
	end

	if not IsModelValid(shell.Model) then
		error(("invalid model for shell (%s)"):format(id))
	end

	while not HasModelLoaded(shell.Model) do
		RequestModel(shell.Model)
		Citizen.Wait(20)
	end

	local coords = vector4(0.0, 0.0, 200.0, 0.0)
	local entity = CreateObject(shell.Model, coords.x, coords.y, coords.z, false, true)

	FreezeEntityPosition(entity, true)
	SetEntityCanBeDamaged(entity, false)
	SetEntityInvincible(entity, true)
	SetEntityDynamic(entity, false)
	SetEntityHasGravity(entity, false)
	SetEntityLights(entity, false)
	
	local ped = PlayerPedId()
	local entry = coords + shell.Entry

	SetEntityVelocity(ped, 0.0, 0.0, 0.0)
	SetEntityCoordsNoOffset(ped, entry.x, entry.y, entry.z, true)
	SetEntityHeading(ped, entry.w)
	ClearPedTasksImmediately(ped)

	self.coords = coords
	self.shell = shell
	self.entity = entity
end

function Main:Exit()
	if self.entity and DoesEntityExist(self.entity) then
		DeleteEntity(self.entity)
	end

	self.coords = nil
	self.shell = nil
	self.entity = nil
end

function Main:Update()
	local shell = self.shell
	if not shell then return end

	local coords = self.coords and vector3(self.coords.x, self.coords.y, self.coords.z) or vector3(0.0, 0.0, 0.0)
	
	-- Update world.
	SetRainLevel(0.0)

	-- Draw lights.
	if shell.Lights then
		for k, light in ipairs(shell.Lights) do
			local color = light.Color or { r = 255, g = 255, b = 255 }
			local _coords = light.Coords + coords

			if light.Direction or light.LookAt then
				local intensity = light.Intensity or 1.0
				local dir
				if light.LookAt then
					dir = (light.LookAt - coords) - _coords
					dir = dir / #dir
				else
					dir = light.Direction
				end

				for i = 1, (light.Double and 2 or 1) do
					if i == 2 then
						dir = dir * -1
						intensity = intensity * light.Double
					end

					DrawSpotLightWithShadow(
						_coords.x, _coords.y, _coords.z,
						dir.x, dir.y, dir.z,
						color.r, color.g, color.b,
						light.Range or 100.0,
						intensity,
						light.Roundness or 0.0,
						light.Radius or 100.0,
						light.Falloff or 1.0
					)
				end
			else
				DrawLightWithRange(
					_coords.x, _coords.y, _coords.z,
					color.r, color.g, color.b,
					light.Range or 100.0,
					light.Intensity or 1.0,
					0.0
				)
			end
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
AddEventHandler("properties:clientStart", function()
	-- Main:Init()
	-- Main:EnterShell("test")
end)

RegisterCommand("test", function(source, args, cmd)
	Config.Shells.test.Model = GetHashKey(args[1])
	Main:Exit()
	Main:EnterShell("test")
end)

AddEventHandler("interact:onNavigate_enterProperty", function(interactable)
	
end)