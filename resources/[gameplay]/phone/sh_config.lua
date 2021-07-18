local props = {
	{ Model = "p_amb_phone_01", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
}

Config = {
	Open = {
		Anim = {
			Dict = "cellphone@",
			Name = "cellphone_text_in",
			Flag = 50,
			Blend = 8.0,
			Props = props,
			DisableCombat = true,
			ShowMinimap = true,
		},
	},
	Close = {
		Anim = {
			Dict = "cellphone@",
			Name = "cellphone_text_out",
			Flag = 48,
			Blend = 8.0,
			Props = props,
			DisableCombat = true,
		},
	},
	Call = {
		Anim = {
			Dict = "cellphone@str",
			Name = "cellphone_call_listen_c",
			Flag = 49,
			Props = props,
			IsCall = true,
			DisableCombat = true,
		},
	},
	ValidTypes = {
		["text"] = true,
		["tweet"] = true,
	},
}