fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'sh_config.lua',
	'sh_admin.lua',
	'modules/sh_*.lua',
}

server_scripts {
	'sv_admin.lua',
	'modules/sv_*.lua',
}

client_scripts {
	'@ui/scripts/cl_main.lua',
	'cl_admin.lua',
	'cl_menu.lua',
	'modules/cl_*.lua',
}