local window

Admin:AddHook("select", "viewContainers", function()
	Navigation:Close()
	TriggerServerEvent(Admin.event.."requestContainers")
end)

Admin:AddHook("select", "viewItems", function()
	Navigation:Close()

	if window then
		window:Destroy()
	end

	local data = {}
	local items = exports.inventory:GetItems()

	for id, item in pairs(items) do
		local icon = item.name:gsub("%s+", "")
		
		data[#data + 1] = {
			id = item.id,
			name = item.name,
			weight = item.weight,
			stack = item.stack,
			category = item.category,
			nested = item.nested,
			model = item.model,
			icon = "nui://inventory/icons/"..icon..".png",
		}
	end

	table.sort(data, function(a, b)
		return (a.name or "") > (b.name or "")
	end)

	window = Window:Create({
		type = "window",
		title = "Containers",
		class = "compact",
		style = {
			["width"] = "100vmin",
			["top"] = "50%",
			["left"] = "50%",
			["transform"] = "translate(-50%, -50%)",
		},
		prepend = {
			type = "q-icon",
			name = "cancel",
			binds = {
				color = "red",
			},
			click = {
				event = "close"
			},
			template = [[
				<div>
					<template v-slot:append>
						<q-icon name="search" />
					</template>
					</q-input>
				</div>
			]]
		},
		defaults = {
			data = data,
			columns = {
				{
					name = "id",
					label = "ID",
					field = "id",
					align = "left",
					sortable = true,
				},
				{
					name = "icon",
					label = "Icon",
					field = "icon",
					align = "left",
					sortable = true,
				},
				{
					name = "name",
					label = "Name",
					field = "name",
					align = "left",
					sortable = true,
				},
				{
					name = "category",
					label = "Category",
					field = "category",
					align = "left",
					sortable = true,
				},
				{
					name = "weight",
					label = "Weight",
					field = "weight",
					align = "left",
					sortable = true,
				},
				{
					name = "stack",
					label = "Stack",
					field = "stack",
					align = "left",
					sortable = true,
				},
				{
					name = "model",
					label = "Model",
					field = "model",
					align = "left",
					sortable = true,
				},
				{
					name = "nested",
					label = "Nested",
					field = "nested",
					align = "left",
					sortable = true,
				},
			},
		},
		components = {
			{
				type = "div",
				template = [[
					<q-table
						style="overflow: hidden; max-height: 90vh"
						:columns="$getModel('columns')"
						:data="$getModel('data')"
						row-key="id"
						dense
					>
						<template v-slot:body-cell-icon="props">
							<q-td :props="props">
								<img
									:src="props.row.icon"
									style="max-width: 64px; max-height: 64px"
									width="auto"
									height="auto"
								/>
							</q-td>
						</template>
					</q-table>
				]]
			},
		},
	})

	window:OnClick("close", function(self)
		self:Destroy()

		UI:Focus(false)
	end)

	window:AddListener("openContainer", function(self, id)
		TriggerServerEvent(Admin.event.."viewContainer", id)
	end)

	UI:Focus(true, true)
end)

RegisterNetEvent(Admin.event.."receiveContainers", function(data)
	if window then
		window:Destroy()
	end

	window = Window:Create({
		type = "window",
		title = "Containers",
		class = "compact",
		style = {
			["width"] = "50vmin",
			["top"] = "50%",
			["left"] = "50%",
			["transform"] = "translate(-50%, -50%)",
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
						callback = "this.$invoke('openContainer', arguments[0]?.id)",
					},
				},
				binds = {
					rowKey = "id",
					dense = true,
					wrapCells = true,
					data = data,
					rowsPerPageOptions = { 20 },
					columns = {
						{
							name = "id",
							label = "ID",
							field = "id",
							align = "left",
							sortable = true,
						},
						{
							name = "type",
							label = "Type",
							field = "type",
							align = "left",
							sortable = true,
						},
						{
							name = "protected",
							label = "Protected",
							field = "protected",
							align = "left",
							sortable = true,
						},
						{
							name = "owner",
							label = "Owner",
							field = "owner",
							align = "left",
							sortable = true,
						},
					},
				},
			}
		}
	})

	window:OnClick("close", function(self)
		self:Destroy()

		UI:Focus(false)
	end)

	window:AddListener("openContainer", function(self, id)
		TriggerServerEvent(Admin.event.."viewContainer", id)
	end)

	UI:Focus(true, true)
end)