Tasks = {}
LastTaskIndex = 0

--[[ Functions ]]--
function Add(id, task, coords)
	Tasks[id] = { task = task, coords = coords }

	TriggerEvent("tasks:add", id, task, coords)
end
exports("Add", Add)

function Remove(id)
	Tasks[id] = nil
	
	TriggerEvent("tasks:remove", id)
end
exports("Remove", Remove)

function Initialize()
	for k, v in ipairs(Config.Points) do
		Add("Task"..tostring(k), table.unpack(v))
	end
end