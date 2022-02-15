fx_version 'cerulean'
game 'gta5'

dependencies {
	'jobs',
	'trackers',
}

shared_script {
	'sh_job.lua',
}

client_scripts {
	'cl_police.lua',
}

server_scripts {
	'sv_police.lua',
}