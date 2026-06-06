// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/arms/mp_vm_arms_nitrox_iw9_1_1.mdl"

$bodygroup "sleeve"
{
	studio "mp_vm_arms_nitrox_iw9_1_1.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\arms\"
$cdmaterials "viper\MWII\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -9.84 -28.52 0 27.267 22.265 72.151

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" -0.000004 0 -4.867001 0.500347 -179.258943 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000084 -0.000035 -0.000006 0 0 -0.000057 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.162516 -0.000502 -0.000089 0.000401 6.829772 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.749378 0.295627 0.000031 0 -66.402771 0.000172 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413525 0.000321 -0.000001 0 -29.682766 0 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017891 0.299792 0.000001 -0.000115 -3.413396 0.000115 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999886 -0.00036 -0.000052 0.000458 -0.000229 -0.000057 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" -0.000004 0 4.867001 0.500347 -179.258943 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000088 -0.000035 -0.000005 0 0 -0.000057 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283571 1.581384 -4.696066 -4.968862 5.166876 83.781839 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.162523 -0.000502 -0.000088 0.000401 6.829772 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.749376 0.295627 0.000031 0 -66.402771 0.000172 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413525 0.000321 -0.000002 0 -29.682766 0 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017891 0.299792 0 -0.000115 -3.413396 0.000115 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.49984 0.000158 -0.000048 0.000458 -0.000458 -0.000057 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.532997 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.25 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.530998 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.036999 -0.021001 -1.943001 88.66035 -66.291453 -66.286863 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.784616 -0.000033 0.000275 47.371347 -14.20122 -4.287554 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500221 0.000135 -0.000057 -0.000002 -0.000003 0.000001 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 11.530249 -0.000258 0.000198 -0.000172 -46.966382 0.000117 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.600056 -0.000347 -0.000656 -0.000002 0.000002 0.000057 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" -1.14553 0.000135 0.000675 0 0.000058 0.000054 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.85769 0.104073 0.104687 9.392154 0.781059 1.348738 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.04128 -0.000351 -0.000671 -0.000001 0.000231 0.000058 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -9.580931 -27.862165 -37.184597 -7.073737 -32.571564 46.573503 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.580931 -27.862165 -37.184597 -7.073737 -32.571564 46.573503 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.610302 -0.939543 0.070286 -8.02479 -10.060855 -94.841828 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.619616 0.000137 0.000406 -1.154167 20.059081 11.551118 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.867863 -0.000065 -0.000531 0.000857 26.531037 0.000578 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.920004 -0.000298 -0.00041 0.000339 36.22927 -0.00057 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.599491 0.400701 0.000245 -0.000006 -0.000001 0.000003 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.200454 0.398911 -0.000746 0.922459 0.408005 -0.541898 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.00011 0.099682 -0.000888 -1.255923 -12.010397 -6.877382 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.639947 -0.199158 0.060173 -7.528034 -3.805184 -95.452597 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.659566 0.000118 -0.000837 -1.909096 27.378846 1.569165 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.008788 -0.000095 -0.000248 -0.00018 56.05819 0.000347 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.099686 -0.00043 0.00012 0.000449 26.567535 0.000572 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000221 0.098995 0.000204 0.621028 -13.706297 -1.078873 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600187 1.080254 -0.339485 1.189862 6.154024 -99.586364 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.199737 0.000526 0.000137 0.001091 35.990685 -0.000114 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.179323 0.000225 -0.000666 -0.00046 42.582056 -0.000973 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.68013 -0.001229 0.00045 -0.00063 31.299718 -0.000688 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000195 0.099627 -0.000029 -0.001375 -17.996433 0.000172 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.59943 0.958706 -0.30068 -0.000343 0.000459 -10.001038 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.609757 0.400162 -0.009403 -3.531194 2.461656 -100.970632 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.560415 -0.000153 0.000029 -2.901225 29.877228 0.141466 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.708748 0.000713 -0.000208 0.000457 47.511489 0.000523 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.019989 -0.000792 -0.000206 -0.000406 32.470887 -0.000454 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000132 0.100433 0.000322 1.326459 -14.945661 -0.625095 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.629725 -0.69005 -0.229774 34.800767 -67.797694 4.999857 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.099438 0.000484 -0.000412 16.616868 31.034146 -13.889929 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290007 -0.000226 0.000595 0 21.034374 0.000002 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.599888 0.400181 -0.000034 0 0.000002 0.000002 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.999546 0.000379 -1.210197 -0.000002 0.000002 0 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299663 -2.499996 -0.599487 12.693135 -30.211832 51.108239 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 0.649932 -0.548304 0.093651 -7.528322 -6.420793 -95.450125 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 1.899121 0.00042 -0.000446 -1.908011 27.37833 1.569455 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 0.657075 0.00839 0.040367 -7.528837 -0.001032 -95.451976 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799662 -0.00024 0.000231 -1.908869 27.378552 1.569394 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799662 -0.00024 0.000231 -1.908869 27.378552 1.569394 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799662 -0.00024 0.000231 -1.908869 27.378552 1.569394 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 0.66578 0.747213 -0.02919 -7.528778 5.441266 -95.451457 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 1.90031 -0.000141 -0.000511 -1.908465 27.37839 1.569165 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.999439 -0.000536 -0.000343 -0.000002 0.000058 0.000117 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119207 -0.275761 -0.000149 0.000056 23.483307 0.000115 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 5.999824 -0.000382 -3.999958 0 0 0.000003 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.037998 -0.021001 1.943 -88.660008 -66.260621 66.256093 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.784618 -0.000029 -0.000187 -47.371983 -14.201105 4.287845 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500225 0.000134 0.000061 -0.000007 -0.000057 -0.000055 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.529516 -0.000345 -0.000843 -0.000634 -46.966379 -0.000225 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999898 0.000017 0.000988 -0.000061 -0.000056 -0.00005 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041275 -0.000389 0.000565 0.000111 -0.000229 -0.000052 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -18.909424 -8.427082 0.00029 7.073968 -32.571506 133.425669 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -18.909424 -8.427082 0.00029 7.073968 -32.571506 133.425669 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228302 7.928223 -3.925659 7.074197 -32.571219 133.425724 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.610307 -0.939537 -0.070297 8.025246 -10.060509 94.841999 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.619612 0.000134 -0.000401 1.153885 20.059031 -11.551181 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.867866 -0.000061 0.000525 0.000292 26.530938 -0.000347 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.919384 0.000408 0.00009 0.000066 36.229495 -0.000056 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.600399 0.399635 -0.000462 0.000912 -179.999978 0 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.200061 0.399933 -0.000153 -0.921656 0.408129 0.541839 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000596 0.100353 0.000324 1.256328 -12.010391 6.87715 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639946 -0.199154 -0.060188 7.528434 -3.805128 95.452775 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.6599 0.000778 0.000162 1.908586 27.378678 -1.568888 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.008775 -0.000893 -0.000387 0.000013 56.058351 0.000051 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.100357 0.000002 0.000462 0.000356 26.567303 -0.000116 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000223 0.098999 -0.000214 -0.620683 -13.706293 1.078408 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600181 1.080261 0.33947 -1.189524 6.154717 99.586262 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.199741 0.000526 -0.000122 -0.000046 35.990579 0.000167 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.18009 0.000381 0.000086 0.000012 42.582046 -0.000111 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.679462 -0.000811 0.000175 -0.000394 31.299933 0.000184 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000196 0.099627 0.000032 -0.00005 -17.996425 0.000163 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599962 0.959274 0.300076 0.000007 0.00035 10.001256 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610216 0.40073 0.010071 3.531535 2.461884 100.970809 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.560411 -0.000149 -0.000029 2.901122 29.877057 -0.141531 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.70875 0.000721 0.0002 0.0003 47.511376 -0.000172 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.019806 -0.000019 -0.000395 -0.000161 32.470952 0.000005 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000582 0.10014 0.000315 -1.325361 -14.945542 0.624971 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.630194 -0.689476 0.230446 -34.800258 -67.797059 -5.000421 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.099335 -0.000095 -0.000393 -16.617044 31.034044 13.889927 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.290598 0.000366 -0.00005 -0.000806 21.03438 -0.000289 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599892 0.400181 0.000031 -0.000801 180.000005 0.000003 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999439 -0.0002 1.209381 -0.000003 0.000005 0.000003 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300138 -2.499422 0.600132 -12.691531 -30.212638 -51.108113 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.76236 0.11694 1.523952 3.675116 99.912383 93.362498 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 0.650393 -0.547731 -0.092983 7.528892 -6.420679 95.450036 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 1.899436 -0.00032 -0.000153 1.908641 27.37839 -1.569169 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 0.657069 0.008394 -0.040386 7.52935 -0.000746 95.451914 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.000244 -0.000237 1.908585 27.378624 -1.569051 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.000244 -0.000237 1.908585 27.378624 -1.569051 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.000244 -0.000237 1.908585 27.378624 -1.569051 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 0.665775 0.747221 0.029186 7.529291 5.441726 95.451457 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 1.900725 0.000542 -0.000072 1.90864 27.378511 -1.569052 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.600054 -0.000378 0.000549 0.000111 -0.000229 -0.000109 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119663 -0.2752 0.000828 0.000054 23.483191 0.000288 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 5.999767 -0.000378 4.000042 0 0 0.000001 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 8.823002 -0.000002 0 -0.000229 -16.850975 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.11697 -0.000429 -0.000013 0.000229 16.850971 0.000057 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233002 -0.000003 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598 -0.000001 0 0 -0.000057 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.481003 -0.202 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.516998 -0.291 -0.001 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.241989 -6.380005 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512001 -3.547003 -1.066 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456001 -3.517004 1.169 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171997 -0.106 -0.902 58.967373 -179.596532 89.995201 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_spine4" 9.904995 -5.486003 -6.443001 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" -0.000004 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 3.999989 -6.500003 0 0.000344 0.056264 0 0 0 0 0 0 0
$definebone "j_crotch" "j_mainroot" -6.500004 0.000001 0 89.999982 0 0 0 0 0 0 0 0
$definebone "tag_weapon" "tag_torso" 14.188001 0 0.141998 0 0 0 0 0 0 0 0 0
$definebone "tag_cambone" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_camera" "tag_cambone" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_player" "tag_camera" 0.106 0 -64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_playerhelmet" "tag_camera" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_camera_scripted" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0

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
	"mp_vm_arms_nitrox_iw9_1_1_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\sleeves\sleeve.qc"
//	}
}
