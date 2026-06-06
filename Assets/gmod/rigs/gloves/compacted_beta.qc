// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_beta.mdl"

$bodygroup "gloves"
{
	studio "compacted_beta.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -11.543 -33.457 0 30.385 35.602 77.202

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.11342 0 68.822403 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.96728 0 -12.63242 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -15.315979 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -5.207691 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.070095 -0.000018 0.000015 0 -0.000057 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 18.363909 -0.000208 0.000234 -0.000573 6.831719 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 18.99184 0.316008 0.000041 -0.000057 -66.40426 0.000115 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.792474 0.000403 -0.000001 0 -29.682141 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.019142 0.320778 0.000001 -0.000286 -3.414256 0.000115 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 10.699883 -0.000194 0.000136 -0.000859 0.000688 0 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 5.207691 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.070103 -0.000018 0.000013 0 -0.000057 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 13.143475 1.692323 -5.024556 -4.96955 5.167966 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 18.363916 -0.000207 0.000233 -0.000573 6.831776 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 18.991842 0.316007 0.00004 -0.000057 -66.40426 0.000115 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.792475 0.0004 -0.000002 0 -29.682189 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.019144 0.320777 0 -0.000286 -3.414256 0.000115 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 10.164837 0.000351 0.00013 -0.000859 0.001146 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.780312 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.6875 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.848171 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.389587 -0.022471 -2.079011 88.660404 -66.29454 -66.29008 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 6.18954 -0.000035 0.000294 47.370657 -14.199725 -4.28607 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.535244 0.000137 -0.000069 -0.000006 -0.000171 0.000171 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 12.337362 -0.000461 0.000065 0.000053 -46.967195 -0.000567 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 11.342066 -0.000368 -0.000698 -0.000006 -0.00001 0.000176 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" 6.047316 20.873281 -48.041409 -7.068639 -32.57529 46.576429 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.261738 0.023336 0.114916 5.568973 0.691672 1.339586 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.814168 -0.000385 -0.000717 -0.000006 -0.00001 0.000119 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -20.233589 -9.01754 0.000557 -7.074025 -32.571164 46.574029 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -10.251468 -29.812632 -39.787476 -7.073851 -32.571284 46.573458 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.653028 -1.005304 0.075211 -8.024623 -10.060403 -94.842333 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.802986 0.000137 0.000431 -1.15301 20.058565 11.5518 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.998614 -0.000053 -0.000534 -0.000218 26.531562 -0.000517 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.984406 -0.000317 -0.000439 -0.000563 36.229789 -0.000451 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.641457 0.428751 0.000246 0.00001 0.000005 0.000007 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.28448 0.426846 -0.000782 0.920237 0.409092 -0.542482 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000115 0.106655 -0.00095 -1.256717 -12.009831 -6.877967 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.684748 -0.213093 0.064388 -7.528268 -3.805708 -95.452932 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.84574 0.000122 -0.000854 -1.910514 27.379184 1.568988 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.149401 -0.000118 -0.000292 0.000986 56.057507 0.001158 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.17667 -0.000449 0.000145 0.000234 26.567653 0.000188 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000237 0.105919 0.000216 0.622133 -13.706819 -1.078657 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.642193 1.15588 -0.363243 1.189856 6.154245 -99.586419 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.353717 0.000565 0.000145 0.000642 35.990869 0.000002 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.261877 0.000237 -0.000721 -0.000853 42.582347 -0.000907 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.727745 -0.001322 0.000473 0.000289 31.299185 0.000299 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000208 0.106598 -0.000031 -0.00159 -17.99649 0.000055 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.641389 1.025818 -0.321732 -0.000447 0.000683 -10.001153 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.652439 0.428179 -0.010056 -3.530971 2.461647 -100.971089 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.739645 -0.000175 0.000038 -2.900932 29.876774 0.142148 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.828362 0.000774 -0.000198 0.000184 47.511742 -0.000394 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.091396 -0.000846 -0.000217 -0.000336 32.470832 -0.00033 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000145 0.107468 0.000341 1.326523 -14.945837 -0.62493 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.673809 -0.73835 -0.24585 34.800603 -67.797523 4.999695 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.246397 0.00052 -0.000439 16.616744 31.03402 -13.890092 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.380306 -0.000238 0.000637 -0.000065 21.034527 0.000633 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.641876 0.428192 -0.000034 -0.000007 -0.000014 0.000003 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 1.069514 0.00041 -1.294907 0.000002 0 0.000007 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.460649 -2.674986 -0.641438 12.692904 -30.211614 51.10727 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.612067 0.009251 0.295723 19.90547 -0.639378 -93.487108 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 4.279401 -0.000574 -0.000362 0.000053 -0.000123 0.000175 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.12755 -0.295065 -0.000156 0.000163 23.483184 -0.000167 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 6.419815 -0.000402 -4.279949 -0.000115 -0.000229 0.000113 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.390659 -0.022471 2.07901 -88.659947 -66.25707 66.252603 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 6.189541 -0.000032 -0.000195 -47.373181 -14.20053 4.286526 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.535244 0.000139 0.000057 -0.000004 0.000172 0.000172 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 12.336586 -0.000452 -0.001137 0.000798 -46.966843 -0.00034 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 4.279894 0.000032 0.001053 0.00034 -0.000285 -0.000168 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.814166 -0.000399 0.000614 0.000111 -0.000231 -0.000112 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -20.233074 -9.016993 0.000282 7.07431 -32.571051 133.425765 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -20.233074 -9.016993 0.000282 7.07431 -32.571051 133.425765 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.734282 8.483202 -4.200443 7.074137 -32.571164 133.425765 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.653029 -1.005302 -0.075218 8.025306 -10.060455 94.841364 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.802988 0.000156 -0.000433 1.153765 20.058802 -11.55124 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.998614 -0.000046 0.000568 -0.000284 26.531621 0.000508 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.983738 0.000431 0.000092 -0.000049 36.229666 0.000164 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.642429 0.427605 -0.000504 -0.000408 179.999978 0.000009 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.284064 0.42794 -0.000156 -0.921892 0.408814 0.542988 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000637 0.10738 0.000349 1.25615 -12.00959 6.87824 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.68474 -0.213093 -0.0644 7.528491 -3.805019 95.452713 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.846092 0.000843 0.000175 1.908463 27.378911 -1.568766 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.149387 -0.000961 -0.000414 0.000466 56.057733 -0.000174 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.177383 0.000013 0.000505 -0.000505 26.568111 0.000456 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000233 0.105927 -0.000223 -0.620687 -13.706521 1.077899 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.642191 1.155882 0.363239 -1.18958 6.154766 99.586255 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.353721 0.000561 -0.000132 -0.000058 35.990688 0.000116 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.262707 0.000402 0.000086 -0.000346 42.582336 0.000345 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.727016 -0.000878 0.000189 0.000397 31.29942 -0.000285 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000204 0.106598 0.000031 -0.000058 -17.99643 0.000175 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.641958 1.026421 0.321077 0.000002 0.000523 10.00138 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.652932 0.428783 0.010784 3.531422 2.461941 100.97098 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.739644 -0.000164 -0.000031 2.901227 29.87689 -0.141979 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.828356 0.000771 0.000214 0 47.511551 0.000058 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.091198 -0.000022 -0.000423 -0.000115 32.470887 -0.000058 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000624 0.107147 0.00033 -1.325363 -14.945197 0.62567 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.674308 -0.737738 0.246578 -34.800657 -67.796949 -5.000195 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.246291 -0.000103 -0.000431 -16.616522 31.033682 13.890222 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.380943 0.000394 -0.000046 -0.001609 21.034886 -0.00051 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.641886 0.42819 0.000019 -0.001598 -179.999978 -0.000006 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 1.06941 -0.000214 1.294037 0 0.000002 0.000005 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.461153 -2.674376 0.642151 -12.696288 -30.207031 -51.108468 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.955726 0.125132 1.630646 3.675518 99.912383 93.362498 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.612064 0.009254 -0.295731 -19.905133 -0.639823 93.487524 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 11.342059 -0.000389 0.000595 0.000511 -0.000231 -0.000112 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.128046 -0.294458 0.000877 0.000511 23.483019 0.000287 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 6.419744 -0.000398 4.280056 -0.000115 0 0 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 9.440613 -0.000002 0 -0.000688 -16.851434 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.335159 -0.000435 -0.000041 0.000688 16.851434 0.000229 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.669319 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.709869 0 0 0 0.000057 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.79467 -0.216138 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.903191 -0.311368 -0.00107 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.678947 -6.8266 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.757851 -3.795289 -1.14062 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.697929 -3.76319 1.25083 89.999982 0.000057 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.184029 -0.11342 -0.96514 58.96766 -179.596532 89.995201 0 0 0 0 0 0
$definebone "j_proc_spine4" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_proc_spine4" 10.598351 -5.870023 -6.894012 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 4.279995 -6.955003 0 0.000802 0.056723 0 0 0 0 0 0 0
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
$bonemerge "j_proc_knuckle_le_1"
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
$bonemerge "j_proc_knuckle_ri_1"
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
$bonemerge "j_proc_spine4"
$bonemerge "tag_carry_attach"
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
	"compacted_beta_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_beta.qc"
//	}
}
