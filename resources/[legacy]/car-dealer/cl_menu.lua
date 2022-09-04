Menu = {}

function Menu:Create()
	local menuPool = NativeUI.CreatePool()
	self.menuPool = menuPool
	
	-- Create the menu.
	local menu = NativeUI.CreateMenu("Car Dealer", "", 0, 0)
	self.menu = menu

	menu.Settings.ControlDisablingEnabled = false
	menu.Settings.MouseControlsEnabled = false
	menu.OnMenuClosed = function(_menu)
		self.isOpen = false
	end
	
	menu:SetMenuWidthOffset(Config.Menu.WidthOffset)

	-- Add to the pool.
	menuPool:Add(menu)
	menuPool:RefreshIndex()
end

function Menu:Build()
	local menu = self.menu
	local menuPool = self.menuPool
	
	-- Clear the list.
	menu:Clear()

	-- Create the sub menus.
	self.subMenus = {}
	self.categories = {}

	-- Get the user's rank.
	local factionRank = 0
	if Dealer.Faction then
		--factionRank = exports.jobs:GetPower(0, Dealer.Faction)
		factionRank = 0
	end

	-- Build the list.
	for vehicleModel, vehicleData in pairs(Dealer.Vehicles) do
		local vehicle = vehicleModel
		if type(vehicleModel) == "number" then vehicle = vehicleData end
		if vehicleData.rank and factionRank < vehicleData.rank then goto endOfLoop end

		local vehicleSettings = exports.vehicles:GetSettings(vehicle)
		if vehicleSettings and vehicleSettings.Category then
			local subMenu = self.subMenus[vehicleSettings.Category]
			if not subMenu then
				subMenu = menuPool:AddSubMenu(menu, vehicleSettings.Category, "", true, true)
				subMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
				subMenu.SubMenu.Settings = menu.Settings
				subMenu.Item.Activated = function(_menu, _item)
					subMenu.SubMenu:Clear()
					for vehicle, vehicleSettings in pairs(self.categories[vehicleSettings.Category]) do
						local value = math.floor(vehicleSettings.Value + ( vehicleSettings.Value * Config.Tax ))
						local canAfford = exports.inventory:CanAfford(value, true, true)
						local prefix = "~r~"
						if canAfford then
							prefix = "~g~"
						end
						local item = menuPool:AddSubMenu(subMenu.SubMenu, vehicleSettings.Name, "", true, true)
						local price = "$"..exports.misc:FormatNumber(value)
						item.Item:Enabled(canAfford)
						item.Item:RightLabel(prefix..price)
						item.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
						item.SubMenu.Settings = menu.Settings
			
						item.Item.OnSelected = function(_item, _index)
							ViewVehicle(vehicle)
						end
			
						item.Item.Activated = function(_menu, _item)
							local desc = ("~r~Are you sure you would like to purchase this vehicle for %s?"):format(price)
						
							local yes = NativeUI.CreateItem("Confirm", desc)
							item.SubMenu:AddItem(yes)
							yes.Activated = function(_menu, _item, _index)
								PurchaseVehicle(vehicle)
								item.SubMenu:Clear()
								item.SubMenu:Visible(false)
								self.isOpen = false
							end
						
							local no = NativeUI.CreateItem("Go Back", desc)
							item.SubMenu:AddItem(no)
							no.Activated = function(_menu, _item, _index)
								item.SubMenu:Clear()
								item.SubMenu:GoBack()
							end
						end
					end
				end

				self.categories[vehicleSettings.Category] = {}
				self.subMenus[vehicleSettings.Category] = subMenu
			end

			self.categories[vehicleSettings.Category][vehicle] = vehicleSettings
		end
		::endOfLoop::
	end

	menu:RefreshIndex()
	menuPool:RefreshIndex()
end

function Menu:Open()
	-- Create the menu.
	if not self.menuPool then
		self:Create()
	end

	Menu:Build()

	-- Open the menu.
	if self.isOpen then return end
	self.menu:Visible(true)

	Citizen.CreateThread(function()
		self.isOpen = true
		while self.isOpen do
			Citizen.Wait(0)

			local ped = PlayerPedId()

			local state = LocalPlayer.state or {}
			local isDead = state.immobile

			if not Dealer or isDead then
				self.isOpen = false
				break
			end

			local kiosk = Dealer.Kiosk

			-- Check the distance.
			if #(GetEntityCoords(ped) - vector3(kiosk.x, kiosk.y, kiosk.z)) > Config.MaxRadius then
				self.isOpen = false
				break
			end

			-- Render the menu.
			self.menuPool:ProcessMenus()
		end

		self.menuPool:CloseAllMenus()
		self.menuPool = nil
		self.menu = nil
		self.subMenus = nil

		ViewVehicle()
		Dealer = nil
	end)
end

function Menu:Close()
	self.menu:GoBack()
end