fx_version 'cerulean'
game 'gta5'

dependencies {
	'jobs',
	'trackers',
}

shared_script {
	'@jobs/flags.lua',
	'sh_*.lua',
}

client_scripts {
	'@utils/client/entities.lua',
	'@utils/client/vehicles.lua',
	"cl_*.lua",
}

server_scripts {
	"sv_*.lua",
}