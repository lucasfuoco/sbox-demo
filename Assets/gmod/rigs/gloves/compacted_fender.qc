// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_fender.mdl"

$bodygroup "gloves"
{
	studio "compacted_fender.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -21.073 -36.909 -0.815 31.324 33.58 72.151

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -4.867001 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000084 -0.000017 0.000013 0 -0.000057 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.16254 -0.000194 0.00022 -0.00063 6.832694 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.749382 0.295044 0.000032 -0.000057 -66.405066 0.000115 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413527 0.000365 -0.000002 0 -29.682076 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017891 0.299792 0 -0.000286 -3.415173 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999893 -0.000181 0.000128 -0.000917 0.000688 0 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 4.867001 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000092 -0.000017 0.000012 0 -0.000057 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283621 1.581611 -4.695846 -4.96955 5.167966 83.78173 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.162546 -0.000194 0.000217 -0.00063 6.832694 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.749382 0.295044 0.000033 -0.000057 -66.405066 0.000115 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413527 0.00036 -0.000002 0 -29.682247 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017891 0.299792 0.000001 -0.000286 -3.415173 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.499846 0.000328 0.000122 -0.000917 0.00212 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.533001 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.25 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.531002 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.036999 -0.021001 -1.943001 88.660466 -66.293509 -66.289103 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.784616 -0.000039 0.000275 47.370661 -14.199841 -4.28607 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500229 0.000128 -0.000057 0.000003 -0.000114 0.000113 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 11.530251 -0.000426 0.000057 -0.000056 -46.966956 -0.000347 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.60006 -0.000383 -0.000652 0.000058 -0.000227 -0.000117 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" 5.651685 19.507776 -44.898495 -7.069039 -32.574832 46.57522 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.244618 0.021805 0.107394 5.568978 0.691156 1.340773 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.041281 -0.000401 -0.000671 0.000058 -0.000227 -0.000117 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -18.909895 -8.427622 0.000534 -7.073909 -32.571219 46.574025 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.580802 -27.862299 -37.184532 -7.074025 -32.571103 46.573161 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.61031 -0.939533 0.07029 -8.02456 -10.060393 -94.842333 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.619617 0.000134 0.000393 -1.153019 20.058568 11.551805 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.867864 -0.000046 -0.000498 -0.00046 26.531614 -0.000456 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.920006 -0.000298 -0.000416 -0.000405 36.22967 -0.000458 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.59951 0.4007 0.000237 -0.000005 0.000003 0 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.200449 0.398926 -0.00073 0.920227 0.409038 -0.542476 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000108 0.099682 -0.00089 -1.256727 -12.009884 -6.877959 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.63995 -0.19915 0.060177 -7.52832 -3.805642 -95.452932 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.659571 0.000122 -0.000797 -1.910584 27.379129 1.569047 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.00879 -0.000103 -0.000271 0.001028 56.057558 0.001206 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.099682 -0.000419 0.000139 0.000399 26.567599 0.000287 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000221 0.098995 0.000206 0.622118 -13.706698 -1.078705 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600181 1.080263 -0.339489 1.189864 6.154317 -99.58648 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.199736 0.000519 0.00013 0.000627 35.990808 0.000058 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.179323 0.000221 -0.000675 -0.000806 42.582456 -0.000919 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.68013 -0.001229 0.000443 0.000285 31.299192 0.000282 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000195 0.099627 -0.000029 -0.00161 -17.99643 0.000059 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.599426 0.958698 -0.30069 -0.000461 0.00069 -10.001145 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.609757 0.400167 -0.009399 -3.530966 2.461659 -100.971158 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.560413 -0.000156 0.000034 -2.900947 29.876887 0.142212 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.708752 0.000721 -0.000183 0.000223 47.511674 -0.000342 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.02 -0.000792 -0.000204 -0.000351 32.470832 -0.000343 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000134 0.100437 0.000322 1.326512 -14.945948 -0.624977 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.629731 -0.690044 -0.229771 34.800483 -67.797291 4.999629 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.099436 0.000479 -0.00042 16.616751 31.033917 -13.889934 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290012 -0.000221 0.000591 -0.000056 21.034543 0.000624 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.599888 0.400183 -0.000034 0.000003 0.000062 -0.000007 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.999544 0.000381 -1.210197 -0.000003 0 -0.000003 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299674 -2.499987 -0.599472 12.693019 -30.21172 51.107147 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.441188 0.008646 0.276371 19.905357 -0.639764 -93.487067 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 6.507327 18.151707 -45.009403 -7.510101 -42.528996 -48.031178 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 1.899125 0.000437 -0.000437 -1.908981 27.378728 1.569907 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 6.702032 18.527327 -44.643631 -12.202971 -38.163802 -47.937775 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799667 -0.000219 0.000238 -1.908405 27.379249 1.56876 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799667 -0.000219 0.000238 -1.908405 27.379249 1.56876 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 6.959258 19.0256 -44.157486 -16.176261 -34.397813 -48.148575 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 1.900314 -0.000131 -0.000514 -1.908867 27.378786 1.569625 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.999439 -0.000553 -0.00034 0.000058 -0.000171 -0.000172 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119205 -0.275763 -0.000141 0.000348 23.482966 -0.000404 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 5.999828 -0.000382 -3.999954 -0.000115 -0.000115 0.000113 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.037998 -0.021001 1.943 -88.659947 -66.25804 66.253634 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.784617 -0.000024 -0.000179 -47.373181 -14.200529 4.286529 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500229 0.000131 0.00005 -0.000001 0.00023 0.000229 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.529518 -0.000415 -0.00106 0.000343 -46.966607 -0.000226 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999897 0.000011 0.000946 0.000629 -0.000285 -0.00028 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041276 -0.00041 0.000481 0.000628 -0.000686 -0.000278 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -18.909374 -8.427197 0.000248 7.0742 -32.570819 133.425614 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -18.909374 -8.427197 0.000248 7.0742 -32.570819 133.425614 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228264 7.928273 -3.925644 7.074085 -32.570935 133.425765 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.610313 -0.939531 -0.070301 8.025304 -10.060167 94.841541 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.619613 0.000145 -0.000402 1.153825 20.05886 -11.551301 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.86786 -0.000053 0.000534 -0.000283 26.531564 0.000452 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.919384 0.000404 0.000086 -0.000051 36.229615 0.000169 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.600403 0.399632 -0.000473 -0.000407 -179.999978 0.000003 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.200058 0.39994 -0.000144 -0.921887 0.408814 0.542929 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000591 0.100346 0.000328 1.256154 -12.009648 6.878237 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639945 -0.199152 -0.060192 7.528493 -3.80467 95.452836 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.659896 0.000786 0.000168 1.908469 27.378907 -1.568769 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.008772 -0.000893 -0.000389 0.000523 56.057733 -0.000232 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.100357 0.000014 0.000469 -0.00062 26.568106 0.000575 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000221 0.098999 -0.00021 -0.620687 -13.706519 1.077841 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600175 1.080267 0.33947 -1.18958 6.155053 99.586316 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.199739 0.000534 -0.000118 -0.000109 35.990637 0.000051 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.180092 0.000378 0.000084 -0.000393 42.582394 0.000394 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.679451 -0.000817 0.000177 0.000239 31.299472 -0.000174 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000196 0.099625 0.000034 -0.00006 -17.99637 0.000223 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599961 0.959282 0.300079 0 0.000521 10.001429 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610216 0.400736 0.010071 3.531251 2.46223 100.971329 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.560413 -0.000164 -0.000027 2.90141 29.876723 -0.142214 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.708752 0.000725 0.0002 0.000011 47.511609 0.000056 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.01981 -0.00002 -0.000391 -0.000225 32.470945 0.000116 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.00058 0.100143 0.000309 -1.325363 -14.945197 0.625659 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.630198 -0.689474 0.230446 -34.801112 -67.796328 -5.000142 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.099337 -0.000111 -0.000423 -16.615897 31.033449 13.890273 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.290607 0.000368 -0.000046 -0.001615 21.034824 -0.000517 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599894 0.40018 0.000015 -0.001591 -180.000005 0.000002 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999458 -0.000197 1.209373 -0.000005 -0.000002 0.000002 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300158 -2.499407 0.600132 -12.696228 -30.206737 -51.108397 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.762361 0.116957 1.523964 3.675399 99.912724 93.362498 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.441186 0.008663 -0.276386 -19.904962 -0.639417 93.487019 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 6.918145 18.946112 44.347878 6.421829 -22.639915 -129.533376 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 1.899438 -0.000312 -0.000154 1.908696 27.378856 -1.569215 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 6.735541 18.563816 44.712017 1.874892 -27.106173 -130.697063 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799661 -0.000252 -0.000235 1.908693 27.378332 -1.569271 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799661 -0.000252 -0.000235 1.908693 27.378332 -1.569271 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 6.492944 18.056187 45.196003 -2.040702 -30.819005 -131.405354 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 1.900729 0.000552 -0.000071 1.908922 27.378682 -1.569782 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.600054 -0.000399 0.000462 0.000972 -0.000227 -0.000166 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119663 -0.2752 0.000813 0.00097 23.482851 0.000352 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 5.999763 -0.000366 4.000057 -0.000115 0.000115 -0.000113 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 8.823002 -0.000002 0 -0.000745 -16.851491 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.116974 -0.000404 -0.00004 0.000688 16.851492 0.000229 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233002 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.481003 -0.201999 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.516998 -0.290999 -0.001 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.241997 -6.380002 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512001 -3.547001 -1.066 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456001 -3.517002 1.169 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171997 -0.106 -0.902 58.967598 -179.596532 89.995201 0 0 0 0 0 0
$definebone "j_proc_spine4" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_proc_spine4" 9.904995 -5.486003 -6.443003 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" -47.983006 -1.010002 0.000063 -0.003495 -89.999982 -89.999982 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 3.999992 -6.500003 0 0.000802 0.056723 0 0 0 0 0 0 0
$definebone "j_crotch" "j_mainroot" -6.5 0.000001 0 89.999982 0 0 0 0 0 0 0 0
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
$bonemerge "j_proc_knuckle_le_1"
$bonemerge "j_proc_metaindex_le_1"
$bonemerge "j_proc_metaindex_le_2"
$bonemerge "j_proc_metaknuckle_le_1"
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
$bonemerge "j_proc_knuckle_ri_1"
$bonemerge "j_proc_metaindex_ri_1"
$bonemerge "j_proc_metaindex_ri_2"
$bonemerge "j_proc_metaknuckle_ri_1"
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
$bonemerge "j_proc_spine4"
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
	"compacted_fender_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_fender.qc"
//	}
}
