Register("Debug Prop", {
	-- Placement = "Floor",
	Stackable = {
		Structure = true,
		Foundation = true,
		Block = true,
	},
	Snap = "CUBE",
	Model = {
		"h4_dfloor_strobe_lightproxy",
	},
})

Register("Table", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"apa_mp_h_din_table_01",
		"apa_mp_h_din_table_04",
		"apa_mp_h_din_table_05",
		"apa_mp_h_din_table_06",
		"apa_mp_h_din_table_11",
		"apa_mp_h_yacht_coffee_table_01",
		"apa_mp_h_yacht_coffee_table_02",
		"apa_mp_h_yacht_side_table_01",
		"apa_mp_h_yacht_side_table_02",
		"ba_prop_int_edgy_table_01",
		"ba_prop_int_trad_table",
		"bkr_prop_fakeid_table",
		"bkr_prop_weed_table_01b",
		"ex_mp_h_din_table_01",
		"ex_mp_h_din_table_04",
		"ex_mp_h_din_table_05",
		"ex_mp_h_din_table_06",
		"ex_mp_h_din_table_11",
		"ex_mp_h_yacht_coffee_table_01",
		"ex_mp_h_yacht_coffee_table_02",
		"ex_prop_ex_console_table_01",
		"gr_dlc_gr_yacht_props_table_01",
		"gr_dlc_gr_yacht_props_table_02",
		"gr_dlc_gr_yacht_props_table_03",
		"hei_heist_din_table_01",
		"hei_heist_din_table_04",
		"hei_heist_din_table_06",
		"hei_heist_din_table_07",
		"hei_prop_yah_table_01",
		"hei_prop_yah_table_02",
		"hei_prop_yah_table_03",
		"prop_chateau_table_01",
		"prop_fbi3_coffee_table",
		"prop_patio_lounger1_table",
		"prop_picnictable_01",
		"prop_rub_table_01",
		"prop_rub_table_02",
		"prop_t_coffe_table",
		"prop_table_02",
		"prop_table_03",
		"prop_table_03b_cs",
		"prop_table_03b",
		"prop_table_04",
		"prop_table_05",
		"prop_table_06",
		"prop_table_07",
		"prop_table_08_chr",
		"prop_table_08",
		"prop_table_tennis",
		"prop_tablesmall_01",
		"prop_ven_market_table1",
		"v_ilev_liconftable_sml",
		"v_res_m_dinetble",
		"v_res_fh_coftbldisp",
		"v_res_tre_bedsidetableb",
		"v_res_tre_bedsidetable",
		"v_res_m_sidetable",
	},
})

Register("Drawer", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"hei_heist_bed_chestdrawer_04",
		"apa_mp_h_bed_chestdrawer_02",
	},
})

Register("Wooden Cabinet", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"prop_tv_cabinet_03",
		"prop_tv_cabinet_04",
		"prop_tv_cabinet_05",
		"apa_mp_h_str_avunitl_01_b",
		"apa_mp_h_str_avunitm_01",
	},
})

Register("Television", {
	Placement = "Floor",
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
		"prop_tv_test",
		"des_tvsmash_start",
		"prop_trev_tv_01",
		"prop_tv_03",
		"prop_tv_04",
		"prop_tv_05",
		"prop_tv_flat_02",
		"prop_tv_flat_02b",
		"sm_prop_smug_tv_flat_01",
	},
})

Register("Ceiling Light", {
	Rotation = vector3(180, 0, 0),
	Placement = "Ceiling",
	Model = {
		"apa_mp_h_lampbulb_multiple_a",
		{
			Name = "v_serv_ct_striplight",
			Offset = vector3(0, 0, -0.2),
		},
	},
})

