fx_version 'adamant'
game 'gta5'

dependencies {
	'vehicles-handling',
	'jobs',
}

shared_script {
	'@utils/shared/math.lua',
	'sh_config.lua',
	'sh_job.lua',
}

client_scripts {
	'@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
	'cl_car-dealer.lua',
	'cl_menu.lua',
}

server_scripts {
	'sv_car-dealer.lua',
}