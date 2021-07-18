Config = {
	Taxis = {
		["taxi"] = true,
		["stretch"] = true,
		["patriot2"] = true,
	}
}

for k, v in pairs(Config.Taxis) do
	Config.Taxis[GetHashKey(k)] = v
end