Register("Lamp", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"apa_mp_h_floor_lamp_int_08",
		"apa_mp_h_floorlamp_a",
		"apa_mp_h_floorlamp_b",
		"apa_mp_h_floorlamp_c",
		"apa_mp_h_lit_floorlamp_01",
		"apa_mp_h_lit_floorlamp_03",
		"apa_mp_h_lit_floorlamp_05",
		"apa_mp_h_lit_floorlamp_06",
		"apa_mp_h_lit_floorlamp_10",
		"apa_mp_h_lit_floorlamp_13",
		"apa_mp_h_lit_floorlamp_17",
		"apa_mp_h_lit_floorlampnight_05",
		"apa_mp_h_lit_floorlampnight_07",
		"apa_mp_h_lit_floorlampnight_14",
		"apa_mp_h_lit_lamptable_005",
		"apa_mp_h_lit_lamptable_02",
		"apa_mp_h_lit_lamptable_04",
		"apa_mp_h_lit_lamptable_09",
		"apa_mp_h_lit_lamptable_14",
		"apa_mp_h_lit_lamptable_17",
		"apa_mp_h_lit_lamptable_21",
		"apa_mp_h_lit_lamptablenight_16",
		"apa_mp_h_lit_lamptablenight_24",
		"apa_mp_h_table_lamp_int_08",
		"apa_mp_h_yacht_floor_lamp_01",
		"apa_mp_h_yacht_table_lamp_01",
		"apa_mp_h_yacht_table_lamp_02",
		"apa_mp_h_yacht_table_lamp_03",
		"bkr_prop_fakeid_desklamp_01a",
		"xm_base_cia_lamp_floor_01a",
		"xm_base_cia_lamp_floor_01b",
	},
})

Register("Painting", {
	Rotation = vector3(0, -90, -90),
	Placement = "Wall",
	Model = {
		"ch_prop_vault_painting_01a",
		"ch_prop_vault_painting_01b",
		"ch_prop_vault_painting_01c",
		"ch_prop_vault_painting_01d",
		"ch_prop_vault_painting_01e",
		"ch_prop_vault_painting_01f",
		"ch_prop_vault_painting_01g",
		"ch_prop_vault_painting_01h",
		"ch_prop_vault_painting_01i",
		"ch_prop_vault_painting_01j",
	},
})

Register("Couch", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"prop_couch_01",
		"prop_couch_03",
		"prop_couch_04",
		"prop_couch_lg_02",
		"prop_couch_lg_05",
		"prop_couch_lg_06",
		"prop_couch_lg_07",
		"prop_couch_lg_08",
		"prop_couch_sm_02",
		"prop_couch_sm_05",
		"prop_couch_sm_06",
		"prop_couch_sm_07",
		"prop_couch_sm1_07",
		"prop_couch_sm2_07",
	},
})

Register("Bed", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"apa_mp_h_bed_double_08",
		"apa_mp_h_bed_double_09",
		"apa_mp_h_bed_wide_05",
		"apa_mp_h_bed_with_table_02",
		"apa_mp_h_yacht_bed_01",
		"apa_mp_h_yacht_bed_02",
		"ex_prop_exec_bed_01",
		"gr_prop_bunker_bed_01",
		"gr_prop_gr_campbed_01",
		"imp_prop_impexp_sofabed_01a",
		"p_lestersbed_s",
		"p_mbbed_s",
		"p_v_res_tt_bed_s",
		"v_res_msonbed_s",
	},
})

Register("Sofa", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = true,
		Block = false,
	},
	Model = {
		"apa_mp_h_stn_sofa_daybed_01",
		"apa_mp_h_stn_sofa_daybed_02",
		"apa_mp_h_stn_sofacorn_01",
		"apa_mp_h_stn_sofacorn_05",
		"apa_mp_h_stn_sofacorn_06",
		"apa_mp_h_stn_sofacorn_07",
		"apa_mp_h_stn_sofacorn_08",
		"apa_mp_h_stn_sofacorn_09",
		"apa_mp_h_stn_sofacorn_10",
		"apa_mp_h_yacht_sofa_01",
		"apa_mp_h_yacht_sofa_02",
		"bkr_prop_clubhouse_sofa_01a",
		"ex_mp_h_off_sofa_003",
		"ex_mp_h_off_sofa_01",
		"ex_mp_h_off_sofa_02",
		"hei_heist_stn_sofa2seat_02",
		"hei_heist_stn_sofa2seat_03",
		"hei_heist_stn_sofa2seat_06",
		"hei_heist_stn_sofa3seat_01",
		"hei_heist_stn_sofa3seat_02",
		"hei_heist_stn_sofa3seat_06",
		"hei_heist_stn_sofacorn_05",
		"hei_heist_stn_sofacorn_06",
		"imp_prop_impexp_sofabed_01a",
		"p_lev_sofa_s",
		"p_res_sofa_l_s",
		"p_v_med_p_sofa_s",
		"v_ilev_m_sofa",
		"v_res_tre_sofa_s",
		"xm_lab_sofa_01",
		"xm_lab_sofa_02",
	},
})

