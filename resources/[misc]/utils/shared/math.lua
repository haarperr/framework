function Lerp(a, b, t)
	return a + math.min(math.max(t, 0), 1) * (b - a)
end

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end