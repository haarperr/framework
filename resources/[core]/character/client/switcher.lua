--[[ Config ]]--
local Locations = {
	--vector3(155.12670898438, -1001.1567382812, -99.219749450684), -- Motel.
	--vector3(-4.042978286743164, 47.28373336791992, -99.19147491455078), -- Low end apartment.
	--vector3(4.5372819900512695, 203.4844665527344, -99.19630432128906), -- Medium end home.
	--vector3(3.675525426864624, -81.52999877929688, -94.5410385131836), -- High end home.
	vector3(467.89892578125, -990.2815551757812, 30.689666748046875), -- MRPD.
	vector3(1775.5147705078125, 2490.763427734375, 45.74066162109375), -- Prison.
	vector3(338.4757995605469, -596.1846923828125, 43.28408813476562), -- Pillbox.
	vector3(1534.66845703125, 812.0772705078125, 77.65585327148438), -- Highway PD.
	vector3(1840.8658447265625, 3691.484130859375, 34.2839241027832), -- Sandy PD.
	vector3(247.07896423339844, -1204.27490234375, 38.92484664916992), -- Olympic Freeway Train Station.
	vector3(-215.5894775390625, -1039.66943359375, 30.14538955688476), -- Alta Train Station.
	vector3(364.3185729980469, -1588.5401611328125, 25.45171928405761), -- Davis PD.
	vector3(-438.1668395996094, 6012.1484375, 36.99563598632812), -- Paleto PD.
}

local Config = {
	Text = "Switch Character",
	DrawRadius = 8.0,
	Radius = 2.0,
}

--[[ Cache ]]--
local markers = {}

--[[ Functions ]]--
function AddSwitcher(coords, resource, condition)
	local marker = exports.markers:CreateUsable(resource or GetCurrentResourceName(), coords, "CharacterSwitch", Config.Text, drawRadius, radius, nil, {
		condition = condition or function()
			return GetResourceState("house-robbery") ~= "started" or not exports["house-robbery"]:IsInside()
		end
	})

	table.insert(markers, marker)
end
exports("AddSwitcher", AddSwitcher)

--[[ Events ]]--
AddEventHandler("markers:use_CharacterSwitch", function()
	Main:SelectCharacter()
end)

--[[ Resource Events ]]--
AddEventHandler("character:clientStart", function()
	for k, coords in ipairs(Locations) do
		AddSwitcher(coords)
	end
end)