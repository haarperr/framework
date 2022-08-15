fx_version 'adamant'
game 'gta5'

dependencies {
	'utils',
	'markers',
	'jobs',
}

shared_scripts {
	'sh_config.lua',
	'sh_job.lua',
}

client_scripts {
	'cl_scrapping.lua',
	'cl_scrapper.lua',
}

server_scripts {
	'sv_scrapping.lua',
}