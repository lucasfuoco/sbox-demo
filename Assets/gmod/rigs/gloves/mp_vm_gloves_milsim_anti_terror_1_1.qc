// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/mp_vm_gloves_milsim_anti_terror_1_1.mdl"

$bodygroup "gloves"
{
	studio "mp_vm_gloves_milsim_anti_terror_1_1.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\milsim_anti_terror\"

$cbox 0 0 0 0 0 0

$bbox -11.498 -33.457 0 29.494 23.207 77.202

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.11342 0 68.822403 0 0 0 0 0 0 0 0 0
$definebone "tag_camera_scripted" "tag_origin" -0.11342 0 68.822403 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_cambone" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.96728 0 -12.63242 0 0 0 0 0 0 0 0 0
$definebone "tag_camera" "tag_cambone" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -15.315983 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "tag_weapon" "tag_torso" 15.181162 0 0.151939 0 0 0 0 0 0 0 0 0
$definebone "tag_player" "tag_camera" 0.11342 0 -68.822403 0 0 0 0 0 0 0 0 0
$definebone "tag_playerhelmet" "tag_camera" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -5.20769 0.500061 -179.258588 -179.996795 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 5.20769 0.500061 -179.258588 -179.996795 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.780312 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 4.279999 -6.955 0 0 0.055978 0 0 0 0 0 0 0
$definebone "j_crotch" "j_mainroot" -6.955002 0 0 89.999982 0 0 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.070095 -0.000031 0 0 0 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 18.363899 -0.000432 0 0 6.830459 0 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 10.699881 -0.000324 0 0 0 0 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.070095 -0.000031 0 0 0 0 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 18.363897 -0.000432 0 0 6.830459 0 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 10.164827 0.000227 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.6875 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 18.991831 0.316201 0 0 -66.403393 0 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.01914 0.320777 0 0 -3.413797 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 13.143427 1.692158 -5.02472 -4.969035 5.16722 83.781839 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 18.991831 0.316201 0 0 -66.403393 0 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.019142 0.320777 0 0 -3.413797 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.848167 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.79247 0.000372 0 0 -29.68237 0 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.79247 0.000371 0 0 -29.68237 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.389587 -0.02247 -2.07901 88.660179 -66.276208 -66.271276 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.390659 -0.02247 2.07901 -88.660179 -66.276208 66.271276 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 9.440613 0 0 0 -16.850746 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_spine4" 10.598351 -5.87002 -6.89401 0 -179.999978 89.999982 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 6.189539 -0.000033 0.000244 47.37158 -14.201446 -4.288132 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 6.18954 -0.000033 -0.000248 -47.37158 -14.201447 4.288132 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.335159 -0.000473 0 0 16.850744 0 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.535244 0.000143 -0.000065 -0.000001 -0.000001 -0.000002 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 12.337358 -0.00031 0.000198 -0.000002 -46.966618 0.000003 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.535244 0.000143 0.000061 -0.000002 -0.000001 0.000002 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 12.336578 -0.000363 -0.000923 0 -46.966614 0.000001 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.669312 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.678932 -6.826601 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.757843 -3.79529 -1.14062 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.697922 -3.76319 1.25083 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.184036 -0.11342 -0.96514 58.967441 -179.596491 89.995228 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 11.342057 -0.000357 -0.000675 -0.000002 -0.000007 0.000003 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.814166 -0.000366 -0.00069 -0.000002 -0.000007 0.000003 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 4.2794 -0.000568 -0.000355 -0.000002 -0.000007 0.000003 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.127552 -0.295065 -0.000153 -0.000003 23.483358 0.000001 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 4.279893 0.000042 0.001083 0 -0.000005 0.000001 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.814165 -0.000366 0.000694 0 -0.000005 0.000001 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 11.342056 -0.000353 0.000675 0 -0.000005 0.000001 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.128046 -0.29446 0.000881 -0.000001 23.483358 0.000002 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.709862 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" -1.225715 0.000139 0.000721 -0.000002 -0.000007 0.000003 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -20.23357 -9.017578 0.000496 -7.073677 -32.571335 46.574544 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -10.251336 -29.81245 -39.787609 -7.073677 -32.571335 46.574544 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.653032 -1.005302 0.075203 -8.024963 -10.060514 -94.841466 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.684745 -0.213093 0.064388 -7.528208 -3.805078 -95.452474 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.642193 1.15588 -0.363243 1.19003 6.154706 -99.586303 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.652437 0.428177 -0.010056 -3.531198 2.461879 -100.970625 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.673811 -0.738346 -0.245857 34.800818 -67.797175 5.000031 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.460655 -2.674978 -0.641445 12.693074 -30.211433 51.108297 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 0.695427 -0.586676 0.100204 -7.528609 -6.420686 -95.449776 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 0.703069 0.008989 0.043194 -7.529065 -0.000749 -95.45162 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 0.712379 0.799526 -0.031231 -7.529126 5.441718 -95.45104 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -20.233072 -9.016972 0.000229 7.073681 -32.571335 133.425423 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -20.233072 -9.016972 0.000229 7.073681 -32.571335 133.425423 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.734301 8.483179 -4.200443 7.073681 -32.571335 133.425423 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.653028 -1.005302 -0.075211 8.024962 -10.060513 94.841473 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.68474 -0.213093 -0.064396 7.528209 -3.805076 95.452474 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.642189 1.155884 0.363232 -1.190033 6.154707 99.58631 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.652931 0.428785 0.01078 3.531195 2.461881 100.970632 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.674305 -0.737736 0.246586 -34.800828 -67.797175 -5.000027 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.461146 -2.674372 0.642166 -12.693078 -30.211429 -51.108291 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.955716 0.125137 1.630653 3.675693 99.91239 93.362443 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 0.695918 -0.586071 -0.099487 7.528608 -6.420685 95.44979 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 0.703065 0.008987 -0.043209 7.529064 -0.000748 95.45162 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 0.712379 0.799528 0.031227 7.529123 5.441719 95.451047 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.79467 -0.21614 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.903191 -0.31137 -0.00107 0 0 0 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.917732 0.111355 0.112015 9.39215 0.781049 1.348514 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.802986 0.000156 0.000431 -1.153815 20.059075 11.551051 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.845738 0.000122 -0.000887 -1.908571 27.378673 1.569102 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.353716 0.000549 0.000126 0.000009 35.990691 0.000002 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.641392 1.025803 -0.321739 0.000007 -0.000002 -10.000696 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.739641 -0.000168 0.000032 -2.901164 29.877054 0.141802 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.246399 0.000514 -0.000443 16.616802 31.033975 -13.889983 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 1.069516 0.000405 -1.29491 -0.000002 0.000005 0.000005 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 2.032059 0.00045 -0.000471 -1.908566 27.37867 1.5691 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.925635 -0.000256 0.000248 -1.908576 27.378673 1.569105 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.925635 -0.000256 0.000248 -1.908576 27.378673 1.569105 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.925635 -0.000256 0.000248 -1.908576 27.378673 1.569105 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 2.033331 -0.000153 -0.000553 -1.908573 27.37867 1.569099 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.802985 0.000153 -0.000433 1.153819 20.059079 -11.551057 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.84609 0.000839 0.000174 1.908573 27.378673 -1.569104 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.353716 0.000561 -0.00013 -0.000003 35.990695 -0.000009 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.64196 1.026424 0.321075 -0.000009 0.000002 10.000689 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.73964 -0.00016 -0.000034 2.901166 29.877057 -0.141806 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.246289 -0.000104 -0.000423 -16.616812 31.033975 13.889985 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 1.069403 -0.000212 1.294041 -0.000002 0.000005 0 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 2.032397 -0.000336 -0.000162 1.908573 27.378672 -1.569105 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.925636 -0.000256 -0.00025 1.90858 27.378675 -1.569107 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 3.089199 -1.289528 -1.174606 1.90858 27.378675 -1.569107 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.925636 -0.000256 -0.00025 1.90858 27.378675 -1.569107 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 2.033779 0.000584 -0.000078 1.908571 27.378677 -1.569104 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.998614 -0.000069 -0.000561 0.000012 26.531318 -0.000002 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.284485 0.426838 -0.000795 0.921726 0.408341 -0.542318 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000121 0.106659 -0.000948 -1.256261 -12.010175 -6.877507 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.149404 -0.000095 -0.000237 0.000006 56.05819 0.000007 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000237 0.105923 0.000221 0.620694 -13.706241 -1.078484 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.261877 0.000235 -0.000742 0.000004 42.581937 0.000007 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.00021 0.1066 -0.000036 0.000009 -17.996717 0 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.82836 0.000771 -0.000217 0.000009 47.511677 0.000007 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000147 0.107471 0.000343 1.325373 -14.945326 -0.625387 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.380306 -0.00024 0.000637 -0.000002 21.034136 0.000001 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.998614 -0.000065 0.000561 -0.000006 26.531327 0.000003 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.284064 0.427925 -0.000164 -0.921721 0.408345 0.542313 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000637 0.107376 0.000345 1.256267 -12.01017 6.877504 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.149386 -0.000946 -0.000406 -0.000005 56.058187 -0.000003 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000237 0.105934 -0.000221 -0.620692 -13.706239 1.078483 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.262699 0.000397 0.00008 0.000002 42.581937 -0.000009 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000206 0.106598 0.000032 -0.000007 -17.996712 -0.000008 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.828362 0.000774 0.000212 -0.000006 47.511674 -0.000005 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000624 0.107151 0.000334 -1.32537 -14.94532 0.625384 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.380947 0.000389 -0.000053 -0.000002 21.03414 -0.000002 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.984409 -0.000313 -0.000448 0.000015 36.229557 0.000003 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.176666 -0.000454 0.000145 0.000002 26.567768 0.00001 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.727741 -0.001312 0.000473 -0.000001 31.29942 0.000007 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.091396 -0.000851 -0.000227 0.000006 32.47061 0.00001 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.641874 0.428198 -0.000034 -0.000002 -0.000002 0.000001 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.983744 0.000431 0.000092 -0.00001 36.229557 -0.000002 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.177383 0.00001 0.0005 -0.000002 26.567761 -0.000007 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.72702 -0.000874 0.000187 0.000006 31.299414 -0.000002 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.09119 -0.000028 -0.000423 -0.000001 32.47061 -0.000009 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.64188 0.4282 0.000034 0 -179.999978 0.000002 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.64146 0.428747 0.00025 0.000015 0.000004 0.000003 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.642433 0.427605 -0.000502 0.000011 -179.999978 0 0 0 0 0 0 0

$bonemerge "tag_origin"
$bonemerge "tag_sync"
$bonemerge "tag_view"
$bonemerge "tag_camera_scripted"
$bonemerge "tag_ads"
$bonemerge "tag_cambone"
$bonemerge "tag_torso"
$bonemerge "tag_camera"
$bonemerge "j_mainroot"
$bonemerge "tag_weapon"
$bonemerge "tag_player"
$bonemerge "tag_playerhelmet"
$bonemerge "j_hip_le"
$bonemerge "j_hip_ri"
$bonemerge "j_spinelower"
$bonemerge "j_groinprotector"
$bonemerge "j_crotch"
$bonemerge "j_hiptwist_le"
$bonemerge "j_knee_le"
$bonemerge "j_hip_proc_le"
$bonemerge "j_hiptwist_ri"
$bonemerge "j_knee_ri"
$bonemerge "j_hip_proc_ri"
$bonemerge "j_spineupper"
$bonemerge "j_proc_spinelower"
$bonemerge "j_ankle_le"
$bonemerge "j_kneedq_le"
$bonemerge "tag_stowed_thigh"
$bonemerge "j_ankle_ri"
$bonemerge "j_kneedq_ri"
$bonemerge "j_spine4"
$bonemerge "j_proc_spineupper"
$bonemerge "j_ball_le"
$bonemerge "j_ball_ri"
$bonemerge "j_chest"
$bonemerge "j_clavicle_le"
$bonemerge "j_clavicle_ri"
$bonemerge "j_neck"
$bonemerge "tag_carry_attach"
$bonemerge "j_shoulder_le"
$bonemerge "j_shoulder_ri"
$bonemerge "j_head"
$bonemerge "j_shouldertwist_le"
$bonemerge "j_elbow_le"
$bonemerge "j_shouldertwist_ri"
$bonemerge "j_elbow_ri"
$bonemerge "j_head_end"
$bonemerge "j_nvg"
$bonemerge "j_eyeball_le"
$bonemerge "j_eyeball_ri"
$bonemerge "j_jaw"
$bonemerge "j_wristfronttwist1_le"
$bonemerge "j_wrist_le"
$bonemerge "j_shield_le"
$bonemerge "j_elbowdq_le"
$bonemerge "j_shield_ri"
$bonemerge "j_wrist_ri"
$bonemerge "j_wristfronttwist1_ri"
$bonemerge "j_elbowdq_ri"
$bonemerge "j_helmet"
$bonemerge "j_proc_wristfronttwist1_le"
$bonemerge "tag_weapon_left"
$bonemerge "tag_accessory_left"
$bonemerge "j_metaindex_le_1"
$bonemerge "j_metamid_le_1"
$bonemerge "j_metapinky_le_1"
$bonemerge "j_metaring_le_1"
$bonemerge "j_thumb_le_1"
$bonemerge "j_webbing_le_1"
$bonemerge "j_proc_metaindex_le_1"
$bonemerge "j_proc_metaknuckle_le_1"
$bonemerge "j_proc_metapinky_le_1"
$bonemerge "j_gun"
$bonemerge "tag_weapon_right"
$bonemerge "tag_accessory_right"
$bonemerge "j_metaindex_ri_1"
$bonemerge "j_metamid_ri_1"
$bonemerge "j_metapinky_ri_1"
$bonemerge "j_metaring_ri_1"
$bonemerge "j_thumb_ri_1"
$bonemerge "j_webbing_ri_1"
$bonemerge "tag_knife_attach2"
$bonemerge "j_proc_metaindex_ri_1"
$bonemerge "j_proc_metaknuckle_ri_1"
$bonemerge "j_proc_metapinky_ri_1"
$bonemerge "j_visor"
$bonemerge "j_visor_inner"
$bonemerge "tag_wrist_attach_le"
$bonemerge "j_index_le_1"
$bonemerge "j_mid_le_1"
$bonemerge "j_pinky_le_1"
$bonemerge "j_webbing_le_3"
$bonemerge "j_ring_le_1"
$bonemerge "j_thumb_le_2"
$bonemerge "j_webbing_le_2"
$bonemerge "j_proc_metaindex_le_2"
$bonemerge "j_proc_knuckle_le_1"
$bonemerge "j_proc_idle_knuckle_le_1"
$bonemerge "j_proc_orient_knuckle_le_1"
$bonemerge "j_proc_metapinky_le_2"
$bonemerge "j_index_ri_1"
$bonemerge "j_mid_ri_1"
$bonemerge "j_pinky_ri_1"
$bonemerge "j_webbing_ri_3"
$bonemerge "j_ring_ri_1"
$bonemerge "j_thumb_ri_2"
$bonemerge "j_webbing_ri_2"
$bonemerge "j_proc_metaindex_ri_2"
$bonemerge "j_proc_knuckle_ri_1"
$bonemerge "j_proc_idle_knuckle_ri_1"
$bonemerge "j_proc_orient_knuckle_ri_1"
$bonemerge "j_proc_metapinky_ri_2"
$bonemerge "j_index_le_2"
$bonemerge "j_indexbulge_le_1"
$bonemerge "j_proc_index_le_1"
$bonemerge "j_mid_le_2"
$bonemerge "j_proc_mid_le_1"
$bonemerge "j_pinky_le_2"
$bonemerge "j_proc_pinky_le_1"
$bonemerge "j_ring_le_2"
$bonemerge "j_proc_ring_le_1"
$bonemerge "j_thumb_le_3"
$bonemerge "j_index_ri_2"
$bonemerge "j_indexbulge_ri_1"
$bonemerge "j_proc_index_ri_1"
$bonemerge "j_mid_ri_2"
$bonemerge "j_proc_mid_ri_1"
$bonemerge "j_pinky_ri_2"
$bonemerge "j_proc_pinky_ri_1"
$bonemerge "j_ring_ri_2"
$bonemerge "j_proc_ring_ri_1"
$bonemerge "j_thumb_ri_3"
$bonemerge "j_index_le_3"
$bonemerge "j_mid_le_3"
$bonemerge "j_pinky_le_3"
$bonemerge "j_ring_le_3"
$bonemerge "j_thumb_le_4"
$bonemerge "j_index_ri_3"
$bonemerge "j_mid_ri_3"
$bonemerge "j_pinky_ri_3"
$bonemerge "j_ring_ri_3"
$bonemerge "j_thumb_ri_4"
$bonemerge "j_index_le_4"
$bonemerge "j_index_ri_4"


$sequence "Idle" {
	"mp_vm_gloves_milsim_anti_terror_1_1_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\mp_vm_gloves_milsim_anti_terror_1_1.qc"
//	}
}
