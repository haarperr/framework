Config = {
    -- set NearbyTip to false to disable
    NearbyTip = false,
    Embeds = {
        YouTube = "https://loaf-scripts.com/fivem/loaf_tv/youtube.php?video=%s&time=TIME_PASSED",
        Twitch = "https://loaf-scripts.com/fivem/loaf_tv/twitch.php?channel=%s",
        MP4 = "https://loaf-scripts.com/fivem/loaf_tv/mp4.php?video=%s&time=TIME_PASSED",
        BiliBili = "https://player.bilibili.com/player.html?bvid=%s&high_quality=1&as_wide=1&autoplay=1&t=TIME_PASSED",
    },
    DuiPositions = {
        YouTube = {
            Volume = {
                Initial = vector2(80, 700),
                Stages = {
                    vector2(99, 700),
                    vector2(149, 700)
                },
            },
            Idle = vector2(1280, 720),
        },
        Twitch = {
            Confirm = vector2(640, 440),
            Volume = {
                Initial = vector2(55, 695),
                Stages = {
                    vector2(70, 695),
                    vector2(179, 695)
                },
            },
            Idle = vector2(1280, 720),
        },
        MP4 = {
            Idle = vector2(1280, 720),
        },
        BiliBili = {
            Idle = vector2(1280, 720),
            Volume = {
                Initial = vector2(1130, 665),
                Stages = {
                    vector2(1130, 640),
                    vector2(1130, 585)
                }
            }
        }
    },
    Objects = {
        {
            Model = `prop_tv_flat_01`,
            Distance = 7.5,
            Draw = "tvscreen", -- scaleform or the rendertarget
        },
        {
            Model = `prop_tv_flat_michael`,
            Distance = 7.5,
            Draw = "tvscreen",
        },
        {
            Model = `prop_trev_tv_01`,
            Distance = 7.5,
            Draw = "tvscreen",
        },
        {
            Model = `prop_tv_flat_03b`,
            Distance = 7.5,
            Draw = "tvscreen",
        },
        {
            Model = `prop_tv_flat_03`,
            Distance = 7.5,
            Draw = "tvscreen",
        },
        {
            Model = `prop_tv_flat_02b`,
            Distance = 7.5,
            Draw = "tvscreen"
        },
        {
            Model = `prop_tv_flat_02`,
            Distance = 7.5,
            Draw = "tvscreen"
        },
        {
            Model = `v_ilev_cin_screen`,
            Distance = 50.0,
            Draw = "cinscreen"
        },
        {
            Model = 1522819744,
            Distance = 50.0,
            Draw = "cinscreen"
        },
        {
            Model = `des_tvsmash_start`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `des_tvsmash_root`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `des_tvsmash_end`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_cs_tv_stand`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_flatscreen_overlay`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_laptop_lester2`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_monitor_02`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_tv_02`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_tv_03_overlay`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_tv_06`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_tv_flat_01_screen`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_monitor_w_large`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `prop_tv_03`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `hei_prop_hst_laptop`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `hei_bank_heist_laptop`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `hei_heist_str_avunitl_03`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `hei_heist_str_avunits_01`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `hei_heist_str_avunitl_01`,
            Distance = 10.0,
            Draw = "tvscreen"
        },
        {
            Model = `xm_prop_x17dlc_monitor_wall_01a`,
            Distance = 10.0,
            Draw = "prop_x17dlc_monitor_wall_01a"
        },
        {
            Model = `prop_big_cin_screen`,
            Distance = 10.0,
            Draw = "cinscreen"
        },
        {
            Model = `xm_prop_x17_tv_flat_01`,
            Distance = 10.0,
            Draw = "tv_flat_01"
        },
        {
            Model = `sm_prop_smug_tv_flat_01`,
            Distance = 10.0,
            Draw = "tv_flat_01"
        },
        {
            Model = `xm_prop_x17_tv_stand_01a`,
            Distance = 10.0,
            Draw = "tvstand_screen"
        },
        {
            Model = `xm_prop_x17_screens_02a_01`,
            Distance = 10.0,
            Draw = "prop_x17_8scrn_01"
        },
        {
            Model = `xm_prop_x17_screens_02a_02`,
            Distance = 10.0,
            Draw = "prop_x17_8scrn_02"
        },
        {
            Model = `xm_prop_x17_screens_02a_03`,
            Distance = 10.0,
            Draw = "prop_x17_8scrn_03"
        },
        {
            Model = `xm_prop_x17_screens_02a_04`,
            Distance = 10.0,
            Draw = "prop_x17_8scrn_04"
        },
        {
            Model = `xm_prop_x17_screens_02a_05`,
            Distance = 10.0,
            Draw = "prop_x17_8scrn_05"
        },
        {
            Model = `xm_prop_x17_screens_02a_06`,
            Distance = 10.0,
            Draw = "prop_x17_8scrn_06"
        },
        {
            Model = `xm_prop_x17_screens_02a_07`,
            Distance = 10.0,
            Draw = "prop_x17_8scrn_07"
        },
        {
            Model = `xm_prop_x17_screens_02a_08`,
            Distance = 10.0,
            Draw = "prop_x17_8scrn_08"
        },
        {
            Model = `xm_prop_x17_tv_ceiling_scn_01`,
            Distance = 10.0,
            Draw = "prop_x17_tv_ceil_scn_01"
        },
        {
            Model = `xm_prop_x17_tv_ceiling_scn_02`,
            Distance = 10.0,
            Draw = "prop_x17_tv_ceil_scn_02"
        },
        {
            Model = `xm_prop_x17_tv_scrn_01`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_01"
        },
        {
            Model = `xm_prop_x17_tv_scrn_02`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_02"
        },
        {
            Model = `xm_prop_x17_tv_scrn_03`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_03"
        },
        {
            Model = `xm_prop_x17_tv_scrn_04`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_04"
        },
        {
            Model = `xm_prop_x17_tv_scrn_05`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_05"
        },
        {
            Model = `xm_prop_x17_tv_scrn_06`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_06"
        },
        {
            Model = `xm_prop_x17_tv_scrn_07`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_07"
        },
        {
            Model = `xm_prop_x17_tv_scrn_08`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_08"
        },
        {
            Model = `xm_prop_x17_tv_scrn_09`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_09"
        },
        {
            Model = `xm_prop_x17_tv_scrn_10`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_10"
        },
        {
            Model = `xm_prop_x17_tv_scrn_11`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_11"
        },
        {
            Model = `xm_prop_x17_tv_scrn_12`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_12"
        },
        {
            Model = `xm_prop_x17_tv_scrn_13`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_13"
        },
        {
            Model = `xm_prop_x17_tv_scrn_14`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_14"
        },
        {
            Model = `xm_prop_x17_tv_scrn_15`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_15"
        },
        {
            Model = `xm_prop_x17_tv_scrn_16`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_16"
        },
        {
            Model = `xm_prop_x17_tv_scrn_17`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_17"
        },
        {
            Model = `xm_prop_x17_tv_scrn_18`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_18"
        },
        {
            Model = `xm_prop_x17_tv_scrn_19`,
            Distance = 10.0,
            Draw = "prop_x17_tv_scrn_19"
        },
        {
            Model = `xm_screen_1`,
            Distance = 10.0,
            Draw = "prop_x17_tv_ceiling_01"
        },
        {
            Model = `ex_prop_ex_tv_flat_01`,
            Distance = 10.0,
            Draw = "ex_tvscreen"
        },
    }
}