AddCSLuaFile()

----------- CUSTOMIZATION -----------
sound.Add({
    name =            "MW.Flashlight",
    channel =        234,
    volume =      1,
    pitch = 100,
    sound = {"viper/shared/flashlight.wav"}
})

sound.Add({
    name =           "wpn_shotgun_fire_lyr",
    channel =        CHAN_WEAPON +1,
    level = 140,
    volume =         0.5,
    pitch = {80,110},
    sound = {"viper/shared/wpn_shotgun_fire_lyr_01.ogg",
             "viper/shared/wpn_shotgun_fire_lyr_02.ogg",
             "viper/shared/wpn_shotgun_fire_lyr_04.ogg"}              
})

sound.Add({
    name =           "wpn_generic_fire_first",
    channel =        CHAN_TRIGGER,
    level = 55,
    volume =         0.2,
    pitch = {80,110},
    sound = {"viper/shared/foley/triggers/weap_generic_fire_first.ogg"}              
})

sound.Add({
    name =           "wpn_generic_disconnector",
    channel =        CHAN_TRIGGER,
    level = 55,
    volume =         0.2,
    pitch = {80,110},
    sound = {"viper/shared/foley/triggers/weap_generic_disconnector.ogg"}              
})

-- Sound: 8
sound.Add({
	name = "wpn_gbl_plr_inspect_mvmnt_sml",
	channel = CHAN_WPNFOLEY + 1,
	level = 55,
	volume = 1,
	pitch = {90,100},
	sound = {
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_01.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_02.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_03.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_04.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_05.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_06.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_07.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_08.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_09.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_10.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_11.ogg",
		"viper/shared/s4/wpn_gbl_plr_inspect_settle_12.ogg",
		}
})

-- Sound: 8
sound.Add({
	name = "wpn_gbl_plr_inspect_smg_swipe",
	channel = CHAN_WPNFOLEY + 1,
	level = 55,
	volume = 1,
	pitch = {90,100},
	sound = {
		"viper/shared/s4/wpn_smg_insp_swipe_01.ogg",
		"viper/shared/s4/wpn_smg_insp_swipe_02.ogg",
		"viper/shared/s4/wpn_smg_insp_swipe_03.ogg",
		}
})

----------- BASHING ------------

sound.Add({
	name = 			"MW_Melee.Miss_Knife",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_attack_knife_plr_01.ogg",
	"viper/shared/melee/melee_attack_knife_plr_02.ogg",
	"viper/shared/melee/melee_attack_knife_plr_03.ogg",
	"viper/shared/melee/melee_attack_knife_plr_04.ogg",
	"viper/shared/melee/melee_attack_knife_plr_05.ogg",
	"viper/shared/melee/melee_attack_knife_plr_06.ogg",
	}
})

sound.Add({
	name = 			"MW_Melee.Miss_Large",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_attack_gun_lrg_plr_01.wav",
	"viper/shared/melee/melee_attack_gun_lrg_plr_02.wav",
	"viper/shared/melee/melee_attack_gun_lrg_plr_03.wav",
	"viper/shared/melee/melee_attack_gun_lrg_plr_04.wav",
	"viper/shared/melee/melee_attack_gun_lrg_plr_05.wav",
	"viper/shared/melee/melee_attack_gun_lrg_plr_06.wav",
	}
})

sound.Add({
	name = 			"MW_Melee.Miss_Medium",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_attack_gun_med_plr_01.wav",
	"viper/shared/melee/melee_attack_gun_med_plr_02.wav",
	"viper/shared/melee/melee_attack_gun_med_plr_03.wav",
	"viper/shared/melee/melee_attack_gun_med_plr_04.wav",
	"viper/shared/melee/melee_attack_gun_med_plr_05.wav",
	"viper/shared/melee/melee_attack_gun_med_plr_06.wav",
	}
})

sound.Add({
	name = 			"MW_Melee.Miss_Small",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_attack_gun_sml_plr_01.wav",
	"viper/shared/melee/melee_attack_gun_sml_plr_02.wav",
	"viper/shared/melee/melee_attack_gun_sml_plr_03.wav",
	"viper/shared/melee/melee_attack_gun_sml_plr_04.wav",
	"viper/shared/melee/melee_attack_gun_sml_plr_05.wav",
	"viper/shared/melee/melee_attack_gun_sml_plr_06.wav",
	}
})

