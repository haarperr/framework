fx_version 'adamant'
game 'gta5'

shared_scripts {
	'sh_config.lua',
	'sh_casino.lua',
}

client_scripts {
	'cl_casino.lua',
	'games/cl_*.lua',
}

server_scripts {
	'sv_casino.lua',
	'games/sv_*.lua',
}