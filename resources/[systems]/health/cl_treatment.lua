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

function Treatment:Begin(ped, bones, serverId)
	self:End()

	self.ped = ped
	self.isLocal = ped == PlayerPedId()
	self.serverId = serverId

	self:SetBones(bones)
	self:CreateCam()

	local state = LocalPlayer.state or {}

	if self.isLocal and not state.immobile and not state.restrained then
		self.emote = exports.emotes:Play(Config.Treatment.Anims.Self)
	end

	local groups = self:GetGroups()

	local window = Window:Create({
		type = "Window",
		--class = "compact transparent",
		style = {
			["width"] = "50vmin",
			["height"] = "auto",
			["top"] = "10vmin",
			["right"] = "5vmin",
		},
		defaults = {
			active = groups and (groups[1] or {}).name,
			groups = groups,
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
						style="display: flex; flex-direction: row; overflow: hidden"
					>
						<q-card
							style="min-width: 49%; flex-grow: 1"
							v-if="($getModel('groups') ?? []).length > 0"
						>
							<q-expansion-item
								v-for="group in $getModel('groups')"
								:key="group.name"
								:style="`background-color: rgba(200, 0, 0, ${0.5 * (1.0 - (group.health ?? 1.0))})`"
								@input="if ($event) $setModel('active', group.name)"
								:value="$getModel('active') == group.name"
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
							style="min-width: 49%; margin-left: 1%"
							v-for="group in $getModel('groups')"
							:key="group.name"
							v-if="group.name == $getModel('active')"
						>
							<q-item
								v-for="(treatment, key) in group.treatments"
								:key="key"
								:disabled="treatment.Disabled"
								:clickable="!treatment.Disabled"
								@click="$invoke('useTreatment', group.name, treatment.Text)"
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
						</q-card>
						<div
							v-if="($getModel('groups') ?? []).length == 0"
						>
							No injuries...
						</div>
					</div>
				]]
			},
		},
	})
	
	window:AddListener("close", function(window)
		Treatment:End()
	end)

	window:AddListener("useTreatment", function(window, groupName, treatmentName)
		TriggerServerEvent("health:treat", Treatment.serverId or false, groupName, treatmentName)
	end)
	
	self.window = window

	UI:Focus(true, true)
end

function Treatment:End()
	if not self.ped then return end

	-- Remove labels.
	for boneId, label in pairs(self.labels) do
		exports.interact:RemoveText(label)
	end

	-- Clear cache.
	self.labels = {}
	self.ped = nil
	self.isLocal = nil

	-- Destroy camera.
	if self.camera then
		self.camera:Destroy()
		self.camera = nil
	end
	
	-- Unsubscribe to player.
	if self.serverId then
		TriggerServerEvent("health:subscribe", self.serverId, false)
		self.serverId = nil
	end

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end

	-- Destroy window.
	if self.window then
		self.window:Destroy()
		self.window = nil
	end

	UI:Focus(false)
end

function Treatment:Update()
	if not self.ped or not self.bones then return end
	
	-- Check other players.
	if not self.isLocal then
		local localPed = PlayerPedId()
		local localCoords = GetEntityCoords(localPed)
		local coords = GetEntityCoords(self.ped)

		if #(coords - localCoords) > 3.0 then
			self:End()
			return
		end
	end

	-- Get cursor stuff.
	local camCoords = GetFinalRenderedCamCoord()
	local mouseX, mouseY = GetNuiCursorPosition()
	local width, height = GetActiveScreenResolution()
	local activeBone, activeDist = nil

	-- Selecting bones.
	if IsDisabledControlJustReleased(0, 237) and self.activeBone and self.window then
		local bone = Main:GetBone(self.activeBone)
		local settings = bone and bone:GetSettings()

		if settings then
			self.window:SetModel("active", settings.Group)
		end
	end

	-- Suppress interacts.
	exports.interact:Suppress()

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

	local ped = self.ped
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

	self.bones = bones

	print("set", json.encode(bones))

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

	if self.window then
		self.window:SetModel("groups", self:GetGroups())
	end
end

function Treatment:GetGroups()
	local groups = {}
	local groupCache = {}
	local isDebug = exports.inventory:HasItem("Orb of Bias")

	for boneId, bone in pairs(self.bones) do
		-- Get settings.
		local settings = bone:GetSettings()
		if not settings or not settings.Group then goto skipBone end

		-- Get group.
		local groupSettings = Config.Groups[settings.Group]
		if not groupSettings then goto skipBone end

		-- Get info.
		local info = bone.info or {}

		-- Find/create the group.
		local groupIndex = groupCache[settings.Group]
		local group = nil

		if groupIndex then
			group = groups[groupIndex]
		else
			groupIndex = #groups + 1

			group = {
				name = settings.Group,
				health = 1.0,
				treatments = {},
				treatmentCache = {},
				injuries = {},
				injuryCache = {},
			}

			groups[groupIndex] = group
			groupCache[settings.Group] = groupIndex
		end

		-- Update health.
		group.health = group.health * (info.health or 1.0)

		-- Add injuries.
		if bone.history then
			for _, event in ipairs(bone.history) do
				local injuryIndex = group.injuryCache[event.name]
				local injury = nil
	
				if injuryIndex then
					injury = group.injuries[injuryIndex]
				else
					injuryIndex = #group.injuries + 1
	
					injury = {
						name = event.name,
						treatment = event.treatment,
						amount = 0,
					}
	
					group.injuries[injuryIndex] = injury
					group.injuryCache[event.name] = injuryIndex
				end

				injury.amount = injury.amount + 1
			end
		end

		-- Add treatments.
		for _, treatmentName in ipairs(groupSettings.Treatments) do
			local treatment = Config.Treatment.Options[treatmentName]
			if not treatment or group.treatmentCache[treatmentName] then goto skipTreatment end

			treatment.Text = treatmentName

			if treatment.Item then
				-- Check for item.
				treatment.Disabled = not isDebug and not exports.inventory:HasItem(treatment.Item)

				-- Set icon.
				treatment.Icon = treatment.Icon or treatment.Item:gsub("%s+", "")
			end

			group.treatments[#group.treatments + 1] = treatment
			group.treatmentCache[treatmentName] = true

			::skipTreatment::
		end

		::skipBone::
	end

	-- Uncache injuries in groups.
	for _, group in ipairs(groups) do
		group.injuryCache = nil
		group.treatmentCache = nil
	end

	-- Return groups.
	return groups
end

--[[ Listeners ]]--
Main:AddListener("UpdateSnowflake", function()
	if Treatment.ped == PlayerPedId() then
		Treatment:SetBones(Main.bones)
	end
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate_healthExamine", function(option)
	local ped = PlayerPedId()
	if Treatment.ped == ped then
		Treatment:End()
	else
		Treatment:Begin(ped, Main.bones)
	end
end)

AddEventHandler("players:on_healthExaminePlayer", function(player, ped)
	if not player then return end

	TriggerServerEvent("health:subscribe", GetPlayerServerId(player), true)
end)

--[[ Events: Net ]]--
RegisterNetEvent("health:treat", function(serverId, groupName, treatmentName)
	local player = GetPlayerFromServerId(serverId)
	if not player then return end

	local ped = GetPlayerPed(player)
	if not ped or not DoesEntityExist(ped) then return end

	local group = Config.Groups[groupName or false]
	if not group then return end
	
	local treatment = Config.Treatment.Options[treatmentName or false]
	if not treatment then return end

	-- Add text.
	exports.players:AddText(ped, ("%s %s"):format(group.Bone, treatment.Action), 12000)
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