sound.Add({
	name = 			"MW_Melee.World_Large",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_world_gun_lrg_polymer_cement_plr_01.wav",
	"viper/shared/melee/melee_world_gun_lrg_polymer_cement_plr_02.wav",
	"viper/shared/melee/melee_world_gun_lrg_polymer_cement_plr_03.wav",
	"viper/shared/melee/melee_world_gun_lrg_polymer_cement_plr_04.wav",
	"viper/shared/melee/melee_world_gun_lrg_polymer_cement_plr_05.wav",
	}
})

sound.Add({
	name = 			"MW_Melee.World_Medium",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_world_gun_med_polymer_cement_plr_01.wav",
	"viper/shared/melee/melee_world_gun_med_polymer_cement_plr_02.wav",
	"viper/shared/melee/melee_world_gun_med_polymer_cement_plr_03.wav",
	"viper/shared/melee/melee_world_gun_med_polymer_cement_plr_04.wav",
	}
})

sound.Add({
	name = 			"MW_Melee.World_Small",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_world_gun_sml_polymer_cement_plr_01.wav",
	"viper/shared/melee/melee_world_gun_sml_polymer_cement_plr_02.wav",
	"viper/shared/melee/melee_world_gun_sml_polymer_cement_plr_03.wav",
	"viper/shared/melee/melee_world_gun_sml_polymer_cement_plr_04.wav",
	"viper/shared/melee/melee_world_gun_sml_polymer_cement_plr_05.wav",
	}
})

sound.Add({
	name = 			"MW_Melee.World_Knife",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_world_knife_cement_plr_01.ogg",
	"viper/shared/melee/melee_world_knife_cement_plr_02.ogg",
	"viper/shared/melee/melee_world_knife_cement_plr_03.ogg",
	"viper/shared/melee/melee_world_knife_cement_plr_04.ogg",
	"viper/shared/melee/melee_world_knife_cement_plr_05.ogg",
	}
})

sound.Add({
	name = 			"MW_Melee.Flesh_Large",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_character_gun_lrg_steel_plr_01.wav",
	"viper/shared/melee/melee_character_gun_lrg_steel_plr_02.wav",
	"viper/shared/melee/melee_character_gun_lrg_steel_plr_03.wav",
	"viper/shared/melee/melee_character_gun_lrg_steel_plr_04.wav",
	"viper/shared/melee/melee_character_gun_lrg_steel_plr_05.wav",
	}
})

sound.Add({
	name = 			"MW_Melee.Flesh_Medium",
	channel = 		CHAN_WEAPON +10,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_character_gun_med_steel_plr_01.wav",
	"viper/shared/melee/melee_character_gun_med_steel_plr_02.wav",
	"viper/shared/melee/melee_character_gun_med_steel_plr_03.wav",
	"viper/shared/melee/melee_character_gun_med_steel_plr_04.wav",
	"viper/shared/melee/melee_character_gun_med_steel_plr_05.wav",
	}
})

sound.Add({
	name = 			"MW_Melee.Flesh_Small",
	channel = 		CHAN_WEAPON,
	volume = 		1.0,
	sound = 			{
	"viper/shared/melee/melee_character_gun_sml_steel_plr_01.wav",
	"viper/shared/melee/melee_character_gun_sml_steel_plr_02.wav",
	"viper/shared/melee/melee_character_gun_sml_steel_plr_03.wav",
	"viper/shared/melee/melee_character_gun_sml_steel_plr_04.wav",
	"viper/shared/melee/melee_character_gun_sml_steel_plr_05.wav",
	}
})


sound.Add({
    name =          "MW_Fist.Miss",
    channel =       CHAN_WEAPON,
    volume =        1.0,
    sound =             {
    "viper/shared/melee/melee_attack_fist_plr_01.ogg",
    "viper/shared/melee/melee_attack_fist_plr_02.ogg",
    "viper/shared/melee/melee_attack_fist_plr_03.ogg",
    "viper/shared/melee/melee_attack_fist_plr_04.ogg",
    "viper/shared/melee/melee_attack_fist_plr_05.ogg",
    "viper/shared/melee/melee_attack_fist_plr_06.ogg",
    "viper/shared/melee/melee_attack_fist_plr_07.ogg",
    "viper/shared/melee/melee_attack_fist_plr_08.ogg",
    }
})

