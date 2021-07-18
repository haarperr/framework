fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**/*.html',
	'html/**/*.js',
	'html/**/*.css',
}

client_scripts {
	'cl_playback.lua',
}

server_scripts {
	'sv_playback.lua',
}