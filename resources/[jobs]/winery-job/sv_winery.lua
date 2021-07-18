AddEventHandler("winery-job:start", function()
	exports.instances:CreateInstance(Config.Instance.id, Config.Instance)
end)