Register("Clutter", {
	Placement = "Floor",
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
		"prop_ashtray_01",
		"prop_cs_beer_box",
		"prop_cs_ironing_board",
		"prop_cs_lester_crate",
		"prop_cs_magazine",
		"prop_pool_rack_01",
		"prop_sh_bong_01",
		"prop_t_telescope_01b",
		"v_res_fa_magtidy",
		"v_res_fh_aftershavebox",
	},
})

Register("Potted Plant", {
	Placement = "Floor",
	Stackable = {
		Structure = true,
		Foundation = true,
		Block = true,
	},
	Model = {
		"apa_mp_h_acc_plant_palm_01",
			"apa_mp_h_acc_plant_tall_01",
			"ex_mp_h_acc_plant_palm_01",
			"ex_mp_h_acc_plant_tall_01",
			"hei_heist_acc_plant_tall_01",
			"prop_fbibombplant",
			"prop_fib_plant_01",
			"prop_pot_plant_01a",
			"prop_pot_plant_01b",
			"prop_pot_plant_01c",
			"prop_pot_plant_01d",
			"prop_pot_plant_01e",
			"prop_pot_plant_03b_cr2",
			"prop_pot_plant_05a",
			"prop_pot_plant_05b",
			"prop_pot_plant_05d",
	},
})

Register("Book", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"v_res_fa_book01",
		"v_res_fa_book02",
		"v_res_fa_book03",
		"v_res_fa_book04",
		"v_ret_ta_book1",
		"v_ret_ta_book2",
		"v_ret_ta_book3",
		"v_ret_ta_book4",
		"prop_cs_stock_book",
		"vw_prop_book_stack_01a",
		"vw_prop_book_stack_01b",
		"vw_prop_book_stack_01c",
		"vw_prop_book_stack_02a",
		"vw_prop_book_stack_02b",
		"vw_prop_book_stack_02c",
		"vw_prop_book_stack_03a",
		"vw_prop_book_stack_03b",
		"vw_prop_book_stack_03c",
		"v_ilev_mp_bedsidebook",
	},
})

Register("Rug", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"apa_mp_h_acc_rugwooll_03",
			"apa_mp_h_acc_rugwooll_04",
			"apa_mp_h_acc_rugwoolm_01",
			"apa_mp_h_acc_rugwoolm_02",
			"apa_mp_h_acc_rugwoolm_03",
			"apa_mp_h_acc_rugwoolm_04",
			"apa_mp_h_acc_rugwools_01",
			"apa_mp_h_acc_rugwools_03",
			"ex_mp_h_acc_rugwoolm_04",
			"hei_heist_acc_rughidel_01",
			"hei_heist_acc_rugwooll_01",
			"hei_heist_acc_rugwooll_02",
			"hei_heist_acc_rugwooll_03",
	},
})


Register("Teddy Bear", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"prop_mr_rasberryclean",
		"v_club_vu_bear",
	},
})

Register("Candle", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"apa_mp_h_acc_candles_01",
		"apa_mp_h_acc_candles_02",
		"apa_mp_h_acc_candles_04",
		"apa_mp_h_acc_candles_06",
		"prop_mem_candle_01",
		"prop_mem_candle_02",
		"prop_mem_candle_03",
		"prop_mem_candle_04",
		"prop_mem_candle_05",
		"prop_mem_candle_06",
		"v_prop_floatcandle",
		"v_res_fa_candle01",
		"v_res_fa_candle02",
		"v_res_fa_candle03",
		"v_res_fa_candle04",
	},
})

