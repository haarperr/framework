Menu = {}

local function SpawnVehicle(model)
	local currentVehicle = GetVehiclePedIsIn(Ped, false)
	if DoesEntityExist(currentVehicle) then
		exports.oldutils:Delete(currentVehicle)
	end

	local coords = GetEntityCoords(Ped)
	local vehicle = exports.oldutils:CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(Ped), true, true)
	SetEntityAsMissionEntity(vehicle)
	SetPedIntoVehicle(Ped, vehicle, -1)
	TriggerServerEvent("vehicles:requestKey", VehToNet(vehicle), "admin-tools")
end

function Menu:AddItemFromTable(menu, table)
	for k, v in pairs(table) do
		local text = v[1]
		local isCategory = type(v[2]) == "table"
		
		if isCategory then
			text = "~b~~h~"..text
		end

		local item = NativeUI.CreateItem(text, "")
		menu:AddItem(item)

		if isCategory then
			self:AddItemFromTable(menu, v[2])
		else
			item:RightLabel(v[2])
		end
	end
end

function Menu:CreateVehicles()
	local item
	
	local subMenu = self.menuPool:AddSubMenu(self.menu, "Vehicles", "", true, true)
	subMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	subMenu.SubMenu.Settings = self.menu.Settings

	subMenu.Item.Activated = function(_menu, _item)
		if _item.generated then return end
		_item.generated = true

		local categories = exports.vehicles:GetCategories()
		
		for category, vehicles in pairs(categories) do
			table.sort(vehicles, function(a, b) return exports.vehicles:GetName(a):lower() < exports.vehicles:GetName(b):lower() end)
			
			local label = GetLabelText("VEH_CLASS_"..category)
			local _subMenu = self.menuPool:AddSubMenu(subMenu.SubMenu, label, "", true, true) 
			_subMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
			_subMenu.SubMenu.Settings = self.menu.Settings
			_subMenu.Item.Activated = function(_menu, _item)
				if _item.generated then return end
				_item.generated = true
				
				for _, vehicle in pairs(vehicles) do
					item = NativeUI.CreateItem(exports.vehicles:GetName(vehicle), "")
					item:RightLabel(vehicle)
					_subMenu.SubMenu:AddItem(item)
					item.Activated = function(_menu, _item)
						local vehicle = SpawnVehicle(vehicle)
						DecorSetBool(vehicle, "hotwired", true)
					end
				end
			end
		end
	end

	-- Spawn by name.
	item = NativeUI.CreateItem("~b~Spawn by name", "")
	subMenu.SubMenu:AddItem(item)
	item.Activated = function(_menu, _item)
		local model = GetHashKey(exports.oldutils:KeyboardInput("Model", "", 32))

		if IsModelValid(model) then
			SpawnVehicle(model)
		else
			TriggerEvent("chat:addMessage", "Invalid model!")
		end
	end

	-- Create the options.
	local options = NativeUI.CreateItem("Vehicle Options", "")
	options.Activated = function(_menu, _item)
		self:Close()
		exports.lscustoms:Open(true)
	end
	self.menu:AddItem(options)

	self.menu:RefreshIndex()
end

function Menu:CreatePlayers()
	-- Online players.
	local listMenu = self.menuPool:AddSubMenu(self.menu, "Online Players", "", true, true)
	listMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	listMenu.SubMenu.Settings = self.menu.Settings

	listMenu.Item.Activated = function(_menu, _item)
		local retval = RequestPlayers()
		listMenu.SubMenu:Clear()
		
		if not retval or #Players <= 0 then
			local item = NativeUI.CreateItem("Timed Out", "")
			listMenu.SubMenu:AddItem(item)

			return
		end

		for k, player in pairs(Players) do
			local playerMenu = self.menuPool:AddSubMenu(listMenu.SubMenu, ("~b~[%s] ~s~%s"):format(player.id, player.info[2][2][2][2]), "", true, true)
			playerMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
			playerMenu.SubMenu.Settings = self.menu.Settings
			playerMenu.Item:RightLabel(player.info[1][2][2][2])
			
			playerMenu.Item.Activated = function(_menu, _item)
				playerMenu.SubMenu:Clear()
				self:AddItemFromTable(playerMenu.SubMenu, player.info)
			end
			playerMenu.Item.OnSelected = function(_menu, _item)
				if IsDisabledControlPressed(0, 21) then
					ExecuteCommand("a:spectate "..tostring(player.id))
					listMenu.SubMenu:Visible(true)
				end
			end
		end
	end

	self.menu:RefreshIndex()
