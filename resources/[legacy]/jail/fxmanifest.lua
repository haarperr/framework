fx_version 'adamant'
game 'gta5'

dependencies {
	'ghmattimysql',
	'main',
	'chat',
	'markers',
}

shared_scripts {
	'sh_config.lua',
}

client_scripts {
	'cl_jail.lua',
}

server_scripts {
	'sv_jail.lua',
}