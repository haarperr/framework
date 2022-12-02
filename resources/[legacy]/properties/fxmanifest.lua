fx_version 'adamant'
game 'gta5'

dependencies {
	'ghmattimysql',
	'oldinstances',
	'character',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'sh_config.lua',
}

client_scripts {
	'cl_properties.lua',
}

server_scripts {
	'sv_properties.lua',
}