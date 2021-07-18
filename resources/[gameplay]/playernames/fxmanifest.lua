-- Add scripts.
client_script 'playernames_api.lua'
server_script 'playernames_api.lua'

client_script 'playernames_cl.lua'
server_script 'playernames_sv.lua'

-- Make exports.
local exportList = {
    'setComponentColor',
    'setComponentAlpha',
    'setComponentVisibility',
    'setWantedLevel',
    'setHealthBarColor',
    'setNameTemplate'
}

exports(exportList)
server_exports(exportList)

-- Add files.
files {
    'template/template.lua'
}

-- Support the latest resource manifest.
fx_version 'adamant'
game 'gta5'