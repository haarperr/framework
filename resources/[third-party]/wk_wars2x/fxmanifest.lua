fx_version "bodacious"
game "gta5"

name "Wraith ARS 2X"
description "Police radar and plate reader system for FiveM"
author "WolfKnight"
version "1.2.4"

files {
	"nui/radar.html", 
	"nui/radar.css", 
	"nui/jquery-3.4.1.min.js", 
	"nui/radar.js",
	"nui/images/*.png",
	"nui/images/plates/*.png",
	"nui/fonts/*.ttf",
	"nui/fonts/Segment7Standard.otf",
	"nui/sounds/*.ogg"
}

ui_page "nui/radar.html"

server_script "sv_version_check.lua"
server_script "sv_exports.lua"
server_export "TogglePlateLock"

client_script "config.lua"
client_script "cl_utils.lua"
client_script "cl_radar.lua"
client_script "cl_plate_reader.lua"