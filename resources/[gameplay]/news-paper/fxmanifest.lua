fx_version 'adamant'
game 'gta5'

ui_page 'html/index.html'

files {
	'html/bootstrap/*.css',
	'html/bootstrap/*.js',
	'html/tablet.png',
	'html/index.html',
	'html/index.css',
	'html/index.js',
}

dependencies {
	
}

shared_scripts {
	'sh_config.lua',
	'sh_news-paper.lua',
}

client_scripts {
	'cl_news-paper.lua',
}

server_scripts {
	'sv_news-paper.lua',
}