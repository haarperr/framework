Restraints = Restraints or {}

Restraints.anims = {
	cuffing = {
		Source = { Dict = "mp_arrest_paired", Name = "cop_p2_back_right", Flag = 16, Duration = 3500 },
		Target = { Dict = "mp_arrest_paired", Name = "crook_p2_back_right", Flag = 16, Heading = 0.0, Offset = vector3(0.0, 0.7, 0.0) },
	},
	uncuffing = {
		Source = { Dict = "mp_arresting", Name = "a_uncuff", Flag = 16 },
		Target = { Dict = "mp_arresting", Name = "b_uncuff", Flag = 16, Heading = 0.0, Offset = vector3(0.0, 0.6, 0.0) },
	},
	cuffed = {
		Dict = "mp_arresting",
		Name = "idle",
		Flag = 49,
		Force = true,
	},
}

Restraints.items = {
	["Handcuffs"] = true,
	["Ziptie"] = true,
}