local window

Admin:AddHook("select", "viewContainers", function()
	Navigation:Close()
	TriggerServerEvent(Admin.event.."requestContainers")
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