end

function Menu:CreateLocations()
	local listMenu = self.menuPool:AddSubMenu(self.menu, "Locations", "", true, true)
	listMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	listMenu.SubMenu.Settings = self.menu.Settings

	listMenu.Item.Activated = function(_menu, _item)
		if listMenu.generated then return end
		listMenu.generated = true
		
		for k, location in pairs(Locations) do
			local item = NativeUI.CreateItem(location[1], "")
			item.Activated = function()
				local coords = location[2]
				if coords then
					SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
				end
			end

			listMenu.SubMenu:AddItem(item)
		end
	end

	self.menu:RefreshIndex()
end

function Menu:CreateOptions()
	local listMenu = self.menuPool:AddSubMenu(self.menu, "Options", "", true, true)
	listMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	listMenu.SubMenu.Settings = self.menu.Settings

	listMenu.Item.Activated = function(_menu, _item)
		if listMenu.generated then return end
		listMenu.generated = true

		local item
		
		item = NativeUI.CreateItem("~b~Set model", "")
		listMenu.SubMenu:AddItem(item)
		item.Activated = function(_menu, _item)
			local model = GetHashKey(exports.oldutils:KeyboardInput("Model", "", 32))

			if IsModelValid(model) then
				RequestModel(model) while not HasModelLoaded(model) do RequestModel(model) Citizen.Wait(1) end
				SetPlayerModel(PlayerId(), model)
				SetPedDefaultComponentVariation(PlayerPedId())
			else
				TriggerEvent("chat:addMessage", "Invalid model!")
			end
		end
		
		for k, option in pairs(Options) do
			if option[2] == "toggle" then
				item = NativeUI.CreateCheckboxItem(option[1], "")
				item.CheckboxEvent = function(_menu, _item, checked)
					option[3](checked)
				end
			else
				item = NativeUI.CreateItem(option[1], "")
				item.Activated = function()
					option[3]()
				end
			end

			listMenu.SubMenu:AddItem(item)
		end
	end

	self.menu:RefreshIndex()
end