Register("Green Screen", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"prop_ld_greenscreen_01",
	},
})

Register("Pool Table", {
	Placement = "Floor",
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		"prop_pooltable_02",
		"prop_pooltable_3b",
	},
})

Register("Sideboard", {
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = false,
	},
	Model = {
			"apa_mp_h_str_sideboardl_06",
			"apa_mp_h_str_sideboardl_09",
			"apa_mp_h_str_sideboardl_11",
			"apa_mp_h_str_sideboardl_13",
			"apa_mp_h_str_sideboardl_14",
			"hei_heist_str_sideboardl_03",
			"hei_heist_str_sideboardl_05",
			"hei_heist_str_sideboards_02",
			"v_med_p_sideboard",
			"v_res_mconsolemod",
			"v_res_mdchest",
			"v_res_tre_sideboard",
	},
})

Register("Desk", {
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = false,
	},
	Model = {
		"prop_office_desk_01",
		"v_corp_maindesk",
		"v_ind_dc_desk03",
		"v_med_p_desk",
		"v_res_mddesk",
		"xm_prop_lab_desk_02",
	},
})

Register("Stool", {
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = false,
	},
	Model = {
			"apa_mp_h_din_stool_04",
			"prop_bar_stool_01",
			"v_corp_lngestool",
			"v_ilev_fh_kitchenstool",
			"v_res_d_highchair",
	},
})

Register("Monitor", {
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
	 	"prop_monitor_01a",
		"prop_monitor_01b",
		"prop_monitor_01c",
		"prop_monitor_02",
		"prop_monitor_li",
		"prop_monitor_w_large",
		"sm_prop_smug_monitor_01",
	},
})

Register("Peripheral", {
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
			"v_res_mousemat",
			"prop_mouse_01b",
			"v_res_tre_remote",
			"v_res_tt_tvremote",
			"prop_cs_remote_01",
			"prop_keyboard_01a",
			"prop_keyboard_01b",
			"v_res_pcheadset",
			"v_res_ipoddock",
	},
})

Register("Speaker", {
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
			"v_ilev_fos_mic",
			"v_club_roc_micstd",
			"prop_table_mic_01",
			"prop_speaker_01",
			"prop_speaker_02",
			"prop_speaker_03",
			"prop_speaker_05",
			"prop_speaker_08",
			"v_res_mm_audio",
			"v_res_pcspeaker",
			"v_club_roc_mixer2",
			"prop_dj_deck_02",
			"prop_dj_deck_01",
			"v_club_vu_deckcase",
			"prop_portable_hifi_01",
			"prop_ghettoblast_01",
			"prop_ghettoblast_02",
			"prop_radio_01",
	},
})

Register("Studio Equipment", {
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
			"ex_office_swag_drugstatue",
			"p_tv_cam_02_s",
			"prop_direct_chair_02",
			"prop_ing_camera_01",
			"prop_kino_light_01",
			"prop_kino_light_02",
			"prop_kino_light_03",
			"prop_pap_camera_01",
			"prop_scrim_01",
			"prop_scrim_02",
			"prop_studio_light_02",
			"prop_studio_light_03",
			"prop_tri_pod",
			"prop_v_cam_01",
			"v_ret_ta_camera",
	},
})

Register("Statue", {
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
			"v_res_m_horsefig",
			"v_res_r_figcat",
			"v_res_r_fighorse",
			"prop_xmas_tree_int",
			"hei_prop_drug_statue_01",
	},
})

