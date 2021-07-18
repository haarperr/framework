Config = {
	Distance = 1.5,
	Text = "Read Newspaper",
	Models = {
		["prop_news_disp_02a_s"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_02c"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_05a"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_02e"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_03c"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_06a"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_02a"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_02d"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_02b"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_01a"] = { Offset = vector3(0.0, 0.0, 1.0) },
		["prop_news_disp_03a"] = { Offset = vector3(0.0, 0.0, 1.0) },
	},
}

ModelsCache = {}
for k, v in pairs(Config.Models) do
	ModelsCache[GetHashKey(k)] = k
end