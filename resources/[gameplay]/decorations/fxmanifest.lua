fx_version 'adamant'
game 'gta5'

dependencies {
	'GHMattiMySQL',
	'instances',
}

shared_scripts {
	'@grids/shared/grids.lua',
	'shared/config.lua',
	'shared/main.lua',
}

client_scripts {
	'@utils/client/vectors.lua',
	'@utils/client/misc.lua',
	'client/main.lua',
	'client/decoration.lua',
	'client/queue.lua',
	'client/editor.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'server/config.lua',
	'server/main.lua',
	'server/decoration.lua',
	'server/grids.lua',
}