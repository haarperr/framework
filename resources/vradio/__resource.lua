resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

supersede_radio "RADIO_13_JAZZ" { url = "http://stream.simulatorradio.com/stream.mp3", volume = 0.35, name = "Simulator Radio" } -- Replace Worldwide FM with SR
supersede_radio "RADIO_04_PUNK" { url = "http://184.75.223.178:8083/;stream/1", volume = 0.35, name = "J-Pop Project Radio" } -- Replace Worldwide FM with SR

files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"data.js",
	"client.js"
}