// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_iw9.mdl"

$bodygroup "gloves"
{
	studio "compacted_iw9.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MWII\rigs\arms\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -10.792 -31.269 0 28.667 21.915 72.151

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" -0.000004 0 -4.867001 0.500347 -179.258943 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000084 -0.000035 -0.000006 0 0 -0.000057 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.162518 -0.000502 -0.000089 0.000401 6.829772 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.749378 0.295627 0.000032 0 -66.402826 0.000172 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413525 0.000327 -0.000001 0 -29.682824 0 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017891 0.299792 0.000001 -0.000115 -3.413396 0.000115 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999889 -0.00036 -0.000052 0.000458 -0.000458 -0.000057 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" -0.000004 0 4.867001 0.500347 -179.258943 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000088 -0.000035 -0.000005 0 0 -0.000057 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283571 1.581383 -4.696066 -4.968862 5.166876 83.781839 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.162525 -0.000502 -0.000089 0.000401 6.829772 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.749376 0.295627 0.000031 0 -66.402826 0.000172 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413524 0.000324 -0.000002 0 -29.682824 0 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017891 0.299792 0 -0.000115 -3.413396 0.000115 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.49984 0.000157 -0.000048 0.000458 -0.000229 -0.000057 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.532997 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.25 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.530998 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.036999 -0.021001 -1.943001 88.66035 -66.290934 -66.286344 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.784617 -0.000035 0.000267 47.371405 -14.200988 -4.287555 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500229 0.000134 -0.000053 -0.000001 -0.000172 0.000174 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 11.530249 -0.000292 0.000206 -0.000058 -46.966324 0.000348 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.600057 -0.000378 -0.00066 -0.000001 -0.000231 0.000003 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" -1.145529 0.000132 0.000683 -0.000001 0.000113 0.000005 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.85769 0.104078 0.104691 9.39215 0.780997 1.348748 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.041277 -0.000389 -0.000679 0.000057 -0.000002 0.000004 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -18.909931 -8.427563 0.000519 -7.073277 -32.572021 46.573909 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.580913 -27.862209 -37.184574 -7.074135 -32.571161 46.572645 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.6103 -0.939541 0.070286 -8.024846 -10.060794 -94.841814 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.619614 0.000149 0.000406 -1.154167 20.059135 11.551166 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.867866 -0.000065 -0.000531 0.000861 26.531033 0.000511 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.920006 -0.000298 -0.000404 0.000293 36.229267 -0.000577 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.599495 0.400702 0.000242 0.000007 -0.000002 -0.000005 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.200456 0.398911 -0.000748 0.922462 0.408001 -0.541909 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000113 0.099682 -0.000886 -1.255927 -12.0104 -6.877388 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.639947 -0.199156 0.060173 -7.528035 -3.805069 -95.452645 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.659571 0.000111 -0.000841 -1.909094 27.378781 1.569211 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.008785 -0.000095 -0.000246 -0.000107 56.058255 0.00034 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.099689 -0.00043 0.00012 0.000465 26.567484 0.000577 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000217 0.098995 0.00021 0.621028 -13.706242 -1.078944 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600185 1.080257 -0.339489 1.189687 6.154081 -99.586193 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.199737 0.000523 0.000134 0.001209 35.990804 -0.000289 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.179325 0.000221 -0.000666 -0.000281 42.582104 -0.000799 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.680126 -0.00123 0.000452 -0.000859 31.299711 -0.001028 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000196 0.099623 -0.000027 -0.001371 -17.996381 0.000166 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.599423 0.958694 -0.30069 -0.000342 0.00063 -10.001214 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.609756 0.400162 -0.009403 -3.53114 2.461712 -100.970625 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.560413 -0.000145 0.000027 -2.901225 29.87717 0.14146 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.708748 0.000717 -0.000204 0.000462 47.511554 0.000517 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.020004 -0.000793 -0.00021 -0.000398 32.470893 -0.000454 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000132 0.100433 0.000322 1.326459 -14.945608 -0.625102 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.629725 -0.69005 -0.229774 34.800705 -67.797646 4.999865 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.099438 0.000478 -0.000408 16.6168 31.034074 -13.88993 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290003 -0.000225 0.000595 -0.000009 21.034476 0.000166 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.599892 0.400182 -0.000034 -0.000009 -0.00001 -0.000005 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.999546 0.000376 -1.21019 -0.000009 -0.000005 0.000061 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299664 -2.499996 -0.59948 12.693133 -30.211778 51.108246 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 0.649933 -0.548302 0.093651 -7.528321 -6.420737 -95.450179 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 1.899123 0.00042 -0.000446 -1.908006 27.378328 1.569443 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 0.657073 0.008392 0.040367 -7.528778 -0.000975 -95.45201 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799665 -0.000237 0.000227 -1.908861 27.378614 1.569381 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799665 -0.000237 0.000227 -1.908861 27.378614 1.569381 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799665 -0.000237 0.000227 -1.908861 27.378614 1.569381 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 0.665774 0.747215 -0.029194 -7.528838 5.441322 -95.451497 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 1.90031 -0.000145 -0.000513 -1.908404 27.378386 1.569213 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.999437 -0.000549 -0.00034 -0.000001 -0.000116 0.000057 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119204 -0.275763 -0.000145 0.000111 23.483128 0.000003 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.037998 -0.021001 1.943 -88.659947 -66.261134 66.256612 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.784619 -0.000027 -0.000191 -47.371983 -14.201158 4.287844 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500221 0.000135 0.000061 -0.000002 0.00006 0.000056 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.529516 -0.000327 -0.000843 -0.000748 -46.966204 -0.000114 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999899 0.000015 0.000969 0.00011 -0.000109 -0.000111 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041276 -0.000397 0.000534 0.000282 -0.000454 -0.000113 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -18.909403 -8.427134 0.00029 7.074194 -32.571106 133.425655 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -18.909403 -8.427134 0.00029 7.074194 -32.571106 133.425655 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228281 7.928244 -3.925652 7.074079 -32.571226 133.425655 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.610311 -0.939537 -0.070293 8.025246 -10.060333 94.841992 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.619615 0.000137 -0.000406 1.153939 20.059028 -11.551178 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.867866 -0.000061 0.000527 0.000288 26.530989 -0.000289 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.919388 0.000412 0.000088 0.000061 36.229383 -0.000116 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.600403 0.39964 -0.000466 0.000911 -179.999978 0 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.20006 0.399929 -0.000152 -0.921603 0.408184 0.541838 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000594 0.100346 0.000324 1.256323 -12.010393 6.87715 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639946 -0.199152 -0.060184 7.528432 -3.804951 95.452761 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.659899 0.000774 0.000153 1.908583 27.378564 -1.568875 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.008777 -0.000889 -0.000383 0.000062 56.05848 0.000056 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.100357 0 0.000465 0.000347 26.567301 -0.000113 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000223 0.098999 -0.000206 -0.620683 -13.706233 1.078415 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600177 1.080261 0.339474 -1.189522 6.154835 99.586255 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.199738 0.000526 -0.000124 -0.000053 35.990517 0.000178 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.180094 0.000378 0.000076 -0.000003 42.582053 -0.000109 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.679459 -0.000818 0.000181 -0.000577 31.299994 0.000289 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000193 0.099623 0.000027 -0.000053 -17.99637 0.000175 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599964 0.959274 0.300076 0.000005 0.000347 10.001268 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610217 0.400732 0.010078 3.531537 2.462005 100.970864 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.560411 -0.000156 -0.000032 2.901119 29.877064 -0.141517 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.708748 0.000721 0.0002 0.00029 47.511376 -0.000162 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.019806 -0.000022 -0.000397 -0.00023 32.470948 0.000067 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.00058 0.10014 0.000311 -1.325359 -14.94554 0.624983 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.630196 -0.689476 0.230446 -34.800251 -67.796949 -5.00037 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.099335 -0.000096 -0.000389 -16.617097 31.034259 13.889709 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.290602 0.000356 -0.000042 -0.00092 21.034199 -0.000223 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599895 0.400183 0.000027 -0.000797 -179.999978 -0.000004 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999437 -0.000203 1.209389 0.000003 -0.000003 0.000009 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300147 -2.499416 0.600132 -12.691477 -30.212468 -51.108175 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.76236 0.116945 1.52396 3.675005 99.912485 93.362498 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 0.650396 -0.547731 -0.092979 7.528893 -6.420563 95.45007 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 1.899437 -0.00032 -0.000156 1.908699 27.378393 -1.569159 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 0.657072 0.008402 -0.040379 7.529347 -0.000627 95.4519 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.00024 -0.000233 1.908586 27.378619 -1.569041 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.00024 -0.000233 1.908586 27.378619 -1.569041 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.00024 -0.000233 1.908586 27.378619 -1.569041 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 0.665773 0.747219 0.02919 7.52906 5.441846 95.451675 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 1.900726 0.000526 -0.000072 1.908757 27.378275 -1.569271 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.600053 -0.000391 0.000515 0.000282 -0.00022 -0.000113 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119665 -0.275198 0.00082 0.000222 23.483145 0.000285 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 8.823002 -0.000002 0 -0.000229 -16.850975 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.11697 -0.000431 -0.000014 0.000229 16.850971 0.000057 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233002 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.48101 -0.201999 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.517006 -0.290999 -0.001 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.241997 -6.380003 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512001 -3.547 -1.066 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456001 -3.517002 1.169 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171997 -0.106 -0.902 58.96725 -179.596464 89.995262 0 0 0 0 0 0
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
	"compacted_iw9_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_iw9.qc"
//	}
}
