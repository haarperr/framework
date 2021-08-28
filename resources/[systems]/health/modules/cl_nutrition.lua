--[[ Functions: Main ]]--
function Main.update:Nutrition()
	local isSprinting = IsPedSprinting(Ped)
	local isRunning = IsPedRunning(Ped)
	local modifier = (isSprinting and Config.Nutrition.SprintMult) or (isRunning and Config.Nutrition.RunMult) or 1.0

	-- local hunger = self:GetEffect("Hunger")
	-- local thirst = self:GetEffect("Thirst")

	self:AddEffect("Hunger", MinutesToTicks / -Config.Nutrition.HungerRate)
	self:AddEffect("Thirst", MinutesToTicks / -Config.Nutrition.ThirstRate * modifier)
end