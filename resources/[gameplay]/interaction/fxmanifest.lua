fx_version 'adamant'
game 'gta5'

dependencies {
	'oldutils',
	'chat',
}

client_scripts {
	'cl_interaction.lua',
	'escort/cl_escort.lua',
	'me/cl_me.lua',
	'stare/cl_stare.lua',
	'gsr/cl_gsr.lua',
	'tenga/cl_tenga.lua',
	'handcuffs/cl_handcuffs.lua',
	'searching/cl_searching.lua',
	'force/cl_force.lua',
	'trunk/cl_trunk.lua',
	'confirmation/cl_confirmation.lua',
	'tackling/cl_tackling.lua',
	'zipties/cl_zipties.lua',
	'dice/cl_dice.lua',
}

server_scripts {
	'sv_config.lua',
	'sv_interaction.lua',
	'escort/sv_escort.lua',
	'me/sv_me.lua',
	'stare/sv_stare.lua',
	'handcuffs/sv_handcuffs.lua',
	'searching/sv_searching.lua',
	'confirmation/sv_confirmation.lua',
	'dice/sv_dice.lua',
	'zipties/sv_zipties.lua',
}

shared_scripts {
	
}