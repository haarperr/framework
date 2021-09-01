Main = {
	peds = {},
}

--[[ Functions ]]--
function Main:CanInteract()
	local player = PlayerId()
	local ped = PlayerPedId()

	return IsPedArmed(ped, 4) and IsPlayerFreeAiming(player) and IsControlEnabled(0, 51) == 1
end

function Main:Update()
	self.coords = GetEntityCoords(PlayerPedId())

	local canInteract = self:CanInteract()
	local peds = exports.oldutils:GetPeds()
	local added = {}

	-- Create targets.
	for _, entity in ipairs(peds) do
		if self.peds[entity] == nil and self:IsValidTarget(entity) then
			local _entity = Entity(entity)
			if not _entity.state.mugged and (canInteract or _entity.state.mugging) then
				local ped = Ped:Create(entity, canInteract)
				
				added[entity] = true
			end
		end
	end

	-- Update targets.
	for entity, ped in pairs(self.peds) do
		ped:Update(canInteract)
	end
end

function Main:IsValidTarget(ped)
	local isValid = DoesEntityExist(ped) and not IsPedAPlayer(ped) and not IsPedDeadOrDying(ped) and IsPedHuman(ped) and NetworkGetEntityIsNetworked(ped)
	local dist = isValid and #(GetEntityCoords(ped) - self.coords)

	return isValid and dist < Config.StopDistance, dist
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(1000)
	end
end)