Menu = {}
DebugMode = false

local function SetRightLabel(item, owned, id)
	local label
	if DebugMode then
		label = id
	elseif owned then
		label = "~b~Owned"
	else
		label = "~g~$0"
	end
	item:RightLabel(label)
end

function Menu:CreateCustomization()
	local menu = self.menu

	-- Begin previewing.
	BeginPreview()

	menu.lastPaints = {}
	menu.lastMods = {}
	menu.lastTint = nil
	menu.lastLight = nil
	menu.lastNeon = nil

	-- Create colors.
	local colorsItems = self.menuPool:AddSubMenu(menu, "Colors", "", true, true)
	colorsItems.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	colorsItems.SubMenu.Settings = menu.Settings

	local colors = {GetVehicleColours(Vehicle)}
	local pearlescentColor, wheelColor = GetVehicleExtraColours(Vehicle)
	local interiorColor, dashboardColor = GetVehicleInteriorColour(Vehicle), GetVehicleDashboardColour(Vehicle)
	colors[3] = pearlescentColor
	colors[4] = wheelColor
	colors[5] = interiorColor
	colors[6] = dashboardColor

	local paintCategories = {
		{ Name = "Primary", Apply = function(preview, color, isMetallic)
			local primaryColor, secondaryColor = GetVehicleColours(Vehicle)
			SetVehicleColours(Vehicle, color, secondaryColor)
			if not preview then
				VehicleInfo.colors[1] = color
			end
			if isMetallic then
				local pearlescentColor, wheelColor = GetVehicleExtraColours(Vehicle)
				SetVehicleExtraColours(Vehicle, color, wheelColor)
				if not preview then
					VehicleInfo.colors[5] = color
				end
			end
		end },
		{ Name = "Secondary", Apply = function(preview, color, isMetallic)
			local primaryColor, secondaryColor = GetVehicleColours(Vehicle)
			SetVehicleColours(Vehicle, primaryColor, color)
			if not preview then
				VehicleInfo.colors[2] = color
			end
			if isMetallic then
				local pearlescentColor, wheelColor = GetVehicleExtraColours(Vehicle)
				SetVehicleExtraColours(Vehicle, color, wheelColor)
				if not preview then
					VehicleInfo.colors[5] = color
				end
			end
		end },
		{ Name = "Pearlescent", Apply = function(preview, color)
			local pearlescentColor, wheelColor = GetVehicleExtraColours(Vehicle)
			SetVehicleExtraColours(Vehicle, color, wheelColor)
			if not preview then
				VehicleInfo.colors[5] = color
			end
		end },
		{ Name = "Wheels", Apply = function(preview, color)
			local pearlescentColor, wheelColor = GetVehicleExtraColours(Vehicle)
			SetVehicleExtraColours(Vehicle, pearlescentColor, color)
			if not preview then
				VehicleInfo.colors[6] = color
			end
		end },
		{ Name = "Interior", Apply = function(preview, color)
			SetVehicleInteriorColour(Vehicle, color)
			if not preview then
				VehicleInfo.colors[10] = color
			end
		end },
		{ Name = "Dashboard", Apply = function(preview, color)
			SetVehicleDashboardColour(Vehicle, color)
			if not preview then
				VehicleInfo.colors[11] = color
			end
		end },
	}

	for k, paintCategory in ipairs(paintCategories) do
		local isPearl = k == 3
		local isWheel = k == 4
		local isInterior = k == 5
		local isDashboard = k == 6
		local paintCategoryMenu = self.menuPool:AddSubMenu(colorsItems.SubMenu, paintCategory.Name, "", true, true)
		paintCategoryMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
		paintCategoryMenu.SubMenu.Settings = menu.Settings

		for _, paintInfo in pairs(Config.Paints) do
			local isMetallic = paintInfo.Name == "Metallic"
			local paintTypeMenu

			if k > 2 then
				paintTypeMenu = paintCategoryMenu
			else
				paintTypeMenu = self.menuPool:AddSubMenu(paintCategoryMenu.SubMenu, paintInfo.Name, paintInfo.Desc or "", true, true)
				paintTypeMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
				paintTypeMenu.SubMenu.Settings = menu.Settings
			end

			paintTypeMenu.SubMenu.OnMenuClosed = function(_menu)
				RestorePreview()
			end

			local paints = paintInfo.Colors
			if not paints and paintInfo.Use then
				paints = Config.Paints[paintInfo.Use].Colors
			end
			for __, paint in pairs(paints) do
				if isPearl and _ ~= 1 then
					goto skip
				end
				local paintItem = NativeUI.CreateItem(paint[1], "")
				local isOwned = (
					paint[2] == colors[k]
				) and (
					(isMetallic and pearlescentColor == paint[2]) or
					(not isMetallic and pearlescentColor ~= paint[2])
				)
				SetRightLabel(paintItem, isOwned, paint[2])
				if isOwned then
					menu.lastPaints[k] = paintItem
				end

				paintItem.Activated = function(_menu, _item)
					if menu.lastPaints[k] == _item then return end
					paintCategory.Apply(false, paint[2], isMetallic)
					
					SetRightLabel(paintItem, true)
					if menu.lastPaints[k] then
						SetRightLabel(menu.lastPaints[k], false)
					end
					menu.lastPaints[k] = paintItem
				end
				paintItem.OnSelected = function(_menu, _item)
					paintCategory.Apply(true, paint[2], isMetallic)
				end

				paintTypeMenu.SubMenu:AddItem(paintItem)
				::skip::
			end
		end
	end

	-- Create mods.
	local validMods = 0
	local modsItem = self.menuPool:AddSubMenu(menu, "Mods", "", true, true)
	modsItem.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	modsItem.SubMenu.Settings = menu.Settings
	
	for modType = 0, 49 do
		local numMods = GetNumVehicleMods(Vehicle, modType)
		local modConfig = Config.Mods[modType]

		if modConfig and numMods > 0 and (not modConfig.Condition or modConfig.Condition(Vehicle)) and (not modConfig.DebugOnly or DebugMode) then
			validMods = validMods + 1

			local modTypeMenu = self.menuPool:AddSubMenu(modsItem.SubMenu, modConfig.Name, "", true, true)
			modTypeMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
			modTypeMenu.SubMenu.Settings = menu.Settings

			modTypeMenu.SubMenu.OnMenuClosed = function(_menu)
				RestorePreview()
			end

			modTypeMenu.Item.Activated = function(_menu, _item)
				modTypeMenu.SubMenu:Clear()
				
				local mod = GetVehicleMod(Vehicle, modType)
				
				for modIndex = -1, numMods - 1 do
					local modName
					if modIndex == -1 then
						modName = "Stock"
					elseif modConfig.Value then
						modName = modConfig.Value(modIndex)
					else
						local label = GetModTextLabel(Vehicle, modType, modIndex)
						if label ~= "" then
							local modLabel = GetLabelText(label)
							if modLabel ~= "NULL" then
								modName = modLabel
							else
								modName = label
							end
						else
							modName = tostring(modConfig.Name).." "..tostring(modIndex + 1)
						end
					end
					local modItem = NativeUI.CreateItem(modName, "")
					local modEnabled = modIndex == mod
					SetRightLabel(modItem, modEnabled, modIndex)
					if modEnabled then
						menu.lastMods[modType] = modItem
					end

					modItem.Activated = function(_menu, _item)
						if menu.lastMods[modType] == modItem then return end

						local lastMod = GetVehicleMod(Vehicle, modType)
						local lastItem = _menu:GetItemAt(lastMod + 2)
						SetVehicleMod(Vehicle, modType, modIndex, false)
						SetRightLabel(modItem, true)
						VehicleInfo.mods[modType + 1] = modIndex
						if menu.lastMods[modType] then
							SetRightLabel(menu.lastMods[modType], false)
						end
						menu.lastMods[modType] = modItem
					end
					modItem.OnSelected = function(_menu, _item)
						SetVehicleMod(Vehicle, modType, modIndex, false)
					end

					modTypeMenu.SubMenu:AddItem(modItem)
				end
			end
		end
	end

	if validMods == 0 then
		modsItem.Item:Enabled(false)
	end
	
	-- Lights.
	local lightsMenu = self.menuPool:AddSubMenu(menu, "Lights", "", true, true)
	lightsMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	lightsMenu.SubMenu.Settings = menu.Settings

	lightsMenu.SubMenu.OnMenuClosed = function(_menu)
		SetVehicleLights(Vehicle, 0)
		RestorePreview()
	end
	
	lightsMenu.Item.Activated = function(_menu, _item)
		lightsMenu.SubMenu:Clear()

		SetVehicleLights(Vehicle, 2)

		-- Turn the lights on.
		local currentLight = GetVehicleXenonLightsColour(Vehicle)

		-- Create the xenon item.
		local xenonItem = NativeUI.CreateCheckboxItem("Xenon Lights", IsToggleModOn(Vehicle, 22), "")
		xenonItem.CheckboxEvent = function(_menu, _item, _value)
			ToggleVehicleMod(Vehicle, 22, _value)
			local value = 0
			if _value then
				value = 1
				SetVehicleXenonLightsColour(Vehicle, currentLight)
			end
			VehicleInfo.mods[22] = { GetVehicleMod(Vehicle, 22), 1 }
		end
	
		lightsMenu.SubMenu:AddItem(xenonItem)
		
		-- Create the xenon color options.
		local colorsItem = self.menuPool:AddSubMenu(lightsMenu.SubMenu, "Colors", "", true, true)
		colorsItem.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
		colorsItem.SubMenu.Settings = menu.Settings

		colorsItem.SubMenu.OnMenuClosed = function(_menu)
			RestorePreview()
		end

		for light, lightName in ipairs(Config.Lights) do
			local lightItem = NativeUI.CreateItem(lightName, "")
			local lightEnabled = light == currentLight
			SetRightLabel(lightItem, lightEnabled)
			if lightEnabled then
				menu.lastLight = lightItem
			end

			lightItem.Activated = function(_menu, _item)
				if menu.lastLight == lightItem then return end

				currentLight = light - 1
				SetVehicleXenonLightsColour(Vehicle, currentLight)
				SetRightLabel(lightItem, true)
				VehicleInfo.colors[9] = currentLight
				if menu.lastLight then
					SetRightLabel(menu.lastLight, false)
				end
				menu.lastLight = lightItem
			end
			lightItem.OnSelected = function(_menu, _item)
				SetVehicleXenonLightsColour(Vehicle, light - 1)
			end

			colorsItem.SubMenu:AddItem(lightItem)
		end

		-- Create the neon color options.
		local neonsItem = self.menuPool:AddSubMenu(lightsMenu.SubMenu, "Neon Colors", "", true, true)
		neonsItem.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
		neonsItem.SubMenu.Settings = menu.Settings

		neonsItem.SubMenu.OnMenuClosed = function(_menu)
			RestorePreview()
		end
		
		for _, neon in ipairs(Config.NeonColors) do
			local neonItem = NativeUI.CreateItem(neon[1], "")
			local lightEnabled = light == currentLight
			SetRightLabel(neonItem, lightEnabled)
			if lightEnabled then
				menu.lastNeon = neonItem
			end

			neonItem.Activated = function(_menu, _item)
				if menu.lastNeon == neonItem then return end

				SetVehicleNeonLightsColour(Vehicle, table.unpack(neon[2]))
				SetRightLabel(neonItem, true)
				VehicleInfo.colors[12] = neon[2]
				if menu.lastNeon then
					SetRightLabel(menu.lastNeon, false)
				end
				menu.lastNeon = neonItem
			end
			neonItem.OnSelected = function(_menu, _item)
				SetVehicleNeonLightsColour(Vehicle, table.unpack(neon[2]))
			end

			neonsItem.SubMenu:AddItem(neonItem)
		end

		-- Create the neon toggles.
		for i = 0, 3 do
			local neonItem = NativeUI.CreateCheckboxItem(Config.Neons[i + 1], IsVehicleNeonLightEnabled(Vehicle, i), "")
			neonItem.CheckboxEvent = function(_menu, _item, _value)
				SetVehicleNeonLightEnabled(Vehicle, i, _value)
				local value = 0
				if _value then
					value = 1
				end
				VehicleInfo.neons[i] = value
			end
		
			lightsMenu.SubMenu:AddItem(neonItem)
		end
	end

	-- Window tints.
	local validTints = GetNumVehicleWindowTints(Vehicle)
	local tintsMenu = self.menuPool:AddSubMenu(menu, "Windows", "", true, true)
	tintsMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	tintsMenu.SubMenu.Settings = menu.Settings

	tintsMenu.SubMenu.OnMenuClosed = function(_menu)
		RestorePreview()
	end
	
	tintsMenu.Item.Activated = function(_menu, _item)
		tintsMenu.SubMenu:Clear()

		local windowTint = math.max(GetVehicleWindowTint(Vehicle), 0)
		VehicleInfo.colors[7] = windowTint

		for tint = 0, validTints do
			local tintName = Config.Tints[tint + 1]
			if not tintName then
				tintName = "Tint "..tostring(tint + 1)
			end
			local tintItem = NativeUI.CreateItem(tintName, "")
			local tintEnabled = windowTint == tint
			SetRightLabel(tintItem, tintEnabled)
			if tintEnabled then
				menu.lastTint = tintItem
			end

			tintItem.Activated = function(_menu, _item)
				if menu.lastTint == tintItem then return end

				SetVehicleWindowTint(Vehicle, tint)
				SetRightLabel(tintItem, true)
				VehicleInfo.colors[7] = tint
				if menu.lastTint then
					SetRightLabel(menu.lastTint, false)
				end
				menu.lastTint = tintItem
			end
			tintItem.OnSelected = function(_menu, _item)
				SetVehicleWindowTint(Vehicle, tint)
			end

			tintsMenu.SubMenu:AddItem(tintItem)
		end
	end

	if validTints == 0 then
		tintsMenu.Item:Enabled(false)
	end
	
	-- Create extras.
	local validExtras = 0
	local extrasItem = self.menuPool:AddSubMenu(menu, "Extras", "", true, true)
	extrasItem.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	extrasItem.SubMenu.Settings = menu.Settings
	
	for extra = 0, 13 do
		if DoesExtraExist(Vehicle, extra) then
			local extraItem = NativeUI.CreateCheckboxItem("Extra "..tostring(extra + 1), IsVehicleExtraTurnedOn(Vehicle, extra), "")
			extraItem.CheckboxEvent = function(_menu, _item, _value)
				SetVehicleExtra(Vehicle, extra, not _value)
				local value = 0
				if _value then
					value = 1
				end
				VehicleInfo.extras[extra + 1] = value
			end

			extrasItem.SubMenu:AddItem(extraItem)

			validExtras = validExtras + 1
		end
	end

	if validExtras == 0 then
		extrasItem.Item:Enabled(false)
	end

	-- Create liveries.
	for _, funcs in ipairs({
		{
			title = "Livery",
			counter = GetVehicleLiveryCount,
			getter = GetVehicleLivery,
			setter = SetVehicleLivery,
			color = 13,
		},
		{
			title = "Roof Livery",
			counter = GetVehicleRoofLiveryCount,
			getter = GetVehicleRoofLivery,
			setter = SetVehicleRoofLivery,
			color = 14,
		},
	}) do
		local liveryCount = funcs.counter(Vehicle)
		if liveryCount > 0 then
			local currentLivery = funcs.getter(Vehicle)
			local liverysItem = self.menuPool:AddSubMenu(menu, "Liverys", "", true, true)
			liverysItem.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
			liverysItem.SubMenu.Settings = menu.Settings
			
			for livery = 0, liveryCount - 1 do
				local liveryItem = NativeUI.CreateItem("Livery "..tostring(livery + 1), "")
				local liveryEnabled = currentLivery == livery
				SetRightLabel(liveryItem, liveryEnabled)
				if liveryEnabled then
					menu.lastTint = liveryItem
				end

				liveryItem.Activated = function(_menu, _item)
					if menu.lastTint == liveryItem then return end

					funcs.setter(Vehicle, livery)
					SetRightLabel(liveryItem, true)
					VehicleInfo.colors[funcs.color] = livery
					if menu.lastTint then
						SetRightLabel(menu.lastTint, false)
					end
					menu.lastTint = liveryItem
				end
				liveryItem.OnSelected = function(_menu, _item)
					funcs.setter(Vehicle, livery)
				end
				liverysItem.SubMenu:AddItem(liveryItem)
			end
		end
	end
