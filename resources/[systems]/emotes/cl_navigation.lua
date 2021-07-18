AddEventHandler("emotes:clientStart", function()
	local expressions = {}

	for k, expression in ipairs(Expressions) do
		if expression.Icon then
			expressions[#expressions + 1] = {
				id = "expression-"..tostring(k),
				text = expression.Name,
				icon = expression.Icon,
			}
		end
	end

	exports.interact:AddOption({
		id = "emotesRoot",
		text = "Emotes",
		icon = "gesture",
		sub = {
			{
				id = "emotes",
				text = "Emote",
				icon = "accessibility",
			},
			{
				id = "walkstyles",
				text = "Walkstyle",
				icon = "directions_run",
			},
			{
				id = "cancelEmote",
				text = "Cancel",
				icon = "not_interested",
			},
			{
				id = "expressions",
				text = "Expression",
				icon = "mood",
				sub = expressions,
			},
		},
	})
end)

AddEventHandler("interact:onNavigate", function(id)
	if not id then return end

	local key, value = id:match("([^-]+)-([^-]+)")
	if key ~= "expression" then return end

	local index = tonumber(value)
	if not index then return end

	local expression = Expressions[index]
	if not expression then return end

	Main:PerformEmote(expression.Anim)
end)

AddEventHandler("interact:onNavigate_emotes", function()
	local emotes = {}
	for name, emote in pairs(Emotes) do
		emotes[#emotes + 1] = {
			emote = name,
		}
	end

	table.sort(emotes, function(a, b)
		return a.emote < b.emote
	end)

	local window = Window:Create({
		type = "window",
		title = "Emotes",
		class = "compact",
		style = {
			["width"] = "30vmin",
			["top"] = "15vmin",
			["right"] = "5vmin",
		},
		prepend = {
			type = "q-icon",
			name = "cancel",
			binds = {
				color = "red",
			},
			click = {
				event = "close"
			}
		},
		components = {
			{
				type = "q-table",
				style = {
					["overflow"] = "hidden",
					["max-height"] = "90vh",
				},
				tableStyle = {
					["overflow-y"] = "auto",
				},
				clicks = {
					["row-click"] = {
						callback = "this.$invoke('playEmote', arguments[0]?.emote)",
					},
				},
				binds = {
					rowKey = "emote",
					dense = true,
					wrapCells = true,
					data = emotes,
					rowsPerPageOptions = { 20 },
					columns = {
						{
							name = "emote",
							label = "Emote",
							field = "emote",
							align = "left",
							sortable = true,
						},
					},
				},
			}
		}
	})

	-- local extraWindow = Window:Create({
	-- 	type = "window",
	-- 	style = {
	-- 		["width"] = "25vmin",
	-- 		["top"] = "15vmin",
	-- 		["right"] = "36vmin",
	-- 	},
	-- 	defaults = {
	-- 		["lastEmote"] = "None",
	-- 		["binds"] = {
	-- 			{},
	-- 			{ emote = "dance2" },
	-- 			{},
	-- 		},
	-- 	},
	-- 	components = {
	-- 		{
	-- 			template = "<div><b>Emote</b>: {{$getModel('lastEmote')}}</div>",
	-- 		},
	-- 		{
	-- 			template = [[
	-- 				<div>
	-- 					<q-separator spaced />
	-- 					<div v-for="(bind, key) in $getModel('binds')">
	-- 						Bind {{key + 1}} -- {{bind.emote ?? "None"}}
	-- 					</div>
	-- 				</div>
	-- 			]]
	-- 		}
	-- 	}
	-- })

	window:OnClick("close", function(self)
		self:Destroy()
		-- extraWindow:Destroy()

		UI:Focus(false)
	end)

	window:AddListener("playEmote", function(self, emote)
		Main:PerformEmote(emote)
	end)

	UI:Focus(true, true)
end)

AddEventHandler("interact:onNavigate_walkstyles", function()
	print("open walkstyles menu")
end)

AddEventHandler("interact:onNavigate_cancelEmote", function()
	Main:CancelEmote()
end)