Register("Chair", {
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
			"apa_mp_h_din_chair_04",
			"apa_mp_h_din_chair_08",
			"apa_mp_h_din_chair_09",
			"apa_mp_h_din_chair_12",
			"apa_mp_h_stn_chairarm_01",
			"apa_mp_h_stn_chairarm_02",
			"apa_mp_h_stn_chairarm_03",
			"apa_mp_h_stn_chairarm_09",
			"apa_mp_h_stn_chairarm_11",
			"apa_mp_h_stn_chairarm_12",
			"apa_mp_h_stn_chairarm_13",
			"apa_mp_h_stn_chairarm_23",
			"apa_mp_h_stn_chairarm_24",
			"apa_mp_h_stn_chairarm_25",
			"apa_mp_h_stn_chairarm_26",
			"apa_mp_h_stn_chairstool_12",
			"apa_mp_h_stn_chairstrip_01",
			"apa_mp_h_stn_chairstrip_02",
			"apa_mp_h_stn_chairstrip_03",
			"apa_mp_h_stn_chairstrip_04",
			"apa_mp_h_stn_chairstrip_05",
			"apa_mp_h_stn_chairstrip_06",
			"apa_mp_h_stn_chairstrip_07",
			"apa_mp_h_stn_chairstrip_08",
			"apa_mp_h_yacht_armchair_01",
			"apa_mp_h_yacht_armchair_03",
			"apa_mp_h_yacht_armchair_04",
			"apa_mp_h_yacht_strip_chair_01",
			"bkr_prop_biker_chair_01",
			"bkr_prop_biker_chairstrip_02",
			"bkr_prop_clubhouse_armchair_01a",
			"bkr_prop_clubhouse_chair_03",
			"bkr_prop_weed_chair_01a",
			"ex_mp_h_off_easychair_01",
			"ex_mp_h_stn_chairarm_03",
			"ex_mp_h_stn_chairarm_24",
			"ex_mp_h_stn_chairstrip_010",
			"ex_mp_h_stn_chairstrip_05",
			"ex_mp_h_stn_chairstrip_07",
			"hei_heist_din_chair_01",
			"hei_heist_din_chair_02",
			"hei_heist_din_chair_03",
			"hei_heist_din_chair_04",
			"hei_heist_din_chair_05",
			"hei_heist_din_chair_06",
			"hei_heist_din_chair_08",
			"hei_heist_din_chair_09",
			"hei_heist_stn_chairarm_01",
			"hei_heist_stn_chairarm_03",
			"hei_heist_stn_chairarm_04",
			"hei_heist_stn_chairarm_06",
			"hei_heist_stn_chairstrip_01",
			"hei_prop_heist_off_chair",
			"p_clb_officechair_s",
			"p_ilev_p_easychair_s",
			"prop_armchair_01",
			"prop_chair_01a",
			"prop_chair_01b",
			"prop_chair_02",
			"prop_chair_03",
			"prop_chair_04a",
			"prop_chair_04b",
			"prop_chair_05",
			"prop_chair_06",
			"prop_chair_07",
			"prop_chair_09",
			"prop_chair_10",
			"prop_clown_chair",
			"prop_cs_office_chair",
			"prop_off_chair_01",
			"prop_off_chair_05",
			"prop_sol_chair",
			"v_corp_cd_chair",
			"v_corp_offchair",
			"v_ilev_hd_chair",
			"sm_prop_offchair_smug_02"
	},
})

Register("Exercise Equipment", {
	Stackable = {
		Structure = true,
		Foundation = true,
		Block = true,
	},
	Model = {
			"prop_barbell_100kg",
			"prop_barbell_30kg",
			"prop_exer_bike_01",
			"prop_muscle_bench_03",
			"prop_punch_bag_l",
			"prop_weight_rack_02",
	},
})

Register("Tableware", {
	Stackable = {
		Structure = true,
		Foundation = false,
		Block = true,
	},
	Model = {
			"prop_cs_champ_flute",
			"prop_mug_02",
			"v_res_mplatelrg",
			"v_res_mplatesml",
			"prop_fruit_basket",
			"prop_kettle",
			"prop_kettle_01",
			"prop_cocktail",
	},
})

Register("Pallet", {
	Stackable = {
		Structure = true,
		Foundation = true,
		Block = true,
	},
	Model = {
			"prop_air_stair_02",
			"prop_air_woodsteps",
			"prop_boxpile_05a",
			"prop_boxpile_06a",
			"prop_boxpile_07d",
			"prop_pallet_01a",
			"prop_pallet_02a",
			"prop_pallet_03a",
	},
})

Register("Generator", {
	Stackable = {
		Structure = false,
		Foundation = false,
		Block = true,
	},
	Model = {
		{
			Name = "prop_generator_01a",
		},
	},
})
