Config = {
	Delivery = {
		Anim = {
			Dict = "anim@heists@box_carry@",
			Name = "idle",
			Flag = 49,
			DisableCombat = true,
			DisableCarMovement = true,
			DisableJumping = true,
			ShowMinimap = true,
			Props = {
				{ Model = "prop_cs_cardbox_01", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
			},
		}
	},
	Deliver = {
		Anim = {
			Dict = "random@domestic",
			Name = "pickup_low",
			Flag = 0,
			BlendSpeed = 1.0,
			Rate = 0.0,
		},
	},
	Messages = {
		Start = "Your routes have been uploaded to your GPS. Use the vehicle provided to make the deliveries.",
	},
}