fx_version 'adamant'
game 'gta5'

dependencies {
	'instances',
	'npcs',
	'quests',
}

shared_scripts {
	'sh_config.lua',
	'sh_tasks.lua',
	'quests/*.lua',
}

client_scripts {
	'cl_tasks.lua',
	'npcs/**/*.lua',
}

server_scripts {
	'sv_tasks.lua',
}