function Menu:CreateSpawner()
	local listMenu = self.menuPool:AddSubMenu(self.menu, "Spawner", "", true, true)
	listMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
	listMenu.SubMenu.Settings = self.menu.Settings

	listMenu.Item.Activated = function(_menu, _item)
		if listMenu.generated then return end
		listMenu.generated = true
		listMenu.isNetwork = true
		listMenu.isMissionEntity = true
		listMenu.isHostile = false

		local _, groupHash = AddRelationshipGroup("ADMIN_TOOLS")
		SetRelationshipBetweenGroups(5, groupHash, GetPedRelationshipGroupHash(PlayerPedId()))

		function listMenu:Spawn()
			local retval, didHit, coords, surfaceNormal, materialHash, entity = table.unpack(exports.oldutils:Raycast())
			if not didHit then return end

			local model = self.pedModel or self.vehicleModel or self.objectModel
			if not model then return end

			while not HasModelLoaded(model) do
				RequestModel(model)
				Citizen.Wait(20)
			end

			local entity

			if self.pedModel then
				entity = CreatePed(4, model, coords.x, coords.y, coords.z, GetRandomFloatInRange(0.0, 360.0), self.isNetwork, true)

				if not self.isMissionEntity then
					SetPedAsNoLongerNeeded(entity)
				end

				if self.weapon then
					local weapon = GetHashKey(self.weapon)
					GiveWeaponToPed(entity, weapon, 60, true, true)
				end

				if self.isHostile then
					SetPedCombatMovement(entity, 4)
					SetPedCombatAbility(entity, 2)
					SetPedRelationshipGroupHash(entity, groupHash)
				end
			elseif self.vehicleModel then

			elseif self.objectModel then

			end
		end
		
		local item

		-- Spawn item.
		item = NativeUI.CreateItem("Spawn", "")
		listMenu.SubMenu:AddItem(item)
		item.Activated = function(_menu, _item)
			listMenu:Spawn()
		end
		
		-- Network checkox.
		item = NativeUI.CreateCheckboxItem("Network Entity", "")
		listMenu.SubMenu:AddItem(item)
		item.Checked = true
		item.CheckboxEvent = function(_menu, _item, checked)
			listMenu.isNetwork = checked
		end
		
		-- Network checkox.
		item = NativeUI.CreateCheckboxItem("Mission Entity", "")
		listMenu.SubMenu:AddItem(item)
		item.Checked = true
		item.CheckboxEvent = function(_menu, _item, checked)
			listMenu.isMissionEntity = checked
		end
		
		-- Is hostile.
		item = NativeUI.CreateCheckboxItem("Is Hostile", "")
		listMenu.SubMenu:AddItem(item)
		item.Checked = false
		item.CheckboxEvent = function(_menu, _item, checked)
			listMenu.isHostile = checked
		end

		-- Ped models.
		local pedMenu = self.menuPool:AddSubMenu(listMenu.SubMenu, "Set Ped", "", true, true)
		pedMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
		pedMenu.SubMenu.Settings = self.menu.Settings

		for k, model in ipairs({
			"a_c_cat_01",
			"a_c_chimp",
			"a_m_y_gay_02",
			"cs_michelle",
			"cs_orleans",
			"cs_prolsec_02",
			"csb_ramp_marine",
			"csb_rashcosvki",
			"g_m_m_chicold_01",
			"mp_m_fibsec_01",
			"s_f_y_sheriff_01",
			"s_m_m_armoured_01",
			"s_m_m_armoured_02",
			"s_m_y_chef_01",
			"s_m_y_clown_01",
			"s_m_y_mime",
			"s_m_y_swat_01",
			"u_m_o_taphillbilly",
			"ig_ramp_hic",
		}) do
			item = NativeUI.CreateItem(model, "")
			pedMenu.SubMenu:AddItem(item)
			item.Activated = function(_menu, _item)
				listMenu.pedModel = model
				pedMenu.Item:RightLabel(model)

				_menu:GoBack()
			end
		end

		-- Ped weapons.
		local weaponMenu = self.menuPool:AddSubMenu(listMenu.SubMenu, "Set Weapon", "", true, true)
		weaponMenu.SubMenu:SetMenuWidthOffset(Config.Menu.WidthOffset)
		weaponMenu.SubMenu.Settings = self.menu.Settings

		for k, weapon in ipairs({
			"WEAPON_UNARMED",
			"WEAPON_APPISTOL",
			"WEAPON_ASSAULTRIFLE_MK2",
			"WEAPON_ASSAULTRIFLE",
			"WEAPON_ASSAULTSHOTGUN",
			"WEAPON_ASSAULTSMG",
			"WEAPON_AUTOSHOTGUN",
			"WEAPON_BATTLEAXE",
			"WEAPON_BRIEFCASE_02",
			"WEAPON_BRIEFCASE",
			"WEAPON_BULLPUPRIFLE_MK2",
			"WEAPON_BULLPUPRIFLE",
			"WEAPON_BULLPUPSHOTGUN",
			"WEAPON_CARBINERIFLE_MK2",
			"WEAPON_CARBINERIFLE",
			"WEAPON_COMBATMG_MK2",
			"WEAPON_COMBATMG",
			"WEAPON_COMBATPDW",
			"WEAPON_COMBATPISTOL",
			"WEAPON_COMPACTLAUNCHER",
			"WEAPON_COMPACTRIFLE",
			"WEAPON_DAGGER",
			"WEAPON_DOUBLEACTION",
			"WEAPON_GRENADELAUNCHER",
			"WEAPON_GUSENBERG",
			"WEAPON_HATCHET",
			"WEAPON_HEAVYPISTOL",
			"WEAPON_HEAVYSHOTGUN",
			"WEAPON_HEAVYSNIPER_MK2",
			"WEAPON_HEAVYSNIPER",
			"WEAPON_KNIFE",
			"WEAPON_KNUCKLE",
			"WEAPON_MACHETE",
			"WEAPON_MACHINEPISTOL",
			"WEAPON_MARKSMANPISTOL",
			"WEAPON_MARKSMANRIFLE_MK2",
			"WEAPON_MARKSMANRIFLE",
			"WEAPON_MG",
			"WEAPON_MICROSMG",
			"WEAPON_MINIGUN",
			"WEAPON_MINISMG",
			"WEAPON_MOLOTOV",
			"WEAPON_MUSKET",
			"WEAPON_PISTOL_MK2",
			"WEAPON_PISTOL",
			"WEAPON_PISTOL50",
			"WEAPON_PUMPSHOTGUN_MK2",
			"WEAPON_PUMPSHOTGUN",
			"WEAPON_RAILGUN",
			"WEAPON_RAYCARBINE",
			"WEAPON_RAYMINIGUN",
			"WEAPON_RAYPISTOL",
			"WEAPON_REVOLVER_MK2",
			"WEAPON_REVOLVER",
			"WEAPON_RPG",
			"WEAPON_SAWNOFFSHOTGUN",
			"WEAPON_SMG_MK2",
			"WEAPON_SMG",
			"WEAPON_SNIPERRIFLE",
			"WEAPON_SNSPISTOL_MK2",
			"WEAPON_SNSPISTOL",
			"WEAPON_SPECIALCARBINE_MK2",
			"WEAPON_SPECIALCARBINE",
			"WEAPON_STINGER",
			"WEAPON_STUNGUN",
			"WEAPON_VINTAGEPISTOL",
		}) do
			local text = exports.weapons:GetName(weapon)
			item = NativeUI.CreateItem(text, "")
			weaponMenu.SubMenu:AddItem(item)
			item.Activated = function(_menu, _item)
				listMenu.weapon = weapon
				weaponMenu.Item:RightLabel(text)

				_menu:GoBack()
			end
		end
	end

	self.menu:RefreshIndex()
