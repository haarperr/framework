local Escorts = {}
local Escortees = {}

Functions["escort"] = function(source, target, value)
	local escorting = Escorts[source]
	local escortee = Escortees[target]
	if escorting then
		Escorts[source] = nil
		Escortees[escorting] = nil
		return true, escorting, false
	else
		Escorts[source] = target
		Escortees[target] = source
		return true, target, value
	end
end

Functions["escort-response"] = function(source, target, value)
	if not value then
		Escorts[target] = nil
		Escortees[source] = nil
	end
	return true, target, value
end

function IsEscorting(source)
	return Escorts[source] ~= nil
end
exports("IsEscorting", IsEscorting)

function IsBeingEscorted(source)
	return Escortees[source] ~= nil
end
exports("IsBeingEscorted", IsBeingEscorted)