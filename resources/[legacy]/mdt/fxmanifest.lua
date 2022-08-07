fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/bootstrap/*.css',
	'html/bootstrap/*.js',
	'html/tablet.png',
	'html/logo.png',
	'html/index.html',
	'html/*.css',
	'html/*.js',
	'html/*.css',
}

dependencies {
	'GHMattiMySQL',
}

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'cl_mdt.lua',
}

server_scripts {
	'sv_config.lua',
	'sv_mdt.lua',
}