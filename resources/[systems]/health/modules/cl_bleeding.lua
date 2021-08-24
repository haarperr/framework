--[[ Functions: Main ]]--
function Main.update:Bleeding()
	local blood = Main:GetEffect("Blood")
	if blood > 0.001 then
		
	end
end

--[[ Functions: Bone ]]--
function Bone.process.update:Bleeding()
	local bleed = self.info.bleed or 0.0
	if bleed > 0.001 then
		Main:AddEffect("Blood", bleed * Config.Values.BloodLoss)
		Main:AddEffect("Health", -bleed * Config.Values.BloodHealthLoss)
	end
end

function Bone:ApplyBlead(amount)
	for name, func in pairs(self.process.bleed) do
		local result = func(self, amount)
		if result == false then
			return
		elseif type(result) == "number" then
			amount = result
		end
	end

	self:SetInfo("bleed", math.min((self.info.bleed or 0.0) + 0.1, 1.0))
end