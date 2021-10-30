Modding = {
	colors = {
		["Primary"] = {
			setter = SetVehicleCustomPrimaryColour,
		},
		["Secondary"] = {
			setter = SetVehicleCustomSecondaryColour,
		},
	},
	palettes = {
		["Interior"] = {
			setter = SetVehicleInteriorColor,
			getter = GetVehicleInteriorColor,
		},
		["Dashboard"] = {
			setter = SetVehicleDashboardColor,
			getter = GetVehicleDashboardColor,
		},
		["Pearlescent"] = {
			setter = function(vehicle, id)
				local pearlescent, wheel = GetVehicleExtraColours(vehicle)
				SetVehicleExtraColours(vehicle, id, wheel)
			end,
			getter = function(vehicle)
				local pearlescent, wheel = GetVehicleExtraColours(vehicle)
				return pearlescent
			end,
		},
		["Wheel"] = {
			setter = function(vehicle, id)
				local pearlescent, wheel = GetVehicleExtraColours(vehicle)
				SetVehicleExtraColours(vehicle, pearlescent, id)
			end,
			getter = function(vehicle)
				local pearlescent, wheel = GetVehicleExtraColours(vehicle)
				return wheel
			end,
		},
	}
}

function Modding:TogglePaint(vehicle)
	self.vehicle = vehicle

	local palette = self:GetPalette()
	local components = {}
	local defaults = {
		palette = palette,
	}

	for name, funcs in pairs(self.colors) do
		local component = {
			type = "q-card",
			class = "q-pa-sm q-mb-md",
			text = name.." Color",
			components = {
				{
					template = [[
						<q-color
							flat
							square
							style="width: 10vmin"
							@change="hex => this.$invoke('setColor', 'rgb', ']]..name..[[', hex)"
						/>
					]],
				},
			},
		}

		table.insert(components, component)
	end

	for name, funcs in pairs(self.palettes) do
		local component =  {
			type = "q-card",
			class = "q-pa-sm q-mb-md",
			components = {
				{
					type = "div",
					template = [[
						<div>
							<q-badge
								:style="`
									width: 10;
									padding: 4px;
									background: ${this.$getModel('colorHex-]]..name..[[')};
									color: ${this.$getModel('colorText-]]..name..[[')};
								`"
								:label="this.$getModel('colorName-]]..name..[[')"
								floating
							/>
							<span>]]..name..[[</span>
						</div>
					]]
				},
				{
					template = [[
						<q-color
							flat
							square
							no-header
							no-footer
							default-view="palette"
							style="max-width: 10vmin"
							:palette="this.$getModel('palette')"
							@change="hex => this.$invoke('setColor', 'palette', ']]..name..[[', hex)"
						/>
					]],
				},
			},
		}

		local currentId = funcs.getter(vehicle)
		local paletteModel = self:GetPaletteModel(name, currentId)
		if paletteModel then
			for k, v in pairs(paletteModel) do
				defaults[k] = v
			end
		end

		table.insert(components, component)
	end

	local window = Window:Create({
		type = "window",
		title = "Paint",
		class = "compact",
		style = {
			["width"] = "40vmin",
			["height"] = "90vmin",
			["top"] = "8vmin",
			["left"] = "2vmin",
			["overflow"] = "visible !important",
		},
		defaults = defaults,
		prepend = {
			type = "q-icon",
			name = "cancel",
			style = {
				["font-size"] = "1.3em",
			},
			binds = {
				color = "red",
			},
			click = {
				callback = "this.$setModel('closing', true)",
			},
			components = {
				{
					type = "q-dialog",
					model = "closing",
					components = {
						{
							type = "q-card",
							components = {
								{
									type = "q-card-section",
									class = "row items-center",
									template = "<div>Would you like to apply these changes?</div>",
								},
								{
									type = "q-card-actions",
									binds = {
										["align"] = "right",
									},
									components = {
										{
											type = "q-btn",
											text = "Save and Exit",
											binds = {
												color = "green",
											},
											click = {
												event = "save",
												callback = "this.$setModel('saving', true)",
											},
										},
										{
											type = "q-btn",
											text = "Exit without Saving",
											binds = {
												color = "red",
											},
											click = {
												event = "discard",
											},
										},
									},
								},
								{
									type = "q-inner-loading",
									condition = "this.$getModel('saving')",
									template = "<q-spinner size='30px' />",
									binds = {
										showing = true,
									},
								},
							},
						},
					},
				},
			},
		},
		components = {
			{
				class = "row justify-evenly q-pt-sm",
				components = components,
			}
		},
	})

	window:OnClick("save", function(window)
		window:Destroy()
		UI:Focus(false)
	end)

	window:OnClick("discard", function(window)
		window:Destroy()
		UI:Focus(false)
	end)

	window:AddListener("setColor", function(window, _type, name, hex)
		local isRgb = _type == "rgb"
		local funcs = isRgb and Modding.colors[name] or Modding.palettes[name]
		if not funcs then return end
		
		if isRgb then
			local r, g, b = HexToRgb(hex)
			funcs.setter(Modding.vehicle, r, g, b)
		else
			local id = Modding.paletteCache[hex]
			funcs.setter(Modding.vehicle, id)

			local paletteModel = self:GetPaletteModel(name, id)
			if paletteModel then
				for k, v in pairs(paletteModel) do
					window:SetModel(k, v)
				end
			end
		end
	end)

	window:AddListener("setPaletteColor", function(window, name, hex)
		funcs.setter(Modding.vehicle, r, g, b)
	end)

	UI:Focus(true)
end

function Modding:GetPalette()
	if self.generatedPalette then
		return self.generatedPalette
	end

	self.paletteCache = {}
	
	local palette = {}
	for id, color in pairs(Colors) do
		self.paletteCache[color.Hex] = id
		table.insert(palette, color.Hex)
	end

	table.sort(palette)

	self.generatedPalette = palette

	return palette
end

function Modding:GetPaletteModel(name, id)
	if not id then return end

	local color = Colors[id]
	if not color then return end

	local r, g, b = HexToRgb(color.Hex)
	local brightness = RgbToLuminance(r, g, b)

	return {
		["colorText-"..name] = brightness > 0.5 and "black" or "white",
		["colorHex-"..name] = color.Hex,
		["colorName-"..name] = color.Name,
	}
end

AddEventHandler("inventory:use", function(item, slot, cb)
	if item.name == "Screwdriver" then
		Modding:TogglePaint(NearestVehicle)
	end
end)