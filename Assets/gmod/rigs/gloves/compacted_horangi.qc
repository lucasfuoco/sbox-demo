// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_horangi.mdl"

$bodygroup "gloves"
{
	studio "compacted_horangi.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -21.073 -36.909 -0.815 31.294 33.401 72.151

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -4.867001 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000084 -0.000017 0.000013 0 -0.000057 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.162552 -0.000194 0.000219 -0.00063 6.83361 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.749397 0.294755 0.000031 -0.000115 -66.406036 0.000115 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413528 0.000368 -0.000007 0.000057 -29.681909 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017891 0.299792 0.000001 -0.000286 -3.416089 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999897 -0.000181 0.000129 -0.000917 -0.000229 0 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 4.867001 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000092 -0.000017 0.000012 0 -0.000057 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283625 1.581611 -4.695848 -4.96955 5.167966 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.162558 -0.000194 0.000217 -0.00063 6.83361 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.749397 0.294755 0.000031 -0.000115 -66.405981 0.000115 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413527 0.000363 -0.000005 0 -29.682308 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017893 0.299792 0 -0.000286 -3.416089 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.499849 0.000328 0.000122 -0.000917 0.00212 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.533001 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.25 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.531002 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.036999 -0.021001 -1.943002 88.66052 -66.292532 -66.288065 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.784615 -0.000045 0.000275 47.370661 -14.199845 -4.286064 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500233 0.000128 -0.000057 0.000003 -0.000117 0.000172 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 11.530254 -0.000433 0.000065 0.000059 -46.967072 -0.00046 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.600061 -0.000372 -0.000652 0.000002 0.000002 -0.000001 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" 5.651738 19.507776 -44.898487 -7.068752 -32.575286 46.575685 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.244616 0.021806 0.107395 5.568919 0.691503 1.340379 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.041286 -0.000385 -0.000675 0.000003 0.000231 0.000053 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -18.90996 -8.427494 0.000546 -7.073852 -32.571683 46.573841 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.581006 -27.862247 -37.184502 -7.073966 -32.571564 46.572642 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.610299 -0.939541 0.070293 -8.024617 -10.060736 -94.842388 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.619614 0.00013 0.000389 -1.153026 20.058628 11.551861 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.867864 -0.000053 -0.000498 -0.000464 26.531673 -0.000458 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.920006 -0.000298 -0.000413 -0.000407 36.229605 -0.000459 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.599499 0.400698 0.000232 0.00005 -0.000004 -0.000002 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.20045 0.398918 -0.000726 0.920165 0.408983 -0.542531 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000113 0.099682 -0.000883 -1.256786 -12.009938 -6.877954 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.639944 -0.199156 0.060177 -7.528262 -3.806042 -95.453 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.659571 0.000118 -0.000805 -1.910587 27.379139 1.569053 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.008787 -0.000099 -0.000277 0.001022 56.057558 0.001204 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.099693 -0.000422 0.000139 0.000393 26.567592 0.00028 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000219 0.098999 0.000196 0.622176 -13.706694 -1.078644 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600186 1.080257 -0.339485 1.189864 6.153909 -99.586487 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.199738 0.000519 0.000137 0.000628 35.990859 0.000063 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.179325 0.000221 -0.000681 -0.000806 42.582391 -0.000917 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.680134 -0.001235 0.000444 0.000279 31.299134 0.000283 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000195 0.099625 -0.000032 -0.001665 -17.99649 0.000003 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.599428 0.958698 -0.300682 -0.000514 0.000688 -10.001147 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.609757 0.400164 -0.009396 -3.530964 2.461313 -100.971151 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.560414 -0.000156 0.00004 -2.900888 29.876832 0.142213 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.708748 0.000725 -0.000179 0.000226 47.511721 -0.000347 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.019997 -0.000797 -0.000202 -0.000345 32.470829 -0.000347 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000139 0.100441 0.000324 1.326509 -14.945885 -0.62492 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.629721 -0.690052 -0.229763 34.800425 -67.797762 4.999624 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.099433 0.000475 -0.000427 16.61681 31.033972 -13.889932 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290009 -0.000224 0.000591 -0.000058 21.034483 0.000624 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.599886 0.400182 -0.000031 0.000003 0.000058 -0.000007 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.999546 0.000376 -1.210205 0.000061 0.000002 -0.000007 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299652 -2.5 -0.599468 12.69302 -30.212061 51.107198 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.441182 0.008629 0.276375 19.905355 -0.640162 -93.487067 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 6.507452 18.151636 -45.009403 -7.510391 -42.529628 -48.030997 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 1.899127 0.000448 -0.000437 -1.908924 27.379192 1.56979 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 6.702158 18.52726 -44.643631 -12.202912 -38.164092 -47.938178 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799667 -0.000222 0.000236 -1.908522 27.379191 1.569046 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799667 -0.000222 0.000236 -1.908522 27.379191 1.569046 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 6.959385 19.025522 -44.157486 -16.176318 -34.398212 -48.147824 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 1.900313 -0.000128 -0.000511 -1.908523 27.378789 1.568935 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.999441 -0.000544 -0.000336 0.000003 -0.000114 -0.000003 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119209 -0.275763 -0.000145 0.000232 23.483015 -0.000225 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 5.999827 -0.000388 -3.999954 0 -0.000229 0.000003 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.037998 -0.021001 1.943 -88.659899 -66.259071 66.254611 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.784616 -0.000018 -0.000179 -47.373181 -14.200929 4.286527 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500225 0.000135 0.00005 0 0.000517 0.000516 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.52952 -0.000357 -0.001068 0.000514 -46.966204 -0.000112 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999903 0.00001 0.000946 0.00063 -0.000453 -0.000228 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041279 -0.000427 0.000477 0.000628 -0.000912 -0.000228 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -18.909355 -8.427238 0.000252 7.074024 -32.570874 133.425491 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -18.909355 -8.427238 0.000252 7.074024 -32.570874 133.425491 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228251 7.928292 -3.925644 7.073967 -32.570932 133.425888 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.61032 -0.939526 -0.070297 8.025306 -10.059991 94.841534 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.619613 0.000149 -0.000395 1.153827 20.058853 -11.551285 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.867864 -0.000061 0.000534 -0.000285 26.531561 0.00046 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.919382 0.000404 0.000089 -0.000057 36.22967 0.000174 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.600395 0.399632 -0.000473 -0.000401 -179.999978 -0.000002 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.200061 0.399933 -0.000144 -0.921887 0.408753 0.542939 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000595 0.100342 0.00033 1.256155 -12.009652 6.878249 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639949 -0.199144 -0.060188 7.528494 -3.804552 95.452836 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.659896 0.000782 0.000166 1.908469 27.378847 -1.568761 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.008771 -0.000893 -0.000383 0.00046 56.057797 -0.000164 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.100353 0.000013 0.000469 -0.000629 26.568111 0.000521 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000221 0.099003 -0.000204 -0.620624 -13.70647 1.077905 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600176 1.080267 0.33947 -1.189576 6.15517 99.586364 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.199738 0.000534 -0.000122 -0.00006 35.990691 0.000056 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.180096 0.000378 0.000082 -0.000399 42.582343 0.000343 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.679459 -0.000816 0.000179 0.000228 31.299482 -0.000174 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000191 0.099628 0.000029 -0.000061 -17.996433 0.000226 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599961 0.959274 0.300076 0 0.000574 10.00138 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610219 0.40074 0.010075 3.531252 2.462401 100.971322 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.560415 -0.000164 -0.000029 2.901406 29.876713 -0.142209 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.708748 0.000721 0.0002 0.000003 47.511605 0 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.01981 -0.000023 -0.000395 -0.000286 32.470955 0.000116 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000584 0.100136 0.000309 -1.325361 -14.945198 0.625667 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.630204 -0.689468 0.23045 -34.80106 -67.796205 -5.000146 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.099338 -0.000108 -0.000427 -16.61589 31.033395 13.890274 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.290604 0.000364 -0.000042 -0.001723 21.034889 -0.000518 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599899 0.400182 0.000011 -0.001658 -179.999978 0.000001 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999458 -0.000194 1.20937 -0.000002 -0.000058 0 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300166 -2.499401 0.600132 -12.69623 -30.206617 -51.108352 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.762363 0.116968 1.523964 3.675295 99.91284 93.362566 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.441193 0.008671 -0.276386 -19.904899 -0.639304 93.487005 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 6.918118 18.946102 44.347878 6.421999 -22.639856 -129.533554 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 1.899438 -0.000316 -0.000155 1.908636 27.378791 -1.569041 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 6.735516 18.563797 44.712013 1.875004 -27.106058 -130.696599 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799661 -0.000255 -0.000233 1.908924 27.378272 -1.569615 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799661 -0.000255 -0.000233 1.908924 27.378272 -1.569615 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 6.49292 18.056168 45.195995 -2.040475 -30.819057 -131.405408 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 1.900729 0.000541 -0.000072 1.908926 27.378332 -1.569672 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.60006 -0.000412 0.000462 0.00103 -0.000225 -0.000113 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119667 -0.275194 0.00082 0.000972 23.48274 0.000458 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 5.999763 -0.00036 4.000057 0 0.000229 0 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 8.823002 -0.000002 0 -0.000745 -16.851491 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.116974 -0.000406 -0.00004 0.000688 16.851492 0.000229 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233002 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.481003 -0.201999 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.516998 -0.290999 -0.001 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.241997 -6.380001 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512001 -3.547001 -1.066 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456001 -3.517003 1.169001 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171997 -0.106 -0.902 58.967598 -179.596587 89.995201 0 0 0 0 0 0
$definebone "j_proc_spine4" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_proc_spine4" 9.904995 -5.486003 -6.443004 0 179.999978 89.999982 0 0 0 0 0 0
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
	"compacted_horangi_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_horangi.qc"
//	}
}
