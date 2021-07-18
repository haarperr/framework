fx_version 'adamant'
game 'gta5'

dependencies {
	'user',
	'markers',
}

shared_script {
	'sh_config.lua',
	'sh_jobs.lua',
}

client_scripts {
	'cl_jobs.lua',
}

server_scripts {
	'sv_jobs.lua',
}