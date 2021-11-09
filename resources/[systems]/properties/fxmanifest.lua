fx_version 'adamant'
game 'gta5'

dependencies {
	'GHMattiMySQL',
	'entities',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'sh_config.lua',
	'sh_properties.lua',
}

client_scripts {
	'cl_main.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'sv_main.lua',
}