fx_version 'adamant'
game 'gta5'

dependencies {
	'instances',
	'npcs',
	'quests',
}

shared_scripts {
	'sh_config.lua',
	'sh_npcs.lua',
	'sh_territories.lua',
	'sh_quests.lua',
	--'quests/*.lua',
}

client_scripts {
	'cl_territories.lua',
	'cl_revives.lua',
	--'npcs/**/*.lua',
}

server_scripts {
	'sv_territories.lua',
	'sv_dailies.lua',
	'sv_threads.lua',
}