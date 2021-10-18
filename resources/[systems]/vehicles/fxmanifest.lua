fx_version 'adamant'
game 'gta5'

files {
	'icons/*.png',
}

shared_script {
	'@grids/shared/grids.lua',
	'@utils/shared/math.lua',
	'config/*.lua',
	'sh_main.lua',
	'modules/sh_*.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'@utils/client/misc.lua',
	'@utils/client/vehicles.lua',
	'@utils/client/vectors.lua',
	'cl_main.lua',
	'modules/cl_*.lua',
}

server_scripts {
	'@utils/server/random.lua',
	'@utils/server/players.lua',
	'sv_main.lua',
	'sv_vehicle.lua',
	'sv_commands.lua',
	'modules/sv_*.lua',
}