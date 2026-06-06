// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/mp_vm_gloves_hutch_iw9_1_1.mdl"

$bodygroup "gloves"
{
	studio "mp_vm_gloves_hutch_iw9_1_1.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MWII\rigs\arms\"
$cdmaterials "viper\MWII\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -10.524 -30.516 0 30.58 23.52 77.202

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.11342 0 68.822403 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.96728 0 -12.63242 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -15.315979 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -5.207691 0.500402 -179.258943 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.070091 -0.000038 -0.000006 0 0 -0.000057 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 18.363895 -0.000548 -0.000116 0.000458 6.83023 0.000057 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 18.991829 0.316155 0.000027 -0.000057 -66.403352 0.000057 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.792473 0.000351 0.000001 0 -29.682653 0 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.01914 0.320777 0 -0.000115 -3.413855 0 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 10.699877 -0.000392 -0.000067 0.000458 -0.000458 -0.000057 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 5.207691 0.500402 -179.258943 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.070095 -0.000037 -0.000006 0 0 -0.000057 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 13.143406 1.692077 -5.024804 -4.968861 5.166876 83.781839 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 18.363897 -0.000548 -0.000116 0.000458 6.83023 0.000057 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 18.991831 0.316156 0.000026 -0.000057 -66.403352 0.000057 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.792474 0.000351 0.000001 0 -29.682653 0 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.019142 0.320778 -0.000001 -0.000115 -3.413855 0 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 10.164825 0.000163 -0.000063 0.000458 -0.000229 -0.000057 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.780312 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.6875 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.848171 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.389587 -0.022471 -2.079011 88.66035 -66.291453 -66.286863 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 6.189539 -0.000034 0.000298 47.371347 -14.201163 -4.287554 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.535244 0.000145 -0.000057 -0.000004 0.000169 -0.000172 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 12.33736 -0.000278 0.000225 -0.000173 -46.966321 0.00023 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 11.342063 -0.000378 -0.000694 0 0 0 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" -1.225715 0.000141 0.000725 0 0.000056 0.000002 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.917731 0.111364 0.112011 9.392152 0.781 1.348746 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.814168 -0.000393 -0.000713 0 0 0.000058 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -10.251489 -29.812637 -39.78746 -7.073508 -32.571676 46.574763 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -10.251489 -29.812637 -39.78746 -7.073508 -32.571676 46.574763 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.653027 -1.005306 0.075207 -8.024845 -10.060625 -94.84193 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.802986 0.000156 0.000435 -1.154223 20.059139 11.551178 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.99861 -0.000076 -0.00057 0.000804 26.530984 0.000575 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.984411 -0.00032 -0.000441 0.000402 36.229267 -0.000511 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.641457 0.428749 0.000259 -0.000002 0 0.000005 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.284485 0.42683 -0.000801 0.922464 0.407948 -0.541897 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000116 0.106655 -0.000948 -1.255921 -12.010396 -6.877382 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.684745 -0.213093 0.064384 -7.528035 -3.8049 -95.452761 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.845737 0.000114 -0.000895 -1.908525 27.378612 1.569103 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.149404 -0.000099 -0.000246 -0.000516 56.058419 0.000002 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.176666 -0.000461 0.00013 0.000457 26.567488 0.000575 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000235 0.105927 0.000219 0.620514 -13.706069 -1.078649 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.642196 1.155878 -0.363251 1.189861 6.154256 -99.58648 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.35372 0.000561 0.000145 0.001146 35.990623 -0.000058 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.261873 0.000242 -0.00071 -0.000459 42.582053 -0.00092 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.727741 -0.00131 0.000479 -0.000633 31.299718 -0.000633 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000212 0.1066 -0.000032 -0.001431 -17.996439 0.000171 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.641391 1.025806 -0.321733 -0.000343 0.000458 -10.000981 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.65244 0.428179 -0.010059 -3.531193 2.461885 -100.970755 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.73964 -0.000168 0.000031 -2.901231 29.877225 0.141468 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.828365 0.000767 -0.000223 0.000396 47.511489 0.000516 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.091393 -0.000848 -0.000225 -0.000406 32.470955 -0.0004 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000143 0.107464 0.000343 1.326338 -14.945659 -0.625092 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.673808 -0.738346 -0.245853 34.800709 -67.797523 4.999796 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.246403 0.000512 -0.000435 16.616805 31.034088 -13.889995 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.380302 -0.000243 0.000637 -0.000061 21.034428 0.000104 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.641884 0.428195 -0.000034 -0.000002 0.000058 0.000106 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 1.069517 0.000404 -1.294903 -0.000005 0.000005 -0.000061 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.460646 -2.674988 -0.641434 12.692958 -30.211549 51.108116 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 0.695426 -0.586678 0.100204 -7.528321 -6.420565 -95.450248 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 2.032062 0.00045 -0.000477 -1.908067 27.37838 1.56945 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 0.70307 0.008987 0.043198 -7.528777 -0.000803 -95.452133 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.925635 -0.000263 0.000242 -1.908923 27.378557 1.569394 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.925635 -0.000263 0.000242 -1.908923 27.378557 1.569394 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.925635 -0.000263 0.000242 -1.908923 27.378557 1.569394 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 0.712379 0.799526 -0.031239 -7.528777 5.441496 -95.451627 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 2.033334 -0.00016 -0.000549 -1.908463 27.378386 1.56922 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 4.279402 -0.000574 -0.000359 0 0 0.000058 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.127554 -0.295065 -0.00016 0.000114 23.483252 0.000001 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 6.41981 -0.000409 -4.279953 0 0 0.000003 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.390659 -0.022471 2.07901 -88.660008 -66.260621 66.256093 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 6.18954 -0.000032 -0.000206 -47.371924 -14.201104 4.287845 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.535244 0.000142 0.000065 -0.000006 0 0.000002 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 12.336586 -0.000369 -0.0009 -0.000578 -46.966611 -0.000222 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 4.279892 0.000042 0.001049 -0.000062 0.000058 -0.00005 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.814166 -0.000368 0.000614 0.000053 0.000231 -0.000049 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -20.233122 -9.016895 0.000294 7.074196 -32.571448 133.42597 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -20.233122 -9.016895 0.000294 7.074196 -32.571448 133.42597 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.734316 8.483166 -4.200443 7.074196 -32.571448 133.425778 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.653023 -1.005306 -0.075218 8.025188 -10.060739 94.84206 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.802985 0.000141 -0.000435 1.153938 20.059031 -11.551245 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.998614 -0.000069 0.000563 0.000295 26.530992 -0.000299 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.983738 0.000439 0.000097 0.00007 36.229437 -0.00012 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.642433 0.427612 -0.000498 0.000901 179.999978 0.000007 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.284069 0.427925 -0.000162 -0.921601 0.408128 0.541833 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000636 0.107368 0.000349 1.256321 -12.01045 6.877142 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.684739 -0.213095 -0.0644 7.528374 -3.805358 95.452843 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.846095 0.000835 0.000168 1.908585 27.378673 -1.568882 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.149386 -0.000954 -0.000404 0.00007 56.058351 0.000055 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.17738 0.000002 0.000494 0.000413 26.56731 -0.000113 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000238 0.105927 -0.000221 -0.620742 -13.706294 1.078357 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.642197 1.155878 0.363235 -1.189582 6.15449 99.586262 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.353719 0.000572 -0.00013 -0.000108 35.990521 0.000167 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.262707 0.000404 0.000086 -0.000047 42.582043 -0.000116 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.727024 -0.000871 0.000193 -0.000449 31.299929 0.000176 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000206 0.106598 0.000032 -0.000053 -17.99637 0.000219 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.641959 1.026428 0.321081 0.000003 0.000348 10.001258 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.652934 0.42878 0.01078 3.531476 2.461657 100.970816 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.739641 -0.000164 -0.000034 2.901125 29.877112 -0.141584 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.82836 0.000774 0.000212 0.00024 47.511376 -0.000169 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.09119 -0.000025 -0.000423 -0.000224 32.470952 0.000005 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000624 0.107155 0.00033 -1.325359 -14.9456 0.625034 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.674303 -0.737745 0.246578 -34.800306 -67.797284 -5.000305 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.246285 -0.000101 -0.000412 -16.617041 31.034033 13.889937 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.380947 0.000385 -0.00005 -0.000751 21.034374 -0.000283 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.64188 0.428195 0.000027 -0.000796 -179.999978 -0.000005 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 1.069399 -0.000216 1.294044 0.000002 0.000003 0.000007 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.461135 -2.674387 0.642143 -12.691589 -30.212867 -51.108048 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.955727 0.12512 1.630642 3.675054 99.912157 93.362375 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 0.695915 -0.586075 -0.099491 7.528835 -6.42091 95.450036 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 2.032395 -0.000336 -0.000162 1.908703 27.378393 -1.569169 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 0.703064 0.008982 -0.043209 7.529288 -0.000975 95.451914 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.925638 -0.000259 -0.000256 1.908582 27.378677 -1.569053 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.925638 -0.000259 -0.000256 1.908582 27.378677 -1.569053 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.925638 -0.000259 -0.000256 1.908582 27.378677 -1.569053 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 0.712381 0.799522 0.031227 7.529403 5.441554 95.451566 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 2.033778 0.000587 -0.000076 1.908646 27.378682 -1.569227 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 11.34206 -0.000353 0.000595 0.000111 0.000232 -0.000108 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.128042 -0.29446 0.000874 0.000049 23.48348 0.000289 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 6.419749 -0.000404 4.280045 0 0 0.000001 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 9.440613 -0.000002 0 -0.000229 -16.850975 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.335159 -0.000463 -0.000014 0.000229 16.850971 0.000057 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.669319 -0.000003 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.709869 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.79467 -0.216138 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.903191 -0.311368 -0.00107 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.67894 -6.826605 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.757851 -3.795292 -1.14062 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.697929 -3.763192 1.25083 89.999982 -0.000057 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.184029 -0.11342 -0.96514 58.967373 -179.596532 89.995201 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_spine4" 10.598351 -5.870023 -6.894012 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 4.279995 -6.955003 0 0.000344 0.056264 0 0 0 0 0 0 0
$definebone "j_crotch" "j_mainroot" -6.955002 0.000001 0 89.999982 0 0 0 0 0 0 0 0
$definebone "tag_weapon" "tag_torso" 15.181162 0 0.151939 0 0 0 0 0 0 0 0 0
$definebone "tag_cambone" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_camera" "tag_cambone" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_player" "tag_camera" 0.11342 0 -68.822403 0 0 0 0 0 0 0 0 0
$definebone "tag_playerhelmet" "tag_camera" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_camera_scripted" "tag_origin" -0.11342 0 68.822403 0 0 0 0 0 0 0 0 0

$bonemerge "tag_origin"
$bonemerge "tag_sync"
$bonemerge "tag_view"
$bonemerge "tag_ads"
$bonemerge "tag_torso"
$bonemerge "j_mainroot"
$bonemerge "j_hip_le"
$bonemerge "j_hiptwist_le"
$bonemerge "j_knee_le"
$bonemerge "j_ankle_le"
$bonemerge "j_ball_le"
$bonemerge "j_kneedq_le"
$bonemerge "j_hip_proc_le"
$bonemerge "j_hip_ri"
$bonemerge "j_hiptwist_ri"
$bonemerge "tag_stowed_thigh"
$bonemerge "j_knee_ri"
$bonemerge "j_ankle_ri"
$bonemerge "j_ball_ri"
$bonemerge "j_kneedq_ri"
$bonemerge "j_hip_proc_ri"
$bonemerge "j_spinelower"
$bonemerge "j_spineupper"
$bonemerge "j_spine4"
$bonemerge "j_chest"
$bonemerge "j_clavicle_le"
$bonemerge "j_shoulder_le"
$bonemerge "j_shouldertwist_le"
$bonemerge "j_elbow_le"
$bonemerge "j_wristfronttwist1_le"
$bonemerge "j_proc_wristfronttwist1_le"
$bonemerge "tag_wrist_attach_le"
$bonemerge "j_wrist_le"
$bonemerge "tag_weapon_left"
$bonemerge "tag_accessory_left"
$bonemerge "j_metaindex_le_1"
$bonemerge "j_index_le_1"
$bonemerge "j_index_le_2"
$bonemerge "j_index_le_3"
$bonemerge "j_index_le_4"
$bonemerge "j_indexbulge_le_1"
$bonemerge "j_proc_index_le_1"
$bonemerge "j_metamid_le_1"
$bonemerge "j_mid_le_1"
$bonemerge "j_mid_le_2"
$bonemerge "j_mid_le_3"
$bonemerge "j_proc_mid_le_1"
$bonemerge "j_metapinky_le_1"
$bonemerge "j_pinky_le_1"
$bonemerge "j_pinky_le_2"
$bonemerge "j_pinky_le_3"
$bonemerge "j_proc_pinky_le_1"
$bonemerge "j_webbing_le_3"
$bonemerge "j_metaring_le_1"
$bonemerge "j_ring_le_1"
$bonemerge "j_ring_le_2"
$bonemerge "j_ring_le_3"
$bonemerge "j_proc_ring_le_1"
$bonemerge "j_thumb_le_1"
$bonemerge "j_thumb_le_2"
$bonemerge "j_thumb_le_3"
$bonemerge "j_thumb_le_4"
$bonemerge "j_webbing_le_2"
$bonemerge "j_webbing_le_1"
$bonemerge "j_proc_metaindex_le_1"
$bonemerge "j_proc_metaindex_le_2"
$bonemerge "j_proc_metaknuckle_le_1"
$bonemerge "j_proc_knuckle_le_1"
$bonemerge "j_proc_idle_knuckle_le_1"
$bonemerge "j_proc_orient_knuckle_le_1"
$bonemerge "j_proc_metapinky_le_1"
$bonemerge "j_proc_metapinky_le_2"
$bonemerge "j_shield_le"
$bonemerge "j_elbowdq_le"
$bonemerge "j_teres_le"
$bonemerge "j_clavicle_ri"
$bonemerge "j_shoulder_ri"
$bonemerge "j_shouldertwist_ri"
$bonemerge "j_elbow_ri"
$bonemerge "j_shield_ri"
$bonemerge "j_wrist_ri"
$bonemerge "j_gun"
$bonemerge "tag_weapon_right"
$bonemerge "tag_accessory_right"
$bonemerge "j_metaindex_ri_1"
$bonemerge "j_index_ri_1"
$bonemerge "j_index_ri_2"
$bonemerge "j_index_ri_3"
$bonemerge "j_index_ri_4"
$bonemerge "j_indexbulge_ri_1"
$bonemerge "j_proc_index_ri_1"
$bonemerge "j_metamid_ri_1"
$bonemerge "j_mid_ri_1"
$bonemerge "j_mid_ri_2"
$bonemerge "j_mid_ri_3"
$bonemerge "j_proc_mid_ri_1"
$bonemerge "j_metapinky_ri_1"
$bonemerge "j_pinky_ri_1"
$bonemerge "j_pinky_ri_2"
$bonemerge "j_pinky_ri_3"
$bonemerge "j_proc_pinky_ri_1"
$bonemerge "j_webbing_ri_3"
$bonemerge "j_metaring_ri_1"
$bonemerge "j_ring_ri_1"
$bonemerge "j_ring_ri_2"
$bonemerge "j_ring_ri_3"
$bonemerge "j_proc_ring_ri_1"
$bonemerge "j_thumb_ri_1"
$bonemerge "j_thumb_ri_2"
$bonemerge "j_thumb_ri_3"
$bonemerge "j_thumb_ri_4"
$bonemerge "j_webbing_ri_2"
$bonemerge "j_webbing_ri_1"
$bonemerge "tag_knife_attach2"
$bonemerge "j_proc_metaindex_ri_1"
$bonemerge "j_proc_metaindex_ri_2"
$bonemerge "j_proc_metaknuckle_ri_1"
$bonemerge "j_proc_knuckle_ri_1"
$bonemerge "j_proc_idle_knuckle_ri_1"
$bonemerge "j_proc_orient_knuckle_ri_1"
$bonemerge "j_proc_metapinky_ri_1"
$bonemerge "j_proc_metapinky_ri_2"
$bonemerge "j_wristfronttwist1_ri"
$bonemerge "j_elbowdq_ri"
$bonemerge "j_teres_ri"
$bonemerge "j_neck"
$bonemerge "j_head"
$bonemerge "j_head_end"
$bonemerge "j_helmet"
$bonemerge "j_visor"
$bonemerge "j_visor_inner"
$bonemerge "j_nvg"
$bonemerge "j_eyeball_le"
$bonemerge "j_eyeball_ri"
$bonemerge "j_jaw"
$bonemerge "tag_carry_attach"
$bonemerge "j_proc_spineupper"
$bonemerge "j_proc_spinelower"
$bonemerge "j_groinprotector"
$bonemerge "j_crotch"
$bonemerge "tag_weapon"
$bonemerge "tag_cambone"
$bonemerge "tag_camera"
$bonemerge "tag_player"
$bonemerge "tag_playerhelmet"
$bonemerge "tag_camera_scripted"


$sequence "Idle" {
	"mp_vm_gloves_hutch_iw9_1_1_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\mp_vm_gloves_hutch_iw9_1_1.qc"
//	}
}