end

function Menu:Create()
	local menuPool = NativeUI.CreatePool()
	self.menuPool = menuPool
	
	-- Create the menu.
	local menu = NativeUI.CreateMenu("Customs", "", 0, 0)
	self.menu = menu

	menu.Settings.ControlDisablingEnabled = false
	menu.Settings.MouseControlsEnabled = false

	menu.OnMenuClosed = function(_menu)
		self.isOpen = false
		if self.fixed then
			RestorePreview()
		end
	end
	
	menu:SetMenuWidthOffset(Config.Menu.WidthOffset)

	-- Create repair option.
	local health = GetVehicleBodyHealth(Vehicle)
	if health < Config.Repair.Threshold then
		local repairItem = NativeUI.CreateItem("Repair", "")
		menu:AddItem(repairItem)

		local price = math.max(math.ceil(math.max(1.0 - health / Config.Repair.Threshold, 0.0) * Config.Repair.MaxPrice), 1)
		repairItem:RightLabel(("$%s"):format(price))

		repairItem.Activated = function()
			if exports.inventory:CanAfford(price, SharedConfig.Purchases.Flag, SharedConfig.Purchases.UseCard) then
				TriggerServerEvent("lscustoms:purchase", "repair", price)

				local engineHealth, bodyHealth, fuelHealth = GetVehicleEngineHealth(Vehicle), GetVehicleBodyHealth(Vehicle), GetVehiclePetrolTankHealth(Vehicle)
				SetVehicleFixed(Vehicle)
				SetVehicleEngineHealth(Vehicle, math.max(engineHealth, 800.0))
				SetVehicleBodyHealth(Vehicle, 1000.0)
				SetVehiclePetrolTankHealth(Vehicle, math.max(fuelHealth, 800.0))
				
				self.fixed = true
				self:CreateCustomization()
				menu:RemoveItemAt(1)
			end
		end
	else
		self.fixed = true
		self:CreateCustomization()
	end
	
	-- Add to the pool.
	menuPool:Add(menu)
	menuPool:RefreshIndex()
end

function Menu:Open(debugMode)
	DebugMode = debugMode
	
	-- Create the menu.
	self:Create()

	-- Open the menu.
	if self.isOpen then return end
	self.menu:Visible(true)

	Citizen.CreateThread(function()
		self.isOpen = true
		
		while self.isOpen do
			Citizen.Wait(0)

			-- Render the menu.
			self.menuPool:ProcessMenus()
		end

		-- Close the menu.
		self.isOpen = false
		
		ExitCustoms()

		VehicleInfo = nil

		self.menu = nil
		self.menuPool  = nil

		collectgarbage("collect")
	end)
end

function Menu:Close()
	if self.isOpen then
		self.menu:GoBack()
	end
end