fx_version 'adamant'
game 'gta5'

server_only 'yes'

dependencies {
	'ghmattimysql',
}

server_scripts {
	'@utils/server/database.lua',
	'sv_log.lua',
	'sv_misc.lua',
}