sound.Add({
    name =          "MW_Fist.HitPlayer",
    channel =       CHAN_WEAPON,
    volume =        1.0,
    sound =             {
    "viper/shared/melee/melee_character_fist_plr_01.ogg",
    "viper/shared/melee/melee_character_fist_plr_02.ogg",
    "viper/shared/melee/melee_character_fist_plr_03.ogg",
    "viper/shared/melee/melee_character_fist_plr_04.ogg",
    "viper/shared/melee/melee_character_fist_plr_05.ogg",
    "viper/shared/melee/melee_character_fist_plr_06.ogg",
    "viper/shared/melee/melee_character_fist_plr_07.ogg",
    "viper/shared/melee/melee_character_fist_plr_08.ogg",    
    "viper/shared/melee/melee_character_fist_plr_09.ogg",
    "viper/shared/melee/melee_character_fist_plr_10.ogg",
    "viper/shared/melee/melee_character_fist_plr_11.ogg",
    }
})

sound.Add({
    name =          "MW_Fist.HitWorld",
    channel =       CHAN_WEAPON,
    volume =        1.0,
    sound =             {
    "viper/shared/melee/melee_world_fist_soft_plr_01.ogg",
    "viper/shared/melee/melee_world_fist_soft_plr_02.ogg",
    "viper/shared/melee/melee_world_fist_soft_plr_03.ogg",
    "viper/shared/melee/melee_world_fist_soft_plr_04.ogg",
    "viper/shared/melee/melee_world_fist_soft_plr_05.ogg",
    }
})

sound.Add({
    name =          "Canted.On",
    channel =       CHAN_WPNFOLEY,
    volume =        1,
    sound =             {
    --"viper/shared/foley/wfoly_plr_hybrid_scope_side_on.ogg",
    "switchsights/switch1.wav",
    "switchsights/switch3.wav"
    }
})
sound.Add({
    name =          "Canted.Off",
    channel =       CHAN_WPNFOLEY,
    volume =        1,
    sound =             {
    --"viper/shared/foley/wfoly_plr_hybrid_scope_side_off.ogg",
    "switchsights/switch2.wav",
    "switchsights/switch5.wav"
    }
})

sound.Add({
    name =          "Flipsight.Up",
    channel =       CHAN_WPNFOLEY,
    volume =        1.0,
    sound =             {
    "viper/shared/foley/wpfoly_hybrid_toggle_on.ogg",
     }
})
sound.Add({
    name =          "Flipsight.Down",
    channel =       CHAN_WPNFOLEY,
    volume =        1.0,
    sound =             {
    "viper/shared/foley/wpfoly_hybrid_flip_down_v1.ogg",
     }
})



sound.Add({
    name =          "Viewmodel.Small",
    channel =       CHAN_WPNFOLEY +35,
    volume =        1.0,
    sound =             {
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_01.ogg",
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_02.ogg",
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_03.ogg",
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_04.ogg",
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_05.ogg",
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_06.ogg",
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_07.ogg",
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_08.ogg",
    "viper/shared/weapmvmt/small/gear_rattle_weap_small_09.ogg",
     }
})
sound.Add({
    name =          "Viewmodel.Medium",
    channel =       CHAN_WPNFOLEY +36,
    volume =        1.0,
    sound =             {
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_01.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_02.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_03.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_04.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_05.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_06.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_07.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_08.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_09.ogg",
        "viper/shared/weapmvmt/medium_new/gear_rattle_weap_medium_10.ogg",
     }
})
sound.Add({
    name =          "Viewmodel.Large",
    channel =       CHAN_WPNFOLEY +37,
    volume =        1.0,
    sound =             {
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_01.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_02.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_03.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_04.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_05.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_06.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_07.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_08.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_09.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_10.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_11.ogg",
        "viper/shared/weapmvmt/large_new/gear_rattle_weap_large_12.ogg",
     }
})
sound.Add({
    name =          "Viewmodel.Launcher",
    channel =       CHAN_WPNFOLEY +15,
    volume =        1.0,
    sound =             {
        "viper/shared/weapmvmt/launcher/gear_rattle_weap_launcher_01.ogg",
        "viper/shared/weapmvmt/launcher/gear_rattle_weap_launcher_02.ogg",
        "viper/shared/weapmvmt/launcher/gear_rattle_weap_launcher_03.ogg",
        "viper/shared/weapmvmt/launcher/gear_rattle_weap_launcher_04.ogg",
        "viper/shared/weapmvmt/launcher/gear_rattle_weap_launcher_05.ogg",
        "viper/shared/weapmvmt/launcher/gear_rattle_weap_launcher_06.ogg",
        "viper/shared/weapmvmt/launcher/gear_rattle_weap_launcher_07.ogg",
        "viper/shared/weapmvmt/launcher/gear_rattle_weap_launcher_08.ogg",
     }
})

