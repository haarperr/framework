local model = ""
local bagMod = ""
local spawnedbag = nil



function Milk:WankCow(anim)
	self.anim = anim
	self.emote = exports.emotes:Play(anim)
end

function EnterCam(settings)
	if Camera then
		return
	end

CurrentSettings = settings

	if settings.Anim then
		exports.emotes:Play(settings.Anim, function()
			ExitCam()
		end)
	end


RegisterNetEvent("milk:startmilking")
AddEventHandler("milk:startmilking", function()
    if Config.Cows then 
        exports.emotes:Play(anim) 
        TriggerServerEvent("chug:thecow")
    else return end
end)