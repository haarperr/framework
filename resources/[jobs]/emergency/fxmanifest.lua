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
}

server_scripts {
	'sv_trackers.lua',
}