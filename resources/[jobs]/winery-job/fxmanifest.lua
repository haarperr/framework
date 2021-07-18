fx_version 'adamant'
game 'gta5'

dependencies {
	'instances',
	'jobs',
	'main',
	'markers',
}

shared_script {
	'sh_config.lua',
	'sh_job.lua',
}

client_scripts {
	'cl_winery.lua',
}

server_scripts {
	'sv_winery.lua',
}