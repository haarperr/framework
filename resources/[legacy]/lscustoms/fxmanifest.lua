fx_version 'adamant'
game 'gta5'

dependencies {
	'markers',
}

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
	'cl_config.lua',
	'cl_menu.lua',
	'cl_customs.lua',
}

server_scripts {
	'sv_customs.lua',
}