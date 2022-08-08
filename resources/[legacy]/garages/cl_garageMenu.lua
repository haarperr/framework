Menu = {}

function Menu:Build()
	-- Clear old options.
	self.menu:Clear()
	
	-- Build the store option if possible.
	local nearest = GetNearest()

	if nearest and CanFitInGarage(CurrentGarage, Vehicles[nearest].id) then
		local item = NativeUI.CreateItem("Park vehicle", "")
		item.Activated = function(_menu, _item)
			StoreNearest()
			self:Close()
		end
		self.menu:AddItem(item)
		return
	end

	-- Build the vehicle options.
	local vehicles = exports.character:GetCharacter().vehicles or {}
	table.sort(vehicles)

	for id, vehicle in pairs(vehicles) do
		if not vehicle.garage_id or Garages[CurrentGarage].id ~= vehicle.garage_id then
			goto continue
		end

		local garage = Garages[CurrentGarage]
		local isProperty = garage.property_id == nil

		if not IsModelValid(vehicle.model) then
			print("Invalid model", vehicle.model, id)
			goto continue
		end

		local isOut = IsVehicleOut(id)
		local name = exports.vehicles:GetName(vehicle.model) or "INVALID MODEL"
		local value = GetStorageValue(vehicle.model)

		if isOut then
			name = name.." ~r~(Missing)"
		end

		local item = NativeUI.CreateItem(name, "")
		item.Activated = function(_menu, _item)
			Retrieve(id)
			self:Close()
		end

		item:Enabled(not isOut and (not isProperty or exports.inventory:CanAfford(value, 0, true)))

		if isProperty then
			item:RightLabel("$"..exports.misc:FormatNumber(value))
		end

		self.menu:AddItem(item)
		
		::continue::
	end
end

function Menu:Create()
	local menuPool = NativeUI.CreatePool()
	self.menuPool = menuPool
	
	-- Create the menu.
	local menu = NativeUI.CreateMenu("Garage", "", 0, 0)
	self.menu = menu

	menu.Settings.ControlDisablingEnabled = false
	menu.Settings.MouseControlsEnabled = false
	
	menu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	
	-- Add to the pool.
	menuPool:Add(menu)
	menuPool:RefreshIndex()
end

function Menu:Open()
	-- Create the menu.
	if not self.menuPool then
		self:Create()
	end

	self:Build()

	-- Open the menu.
	if self.isOpen then return end
	self.menu:Visible(true)

	Citizen.CreateThread(function()
		self.isOpen = true
		while self.menu:Visible() do
			Citizen.Wait(0)

			-- Render the menu.
			self.menuPool:ProcessMenus()

			-- Check distance.
			if CurrentGarage then
				local inCoords = Garages[CurrentGarage].inCoords
				if #(GetEntityCoords(PlayerPedId()) - vector3(inCoords.x, inCoords.y, inCoords.z)) > Config.Radius then
					self:Close()
				end
			else
				self:Close()
			end
		end

		-- Close the menu.
		self.isOpen = false
	end)
end

function Menu:Close()
	self.menu:GoBack()
end