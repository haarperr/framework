fx_version 'adamant'
game 'gta5'

dependencies {
	'GHMattiMySQL',
	'instances',
}

shared_scripts {
	'sh_config.lua',
	'sh_decorations.lua',
}

client_scripts {
	'@misc/misc.lua',
	'cl_decorations.lua',
}

server_scripts {
	'sv_decorations.lua',
}