fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/images/*.png',
	'html/**/*.html',
	'html/**/*.css',
	'html/**/*.js',
}

dependencies {
	'main',
}

shared_scripts {
	'sh_config.lua'
}

client_scripts {
	'cl_health.lua',
	'cl_death.lua',
	'cl_beds.lua',
	'cl_effects.lua',
	'cl_food.lua',
}

server_scripts {
	'sv_health.lua',
	'sv_beds.lua',
}
