local commands = {
	{
		command = "box",
		model = "prop_cs_cardbox_01",
		bone = 0x796E,
		pos = vector3(0.0, 0.0, 0.0),
		rot = vector3(0.0, 0.0, 0.0),
	},
	{
		command = "boxhat",
		model = "prop_hat_box_01",
		bone = 0x796E,
		pos = vector3(-0.2, 0.0, 0.0),
		rot = vector3(0.0, 90.0, 0.0),
	},
	{
		command = "hardhat",
		model = "prop_hard_hat_01",
		bone = 0x796E,
		pos = vector3(0.12, 0.0, 0.0),
		rot = vector3(180.0, -90.0, 0.0),
	},
	-- {
	-- 	command = "pumpkin",
	-- 	model = "prop_veg_crop_03_pump",
	-- 	bone = 0x796E,
	-- 	pos = vector3(-0.15, 0.0, 0.0),
	-- 	rot = vector3(0.0, 90.0, 0.0),
	-- },
	{
		command = "bucket",
		model = "prop_bucket_02a",
		bone = 0x796E,
		pos = vector3(0.25, 0.0, 0.0),
		rot = vector3(90.0, 0.0, -90.0),
	},
}

Entity = nil

for k, v in pairs(commands) do
	RegisterCommand(v.command, function(source, args, command)
		if DoesEntityExist(Entity) then
			DeleteEntity(Entity)
			return
		end

		local model = GetHashKey(v.model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(20)
		end
	
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		
		Entity = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
		SetEntityCollision(Entity, false, false)
		AttachEntityToEntity(Entity, ped, GetPedBoneIndex(ped, v.bone), v.pos.x, v.pos.y, v.pos.z, v.rot.x, v.rot.y, v.rot.z, false, false, true, true, 0, true)
		SetModelAsNoLongerNeeded(model)
	end)
end

AddEventHandler("onResourceStop", function(name)
	if name ~= GetCurrentResourceName() then return end
	if DoesEntityExist(Entity) then
		DeleteEntity(Entity)
	end
end)