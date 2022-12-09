
AddNpc({
    name = "BILGECO Trucking Foreman",
    id = "Trucking-Foreman",
    coords = vector4(857.9915161132812, -3208.8984375, 5.90071630477905, 180.0852355957031),
    model = "a_m_m_farmer_01",
    idle = {
        dict = "missfam4", 
        name = "base", 
        props = {
            { 
                Model = "p_amb_clipboard_01", 
                Bone = 36029, 
                Offset = { 0.16, 0.08, 0.1, -130.0, -50.0, 0.0 } 
            },
        },
    },
    stages = {
        ["INIT"] = {
            text = "What do you want?",
            responses = {
                {
                    text = "What do you do here?",
                    next = "WHOAMI",
                },
                {
                    text = "I'm looking for work.",
                    next = "GETJOB",
                    condition = function(self)
                        return not TruckingJob:HasJob()
                    end,
                },
                {
                    text = "I need to cancel my current job.",
                    next = "CANCELJOB",
                    condition = function(self)
                        return TruckingJob:HasJob()
                    end,
                },
            },
        },
        ["WHOAMI"] = {
            text = "I'm the trucking foreman. Truckers come to me for available jobs.",
            responses = {
                {
                    text = "I'm looking for work.",
                    next = "GETJOB",
                    condition = function(self)
                        return not TruckingJob:HasJob()
                    end,
                },
                "NEVERMIND",
            },
        },
        ["GETJOB"] = {
            text = "I have a few runs need doing. Pick your poison.",
            condition = function(self)
                if not exports.jobs:GetCurrentJob("truck driver") then
                    return false, false, "You ain't a trucker. Sign on over there at the door. You can get a truck at the maintenance door."
                --[[elseif not DoesEntityExist(exports.jobs:GetVehicle()) then 
                    return false, false, "I don't see your truck on the lot. Stop by the maintenance bay door."]]
                else
                    return true
                end
            end,
            responses = {
                "NEVERMIND",
            }, 
            onInvoke = function(self)                   
                for k, v in ipairs(Config.Deliveries) do
                    local jobName = v.Name
                    
                    self:AddResponse({
                        text = jobName,
                        condition = function(self)
                            return not TruckingJob:HasJob() and TruckingJob:IsJobValid(jobName)
                        end,
                        callback = function(self)
                            TruckingJob:SelectJob(jobName)

                            self:GotoStage("FINALIZE")
                            self:InvokeDialogue()
                        end,
                    })
                end
            end,
        },
        ["CANCELJOB"] = {
            text = "You sure you wanna cancel your assigned job?",
            responses = {
                {
                    text = "I'm sure. Cancel it.",
                    next = "FINALIZE",
                    condition = function(self)
                        return TruckingJob:HasJob()
                    end,
                    callback = function(self)
                        print("Canceled job at NPC")
                        TruckingJob:Reset()
                    end,
                },
                "NEVERMIND",
            }
        },
        ["FINALIZE"] = {
            text = "Anything else I can do for you?",
            responses = {
                {
                    text = "That's all",
                    next = "INIT",
                },
            }
        },
    },
})