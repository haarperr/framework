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
		text = text.."<img style='margin-left: 0.5vmin' src='nui://health/html/images/icons/"..icon..".png' width=auto height=10vmin />"
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
	self.bones = bones

	self:SetBones(bones)
	self:CreateCam()

	if self.isLocal then
		self.emote = exports.emotes:Play(Config.Treatment.Anims.Self)
	end

	local window = Window:Create({
		type = "Window",
		class = "compact transparent",
		style = {
			["width"] = "50vmin",
			["height"] = "auto",
			["top"] = "10vmin",
			["right"] = "5vmin",
		},
		defaults = {
			groups = Main:GetGroups(),
		},
		components = {
			{
				type = "q-btn",
				text = "Close",
				class = "q-mb-sm",
				click = {
					callback = "this.$invoke('close')",
				},
				binds = {
					color = "red",
				}
			},
			{
				template = [[
					<div
						class="flex justify-between"
						style="overflow: hidden"
					>
						<q-card
							style="width: 49%"
						>
							<q-expansion-item
								v-for="group in $getModel('groups')"
								:key="group.name"
								:style="`background-color: rgba(200, 0, 0, ${0.5 * (group.damage ?? 0.0)})`"
								@input="if ($event) $setModel('active', group.name)"
								group="groups"
								expand-separator
								dense
							>
								<template v-slot:header>
									<q-item-section side v-if="group.injuries.find(x => x.treatment)">
										<q-icon name="healing" />
									</q-item-section>
									<q-item-section>
										<q-item-label>{{group.name}}</q-item-label>
									</q-item-section>
								</template>
								<q-item
									v-for="(info, key) in group.injuries"
									:key="key"
									:style="`background: rgba(${(info.treatment ? '0, 200, 0' : '200, 0, 0')}, ${0.5 * (info.intensity ?? 1.0)})`"
									inset-level="0.2"
									dense
								>
									<q-item-section>
										{{info.name}}
									</q-item-section>
									<q-item-section side>
										{{info.amount ?? 1}}
									</q-item-section>
								</q-item>
							</q-expansion-item>
						</q-card>
						<q-card
							style="width: 49%"
							v-for="group in $getModel('groups')"
							:key="group.name"
							v-if="group.name == $getModel('active')"
						>
							<q-item
								v-for="(treatment, key) in group.treatments"
								:key="key"
								:disabled="treatment.Disabled"
								:clickable="!treatment.Disabled"
								@click="$invoke('useTreatment', group.name, treatment.Name)"
							>
								<q-item-section avatar>
									<q-img contain :src="`nui://inventory/icons/${treatment.Icon}.png`" width="4vmin" height="4vmin" />
								</q-item-section>
								<q-item-section>
									<q-item-label>{{treatment.Text}}</q-item-label>
									<q-item-label caption>{{treatment.Description}}</q-item-label>
								</q-item-section>
								<q-item-section side>
									{{treatment.Amount ?? 1}}
								</q-item-section>
							</q-item>
						</q-card
					</div>
				]]
			},
		},
	})
	
	window:AddListener("close", function(window)
		Treatment:End()
	end)
	
	self.window = window

	UI:Focus(true, true)
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

	if self.window then
		self.window:Destroy()
		self.window = nil
	end

	UI:Focus(false)
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
			self:SelectBone()
		elseif self.activeBone then
			self.treating = true
			
			local coords = GetPedBoneCoords(self.ped, self.activeBone, 0.0, 0.0, 0.0)
			local retval, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)

			self:SelectBone(self.activeBone)
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

function Treatment:SelectBone(boneId)
	if self.label then
		exports.interact:RemoveText()
		self.label = nil
	end

	local bone = boneId and Main:GetBone(boneId)
	if not bone then
		return
	end
end

function Treatment:GetTreatments()
	return {}
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
		end
	end

	self.bones = bones
end

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