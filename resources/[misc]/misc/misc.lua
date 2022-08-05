Up = vector3(0, 0, 1)

exports("GetDirection", function(heading)
	local rad = (heading % 360.0) / 180.0 * math.pi
	return vector3(math.cos(rad), math.sin(rad), 0)
end)

function FromRotation(vector)
	local pitch, yaw = (vector.x % 360.0) / 180.0 * math.pi, (vector.z % 360.0) / 180.0 * math.pi

	return vector3(
		math.cos(yaw) * math.cos(pitch),
		math.sin(yaw) * math.cos(pitch),
		math.sin(pitch)
	)
end
exports("FromRotation", FromRotation)

function ToRotation(v0)
	local v1 = Cross(v0, Up)
	local v2 = Cross(v0, v1)
	
	local r11, r12, r13 = v0.x, v1.x, v2.x
	local r21, r22, r23 = v0.y, v1.y, v2.y
	local r31, r32, r33 = v0.z, v1.z, v2.z
	
	return vector3(
		math.deg(math.atan2(r32, r33)),
		math.deg(math.atan2(-r31, math.sqrt(r32^2 + r33^2))) - 90,
		math.deg(math.atan2(r21, r11))
	)
end
exports("ToRotation", ToRotation)

exports("ToRotation2", function(vector)
	local yaw = math.atan2(vector.y, vector.x) * 180.0 / math.pi
	local pitch = math.asin(Dot(vector, vector3(0, 0, 1))) * 180.0 / math.pi
	return vector3(pitch, 0.0, yaw - 90)
end)

function Cross(v1, v2)
	local x, y, z
	x = v1.y * v2.z - v2.y * v1.z
	y = (v1.x * v2.z - v2.x * v1.z) * -1
	z = v1.x * v2.y - v2.x * v1.y

	return vector3(x, y, z)
end
exports("Cross", Cross)

function Dot(a, b)
	return (a.x * b.x) + (a.y * b.y) + (a.z * b.z)
end
exports("Dot", Dot)

function Normalize(vector)
	if type(vector) == "vector3" then
		-- local norm = math.sqrt(vector.x^2, vector.y^2, vector.z^2)
		local norm = Vmag(vector)
		return vector3(vector.x / norm, vector.y / norm, vector.z / norm)
	end
end
exports("Normalize", Normalize)

exports("Lerp", function(a, b, t)
	return a + math.min(math.max(t, 0), 1) * (b - a)
end)

exports("NumberTable", function(from, to, increment)
	local value = {}
	if increment == nil then increment = 1 end
	for i = from, to, increment do
		table.insert(value, tostring(i))
	end
	return value
end)

exports("FormatNumber", function(number)
	return tostring(number):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end)

exports("FixText", function(text)
	return tostring(text):gsub("[\192-\255][\128-\191]*", "?")
end)

local Characters = "QWERTYUIOPASDFGHJKLZXCVBNM1234567890"
local Letters = "QWERTYUIOPASDFGHJKLZXCVBNM"
local Numbers = "1234567890"

function GetRandomText(seed, limit, selector, seed2, seed3)
	if type(selector) ~= "string" then
		if selector == 1 then
			selector = Letters
		elseif selector == 2 then
			selector = Numbers
		else
			selector = Characters
		end
	end

	local output = ""
	limit = math.min(limit or 8, 8)
	for i = 1, limit do
		local char = math.floor(Random(seed * 8, i, seed2 or 0, seed3 or 0) * #selector) + 1
		output = output..selector:sub(char, char)
	end
	return output
end
exports("GetRandomText", GetRandomText)

function Random(r1, r2, r3, r4)
	local x1, x2 = 0, 1
	local a1, a2 = 727595 + r3, 798405 + r3
	local d20, d40 = 1048576 + (r1*r2)^4, 1099511627776 + (r1*r2)^2 + r4
	local u = x2*a2
	local v = (x1*a2 + x2*a1) % d20

	v = (v*d20 + u) % d40
	x1 = math.floor(v/d20)
	x2 = v - x1*d20

	return v/d40
end