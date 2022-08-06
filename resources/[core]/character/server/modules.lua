Modules = {
	Load = {},
	SkipReferences = {
		["outfits"] = true,
		["containers"] = true,
		["decorations"] = true,
		["jail"] = true,
		["mdt_paramedic_profiles"] = true,
		["mdt_paramedic_reports"] = true,
		["mdt_police_profiles"] = true,
		["mdt_police_reports"] = true,
		["vehicles"] = true,
		["phone_contacts"] = true,
		["phone_messages"] = true,
		["phone_conversations"] = true,
		["weapons"] = true,
	},
}

function Modules:LoadDatabase()
	local references = GetTableReferences("characters", "id")
	self.references = {}
	
	for k, reference in pairs(references) do
		if not self.SkipReferences[reference.table] then
			print(reference.table)
			self.references[reference.table] = reference
		end
	end
end

function Modules:LoadModules(source, character)
	local loadedModules = 0
	for reference, data in pairs(self.references) do
		exports.GHMattiMySQL:QueryResultAsync("SELECT * FROM `"..data.table.."` WHERE character_id=@character_id", {
			["@character_id"] = character.id,
		}, function(result)
			result = ConvertTableResult(result)
			loadedModules = loadedModules + 1
			if self.Load[data.table] then
				local output = self.Load[data.table](result)
				if output ~= nil then
					result = output
				end
			end
			character[data.table] = result
		end)
	end

	while loadedModules < #self.references do Wait(20) end
end