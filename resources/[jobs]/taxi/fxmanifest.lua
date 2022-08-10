fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.css',
	'html/index.js',
	'html/meter.png',
	'html/font.ttf',
}

dependencies {
	'jobs',
	'trackers',
}

shared_script {
	'@jobs/flags.lua',
	'sh_*.lua',
}

client_scripts {
	'cl_taxi.lua',
}

server_scripts {
	'sv_taxi.lua',
}