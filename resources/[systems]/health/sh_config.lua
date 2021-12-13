Config = {
	EnableControls = {
		[0] = true, -- INPUT_NEXT_CAMERA
		[1] = true, -- INPUT_LOOK_LR
		[2] = true, -- INPUT_LOOK_UD
		[3] = true, -- INPUT_LOOK_UP_ONLY
		[4] = true, -- INPUT_LOOK_DOWN_ONLY
		[5] = true, -- INPUT_LOOK_LEFT_ONLY
		[6] = true, -- INPUT_LOOK_RIGHT_ONLY
		[52] = true, -- INPUT_CONTEXT_SECONDARY
		[187] = true, -- INPUT_FRONTEND_DOWN
		[188] = true, -- INPUT_FRONTEND_UP
		[189] = true, -- INPUT_FRONTEND_LEFT
		[190] = true, -- INPUT_FRONTEND_RIGHT
		[191] = true, -- INPUT_FRONTEND_RDOWN
		[192] = true, -- INPUT_FRONTEND_RUP
		[193] = true, -- INPUT_FRONTEND_RLEFT
		[194] = true, -- INPUT_FRONTEND_RRIGHT
		[195] = true, -- INPUT_FRONTEND_AXIS_X
		[196] = true, -- INPUT_FRONTEND_AXIS_Y
		[197] = true, -- INPUT_FRONTEND_RIGHT_AXIS_X
		[198] = true, -- INPUT_FRONTEND_RIGHT_AXIS_Y
		[199] = true, -- INPUT_FRONTEND_PAUSE
		[200] = true, -- INPUT_FRONTEND_PAUSE_ALTERNATE
		[201] = true, -- INPUT_FRONTEND_ACCEPT
		[202] = true, -- INPUT_FRONTEND_CANCEL
		[203] = true, -- INPUT_FRONTEND_X
		[204] = true, -- INPUT_FRONTEND_Y
		[205] = true, -- INPUT_FRONTEND_LB
		[206] = true, -- INPUT_FRONTEND_RB
		[207] = true, -- INPUT_FRONTEND_LT
		[208] = true, -- INPUT_FRONTEND_RT
		[209] = true, -- INPUT_FRONTEND_LS
		[210] = true, -- INPUT_FRONTEND_RS
		[211] = true, -- INPUT_FRONTEND_LEADERBOARD
		[212] = true, -- INPUT_FRONTEND_SOCIAL_CLUB
		[213] = true, -- INPUT_FRONTEND_SOCIAL_CLUB_SECONDARY
		[214] = true, -- INPUT_FRONTEND_DELETE
		[215] = true, -- INPUT_FRONTEND_ENDSCREEN_ACCEPT
		[216] = true, -- INPUT_FRONTEND_ENDSCREEN_EXPAND
		[217] = true, -- INPUT_FRONTEND_SELECT
		[237] = true, -- INPUT_CURSOR_ACCEPT
		[238] = true, -- INPUT_CURSOR_CANCEL
		[239] = true, -- INPUT_CURSOR_X
		[240] = true, -- INPUT_CURSOR_Y
		[241] = true, -- INPUT_CURSOR_SCROLL_UP
		[242] = true, -- INPUT_CURSOR_SCROLL_DOWN
		[245] = true, -- INPUT_MP_TEXT_CHAT_ALL
		[246] = true, -- INPUT_MP_TEXT_CHAT_TEAM
		[249] = true, -- INPUT_PUSH_TO_TALK
	},
	Saving = {
		Cooldown = 5000,
		ValidInfo = {
			["armor"] = true,
			["bleed"] = true,
			["fractured"] = true,
			["health"] = true,
		}
	},
	Groups = {
		["Head"] = {
			Part = 31086,
			Bone = "head",
			Treatments = { "Saline", "Gauze", "Bandage", "Ice Pack", "Suture Kit", "Cervical Collar", "Nasopharyngeal Airway", }
		},
		["Torso"] = {
			Part = 11816,
			Bone = "spine2",
			Treatments = { "Saline", "Gauze", "Bandage", "Ice Pack", "Suture Kit", "Fire Blanket", }
		},
		["Left Arm"] = {
			Part = 18905,
			Bone = "lforearm",
			Treatments = { "Saline", "Gauze", "Bandage", "Ice Pack", "Suture Kit", "Splint", "IV Bag", "Tranexamic Acid", "Tourniquet", }
		},
		["Right Arm"] = {
			Part = 40269,
			Bone = "rforearm",
			Treatments = { "Saline", "Gauze", "Bandage", "Ice Pack", "Suture Kit", "Splint", "IV Bag", "Tranexamic Acid", "Tourniquet", }
		},
		["Left Leg"] = {
			Part = 58271,
			Bone = "lcalf",
			Treatments = { "Saline", "Gauze", "Bandage", "Ice Pack", "Suture Kit", "Splint", "Tourniquet", }
		},
		["Right Leg"] = {
			Part = 51826,
			Bone = "rcalf",
			Treatments = { "Saline", "Gauze", "Bandage", "Ice Pack", "Suture Kit", "Splint", "Tourniquet", }
		},
	},
	Bones = {
		-- Fallbacks.
		[0] = {
			Name = "SKEL_ROOT",
			Fallback = 11816,
		},
		[23553] = {
			Name = "SKEL_Spine0",
			Fallback = 11816,
		},
		[24816] = {
			Name = "SKEL_Spine1",
			Fallback = 24817,
		},
		[39317] = {
			Name = "SKEL_Neck_1",
			Fallback = 31086,
		},
		[57597] = {
			Name = "SKEL_Spine_Root",
			Fallback = 11816,
		},
		-- Bones.
		[31086] = {
			Name = "SKEL_Head",
			Label = "Head",
			Group = "Head",
			Modifier = 1.8,
			Nearby = { 10706, 64729 },
			Concussion = true,
			Armor = 1 << 3,
		},
		[10706] = {
			Name = "SKEL_R_Clavicle",
			Label = "Right Clavicle",
			Group = "Torso",
			Modifier = 0.8,
			Nearby = { 40269, 31086, 24818 },
			Armor = 1 << 1,
		},
		[11816] = {
			Name = "SKEL_Pelvis",
			Label = "Pelvis",
			Group = "Torso",
			Modifier = 0.9,
			Nearby = { 24817, 51826, 58271 },
			Limp = 0.5,
			Armor = 1 << 2,
		},
		[14201] = {
			Name = "SKEL_L_Foot",
			Label = "Left Foot",
			Group = "Left Leg",
			Modifier = 0.6,
			Nearby = { 63931 },
			Limp = 0.25,
		},
		[18905] = {
			Name = "SKEL_L_Hand",
			Label = "Left Hand",
			Group = "Left Arm",
			Modifier = 0.6,
			Nearby = { 61163 },
		},
		[24817] = {
			Name = "SKEL_Spine2",
			Label = "Abdomen",
			Group = "Torso",
			Modifier = 1.0,
			Nearby = { 24818, 24816 },
			Armor = 1 << 1,
		},
		[24818] = {
			Name = "SKEL_Spine3",
			Label = "Chest",
			Group = "Torso",
			Modifier = 1.1,
			Nearby = { 10706, 64729, 24817, 45509, 40269 },
			Armor = 1 << 1,
		},
		[28252] = {
			Name = "SKEL_R_Forearm",
			Label = "Right Forearm",
			Group = "Right Arm",
			Modifier = 0.7,
			Nearby = { 40269, 57005 },
		},
		[36864] = {
			Name = "SKEL_R_Calf",
			Label = "Right Calf",
			Group = "Right Leg",
			Modifier = 0.7,
			Nearby = { 51826, 52301 },
			Limp = 0.5,
		},
		[40269] = {
			Name = "SKEL_R_UpperArm",
			Label = "Right Arm",
			Group = "Right Arm",
			Modifier = 0.8,
			Nearby = { 10706, 28252, 24818 },
			Armor = 1 << 2,
		},
		[45509] = {
			Name = "SKEL_L_UpperArm",
			Label = "Left Arm",
			Group = "Left Arm",
			Modifier = 0.8,
			Nearby = { 64729, 61163, 24818 },
			Armor = 1 << 2,
		},
		[51826] = {
			Name = "SKEL_R_Thigh",
			Label = "Right Thigh",
			Group = "Right Leg",
			Modifier = 0.8,
			Nearby = { 11816, 36864 },
			Limp = 0.5,
		},
		[52301] = {
			Name = "SKEL_R_Foot",
			Label = "Right Foot",
			Group = "Right Leg",
			Modifier = 0.6,
			Nearby = { 36864 },
			Limp = 0.25,
		},
		[57005] = {
			Name = "SKEL_R_Hand",
			Label = "Right Hand",
			Group = "Right Arm",
			Modifier = 0.6,
			Nearby = { 28252 },
		},
		[58271] = {
			Name = "SKEL_L_Thigh",
			Label = "Left Thigh",
			Group = "Left Leg",
			Modifier = 0.8,
			Nearby = { 11816, 63931 },
			Limp = 0.5,
		},
		[61163] = {
			Name = "SKEL_L_Forearm",
			Label = "Left Forearm",
			Group = "Left Arm",
			Modifier = 0.7,
			Nearby = { 45509, 18905 },
		},
		[63931] = {
			Name = "SKEL_L_Calf",
			Label = "Left Calf",
			Group = "Left Leg",
			Modifier = 0.7,
			Nearby = { 58271, 14201 },
			Limp = 0.5,
		},
		[64729] = {
			Name = "SKEL_L_Clavicle",
			Label = "Left Clavicle",
			Group = "Torso",
			Modifier = 0.8,
			Nearby = { 45509, 31086, 24818 },
			Armor = 1 << 1,
		},
	},
	Effects = {
		{
			Name = "Energy",
			Default = 1.0,
			Invert = false,
			Background = "grey",
			Foreground = "gold",
			Low = true,
			High = false,
		},
		{
			Name = "Health",
			Default = 1.0,
			Invert = false,
			Background = "grey",
			Foreground = "white",
			Low = true,
			High = false,
		},
		{
			Name = "Blood",
			Default = 0.0,
			Invert = true,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
		},
		{
			Name = "Hunger",
			Default = 1.0,
			Invert = false,
			Background = "grey",
			Foreground = "white",
			Low = true,
			High = false,
		},
		{
			Name = "Thirst",
			Default = 1.0,
			Invert = false,
			Background = "grey",
			Foreground = "white",
			Low = true,
			High = false,
		},
		{
			Name = "Stress",
			Default = 0.0,
			Invert = true,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
			Passive = -60.0,
		},
		{
			Name = "Fatigue",
			Default = 0.0,
			Invert = true,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
			Passive = -30.0,
		},
		{
			Name = "Fracture",
			Default = 0.0,
			Invert = true,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
		},
		{
			Name = "Rage",
			Default = 0.0,
			Invert = false,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
			Passive = -5.0,
		},
		{
			Name = "Comfort",
			Default = 0.0,
			Invert = false,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
			Passive = -60.0,
		},
		{
			Name = "Speed",
			Default = 0.0,
			Invert = false,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
		},
		{
			Name = "Concussion",
			Default = 0.0,
			Invert = true,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
		},
		{
			Name = "Bac",
			Default = 0.0,
			Invert = true,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
			Passive = -30.0,
		},
		{
			Name = "Drug",
			Default = 0.0,
			Invert = true,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
			Passive = 60.0 * -3.0,
		},
		{
			Name = "Oxygen",
			Default = 1.0,
			Invert = false,
			Background = "grey",
			Foreground = "white",
			Low = true,
			High = false,
		},
		{
			Name = "Poison",
			Default = 0.0,
			Invert = true,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
			Passive = -30.0,
		},
		{
			Name = "Scuba",
			Default = 0.0,
			Invert = false,
			Background = "grey",
			Foreground = "white",
			Low = false,
			High = true,
		},
	},
	Injuries = {
		["Gunshot"] = {
			Lifetime = function(bone, groupBone, treatments)
				local sum = math.min(treatments["Gauze"] or 0, 1) + math.min(treatments["Bandage"] or 0) + math.min(treatments["Suture Kit"] or 0, 1)
				return 28800.0 / (math.pow(sum, 2) + 1)
			end,--3600.0 * 8.0,
			Healing = 0.0,
			Clear = 1.0,
		},
		["Stab"] = {
			Lifetime = 3600.0 * 4.0,
			Healing = 0.0,
			Clear = 1.0,
		},
		["Bruising"] = {
			Lifetime = 3600.0 * 0.5,
			Healing = 0.5,
			Clear = 0.2,
		},
		["Fracture"] = {
			Lifetime = 3600.0 * 0.5,
			Healing = 0.0,
			Clear = 0.8,
		},
		["Compound Fracture"] = {
			Lifetime = 3600.0 * 1.0,
			Healing = 0.0,
		},
		["Overdose"] = {
			Lifetime = 300.0,
		},
		["Shock"] = {
			Lifetime = 300.0,
		},
		["Drown"] = {
			Lifetime = 300.0,
		},
		["Starvation"] = {
			Lifetime = 300.0,
		},
		["Dehydration"] = {
			Lifetime = 300.0,
		},
		["Electrocution"] = {
			Lifetime = 300.0,
		},
		["1st Degree Burn"] = {
			Lifetime = 300.0,
			Healing = 0.8,
		},
		["2nd Degree Burn"] = {
			Lifetime = 300.0,
			Healing = 0.4,
		},
		["3rd Degree Burn"] = {
			Lifetime = 300.0,
			Healing = 0.0,
		},
	},
	Treatments = {
		["Bandage"] = {
			Item = "Bandage",
			Description = "Wrap the wound in bandages.",
			Action = "Secures the wound with bandages.",
			Removable = true,
			Lifetime = function(bone, groupBone, treatments)
				return IsPedSprinting(Ped) and 300.0 or 3600.0
			end,
			Update = function(bone, groupBone, treatments)
				groupBone.bleedRate = groupBone.bleedRate * 0.4
			end,
		},
		["Cervical Collar"] = {
			Item = "Cervical Collar",
			Description = "Secure a c-collar around their neck.",
			Action = "Secures a cervical collar around neck.",
			Limit = 1,
			Removable = true,
		},
		["Fire Blanket"] = {
			Item = "Fire Blanket",
			Description = "Cover in a fire blanket.",
			Action = "Wraps a fire blanket around them.",
			Limit = 1,
			Removable = true,
		},
		["Gauze"] = {
			Item = "Gauze",
			Description = "Stuff an open wound with gauze.",
			Action = "Packs the wound with gauze.",
			Removable = true,
			Lifetime = function(bone, groupBone, treatments)
				return (IsPedSprinting(Ped) and 300.0 or 3600.0) * (treatments["Bandage"] and 1.0 or 0.05)
			end,
			Update = function(bone, groupBone, treatments)
				groupBone.bleedRate = groupBone.bleedRate * 0.1
			end,
		},
		["Ice Pack"] = {
			Item = "Ice Pack",
			Description = "An item.",
			Action = "Does something.",
			Limit = 1,
			Removable = true,
		},
		["IV Bag"] = {
			Item = "IV Bag",
			Description = "A bag full of fluids with a needle.",
			Action = "Inserts a needle leading to an IV bag full of fluids.",
			Limit = 1,
			Removable = true,
			Lifetime = function(bone, groupBone, treatments)
				return (IsPedRunning(Ped) or IsPedSprinting(Ped)) and 1.0 or 300.0
			end,
			Update = function(bone, groupBone, treatments)
				Main:AddEffect("Blood", -1.0 / 60.0)
			end,
		},
		["Nasopharyngeal Airway"] = {
			Item = "Nasopharyngeal Airway",
			Description = "An item.",
			Action = "Does something.",
			Limit = 1,
			Removable = true,
		},
		["Saline"] = {
			Item = "Saline",
			Description = "A bottle full of saline.",
			Action = "Cleans the area with saline.",
		},
		["Splint"] = {
			Item = "Splint",
			Description = "An item.",
			Action = "Does something.",
			Limit = 1,
			Removable = true,
			Lifetime = function(bone, groupBone, treatments)
				return IsPedSprinting(Ped) and 300.0 or 3600.0
			end,
		},
		["Suture Kit"] = {
			Item = "Suture Kit",
			Description = "An item.",
			Action = "Does something.",
			Limit = 1,
			Removable = true,
			Lifetime = function(bone, groupBone, treatments)
				return IsPedSprinting(Ped) and 600.0 or 3600.0
			end,
		},
		["Tourniquet"] = {
			Item = "Tourniquet",
			Description = "Secure the limb with a tourniquet.",
			Action = "Secures a tourniquet.",
			Limit = 1,
			Removable = true,
		},
		["Tranexamic Acid"] = {
			Item = "Tranexamic Acid",
			Description = "Add TXA to the IV bag.",
			Action = "Adds tranexamic acid to the IV bag.",
			Condition = function(bone)
				if not bone.history then return false end

				for k, event in ipairs(bone.history) do
					if event.name == "IV Bag" then
						return true
					end
				end

				return false
			end,
			Update = function(bone, groupBone, treatments)
				ClotRate = 1800.0
			end,
		},
	},
	Examining = {
		Anims = {
			Self = {
				Sequence = {
					{ Dict = "special_ped@andy_moon@intro", Name = "idle_intro" },
					{ Dict = "special_ped@andy_moon@base", Name = "base", Flag = 1, Locked = true },
				},
			},
			Revive = {
				Dict = "missexile3",
				Name = "ex03_dingy_search_case_base_michael",
				Flag = 48,
				Duration = 2000,
			},
		},
		Camera = {
			Offset = vector3(0.8, 1.2, 0.4),
			Target = vector3(0.0, 0.0, 0.0),
			Fov = 70.0,
		},
	},
	Blood = {
		BleedMult = 1.0, -- How much bleed is applied, multiplied by damage.
		LossMult = 0.04, -- How much blood is lost, multiplied by bleed.
		HealthLossMult = 0.01,
		ClotRate = 1.0 / 3600.0,
	},
	Energy = {
		RegenRate = 60.0 * 2.0, -- How long it takes to completely restore energy, in minutes.
	},
	Nutrition = {
		HungerRate = 60.0 * 3.0, -- How long it takes to become hungry, in minutes.
		ThirstRate = 60.0 * 2.0, -- How long it takes to become hungry, in minutes.
		SprintMult = 2.0, -- Multiplied value when sprinting.
		RunMult = 4.0, -- Multiplied value when running (slower than sprinting)
	},
	Stamina = {
		RegenRate = 0.5,
		Swimming = {
			Run = 2.0,
			Sprint = 1.0,
		},
		UnderWater = {
			Normal = 1.0,
			Run = 0.5,
			Sprint = 0.5,
			HealthLoss = 0.15,
		},
		Land = {
			Run = 5.0,
			Sprint = 2.0,
		},
	},
	Stress = {
		Shake = "VIBRATE_SHAKE",
		Delay = { 15000, 1000 },
		RandomDelay = { 0, 2000 },
		Intensity = 0.4,
		PerShot = 0.005,
	},
	Armor = {
		Duration = 8000,
		Anim = {
			Flag = 48,
			Dict = "clothingtie",
			Name = "try_tie_neutral_c",
		}
	},
	Anims = {
		Normal = {
			Restrained = { Dict = "dead", Name = "dead_f", Flag = 1 },
			Burning = { Dict = "anim@heists@ornate_bank@hostages@ped_c@", Name = "flinch_loop_underfire", Flag = 49 },
			Sit = { Dict = "rcm_barry3", Name = "barry_3_sit_loop", Flag = 1 },
			Deaths = {
				{ Dict = "combat@death@from_writhe", Name = "death_a", Flag = 2 },
				{ Dict = "combat@death@from_writhe", Name = "death_b", Flag = 2 },
				{ Dict = "combat@death@from_writhe", Name = "death_c", Flag = 2 },
			},
			Writhes = {
				{ Dict = "combat@damage@writheidle_a", Name = "writhe_idle_a", Flag = 1 },
				{ Dict = "combat@damage@writheidle_a", Name = "writhe_idle_b", Flag = 1 },
				{ Dict = "combat@damage@writheidle_a", Name = "writhe_idle_c", Flag = 1 },
				{ Dict = "combat@damage@writheidle_b", Name = "writhe_idle_d", Flag = 1 },
				{ Dict = "combat@damage@writheidle_b", Name = "writhe_idle_e", Flag = 1 },
				{ Dict = "combat@damage@writheidle_b", Name = "writhe_idle_f", Flag = 1 },
				{ Dict = "combat@damage@writheidle_c", Name = "writhe_idle_g", Flag = 1 },
			},
		},
		Vehicle = {
			Normal = { Dict = "veh@bus@passenger@common@idle_duck", Name = "sit", Flag = 49 },
			Restrained = { Dict = "veh@boat@jetski@rear@idle_duck", Name = "sit", Flag = 49 },
		},
		Water = {
			Normal = { Dict = "dam_ko", Name = "drown", Flag = 2 },
			Restrained = { Dict = "dam_ko", Name = "drown_cuffed", Flag = 2 },
		},
		Revive = { Dict = "get_up@directional@movement@from_seated@action", Name = "getup_r_0", Flag = 0, Duration = 1600 },
	},
}