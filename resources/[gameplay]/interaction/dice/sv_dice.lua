local TimeCache = {}
local Seed = nil

--[[ Events ]]--
RegisterNetEvent("interaction:scratchOff")
AddEventHandler("interaction:scratchOff", function(slotId, status)
	local source = source

	local slot = exports.inventory:GetSlot(source, slotId, true)
	if not slot or slot[1] ~= exports.inventory:GetItem("Scratch Off").id then return end

	if not exports.inventory:TakeItem(source, "Scratch Off", 1, slotId) or not status then return end

	Reseed()

	local a = math.random()
	local won = 0

	Reseed()

	if a < 0.0001 then
		won = math.random(1000, 5000)
	elseif a < 0.001 then
		won = math.random(100, 1000)
	elseif a < 0.01 then
		won = math.random(60, 90)
	elseif a < 0.1 then
		won = math.random(30, 60)
	else
		won = math.random(1, 30)
	end

	if won <= 0 then return end

	won = math.floor(won)

	exports.log:Add({
		source = source,
		verb = "won",
		noun = "the lottery",
		extra = ("$%s"):format(won),
	})

	exports.inventory:GiveItem(source, "Bills", won)
	exports.log:AddEarnings(source, "Lottery", won)
end)

--[[ Functions ]]--
function Reseed()
	if Seed then
		math.randomseed(Seed)
		Seed = math.random(0, 2147483648)
	else
		Seed = math.floor(os.clock() * 1000)
	end
	math.randomseed(Seed)
end

--[[ Commands ]]--
exports.chat:RegisterCommand("roll", function(source, args, rawCommand)
	local lastTime = TimeCache[source]
	if lastTime and os.time() - lastTime < 5 then return end
	TimeCache[source] = os.time()

	local containerId = exports.inventory:GetPlayerContainer(source)
	if not containerId then return end

	local hasDie = false
	local dieType = args[2]

	if dieType then
		hasDie = exports.inventory:HasItem(containerId, dieType.." Die")
	else
		hasDie = exports.inventory:HasItem(containerId, "Die")
	end

	if not hasDie then
		TriggerClientEvent("notify:sendAlert", source, "error", "I don't have a die to roll...", 7000)
		return
	end

	Reseed()

	local sides = math.min(math.max((tonumber(args[1]) or 6), 4), 100)
	
	if sides % 2 == 1 then
		sides = sides + 1
	end

	local side = math.random(1, sides)

	Reseed()

	if dieType ~= nil and math.random() < 0.9 then
		if dieType == "Even" then
			side = math.min(side + side % 2, sides)
		elseif dieType == "Odd" then
			side = math.min(side + side % 2 - 1, sides - 1)
		end
	end

	local text = ("Rolled ~b~%s~w~ out of ~b~%s~w~..."):format(exports.misc:FormatNumber(side), exports.misc:FormatNumber(sides))

	if dieType then
		exports.log:Add({
			source = source,
			verb = "rolled",
			noun = dieType.." Die",
			extra = ("%s/%s"):format(side, sides),
			channel = "misc",
		})
	else
		exports.log:Add({
			source = source,
			verb = "rolled",
			noun = "Die",
			extra = ("%s/%s"):format(side, sides),
			channel = "misc",
		})
	end

	local nearbyPlayers = exports.grids:GetNearbyPlayers(source)
	for k, player in ipairs(nearbyPlayers) do
		TriggerClientEvent("interaction:me", player, source, text)
	end
	TriggerClientEvent("interaction:dice", source)
end, {
	help = "Roll a die.",
	params = {
		{ name = "Sides", help = "How many sides does your die have? Default is D6, minimum is D4, and maximum is D100." },
		{ name = "Loaded", help = "Have a loaded die? Enter the die's name such as 'even' or 'odd,' or use it from your inventory." },
	}
}, -1)

exports.chat:RegisterCommand("coin", function(source, args, rawCommand)
	local lastTime = TimeCache[source]
	if lastTime and os.time() - lastTime < 5 then return end
	TimeCache[source] = os.time()

	local hasCoin = false
	local containerId = exports.inventory:GetPlayerContainer(source)
	if not containerId then return end

	for k, item in ipairs({ "Penny", "Nickel", "Dime", "Quarter" }) do
		if exports.inventory:HasItem(containerId, item) then
			hasCoin = true
			break
		end
	end
	if not hasCoin then
		TriggerClientEvent("notify:sendAlert", source, "error", "I don't have a coin to flip...", 7000)
		return
	end

	Reseed()
	
	local side
	local rand = math.random()
	if rand < 0.001 then
		side = "the coin on its side"
	elseif rand < 0.5005 then
		side = "heads"
	else
		side = "tails"
	end
	local text = ("Flipped ~b~%s~w~..."):format(side)
	
	exports.log:Add({
		source = source,
		verb = "flipped",
		noun = "a coin",
		extra = side,
		channel = "misc",
	})

	local nearbyPlayers = exports.grids:GetNearbyPlayers(source)
	for k, player in ipairs(nearbyPlayers) do
		TriggerClientEvent("interaction:me", player, source, text)
	end
	TriggerClientEvent("interaction:dice", source)
end, {
	help = "Flip a coin, or use it from your inventory.",
}, -1)