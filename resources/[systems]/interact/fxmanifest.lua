fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**/*.html',
	'html/**/*.js',
	'html/**/*.css',
	'html/fonts/*.ttf',
	'html/assets/*.png',
	'html/assets/*.jpg',
}

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'@utils/client/misc.lua',
	'@grids/shared/grids.lua',
	'confirmation/cl_confirmation.lua',
	'gsr/cl_gsr.lua',
	'cl_misc.lua',
	'cl_drawing.lua',
	'cl_interactable.lua',
	'cl_interact.lua',
	'cl_navigation.lua',
}

server_scripts {
	'confirmation/sv_confirmation.lua',
	'gsr/sv_gar.lua',
	'sv_interact.lua',
}