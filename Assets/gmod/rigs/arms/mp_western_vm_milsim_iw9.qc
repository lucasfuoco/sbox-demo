// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/arms/mp_western_vm_milsim_iw9.mdl"

$bodygroup "sleeve"
{
	studio "mp_western_vm_milsim_iw9.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\arms\"
$cdmaterials "viper\MWII\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -10.522 -31.269 0 27.267 22.127 72.151

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0.000004 0 -4.867001 0.500402 -179.258943 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000088 -0.000035 -0.000006 0 0 -0.000057 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.162523 -0.000501 -0.000092 0.000401 6.83023 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.749374 0.295484 0.000032 0 -66.403632 0.000172 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413527 0.000361 0 -0.000057 -29.68225 0 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017893 0.299792 0.000001 -0.000115 -3.413854 0 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999886 -0.00036 -0.000053 0.000458 -0.000458 -0.000057 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" -0.000004 0 4.867001 0.500402 -179.258943 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000092 -0.000035 -0.000005 0 0 -0.000057 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283562 1.581383 -4.696069 -4.969091 5.166934 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.162527 -0.000501 -0.000091 0.000401 6.83023 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.749374 0.295484 0.000031 0 -66.403577 0.000172 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413526 0.000355 0 0 -29.682482 0 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017895 0.299792 0 -0.000115 -3.413854 0 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.49984 0.000158 -0.00005 0.000458 -0.000229 -0.000057 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.533001 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.249996 0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.530998 0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.036999 -0.020999 -1.943001 88.66035 -66.291453 -66.286863 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.784618 -0.000032 0.000271 47.371347 -14.201049 -4.287554 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500225 0.000135 -0.000061 0 -0.00006 0.000057 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 11.530245 -0.000278 0.000202 -0.000115 -46.966379 0.000344 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.600058 -0.000368 -0.00066 -0.000001 0.000003 -0.000054 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" -1.145525 0.000132 0.000679 -0.000002 0 0.000005 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.857694 0.104074 0.104694 9.392152 0.781 1.348749 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.041279 -0.000376 -0.000671 -0.000001 0.000003 0.000057 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -18.90991 -8.427591 0.000542 -7.073908 -32.571331 46.573957 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.580861 -27.862328 -37.184494 -7.074023 -32.571219 46.572874 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.610304 -0.939545 0.070286 -8.024846 -10.06062 -94.841992 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.619613 0.000141 0.000401 -1.154168 20.059139 11.551173 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.867863 -0.000076 -0.000534 0.000799 26.530989 0.000572 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.920006 -0.000298 -0.000411 0.000343 36.229325 -0.000517 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.599503 0.400702 0.000239 -0.000001 0 -0.000003 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.200456 0.398907 -0.000751 0.922459 0.407948 -0.541902 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000109 0.099682 -0.000891 -1.255928 -12.010396 -6.877386 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.639945 -0.19916 0.060177 -7.528035 -3.804954 -95.452761 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.659567 0.000099 -0.000843 -1.908523 27.37861 1.569109 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.008786 -0.000092 -0.000231 -0.000522 56.058416 -0.000055 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.099686 -0.000427 0.000126 0.000452 26.567484 0.000514 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000217 0.098999 0.000206 0.620516 -13.706066 -1.078648 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600182 1.080254 -0.339485 1.190377 6.15431 -99.587122 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.19974 0.000507 0.000126 0.000972 35.990166 0.000517 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.179327 0.000223 -0.000668 -0.000458 42.582053 -0.00097 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.680138 -0.001225 0.000446 -0.000634 31.299711 -0.000627 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000195 0.099623 -0.000031 -0.001429 -17.996433 0.000173 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.59944 0.958698 -0.300678 -0.000172 -0.000058 -10.000461 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.609756 0.400158 -0.009407 -3.531137 2.461889 -100.970803 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.560412 -0.000149 0.000027 -2.901176 29.87717 0.141462 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.708752 0.000713 -0.000206 0.000398 47.511554 0.000511 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.02 -0.000793 -0.000212 -0.0004 32.470897 -0.000463 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000135 0.10043 0.000322 1.326389 -14.945605 -0.625095 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.629725 -0.690052 -0.229774 34.800599 -67.797578 4.999802 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.099441 0.000482 -0.000416 16.616862 31.034211 -13.889931 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290001 -0.00023 0.000595 -0.000007 21.034379 0.000114 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.59989 0.400181 -0.000031 0.000108 -0.000735 -0.000576 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.999547 0.000378 -1.210201 -0.000005 0 -0.000002 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299668 -2.499996 -0.599476 12.692904 -30.211607 51.108116 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 0.649933 -0.548302 0.093651 -7.528321 -6.420565 -95.450302 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 1.899121 0.00042 -0.000444 -1.907949 27.378385 1.569387 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 0.657072 0.008394 0.040367 -7.528779 -0.000856 -95.452133 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799664 -0.000248 0.000229 -1.90881 27.378552 1.569387 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799664 -0.000248 0.000229 -1.90881 27.378552 1.569387 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799664 -0.000248 0.000229 -1.90881 27.378552 1.569387 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 0.665775 0.747211 -0.029194 -7.528777 5.441497 -95.451682 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 1.900311 -0.000149 -0.000513 -1.908412 27.378441 1.569218 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.999436 -0.000544 -0.000343 -0.000001 -0.000056 0 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119204 -0.275764 -0.000149 0.000116 23.483251 -0.000055 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.037998 -0.020999 1.943 -88.660008 -66.260908 66.256325 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.784617 -0.000029 -0.000195 -47.371983 -14.201104 4.287846 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500225 0.000134 0.000069 -0.000004 -0.000057 0.000002 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.529512 -0.000346 -0.000839 -0.000576 -46.966443 -0.000225 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999897 0.000027 0.000988 -0.000117 0.000003 -0.000051 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041273 -0.000383 0.00058 0.000113 0.000232 -0.00005 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -18.909479 -8.426928 0.000271 7.074197 -32.571683 133.425669 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -18.909479 -8.426928 0.000271 7.074197 -32.571683 133.425669 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228364 7.928167 -3.925648 7.074197 -32.571683 133.425724 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.610299 -0.939539 -0.070297 8.025191 -10.060967 94.841999 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.619614 0.000137 -0.00041 1.153943 20.058968 -11.551182 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.867864 -0.000061 0.000525 0.000296 26.530977 -0.000296 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.919382 0.000416 0.000089 0.000074 36.229448 -0.000056 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.600407 0.399634 -0.000463 0.000845 179.999978 0.000002 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.200063 0.399933 -0.000154 -0.921658 0.408232 0.541834 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000598 0.100349 0.000321 1.256326 -12.01034 6.877142 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639941 -0.19916 -0.060184 7.528376 -3.805526 95.452775 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.659898 0.000778 0.00016 1.908643 27.378559 -1.568881 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.008776 -0.000893 -0.000381 0.000072 56.058474 0.000056 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.100365 0.000004 0.000462 0.000411 26.567307 -0.000109 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000223 0.098995 -0.000202 -0.620736 -13.706234 1.078354 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600187 1.080257 0.339474 -1.189581 6.15426 99.586262 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.199739 0.00053 -0.000128 -0.000104 35.990521 0.000171 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.180096 0.000378 0.00008 -0.000048 42.582046 -0.000053 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.679455 -0.000811 0.000181 -0.000393 31.299936 0.000178 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.0002 0.099623 0.000031 -0.000048 -17.996372 0.000225 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599962 0.959274 0.300074 0.000007 0.00029 10.001262 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610218 0.400728 0.010075 3.53148 2.461429 100.970816 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.560413 -0.000156 -0.000032 2.901121 29.877109 -0.141584 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.708748 0.000717 0.0002 0.000242 47.511322 -0.000111 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.019814 -0.000018 -0.000393 -0.00022 32.470955 0.000067 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000582 0.10014 0.000309 -1.325361 -14.945608 0.62503 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.630186 -0.689482 0.230442 -34.800306 -67.797523 -5.000308 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.099332 -0.000097 -0.000378 -16.617048 31.033979 13.889942 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.290602 0.000366 -0.000038 -0.000816 21.03438 -0.000167 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599894 0.400186 0.000023 -0.000845 180.000005 -0.000008 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999439 -0.000201 1.209393 0.000002 -0.000002 0.000012 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300119 -2.499434 0.600136 -12.691584 -30.213034 -51.108048 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.762361 0.11692 1.52396 3.675055 99.911925 93.36232 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 0.650387 -0.547737 -0.092979 7.528836 -6.421138 95.450036 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 1.899436 -0.000324 -0.000154 1.908699 27.378328 -1.56917 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 0.657068 0.00839 -0.040386 7.529237 -0.001202 95.451914 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.000252 -0.000233 1.908586 27.37867 -1.569054 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.000252 -0.000233 1.908586 27.37867 -1.569054 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.000252 -0.000233 1.908586 27.37867 -1.569054 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 0.665782 0.747219 0.029179 7.529349 5.441385 95.451566 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 1.900724 0.000546 -0.000071 1.908643 27.37862 -1.569227 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.600054 -0.00037 0.000565 0.000113 0.000002 0.000005 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119667 -0.275192 0.000835 -0.000005 23.483247 0.000289 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 8.823002 0.000001 0 -0.000229 -16.850975 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.11697 -0.000429 -0.000013 0.000229 16.850971 0.000057 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233002 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598 0 0 0 -0.000057 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.481003 -0.202001 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.516998 -0.291001 -0.001 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.241989 -6.380002 0 0 -0.000115 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512001 -3.547001 -1.066 89.999982 -0.000057 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456001 -3.517001 1.169 89.999982 -0.000057 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171997 -0.106 -0.902 58.967373 -179.596532 89.995201 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_spine4" 9.904999 -5.486001 -6.443002 0 -179.999964 89.999982 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" -0.000004 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" -0.000004 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 3.999992 -6.500001 0 0.000286 0.056264 0 0 0 0 0 0 0
$definebone "j_crotch" "j_mainroot" -6.5 -0.000001 0 89.999982 0 0 0 0 0 0 0 0
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
	"mp_western_vm_milsim_iw9_anims\Idle.smd"
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
