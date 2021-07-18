local appid = 713199197674930236
local text = "Selecting a character"
local numPlayers = 0
local maxPlayers = 0

function SetRP()
	local id = GetPlayerServerId(PlayerId())

	-- App Id.
	SetDiscordAppId(appid)

	-- Presence.
	SetRichPresence(("[%s] %s - %s/%s players"):format(id, text, numPlayers, maxPlayers))

	-- Large asset.
	SetDiscordRichPresenceAsset("logo")
	SetDiscordRichPresenceAssetText("NonstopRP")

	-- Small asset.
	SetDiscordRichPresenceAssetSmall("info")
	SetDiscordRichPresenceAssetSmallText("discord.gg/nonstoprp")
end

AddEventHandler("character:selected", function(character)
	text = ("Playing as %s %s"):format(character.first_name, character.last_name)
end)

RegisterNetEvent("discord-rp:updatePlayers")
AddEventHandler("discord-rp:updatePlayers", function(_numPlayers, _maxPlayers)
	numPlayers = _numPlayers
	maxPlayers = _maxPlayers
end)

function SetText(_text)
	text = _text or "Doing something"
end
exports("SetText", SetText)

Citizen.CreateThread(function()
	SetRP()
	
	while true do
		Citizen.Wait(15000)
		SetRP()
	end
end)