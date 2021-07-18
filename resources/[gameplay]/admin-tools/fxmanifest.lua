fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.js',
	'html/index.css',
	'html/assets/bootstrap.min.css',
	'html/assets/bootstrap.min.js',
	'html/assets/jquery.min.js',
}

dependencies {
	'user',
}

shared_script {
	'sh_config.lua',
}

client_scripts {
	'@NativeUILua_Reloaded/src/NativeUIReloaded.lua',
	'cl_admin-tools.lua',
	'cl_assertion.lua',
	'cl_cams.lua',
	'cl_debugger.lua',
	'cl_locations.lua',
	'cl_menu.lua',
	'cl_noclip.lua',
	'cl_player-blips.lua',
	'cl_teleport.lua',
}

server_scripts {
	'sv_admin-tools.lua',
	'sv_cams.lua',
	'sv_config.lua',
	'sv_player-blips.lua',
	'sv_teleport.lua',
}