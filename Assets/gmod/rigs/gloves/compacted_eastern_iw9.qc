// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_eastern_iw9.mdl"

$bodygroup "gloves"
{
	studio "compacted_eastern_iw9.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -21.073 -36.909 -0.815 31.336 33.65 72.151

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -4.867001 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000084 -0.000017 0.000013 0 -0.000057 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.162535 -0.000194 0.00022 -0.00063 6.832234 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.74938 0.295191 0.000035 -0.000057 -66.404663 0.000115 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413528 0.000366 0 0 -29.682189 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017889 0.299793 0 -0.000286 -3.414714 0.000115 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999891 -0.000181 0.000127 -0.000917 0.000688 0 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 4.867001 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000092 -0.000017 0.000012 0 -0.000057 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283621 1.58161 -4.695846 -4.96955 5.167966 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.16254 -0.000194 0.000218 -0.00063 6.832234 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.74938 0.29519 0.000036 -0.000057 -66.404609 0.000115 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413527 0.000361 -0.000001 0 -29.682254 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017889 0.299792 0 -0.000286 -3.414714 0.000115 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.499844 0.000328 0.000121 -0.000917 0.001604 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.533001 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.25 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.531002 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.036999 -0.021001 -1.943001 88.660404 -66.294021 -66.289561 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.784616 -0.000036 0.000275 47.370654 -14.199839 -4.286068 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500221 0.000129 -0.000057 -0.000007 -0.000113 0.000115 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 11.530247 -0.000421 0.000061 -0.000059 -46.96701 -0.000455 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.600061 -0.000372 -0.00066 0.000056 -0.000231 0.000003 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" 5.651674 19.507771 -44.898491 -7.068522 -32.57529 46.575685 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.244615 0.021804 0.107395 5.568972 0.691844 1.340382 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.041281 -0.000389 -0.000675 0.000056 -0.000231 -0.000053 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -18.909893 -8.427635 0.000526 -7.073907 -32.571161 46.573861 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.580784 -27.862274 -37.184555 -7.07385 -32.571219 46.573052 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.610309 -0.939529 0.07029 -8.024563 -10.060338 -94.842333 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.619615 0.000134 0.000397 -1.153017 20.058623 11.551794 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.867865 -0.000046 -0.000502 -0.000455 26.531672 -0.000408 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.920012 -0.000294 -0.000411 -0.000395 36.229605 -0.000459 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.599503 0.400699 0.000232 0.000004 0 -0.000002 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.20045 0.398918 -0.000729 0.92023 0.408975 -0.542484 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000111 0.099686 -0.000889 -1.256726 -12.009941 -6.87797 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.639947 -0.199152 0.060181 -7.528324 -3.805587 -95.452925 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.659568 0.000114 -0.000803 -1.910577 27.379187 1.569035 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.008792 -0.000107 -0.000267 0.001041 56.057562 0.001206 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.099678 -0.000419 0.000139 0.000409 26.5676 0.000292 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000225 0.098991 0.00021 0.622125 -13.706702 -1.078718 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600177 1.080265 -0.339481 1.189856 6.154308 -99.586419 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.199737 0.000515 0.000128 0.00064 35.990862 0.000053 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.179323 0.000221 -0.000677 -0.000794 42.582401 -0.000917 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.680134 -0.001232 0.000439 0.000293 31.299137 0.00029 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000195 0.099625 -0.000029 -0.001598 -17.996491 -0.000009 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.599433 0.958698 -0.30069 -0.000454 0.000683 -10.00116 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.609756 0.400169 -0.009396 -3.531029 2.461711 -100.971083 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.560414 -0.000168 0.000032 -2.900935 29.876767 0.142204 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.708748 0.000729 -0.000187 0.000178 47.511779 -0.000398 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.02 -0.000793 -0.000206 -0.000339 32.470835 -0.000278 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.00013 0.100445 0.000319 1.326521 -14.945839 -0.624986 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.629727 -0.690044 -0.229763 34.80048 -67.797305 4.999639 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.099438 0.000475 -0.00042 16.616744 31.033962 -13.889927 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290001 -0.000224 0.000595 -0.000063 21.034541 0.00063 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.599888 0.400182 -0.000034 -0.000005 -0.000001 0.000001 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.999544 0.00038 -1.210197 -0.000003 -0.000003 0.000007 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299671 -2.499985 -0.599468 12.693077 -30.211668 51.107263 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.441182 0.008648 0.276375 19.905352 -0.639713 -93.486998 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 6.507309 18.151739 -45.009392 -7.509927 -42.528825 -48.030239 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 1.899125 0.000427 -0.000434 -1.908576 27.378612 1.569156 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 6.70202 18.527365 -44.643608 -12.202965 -38.163743 -47.93828 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799667 -0.000217 0.000236 -1.908636 27.379302 1.569217 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799667 -0.000217 0.000236 -1.908636 27.379302 1.569217 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 6.959244 19.025633 -44.157463 -16.176314 -34.397864 -48.147981 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 1.900314 -0.000131 -0.000512 -1.908636 27.378897 1.569162 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.99944 -0.000544 -0.00034 0.000056 -0.000118 -0.000054 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119207 -0.275759 -0.000137 0.000286 23.483015 -0.000283 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 5.999828 -0.000379 -3.99995 -0.000115 -0.000115 0.000114 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.037998 -0.021001 1.943 -88.659947 -66.257582 66.253115 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.784618 -0.000027 -0.000179 -47.373181 -14.200528 4.286528 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500225 0.000131 0.000057 -0.000003 0.000231 0.000229 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.52952 -0.000419 -0.00106 0.000456 -46.966549 -0.000227 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999903 0.000017 0.000965 0.000455 -0.000342 -0.000225 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041283 -0.000418 0.000519 0.000455 -0.000458 -0.000227 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -18.909428 -8.427099 0.000259 7.074254 -32.571048 133.425601 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -18.909428 -8.427099 0.000259 7.074254 -32.571048 133.425601 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228305 7.928228 -3.925648 7.074195 -32.571161 133.425888 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.610309 -0.939537 -0.070297 8.025303 -10.060452 94.841473 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.619617 0.000149 -0.000404 1.153822 20.058852 -11.551288 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.867866 -0.00005 0.00053 -0.000286 26.531556 0.000458 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.919382 0.000404 0.00009 -0.00006 36.22967 0.000171 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.600395 0.399632 -0.00047 -0.0004 -179.999978 0 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.20006 0.399944 -0.000148 -0.921888 0.408748 0.542936 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000596 0.100349 0.000324 1.256152 -12.009657 6.878243 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639943 -0.199154 -0.060184 7.52849 -3.805015 95.452706 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.659901 0.000778 0.000164 1.908465 27.3789 -1.56876 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.008772 -0.000893 -0.000389 0.000459 56.057733 -0.000171 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.100353 0.000012 0.000467 -0.000628 26.568113 0.000514 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000219 0.098995 -0.000208 -0.620685 -13.706524 1.077905 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600178 1.080261 0.339474 -1.189577 6.154769 99.586316 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.199737 0.000526 -0.00012 -0.000058 35.990688 0.000055 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.180098 0.000376 0.000076 -0.000399 42.582329 0.000343 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.679455 -0.00082 0.000172 0.000231 31.299485 -0.000172 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000193 0.099627 0.000029 -0.00006 -17.996432 0.00017 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599958 0.95927 0.300079 -0.000002 0.00052 10.001433 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610215 0.400728 0.010078 3.531252 2.461944 100.97126 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.560414 -0.000164 -0.000029 2.901348 29.876719 -0.14221 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.708752 0.000729 0.0002 0.000006 47.511544 0.000002 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.019806 -0.000023 -0.000397 -0.000283 32.471003 0.00012 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.00058 0.100147 0.000311 -1.325363 -14.945197 0.625666 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.630194 -0.689478 0.23045 -34.800886 -67.796833 -5.000201 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.099339 -0.000103 -0.000408 -16.616187 31.033566 13.890272 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.290607 0.000372 -0.000046 -0.001617 21.034886 -0.000575 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599894 0.40018 0.000019 -0.001535 180.000005 0 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999453 -0.000196 1.209385 -0.000005 -0.000007 0.000005 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300143 -2.49942 0.60014 -12.696287 -30.207027 -51.108461 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.762361 0.116943 1.523964 3.675464 99.912383 93.362566 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.441185 0.008648 -0.276382 -19.904899 -0.639762 93.487231 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 6.918246 18.946123 44.347847 6.421711 -22.640195 -129.534032 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 1.899439 -0.000313 -0.000155 1.908408 27.378957 -1.568758 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 6.735638 18.563826 44.711983 1.874431 -27.10612 -130.697118 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799664 -0.000238 -0.000235 1.908691 27.37896 -1.569272 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799664 -0.000238 -0.000235 1.908691 27.37896 -1.569272 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 6.493041 18.056202 45.195969 -2.040648 -30.819398 -131.406269 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 1.90073 0.000547 -0.000075 1.908524 27.378557 -1.568988 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.600063 -0.000404 0.0005 0.0008 -0.000458 -0.000283 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119667 -0.275192 0.000824 0.0008 23.48279 0.000286 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 5.999763 -0.000369 4.000053 -0.000115 0 -0.000113 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 8.823002 -0.000002 0 -0.000745 -16.851491 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.116974 -0.000404 -0.00004 0.000688 16.851492 0.000229 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233009 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598007 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.481003 -0.201999 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.516998 -0.290998 -0.001 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.242004 -6.380003 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512009 -3.547002 -1.066 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456009 -3.517003 1.169 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171989 -0.106 -0.902 58.967598 -179.596532 89.995201 0 0 0 0 0 0
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
	"compacted_eastern_iw9_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_eastern_iw9.qc"
//	}
}
