fx_version 'adamant'
game 'gta5'

dependencies {
	'GHMattiMySQL',
}

shared_script {
	'sh_config.lua',
	'sh_garages.lua',
}

client_scripts {
	'@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
	'cl_garages.lua',
	'cl_garageMenu.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'sv_garages.lua',
}