Treatment = {
	labels = {},
	full = { 0, 240, 0 },
	empty = { 220, 0, 0},
}

function Treatment:GetText(boneId, info)
	if not info then return end
	
	local settings = Config.Bones[boneId or false]
	if not settings then return end

	local health = info.health or 1.0
	if health > 0.98 then return end

	local color = {}
	for i = 1, 3 do
		color[i] = Lerp(self.empty[i], self.full[i], health)
	end

	local text = settings.Label
	local function appendText(icon)
		text = text.."<img style='margin-left: 0.5vmin' src='nui://health/html/images/icons/"..icon..".png' width=auto height=20vmin />"
	end

	if info.fractured then
		appendText("Fracture")
	end

	if info.bleed and info.bleed > 0.001 then
		appendText("Blood")
	end

	return [[
		<div style="width: auto; height: auto;">
			<div style='
				position: absolute;
				border-radius: 3px;
				background: rgba(]]..color[1]..[[, ]]..color[2]..[[, ]]..color[3]..[[, 0.8);
				left: 0%;
				right: ]]..(100.0 - health * 100.0)..[[%;
				bottom: 0%;
				top: 0%;
			'></div>
			<div style='
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: row;
				position: relative;
				font-size: 0.8em;
			'>]]..text..[[</div>
		</div>
	]]
end

function Treatment:Begin(ped, bones)
	self:End()

	self.ped = ped
	self.isLocal = ped == PlayerPedId()

	self:SetBones(bones)
	self:CreateCam()

	if self.isLocal then
		self.emote = exports.emotes:Play(Config.Treatment.Anims.Self)
	end

	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)
end

function Treatment:End()
	if not self.ped then return end

	for boneId, label in pairs(self.labels) do
		exports.interact:RemoveText(label)
	end

	if self.camera then
		self.camera:Destroy()
	end

	self.labels = {}
	self.camera = nil
	self.ped = nil

	if self.isLocal then
		exports.emotes:Stop(self.emote)

		self.emote = nil
		self.isLocal = nil
	end

	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
end

function Treatment:Update()
	if not self.ped or not self.bones then return end

	-- Get cursor stuff.
	local camCoords = GetFinalRenderedCamCoord()
	local mouseX, mouseY = GetNuiCursorPosition()
	local width, height = GetActiveScreenResolution()
	local activeBone, activeDist = nil

	-- Selecting bones.
	if IsDisabledControlJustReleased(0, 237) then
		if self.treating then
			self.treating = false
			Menu:Invoke(false, "setTreatment")
		elseif self.activeBone then
			self.treating = true
			
			local coords = GetPedBoneCoords(self.ped, self.activeBone, 0.0, 0.0, 0.0)
			local retval, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)

			Menu:Invoke(false, "setTreatment", screenX, screenY, {
				{ label = "Gauze", icon = "nui://inventory/icons/Gauze.png" },
				{ label = "Bandage", icon = "nui://inventory/icons/Bandage.png" },
				{ label = "Icepack", icon = "nui://inventory/icons/NONE.png" },
				{ label = "Forceps", icon = "nui://inventory/icons/NONE.png" },
			})
		end
	end

	-- Cooldowns.
	if self.lastUpdateCursor and GetGameTimer() - self.lastUpdateCursor < 100 then
		return
	end

	self.lastUpdateCursor = GetGameTimer()

	-- Check bones.
	for boneId, bone in pairs(self.bones) do
		local coords = GetPedBoneCoords(self.ped, boneId, 0.0, 0.0, 0.0)
		local retval, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)

		if retval then
			screenX = screenX * width
			screenY = screenY * height

			local screenDist = ((screenX - mouseX)^2 + (screenY - mouseY)^2)^0.5
			local isActive = screenDist < 100.0

			if isActive and (activeBone == nil or screenDist < activeDist) then
				activeBone = boneId
				activeDist = screenDist
			end
		end
	end

	-- Update active.
	if self.activeBone ~= activeBone then
		self.activeBone = activeBone
	end
end

function Treatment:CreateCam()
	local camera = Camera:Create({
		fov = 80.0,
	})

	local ped = PlayerPedId()
	local offset = Config.Treatment.Camera.Offset
	local target = Config.Treatment.Camera.Target

	function camera:Update()
		AttachCamToEntity(self.handle, ped, offset.x, offset.y, offset.z, true)
		PointCamAtPedBone(self.handle, ped, 11816, target.x, target.y, target.z, true)
		SetCamFov(self.handle, Config.Treatment.Camera.Fov)
	end

	camera:Activate()

	self.camera = camera
end

function Treatment:SetBones(bones)
	if not self.ped then return end

	for boneId, bone in pairs(bones) do
		local label = self.labels[boneId]
		local text = self:GetText(boneId, bone.info, self.activeBone == boneId)

		if label and text then
			exports.interact:SetText(label, text)
		elseif text then
			self.labels[boneId] = exports.interact:AddText({
				text = text,
				bone = boneId,
				entity = self.ped,
			})
		elseif label then
			exports.interact:RemoveText(label)
			self.labels[boneId] = nil
			bones[boneId] = nil
		elseif not text then
			bones[boneId] = nil
		end
	end

	self.bones = bones
end

--[[ Listeners ]]--
Main:AddListener("UpdateSnowflake", function()
	Treatment:SetBones(Main.bones)
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate_health-examine", function()
	local ped = PlayerPedId()
	if Treatment.ped == ped then
		Treatment:End()
	else
		Treatment:Begin(ped, Main.bones)
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Treatment.ped then
			Treatment:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)