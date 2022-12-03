fx_version 'adamant'
game 'gta5'

dependencies {
	'jobs',
	'oldnpcs',
}

shared_script {
	'sh_config.lua',
	'sh_job.lua',
}

client_scripts {
	'cl_trucking.lua',
	'cl_npcs.lua',
}

server_scripts {
	'sv_trucking.lua',
}