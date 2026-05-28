AddCSLuaFile()

-- Sound: 16
sound.Add({
	name = "weap_golf21_fire_plr",
	channel = CHAN_WEAPON,
	level = 140,
	volume = 1,
	pitch = {100,100},
	sound = 
		"^weapons/golf21/weap_golf21_fire_plr_01.wav"		
})

sound.Add({
	name = "weap_golf21_fire_first",
	channel = CHAN_WPNFOLEY,
	volume = 1,
	pitch = {100,100},
	sound = {
		"weapons/golf21/weap_golf21_fire_first_plr_01.ogg",
		}
})
sound.Add({
	name = "weap_golf21_fire_disconnector",
	channel = CHAN_WPNFOLEY +1,
	volume = 1,
	pitch = {100,100},
	sound = {
		"weapons/golf21/weap_golf21_disconnector_plr_01.ogg",
		}
})

-- Sound: 40
sound.Add({
	name = "weap_golf21_sup_plr",
	channel = CHAN_WEAPON,
	level = 140,
	volume = 1,
	pitch = {100,100},
	sound = {
		"weapons/golf21/weap_golf21_supp_plr_01.ogg",
		}
})
-- Sound: 45
sound.Add({
	name = "weap_golf21_sup1_last_plr_mech",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"weapons/iw8_golf21/weap_golf21_fire_last_plr_mech_01.ogg",
		"weapons/iw8_golf21/weap_golf21_fire_last_plr_mech_02.ogg",
		"weapons/iw8_golf21/weap_golf21_fire_last_plr_mech_03.ogg",
		}
})
-- Sound: 48
sound.Add({
	name = "weap_golf21_sup1_plr_lfe",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"weapons/iw8_golf21/weap_golf21_sup_plr_lfe.ogg",
		}
})
-- Sound: 53
sound.Add({
	name = "weap_golf21_sup2_last_plr_mech",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"weapons/iw8_golf21/weap_golf21_fire_last_plr_mech_01.ogg",
		"weapons/iw8_golf21/weap_golf21_fire_last_plr_mech_02.ogg",
		"weapons/iw8_golf21/weap_golf21_fire_last_plr_mech_03.ogg",
		}
})
-- Sound: 56
sound.Add({
	name = "weap_golf21_sup2_plr_lfe",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"weapons/iw8_golf21/weap_golf21_sup_plr_lfe.ogg",
		}
})
-- Sound: 58
sound.Add({
	name = "weap_pi_golf21_ads_down",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_ads_down.ogg",
		}
})
-- Sound: 59
sound.Add({
	name = "weap_pi_golf21_ads_up",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_ads_up.ogg",
		}
})
-- Sound: 60
sound.Add({
	name = "wfoly_pi_golf21_reload_empty_fast_01",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_magout_01.ogg",
		}
})
-- Sound: 61
sound.Add({
	name = "wfoly_pi_golf21_reload_empty_fast_02",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_magin_v2_01.ogg",
		}
})
-- Sound: 62
sound.Add({
	name = "wfoly_pi_golf21_reload_empty_fast_025",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_magin_v2_02.ogg",
		}
})
-- Sound: 63
sound.Add({
	name = "wfoly_pi_golf21_reload_empty_fast_03",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_chamber_01.ogg",
		}
})
-- Sound: 64
sound.Add({
	name = "wfoly_pi_golf21_reload_empty_fast_04",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_end.ogg",
		}
})
-- Sound: 65
sound.Add({
	name = "wfoly_plr_pi_golf21_drop_01",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_drop.ogg",
		}
})
-- Sound: 66
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_01",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_01.ogg",
		}
})
-- Sound: 67
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_02",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_02.ogg",
		}
})
-- Sound: 68
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_03",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_03.ogg",
		}
})
-- Sound: 69
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_04",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_04.ogg",
		}
})
-- Sound: 70
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_empty_01",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_empty_01.ogg",
		}
})
-- Sound: 71
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_empty_02",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_empty_02.ogg",
		}
})
-- Sound: 72
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_empty_03",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_empty_03.ogg",
		}
})
-- Sound: 73
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_empty_04",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_empty_04.ogg",
		}
})
-- Sound: 74
sound.Add({
	name = "wfoly_plr_pi_golf21_farah_reload_empty_05",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_farah_reload_empty_05.ogg",
		}
})
-- Sound: 75
sound.Add({
	name = "wfoly_plr_pi_golf21_inspect_01",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_inspect_01.ogg",
		}
})
-- Sound: 76
sound.Add({
	name = "wfoly_plr_pi_golf21_inspect_02",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_inspect_02.ogg",
		}
})
-- Sound: 77
sound.Add({
	name = "wfoly_plr_pi_golf21_inspect_03",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_inspect_03.ogg",
		}
})
-- Sound: 78
sound.Add({
	name = "wfoly_plr_pi_golf21_inspect_04",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_inspect_04.ogg",
		}
})
-- Sound: 79
sound.Add({
	name = "wfoly_plr_pi_golf21_raise_01",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_raise.ogg",
		}
})
-- Sound: 79
sound.Add({
	name = "wfoly_plr_pi_golf21_first_raise_01",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_first_raise_open_slide.ogg",
		}
})
-- Sound: 79
sound.Add({
	name = "wfoly_plr_pi_golf21_first_raise_02",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_first_raise_slide_release.ogg",
		}
})
-- Sound: 80
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_01",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_magout_01.ogg",
		}
})
-- Sound: 81
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_02",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_magin_v2_01.ogg",
		}
})
-- Sound: 82
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_025",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_magin_v2_02.ogg",
		}
})
-- Sound: 83
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_03",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_end.ogg",
		}
})
-- Sound: 84
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_01",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_magout_01.ogg",
		}
})
-- Sound: 85
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_02",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_raise.ogg",
		}
})
-- Sound: 86
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_03",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_magin_v2_01.ogg",
		}
})
-- Sound: 87
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_035",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_magin_v2_02.ogg",
		}
})
-- Sound: 88
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_04",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_down.ogg",
		}
})
-- Sound: 89
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_05",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_chamber.ogg",
		}
})
-- Sound: 90
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_06",
	channel = CHAN_WPNFOLEY + 8,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_end.ogg",
		}
})
-- Sound: 91
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_fast_01",
	channel = CHAN_WPNFOLEY + 9,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_magout_01.ogg",
		}
})
-- Sound: 92
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_fast_02",
	channel = CHAN_WPNFOLEY + 10,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_magin_v2_01.ogg",
		}
})
-- Sound: 93
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_fast_025",
	channel = CHAN_WPNFOLEY + 1,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_magin_v2_02.ogg",
		}
})
-- Sound: 94
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_fast_03",
	channel = CHAN_WPNFOLEY + 2,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_chamber_01.ogg",
		}
})
-- Sound: 95
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_empty_fast_04",
	channel = CHAN_WPNFOLEY + 3,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_empty_fast_end.ogg",
		}
})
-- Sound: 96
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_fast_01",
	channel = CHAN_WPNFOLEY + 4,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_fast_magout_01.ogg",
		}
})
-- Sound: 97
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_fast_02",
	channel = CHAN_WPNFOLEY + 5,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_fast_magin_v2_01.ogg",
		}
})
-- Sound: 98
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_fast_025",
	channel = CHAN_WPNFOLEY + 6,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_fast_magin_v2_02.ogg",
		}
})
-- Sound: 99
sound.Add({
	name = "wfoly_plr_pi_golf21_reload_fast_03",
	channel = CHAN_WPNFOLEY + 7,
	
	volume = 1,
	pitch = {100,100},
	sound = {
		"reloads/iw8_golf21/wfoly_pi_golf21_reload_fast_end.ogg",
		}
})
