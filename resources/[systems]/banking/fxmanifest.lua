fx_version 'adamant'
game 'gta5'

version '1.0.0'
author 'Kole'
description 'Rp Banking'

dependencies {
	'interact',
}

ui_page('ui/dist/index.html')

files { 
	"ui/dist/index.html",
	"ui/dist/**/*.css",
	"ui/dist/**/*.woff",
	"ui/dist/**/*.js",
	"ui/dist/**/*.js.map",
}

shared_scripts {
	'scripts/sh_config.lua',
}

client_scripts {
	'scripts/cl_banking.lua',
}

server_scripts {
	'scripts/sv_banking.lua',
}