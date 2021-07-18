fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/index.js',
	'html/index.css',
	'html/bootstrap/*',
}

dependencies {
	'interact',
}

shared_script 'sh_config.lua'
client_script 'cl_banking.lua'
server_script 'sv_banking.lua'