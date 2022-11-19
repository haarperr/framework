fx_version "cerulean"
lua54 "yes"
game "gta5"

name "loaf_tv"
author "Loaf Scripts"
version "2.1.0"

shared_script "config.lua"
server_script "server/*.lua"
client_script "client/*.lua"

dependency "loaf_lib"

escrow_ignore {
    "client/*.lua",
    "config.lua"
}
dependency '/assetpacks'