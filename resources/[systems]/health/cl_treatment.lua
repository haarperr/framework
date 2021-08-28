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
		<div style="width: auto; height: auto">
			<div style='
				position: absolute;
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
				font-size: 0.8em
			'>]]..text..[[</div>
		</div>
	]]
end

function Treatment:Begin(ped, bones)
	self:End()

	self.ped = ped

	self:Update(bones)
end

function Treatment:End()
	if not self.ped then return end

	for boneId, label in pairs(self.labels) do
		exports.interact:RemoveText(label)
	end

	self.labels = {}
	self.ped = nil
end

function Treatment:Update(bones)
	if not self.ped then return end

	for boneId, bone in pairs(bones) do
		local label = self.labels[boneId]
		local text = self:GetText(boneId, bone.info)

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
end

--[[ Listeners ]]--
Main:AddListener("UpdateSnowflake", function()
	Treatment:Update(Main.bones)
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