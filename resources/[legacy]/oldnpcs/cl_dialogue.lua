CurrentDialogue = nil
Dialogue = {}
Responses = {}

--[[ Functions ]]--
function Dialogue:Focus()
	CurrentDialogue = self.id
	SetDialogue("name", self.name)
	ToggleMenu(true)
end

function Dialogue:Input(callback)
	Debug("Awaiting input", self.id)

	InputCallback = callback
	SendNUIMessage({
		input = true,
	})
end

function Dialogue:Say(text)
	if type(text) == "table" then
		SendNUIMessage({
			playAudio = self.id.."/"..text[2]
		})
		text = text[1]
	end

	-- Replacements.
	local gender = exports.character:Get("gender")
	
	text = text:gsub("%^pronoun_informal", function(value)
		if gender == 1 then
			return "guy"
		else
			return "girl"
		end
	end)
	
	text = text:gsub("%^pronoun_formal", function(value)
		if gender == 1 then
			return "man"
		else
			return "woman"
		end
	end)

	text = text:gsub("%-+", "—")

	-- Debug.
	Debug("Say", self.id, text)

	-- Update menu.
	SetDialogue("dialogue", text)
	ToggleMenu(true)
end

function Dialogue:Set(key, value)
	self = Info[self.id]

	local stack = { self }
	for _key in key:gmatch("([^%.]+)") do
		key = _key
		stack[#stack + 1] = stack[#stack][_key]
	end
	stack[#stack - 1][key] = value
end

function Dialogue:ResponseCallback(response)
	self = Info[self.id]

	if response.next ~= nil then
		if self:GotoStage(response.next) then
			self:InvokeDialogue()
		end
	end
	if response.dialogue ~= nil then
		if type(response.dialogue) == "table" and rawget(response.dialogue, "__cfx_functionReference") then
			self:Say(response.dialogue(self))
		else
			self:Say(response.dialogue)
		end
	end
	if response.callback ~= nil then
		response.callback(self)
	end
end

function Dialogue:AddResponse(response, skipInform)
	self = Info[self.id]

	local id = #Responses + 1
	local isValid = true
	if type(response) == "string" then
		response = Config.GenericDialogue[response]
	elseif response.quest ~= nil then
		local questId = response.quest
		if questId == true then
			questId = self.quest
		end
		local quest = exports.quests:Get(questId)
		if quest and quest:Check() then
			response.callback = function(self)
				quest:Finish()
			end
		else
			isValid = false
		end
	end
	if isValid and (not response.condition or response.condition(self)) then
		Responses[id] = {
			id = id,
			text = response.text,
			response = response,
			info = self,
		}
	end
	if not skipInform then
		SetDialogue("options", Responses)
	end
end

function Dialogue:InvokeDialogue()
	self = Info[self.id]
	
	-- Stage fallback when unset.
	if not self.stage then
		if not self:GotoStage("INIT") then return end
	end
	
	Debug("Invoke dialogue", self.id, self.stage)

	-- Get the stage.
	local stage = self.stages[self.stage]
	if not stage then return end

	-- Set dialogue text.
	if stage.text then
		if type(stage.text) == "table" and rawget(stage.text, "__cfx_functionReference") then
			self:Say(stage.text(self))
		else
			self:Say(stage.text)
		end
	end

	-- Setup responses.
	if stage.responses then
		Responses = {}
		for k, response in pairs(stage.responses) do
			self:AddResponse(response, true)
		end
		SetDialogue("options", Responses)
	else
		Responses = {}
		SetDialogue("options", {})
	end

	-- Invoke callback.
	if stage.onInvoke then
		stage.onInvoke(self)
	end

	-- Goto next stage.
	if stage.next ~= nil then
		self:GotoStage(stage.next)
	end

	-- Finally, focus.
	self:Focus()
end

function Dialogue:GotoStage(stageId)
	self = Info[self.id]
	
	Debug("Goto stage", self.id, stageId)

	-- Get the stage.
	local stage = self.stages[stageId]
	if not stage then return false end

	-- Check the stage conditions.
	if stage.condition then
		local retval, keepOptions, dialogue = stage.condition(self)

		if dialogue then
			self:Say(dialogue)
			if not keepOptions then
				SetDialogue("options", {})
			end
		end

		if not retval then
			return false
		end
	end

	-- Disable input from previous dialogue.
	SendNUIMessage({
		input = false,
	})
	
	-- Set the stage.
	self.stage = stageId

	-- Invoke callbacks.
	if stage.onChange then
		stage.onChange(self)
	end
	
	-- Trigger events.
	TriggerEvent("oldnpcs:onStageChange", self.id, stageId, self.stage)

	-- Return success.
	return true
end

function Dialogue:HasQuest(checkCompleted, questId)
	self = Info[self.id]

	local quest = questId or self.quest
	if not quest then return false end

	quest = exports.quests:Get(self.quest)
	
	return quest and quest:Has() and (not checkCompleted or quest.stage ~= "END")
end

local function Invoke(info, func, ...)
	if info[func] then
		info[func](info, ...)
	end
end

--[[ Events ]]--
RegisterNetEvent("oldnpcs:invoke")
AddEventHandler("oldnpcs:invoke", function(target, func, ...)
	if target == "*" then
		target = CurrentDialogue
	end
	local info = Info[target]
	if not info then return end

	if type(func) == "table" then
		for _, _func in ipairs(func) do
			Invoke(info, table.unpack(_func))
		end
	else
		Invoke(info, func, ...)
	end
end)