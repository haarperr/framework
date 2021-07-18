fx_version 'cerulean'
game 'gta5'

dependencies {
	'chat',
	'interact',
}

files {
	'animations.txt',
}

shared_scripts {
	'sh_config.lua',
	'sh_main.lua',
}

client_scripts {
	'@ui/scripts/cl_main.lua',
	'cl_main.lua',
	'cl_navigation.lua',
	'cl_emotes.lua',
	'cl_commands.lua',
	'cl_animations.lua',
}

server_scripts {
	
}
