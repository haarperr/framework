ServerConfig = {
	ValidDiffs = {
		["notes"] = "string",
		["mugshot_url"] = "string",
	},
	Types = {
		["paramedic"] = {
			Describe = function(info)
				local queries
				local values = {}

				if type(info.character_id) == "number" then
					query = [[
						SELECT
							notes,
							first_name,
							last_name,
							gender,
							dead,
							phone_number,
							license_text,
							DATE_FORMAT(dob, GET_FORMAT(DATE, 'JIS')) AS 'dob'
						FROM
							mdt_paramedic_profiles AS `t1`,
							characters AS `t2`
						WHERE
							(t1.character_id=@id OR NOT EXISTS (
								SELECT 1 FROM mdt_paramedic_profiles AS `t3` WHERE t3.character_id=@id
							)) AND
							t2.id=@id;
					]]

					values = {
						["@id"] = info.character_id,
					}
				elseif type(info.vehicle_id) == "number" then
					query = [[
						SELECT
							model,
							plate,
							colors
						FROM
							vehicles
						WHERE
							id=@id
					]]

					values = {
						["@id"] = info.vehicle_id,
					}
				end
				
				local result = {}
				if queries then
					for k, v in pairs(queries) do
						result[k] = exports.GHMattiMySQL:QueryResult(v, values)
					end
				end
				return result
			end,
			Load = function(source, loader, data)
				local result = {}
				local conditions = {}
				local queries = nil
				local singular = false

				local characterId = exports.character:Get(source, "id")
				if not characterId then return end

				if loader == "persons" then
					if type(data) ~= "string" or data:len() > 512 then return end
			
					local firstName = ""
					local lastName = ""
					local i = 1;
					for str in data:gmatch("([^%s]+)") do
						if i == 1 then
							firstName = str
						elseif i == 2 then
							lastName = str
						else
							break
						end
						i = i + 1
					end
			
					statement = "SELECT id, first_name, last_name, dob, gender, license_text, dead FROM characters"
					if firstName ~= "" then
						statement = statement.." WHERE first_name LIKE @first_name"
						conditions = {
							["@first_name"] = "%"..firstName.."%"
						}
			
						if lastName ~= "" then
							statement = statement.." AND last_name LIKE @last_name"
							conditions["@last_name"] = "%"..lastName.."%"
						else
							statement = statement.." OR last_name LIKE @last_name"
							conditions["@last_name"] = "%"..firstName.."%"
						end
						statement = statement.." ORDER BY first_name, last_name ASC"
					else
						conditions = nil
					end

					queries = { statement }
				elseif loader == "vehicles" then
					if type(data) ~= "string" or data:len() > 512 then return end
			
					statement = "SELECT id, plate, model, (SELECT CONCAT(characters.first_name, ' ', characters.last_name) FROM characters WHERE characters.id=vehicles.character_id) AS `name` FROM vehicles"
			
					if data ~= "" then
						statement = statement.." WHERE plate LIKE @plate"
						conditions = {
							["@plate"] = "%"..data.."%",
						}
					else
						conditions = nil
					end

					queries = { statement }
				elseif loader == "weapons" then
					if type(data) ~= "string" or data:len() > 512 then return end
			
					statement = "SELECT serial_number, (SELECT CONCAT(characters.first_name, ' ', characters.last_name) FROM characters WHERE characters.id=serials.character_id) AS `name` FROM serials"
			
					if data ~= "" then
						statement = statement.." WHERE serial_number LIKE @serial"
						conditions = {
							["@serial"] = "%"..data.."%",
						}
					else
						conditions = nil
					end

					queries = { statement }
				elseif loader == "person" then
					if not data.character_id then return end
					
					conditions = { ["@id"] = data.character_id }
					singular = {
						character = true,
						profile = true,
						reports = false,
						citations = false,
					}
					queries = {
						character = "SELECT id, first_name, last_name, gender, dead, phone_number, license_text, DATE_FORMAT(dob, GET_FORMAT(DATE, 'JIS')) AS 'dob' FROM characters WHERE id=@id LIMIT 1",
						profile = "SELECT mugshot_url, notes FROM mdt_paramedic_profiles WHERE character_id=@id LIMIT 1",
						arrests = "SELECT * FROM mdt_police_reports_formatted WHERE character_id=@id";
						citations = "SELECT * FROM mdt_police_reports_formatted_vehicles WHERE character_id=@id";
					}
				elseif loader == "vehicle" then
					singular = true
					queries = {
						vehicle = "SELECT * FROM vehicles WHERE id=@id";
					}

					conditions = {
						["@id"] = data.vehicle_id
					}
				elseif loader == "home" then
					queries = {
						drafts = "SELECT * FROM mdt_police_reports_formatted WHERE `author_id`=@character_id AND `status`='Draft'",
						arrests = "SELECT * FROM mdt_police_reports_formatted WHERE `status`='Guilty' OR `status`='Not Guilty' OR `status`='Awaiting Trial' LIMIT 5",
						warrants = "SELECT * FROM mdt_police_reports_formatted WHERE `status`='Active' OR `status`='Pending' LIMIT 5",
						citations = "SELECT * FROM mdt_police_reports_formatted_vehicles WHERE `status`!='Draft' LIMIT 5",
						citationDrafts = "SELECT * FROM mdt_police_reports_formatted_vehicles WHERE `author_id`=@character_id AND `status`='Draft'",
					}

					conditions = {
						["@character_id"] = characterId,
					}
				end

				if queries then
					for k, v in pairs(queries) do
						if EnableDebug then
							print(k, v)
						end
						result[k] = exports.GHMattiMySQL:QueryResult(v, conditions)
						if singular == true or (type(singular) == "table" and singular[k]) then
							result[k] = result[k][1]
						end
					end
				end

				return result
			end,
			Add = function(source, authorId, targetId, data)
				local charges = {}
				if data.charges then
					for _, v in ipairs(data.charges) do
						if type(v.id) == "number" and (v.count == nil or type(v.count) == "number") then
							charges[v.id] = v.count or 1
						end
					end
				end

				local query = nil
				local values = {
					["@targetId"] = targetId,
					["@authorId"] = authorId,
					["@details"] = data.details or "",
					["@charges"] = json.encode(charges),
					["@status"] = "Draft",
					["@plead"] = data.plead,
					["@served"] = 0,
				}

				if data.plate then
					local vehicleId = exports.GHMattiMySQL:QueryScalar("SELECT id FROM vehicles WHERE character_id=@characterId AND plate=@plate", {
						["@characterId"] = targetId,
						["@plate"] = data.plate,
					})

					if not vehicleId then
						return
					end

					values["@vehicleId"] = vehicleId
					values["@plead"] = nil
				end

				local returnId = false
				data.id = tonumber(data.id)
				if data.id then
					local where = "WHERE `id`=@id"
					
					if not exports.character:HasFaction(source, "judge") then
						where = where.." AND `author_id`=@authorId"
					end

					local set = [[
						SET
							`details`=@details,
							`charges`=@charges,
							`served`=@served
					]]

					if data.state == "serve" then
						local player = exports.character:GetCharacterById(targetId)
						local isNearby = false
						if player then
							local sourcePed = GetPlayerPed(source)
							local targetPed = GetPlayerPed(player)
							if DoesEntityExist(sourcePed) and DoesEntityExist(targetPed) and #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) < 20.0 then
								isNearby = true
							end
						end
						if isNearby then
							values["@served"] = 1
							values["@status"] = nil
							
							local minutes = 0
							local fine = 0
							for _, charge in ipairs(data.charges) do
								local chargeInfo = CriminalCodeIds[charge.id]
								if chargeInfo then
									if chargeInfo.time then
										if chargeInfo.time == -1 then
											minutes = -1
										elseif minutes ~= -1 then
											minutes = minutes + chargeInfo.time * (charge.count or 1)
										end
									end
									if chargeInfo.fine then
										fine = fine + chargeInfo.fine * (charge.count or 1)
									end
								end
							end
							if minutes ~= 0 then
								exports.jail:Jail(source, player, math.min(minutes, 240), "prison")
							end
							if fine > 0 then
								exports.character:AddBank(player, -fine, true)
								exports.log:AddEarnings(player, "Jail", -fine)
							end
							print("jail", minutes, "fine", fine)
						else
							TriggerClientEvent("notify:sendAlert", source, "error", "Can't serve somebody not next to you...", 7000)
							return
						end
					elseif data.state == "save" then
						if data.type == "Warrant" then
							values["@status"] = "Pending"
						end
					elseif data.state == "delete" then
						set = "SET `deleted`=1"	
					elseif data.state == "publish" then
						if data.type == "Warrant" then
							values["@status"] = "Active"
						else
							values["@status"] = "Guilty"
						end
					end

					if data.type == "Warrant" or data.type == "Citation" then
						set = set..", `plead`=NULL"
					else
						set = set..", `plead`=@plead"
					end

					if values["@status"] then
						set = set .. ", `status`=@status"
					end

					query = "UPDATE mdt_police_reports "..set.." "..where

					values["@id"] = data.id
				else
					returnId = true
					query = [[
						INSERT INTO mdt_police_reports SET
							`character_id`=@targetId,
							`author_id`=@authorId,
							`details`=@details,
							`charges`=@charges,
							`status`=@status
						]]

					if values["@plead"] then
						query = query..", `plead`=@plead"
					end

					if values["@vehicleId"] then
						query = query..", `vehicle_id`=@vehicleId"
					end
					
					query = query.."; SELECT LAST_INSERT_ID();"
				end
				if query then
					if values["@status"] or values["@served"] then
						TriggerClientEvent("mdt:sendMessage", source, { status = values["@status"], served = values["@served"] })
					end
					if EnableDebug then
						print(query)
						print(json.encode(values))
						print(data.type, data.state)
					end
					if returnId then
						local result = exports.GHMattiMySQL:QueryScalar(query, values)
						TriggerClientEvent("mdt:sendMessage", source, { reportId = result })
					else
						exports.GHMattiMySQL:Query(query, values)
					end
				elseif EnableDebug then
					print("no query")
				end
			end,
		},
		["police"] = {
			Describe = function(info)
				local queries
				local values = {}

				if type(info.character_id) == "number" then
					query = [[
						SELECT
							mugshot_url,
							notes,
							first_name,
							last_name,
							gender,
							dead,
							phone_number,
							license_text,
							DATE_FORMAT(dob, GET_FORMAT(DATE, 'JIS')) AS 'dob'
						FROM
							mdt_police_profiles AS `t1`,
							characters AS `t2`
						WHERE
							(t1.character_id=@id OR NOT EXISTS (
								SELECT 1 FROM mdt_police_profiles AS `t3` WHERE t3.character_id=@id
							)) AND
							t2.id=@id;
					]]

					values = {
						["@id"] = info.character_id,
					}
				elseif type(info.vehicle_id) == "number" then
					query = [[
						SELECT
							model,
							plate,
							colors
						FROM
							vehicles
						WHERE
							id=@id
					]]

					values = {
						["@id"] = info.vehicle_id,
					}
				end
				
				local result = {}
				if queries then
					for k, v in pairs(queries) do
						result[k] = exports.GHMattiMySQL:QueryResult(v, values)
					end
				end
				return result
			end,
			Load = function(source, loader, data)
				local result = {}
				local conditions = {}
				local queries = nil
				local singular = false

				local characterId = exports.character:Get(source, "id")
				if not characterId then return end

				if loader == "persons" then
					if type(data) ~= "string" or data:len() > 512 then return end
			
					local firstName = ""
					local lastName = ""
					local i = 1;
					for str in data:gmatch("([^%s]+)") do
						if i == 1 then
							firstName = str
						elseif i == 2 then
							lastName = str
						else
							break
						end
						i = i + 1
					end
			
					statement = "SELECT id, first_name, last_name, dob, gender, license_text, dead FROM characters"
					if firstName ~= "" then
						statement = statement.." WHERE first_name LIKE @first_name"
						conditions = {
							["@first_name"] = "%"..firstName.."%"
						}
			
						if lastName ~= "" then
							statement = statement.." AND last_name LIKE @last_name"
							conditions["@last_name"] = "%"..lastName.."%"
						else
							statement = statement.." OR last_name LIKE @last_name"
							conditions["@last_name"] = "%"..firstName.."%"
						end
						statement = statement.." ORDER BY first_name, last_name ASC"
					else
						conditions = nil
					end

					queries = { statement }
				elseif loader == "vehicles" then
					if type(data) ~= "string" or data:len() > 512 then return end
			
					statement = "SELECT id, plate, model, (SELECT CONCAT(characters.first_name, ' ', characters.last_name) FROM characters WHERE characters.id=vehicles.character_id) AS `name` FROM vehicles"
			
					if data ~= "" then
						statement = statement.." WHERE plate LIKE @plate"
						conditions = {
							["@plate"] = "%"..data.."%",
						}
					else
						conditions = nil
					end

					queries = { statement }
				elseif loader == "weapons" then
					if type(data) ~= "string" or data:len() > 512 then return end
			
					statement = "SELECT serial_number, (SELECT CONCAT(characters.first_name, ' ', characters.last_name) FROM characters WHERE characters.id=serials.character_id) AS `name` FROM serials"
			
					if data ~= "" then
						statement = statement.." WHERE serial_number LIKE @serial"
						conditions = {
							["@serial"] = "%"..data.."%",
						}
					else
						conditions = nil
					end

					queries = { statement }
				elseif loader == "person" then
					if not data.character_id then return end
					
					conditions = { ["@id"] = data.character_id }
					singular = {
						character = true,
						profile = true,
						reports = false,
						citations = false,
					}
					queries = {
						character = "SELECT id, first_name, last_name, gender, dead, phone_number, license_text, DATE_FORMAT(dob, GET_FORMAT(DATE, 'JIS')) AS 'dob' FROM characters WHERE id=@id LIMIT 1",
						profile = "SELECT mugshot_url, notes FROM mdt_police_profiles WHERE character_id=@id LIMIT 1",
						arrests = "SELECT * FROM mdt_police_reports_formatted WHERE character_id=@id LIMIT 5";
						citations = "SELECT * FROM mdt_police_reports_formatted_vehicles WHERE character_id=@id LIMIT 5";
					}
				elseif loader == "vehicle" then
					singular = true
					queries = {
						vehicle = "SELECT * FROM vehicles WHERE id=@id";
					}

					conditions = {
						["@id"] = data.vehicle_id
					}
				elseif loader == "home" then
					queries = {
						drafts = "SELECT * FROM mdt_police_reports_formatted WHERE `author_id`=@character_id AND `status`='Draft'",
						arrests = "SELECT * FROM mdt_police_reports_formatted WHERE `status`='Guilty' OR `status`='Not Guilty' OR `status`='Awaiting Trial' LIMIT 5",
						warrants = "SELECT * FROM mdt_police_reports_formatted WHERE `status`='Active' OR `status`='Pending' LIMIT 5",
						citations = "SELECT * FROM mdt_police_reports_formatted_vehicles WHERE `status`!='Draft' LIMIT 5",
						citationDrafts = "SELECT * FROM mdt_police_reports_formatted_vehicles WHERE `author_id`=@character_id AND `status`='Draft'",
					}

					conditions = {
						["@character_id"] = characterId,
					}
				end

				if queries then
					for k, v in pairs(queries) do
						if EnableDebug then
							print(k, v)
						end
						result[k] = exports.GHMattiMySQL:QueryResult(v, conditions)
						if singular == true or (type(singular) == "table" and singular[k]) then
							result[k] = result[k][1]
						end
					end
				end

				return result
			end,
			Add = function(source, authorId, targetId, data)
				local charges = {}
				if data.charges then
					for _, v in ipairs(data.charges) do
						if type(v.id) == "number" and (v.count == nil or type(v.count) == "number") then
							charges[v.id] = v.count or 1
						end
					end
				end

				local query = nil
				local values = {
					["@targetId"] = targetId,
					["@authorId"] = authorId,
					["@details"] = data.details or "",
					["@charges"] = json.encode(charges),
					["@status"] = "Draft",
					["@plead"] = data.plead,
					["@served"] = 0,
				}

				if data.plate then
					local vehicleId = exports.GHMattiMySQL:QueryScalar("SELECT id FROM vehicles WHERE character_id=@characterId AND plate=@plate", {
						["@characterId"] = targetId,
						["@plate"] = data.plate,
					})

					if not vehicleId then
						return
					end

					values["@vehicleId"] = vehicleId
					values["@plead"] = nil
				end

				local returnId = false
				data.id = tonumber(data.id)
				if data.id then
					local where = "WHERE `id`=@id"
					
					if not exports.character:HasFaction(source, "judge") then
						where = where.." AND `author_id`=@authorId"
					end

					local set = [[
						SET
							`details`=@details,
							`charges`=@charges,
							`served`=@served
					]]

					if data.state == "serve" then
						local player = exports.character:GetCharacterById(targetId)
						local isNearby = false
						if player then
							local sourcePed = GetPlayerPed(source)
							local targetPed = GetPlayerPed(player)
							if DoesEntityExist(sourcePed) and DoesEntityExist(targetPed) and #(GetEntityCoords(sourcePed) - GetEntityCoords(targetPed)) < 20.0 then
								isNearby = true
							end
						end
						if isNearby then
							values["@served"] = 1
							values["@status"] = nil
							
							local minutes = 0
							local fine = 0
							for _, charge in ipairs(data.charges) do
								local chargeInfo = CriminalCodeIds[charge.id]
								if chargeInfo then
									if chargeInfo.time then
										if chargeInfo.time == -1 then
											minutes = -1
										elseif minutes ~= -1 then
											minutes = minutes + chargeInfo.time * (charge.count or 1)
										end
									end
									if chargeInfo.fine then
										fine = fine + chargeInfo.fine * (charge.count or 1)
									end
								end
							end
							if minutes ~= 0 then
								exports.jail:Jail(source, player, math.min(minutes, 240), "prison")
							end
							if fine > 0 then
								exports.character:AddBank(player, -fine, true)
								exports.log:AddEarnings(player, "Jail", -fine)
							end
							print("jail", minutes, "fine", fine)
						else
							TriggerClientEvent("notify:sendAlert", source, "error", "Can't serve somebody not next to you...", 7000)
							return
						end
					elseif data.state == "save" then
						if data.type == "Warrant" then
							values["@status"] = "Pending"
						end
					elseif data.state == "delete" then
						set = "SET `deleted`=1"	
					elseif data.state == "publish" then
						if data.type == "Warrant" then
							values["@status"] = "Active"
						else
							values["@status"] = "Guilty"
						end
					end

					if data.type == "Warrant" or data.type == "Citation" then
						set = set..", `plead`=NULL"
					else
						set = set..", `plead`=@plead"
					end

					if values["@status"] then
						set = set .. ", `status`=@status"
					end

					query = "UPDATE mdt_police_reports "..set.." "..where

					values["@id"] = data.id
				else
					returnId = true
					query = [[
						INSERT INTO mdt_police_reports SET
							`character_id`=@targetId,
							`author_id`=@authorId,
							`details`=@details,
							`charges`=@charges,
							`status`=@status
						]]

					if values["@plead"] then
						query = query..", `plead`=@plead"
					end

					if values["@vehicleId"] then
						query = query..", `vehicle_id`=@vehicleId"
					end
					
					query = query.."; SELECT LAST_INSERT_ID();"
				end
				if query then
					if values["@status"] or values["@served"] then
						TriggerClientEvent("mdt:sendMessage", source, { status = values["@status"], served = values["@served"] })
					end
					if EnableDebug then
						print(query)
						print(json.encode(values))
						print(data.type, data.state)
					end
					if returnId then
						local result = exports.GHMattiMySQL:QueryScalar(query, values)
						TriggerClientEvent("mdt:sendMessage", source, { reportId = result })
					else
						exports.GHMattiMySQL:Query(query, values)
					end
				elseif EnableDebug then
					print("no query")
				end
			end,
		},
	},
}