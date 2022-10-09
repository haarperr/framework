fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/**/*.html',
	'html/**/*.js',
	'html/**/*.css',
	'html/sound/**/*.ogg',
}

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'cl_npcs.lua',
	'cl_ui.lua',
	'cl_dialogue.lua',
	'npcs/*.lua',
}

server_scripts {
	'sv_npcs.lua',
}