RegisterNetEvent("license:buy")
AddEventHandler("license:buy", function(id)
	local source = source
	local license = Config.Licenses[id]
	if not license then return end

	local character = exports.character:GetCharacter(source)
	if not character then return end

	if not exports.inventory:CanAfford(source, license.Price, 0, true) then return end

	exports.inventory:TakeBills(source, license.Price, 0, true)
	exports.inventory:GiveItem(source, license.Item, 1, { ("%s %s"):format(character.first_name, character.last_name), character.license_text })

	TriggerClientEvent("chat:addMessage", source, "You purchased a "..license.Text.." license!")
end)

RegisterNetEvent("license:show")
AddEventHandler("license:show", function(slotId, _license, targets)
	local source = source

	if type(targets) ~= "table" or #targets > 8 then return end

	local license = Config.Licenses[_license]
	if not license then return end

	local slot = exports.inventory:GetSlot(source, slotId, true)
	if not slot then return end

	local extra = slot[4]
	if not extra then return end
	
	exports.log:Add({
		source = source,
		verb = "showed",
		noun = "license",
		extra = ("text: %s - name: %s - license: %s - targets %s"):format(license.Text, extra[1] or "?", extra[2] or "?", #targets),
	})

	local info
	if license.License == "drivers" then
		info = exports.GHMattiMySQL:QueryResult("SELECT IF(`gender`, 'Male', 'Female') as 'Gender', DATE_FORMAT(`dob`, GET_FORMAT(DATE, 'JIS')) AS 'DOB' FROM `characters` WHERE license_text=@id LIMIT 1", {
			["@id"] = extra[2]
		})[1]
	end

	for _, target in ipairs(targets) do
		TriggerClientEvent("license:show", target, _license, source, extra[1], extra[2], info)
	end
end)