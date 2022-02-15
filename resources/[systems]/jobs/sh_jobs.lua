Main = {
	jobs = {},
}

Job = {}
Job.__index = Job

--[[ Functions ]]--
function RegisterJob(id, data)
	if type(id) ~= "string" then
		error("job id must by string")
	end

	if type(data) ~= "table" then
		error("job data must be table")
	end

	Citizen.CreateThread(function()
		while GetResourceState(GetCurrentResourceName()) == "starting" do
			Citizen.Wait(0)
		end
		
		Main:RegisterJob(id, data)
	end)
end

--[[ Functions: Main ]]--
function Main:RegisterJob(id, data)
	id = id:lower()
	
	local job = Job:Create(id, data)
	
	self.jobs[id] = job

	if self.OnRegister then
		self:OnRegister(job)
	end
end

--[[ Functions: Job ]]--
function Job:Create(id, data)
	data.id = id

	return setmetatable(data, Job)
end

--[[ Exports ]]--
exports("Register", function(id, data)
	data.resource = GetInvokingResource()

	RegisterJob(id, data)
end)