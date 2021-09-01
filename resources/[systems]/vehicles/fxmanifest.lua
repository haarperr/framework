fx_version 'adamant'
game 'gta5'

shared_script {
	'@grids/shared/grids.lua',
	'config/*.lua',
	'sh_main.lua',
	'sh_vehicle.lua',
	'modules/sh_*.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'cl_main.lua',
	'cl_vehicle.lua',
	'modules/cl_*.lua',
}

server_scripts {
	'sv_main.lua',
	'sv_vehicle.lua',
	'sv_commands.lua',
	'modules/sv_*.lua',
}