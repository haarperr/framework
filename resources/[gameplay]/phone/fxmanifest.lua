fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**/*.html',
	'html/**/*.css',
	'html/**/*.js',
	'html/**/*.jpg',
	'html/**/*.png',
	'html/sounds/*.ogg',
}

dependencies {
	'GHMattiMySQL',
}

shared_scripts {
	'sh_config.lua',
	'sh_phone.lua',
	'apps/**/sh_*.lua',
}

client_scripts {
	'cl_phone.lua',
	'cl_hooks.lua',
	'apps/**/cl_*.lua',
}

server_scripts {
	'sv_phone.lua',
	'apps/**/sv_*.lua',
}