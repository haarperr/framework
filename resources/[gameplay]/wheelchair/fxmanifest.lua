fx_version 'cerulean'
game 'gta5'

files {
	'data/vehicles.meta',
	'data/carvariations.meta',
	'data/handling.meta'
}

data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'

shared_scripts {
	'sh_config.lua',
	'sh_main.lua',
}

client_scripts {
	'cl_main.lua',
}

server_scripts {
	'sv_main.lua',
}