end

function Menu:Create()
	local menuPool = NativeUI.CreatePool()
	self.menuPool = menuPool
	
	-- Create the menu.
	local menu = NativeUI.CreateMenu("Admin Tools", "", 0, 0)
	self.menu = menu

	menu.Settings.ControlDisablingEnabled = false
	menu.Settings.MouseControlsEnabled = false

	menu.OnMenuClosed = function(_menu)
		self.isOpen = false
	end
	
	menu:SetMenuWidthOffset(Config.Menu.WidthOffset)

	-- Create an item.
	-- local item = NativeUI.CreateItem("Item", "Description")
	-- item.Activated = function(_menu, _item)
		
	-- end

	-- menu:AddItem(item)

	local createFuncs = {}
	for name, func in pairs(self) do
		if name ~= "Create" and name:sub(1, 6) == "Create" then
			table.insert(createFuncs, { name, func })
		end
	end

	table.sort(createFuncs, function(a, b)
		return a[1] < b[1]
	end)

	for k, v in pairs(createFuncs) do
		v[2](self)
	end

	-- Add to the pool.
	menuPool:Add(menu)
	menuPool:RefreshIndex()
end

function Menu:Open()
	-- Create the menu.
	if not self.menuPool then
		self:Create()
	end
	
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
	end)
end

function Menu:Close()
	self.isOpen = false
	self.menu:GoBack()
end

function Functions:ProcessMenu()
	if IsDisabledControlJustPressed(0, Config.Menu.Key) then
		if Menu.isOpen then
			Menu:Close()
		else
			Menu:Open()
		end
	end
end