sound.Add({
    name =          "Viewmodel.BipodDeploy",
    channel =       159,
    volume =        1.0,
    sound =             {
        "mount/enter1.wav",
        "mount/enter2.wav",
        "mount/enter3.wav",
        "mount/enter4.wav",
        "mount/enter5.wav"
    }
})

sound.Add({
    name =          "Viewmodel.BipodExit",
    channel =       159,
    volume =        1.0,
    sound =             {
        "mount/exit1.wav",
        "mount/exit2.wav",
        "mount/exit3.wav",
        "mount/exit4.wav"
    }
})

sound.Add({
    name =          "MW_MagazineDrop.AK.Metal",
    channel =       CHAN_MAGAZINEDROP,
    volume =        1.0,
    sound =             {
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_metal_concrete_01.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_metal_concrete_02.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_metal_concrete_03.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_metal_concrete_04.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_metal_concrete_05.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_metal_concrete_06.ogg",
    }
})

sound.Add({
    name =          "MW_MagazineDrop.AK.Poly",
    channel =       CHAN_MAGAZINEDROP,
    volume =        1.0,
    sound =             {
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_poly_concrete_01.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_poly_concrete_02.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_poly_concrete_03.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_poly_concrete_04.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_poly_concrete_05.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ak_poly_concrete_06.ogg",
    }
})

sound.Add({
    name =          "MW_MagazineDrop.AR.Metal",
    channel =       CHAN_MAGAZINEDROP,
    volume =        1.0,
    sound =             {
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_metal_concrete_01.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_metal_concrete_02.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_metal_concrete_03.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_metal_concrete_04.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_metal_concrete_05.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_metal_concrete_06.ogg",
    }
})

sound.Add({
    name =          "MW_MagazineDrop.AR.Poly",
    channel =       CHAN_MAGAZINEDROP,
    volume =        1.0,
    sound =             {
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_poly_concrete_01.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_poly_concrete_02.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_poly_concrete_03.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_poly_concrete_04.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_poly_concrete_05.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_ar_poly_concrete_06.ogg",
    }
})

sound.Add({
    name =          "MW_MagazineDrop.Drum",
    channel =       CHAN_MAGAZINEDROP,
    volume =        1.0,
    sound =             {
    "viper/shared/magazine_drops/iw8_phys_mag_drop_large_drum_concrete_01.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_large_drum_concrete_02.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_large_drum_concrete_03.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_large_drum_concrete_04.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_large_drum_concrete_05.ogg",
    }
})

sound.Add({
    name =          "MW_MagazineDrop.SMG.Metal",
    channel =       CHAN_MAGAZINEDROP,
    volume =        1.0,
    sound =             {
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_metal_concrete_01.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_metal_concrete_02.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_metal_concrete_03.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_metal_concrete_04.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_metal_concrete_05.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_metal_concrete_06.ogg",
    }
})

sound.Add({
    name =          "MW_MagazineDrop.SMG.Poly",
    channel =       CHAN_MAGAZINEDROP,
    volume =        1.0,
    sound =             {
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_poly_concrete_01.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_poly_concrete_02.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_poly_concrete_03.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_poly_concrete_04.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_poly_concrete_05.ogg",
    "viper/shared/magazine_drops/iw8_phys_mag_drop_smg_poly_concrete_06.ogg",
    }
})