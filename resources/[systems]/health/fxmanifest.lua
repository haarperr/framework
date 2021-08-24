fx_version 'cerulean'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**/*.css',
	'html/**/*.html',
	'html/**/*.js',
	'html/**/*.png',
}

shared_scripts {
	'sh_config.lua',
	'sh_health.lua',
	'modules/sh_*.lua',
}

client_scripts {
	'cl_bones.lua',
	'cl_health.lua',
	'cl_injury.lua',
	'cl_menu.lua',
	'modules/cl_*.lua',
}

server_scripts {
	'sv_health.lua',
	'sv_commands.lua',
	'modules/sv_*.lua',
}
