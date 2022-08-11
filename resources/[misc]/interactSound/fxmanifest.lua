fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/sounds/*.ogg'
}

client_scripts {
	'cl_interactSound.lua',
}

server_scripts {
	'sv_interactSound.lua',
}