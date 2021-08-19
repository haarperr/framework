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
	'sh_config.lua'
}

client_scripts {
	'cl_health.lua',
}

server_scripts {
	'sv_health.lua',
}
