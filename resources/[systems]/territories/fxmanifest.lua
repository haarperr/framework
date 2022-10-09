fx_version 'adamant'
game 'gta5'

dependencies {
	'instances',
	'oldnpcs',
	'quests',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'sh_config.lua',
	'sh_territories.lua',
	'sh_quests.lua',
	'quests/*.lua',
}

client_scripts {
	'@npcs/client.lua',
	'@ui/scripts/cl_main.lua',
	'cl_territories.lua',
	'cl_revives.lua',
	'npcs/**/*.lua',
}

server_scripts {
	'@npcs/server.lua',
	'sv_territories.lua',
	'sv_dailies.lua',
	'sv_threads.lua',
}