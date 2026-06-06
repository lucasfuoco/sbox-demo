// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/arms/mp_vm_arms_kilgore_iw9_1_1.mdl"

$bodygroup "sleeve"
{
	studio "mp_vm_arms_kilgore_iw9_1_1.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\arms\"
$cdmaterials "viper\MWII\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -10.522 -31.269 0 27.408 21.901 72.151

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -4.867001 0.499705 -179.258301 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000088 -0.000024 0.000006 0 0 -0.000057 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.162523 -0.000313 0.0001 -0.000229 6.831376 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.749374 0.295333 0.000025 -0.000057 -66.403973 0.000115 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413526 0.000345 -0.000001 0 -29.682479 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017889 0.299792 0.000001 -0.000057 -3.414428 0 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999889 -0.00025 0.000058 -0.000458 0.000458 -0.000057 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 4.867001 0.499705 -179.258301 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000088 -0.000024 0.000006 0 0 -0.000057 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283598 1.581519 -4.69593 -4.969493 5.167564 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.162525 -0.000313 0.0001 -0.000229 6.831376 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.749374 0.295332 0.000025 -0.000057 -66.403973 0.000115 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413526 0.000345 -0.000002 0 -29.682479 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017891 0.299792 0 -0.000057 -3.414428 0 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.499838 0.000263 0.000055 -0.000458 0.000458 -0.000057 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.533001 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.25 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.531002 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.036999 -0.021001 -1.943001 88.66035 -66.290702 -66.286118 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.784616 -0.000034 0.000271 47.37106 -14.200417 -4.286923 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500225 0.000129 -0.000053 0.000008 -0.00006 0.000057 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 11.530251 -0.000362 0.000134 0.00012 -46.96713 -0.000467 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.600056 -0.000294 -0.000629 0.000009 0.000227 0.000219 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.041275 -0.000303 -0.000648 0.000008 -0.000003 0.000219 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -18.909849 -8.4277 0.000465 -7.073794 -32.571106 46.57424 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.580589 -27.862175 -37.184662 -7.073565 -32.571284 46.574121 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.610312 -0.939533 0.070286 -8.024843 -10.060341 -94.841889 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.619613 0.000137 0.000404 -1.153478 20.058857 11.551645 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.867867 -0.000057 -0.000508 0.000054 26.531274 -0.000563 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.920008 -0.000294 -0.000409 -0.000467 36.229779 -0.000282 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.599499 0.400697 0.000239 -0.000009 -0.000004 0.000005 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.200453 0.398918 -0.000737 0.920686 0.408753 -0.542521 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000111 0.099678 -0.00089 -1.256608 -12.01005 -6.877947 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.639951 -0.19915 0.060177 -7.528317 -3.805133 -95.452597 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.659571 0.000122 -0.000813 -1.909495 27.379025 1.569056 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.008787 -0.000095 -0.000246 0.000394 56.057787 0.000521 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.099686 -0.000421 0.000135 -0.000004 26.567868 0.000056 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000221 0.098995 0.000204 0.621778 -13.706687 -1.078471 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600179 1.080265 -0.339481 1.189698 6.154536 -99.586262 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.199735 0.000526 0.000135 0.000859 35.990695 -0.000109 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.179323 0.000223 -0.000669 -0.00058 42.582227 -0.000857 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.680126 -0.001228 0.000443 0.000167 31.299246 0.000058 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000193 0.099627 -0.000029 -0.001491 -17.996369 0.000121 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.599428 0.958706 -0.300686 -0.000283 0.000465 -10.001089 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.609755 0.400169 -0.009396 -3.531076 2.462339 -100.9707 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.560414 -0.000156 0.000021 -2.900259 29.876835 0.14216 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.70875 0.000721 -0.000177 0.000283 47.511663 -0.000394 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.02 -0.00079 -0.000204 -0.00041 32.470996 -0.000461 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000134 0.100437 0.000317 1.325595 -14.945533 -0.625089 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.629734 -0.690041 -0.229767 34.800886 -67.797113 5.000076 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.099436 0.000484 -0.000416 16.616754 31.033921 -13.890336 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290009 -0.00022 0.000603 -0.000056 21.034257 0.000285 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.599886 0.400185 -0.000031 0 0.000003 -0.000001 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.999548 0.000375 -1.210194 0 0.000009 -0.000003 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299686 -2.499969 -0.599476 12.693025 -30.211317 51.107823 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.441183 0.008656 0.276379 19.90542 -0.639023 -93.486951 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.999436 -0.000515 -0.000336 0.000007 0.000055 0.00022 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119209 -0.275759 -0.000149 0.000068 23.48342 -0.000119 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 5.999822 -0.000384 -3.999962 0 -0.000115 0.000002 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.037998 -0.021001 1.943 -88.660008 -66.260963 66.256441 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.784617 -0.000031 -0.000198 -47.372498 -14.200759 4.287213 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500233 0.000132 0.00005 -0.000001 0 -0.000058 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.529512 -0.0004 -0.000957 0.000573 -46.96713 0 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999904 0.000057 0.001026 0.000055 0.000002 -0.000226 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041277 -0.000294 0.000675 0.000055 0.000002 -0.000226 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -18.909389 -8.427151 0.000134 7.073622 -32.57099 133.425601 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -18.909389 -8.427151 0.000134 7.073622 -32.57099 133.425601 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228312 7.928246 -3.925613 7.073567 -32.571048 133.425942 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.610311 -0.939529 -0.070286 8.024676 -10.06028 94.84176 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.619613 0.000137 -0.000401 1.153881 20.058906 -11.551458 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.86786 -0.000057 0.000526 -0.00005 26.531267 0.000112 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.919388 0.000408 0.000086 -0.000163 36.229721 0.000227 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.60041 0.399631 -0.000471 -0.000181 -180.000005 0.000002 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.200058 0.399933 -0.000147 -0.92177 0.408517 0.542647 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000593 0.100349 0.000326 1.256268 -12.009999 6.877896 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639947 -0.199144 -0.060177 7.527976 -3.804836 95.452706 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.659902 0.000782 0.000158 1.908586 27.378731 -1.568987 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.008776 -0.000881 -0.000387 0.000291 56.058078 -0.000109 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.100361 0.00001 0.000471 -0.000059 26.567762 0.000121 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000225 0.099007 -0.000212 -0.620678 -13.706294 1.07819 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600173 1.080271 0.339478 -1.190095 6.154942 99.586023 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.199738 0.00053 -0.000126 -0.000058 35.990582 0.000171 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.180096 0.00038 0.000074 -0.000171 42.582162 0.000111 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.679455 -0.000814 0.000175 0.000231 31.299588 -0.000287 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000193 0.099625 0.000029 -0.00006 -17.996367 0.00017 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599961 0.959278 0.300072 -0.000003 0.000349 10.001263 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610213 0.40074 0.010082 3.531135 2.462173 100.970639 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.560411 -0.000145 -0.000032 2.901179 29.877061 -0.14187 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.708742 0.000729 0.0002 0.000065 47.511489 -0.000056 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.01981 -0.000021 -0.000393 -0.000167 32.471061 -0.000046 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000584 0.100143 0.000313 -1.325361 -14.945427 0.625259 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.630195 -0.689468 0.230461 -34.800483 -67.797236 -4.999912 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.099334 -0.000099 -0.000389 -16.617388 31.033801 13.890217 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.290598 0.000365 -0.00005 -0.000007 21.034375 -0.000286 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599899 0.400182 0.000023 -0.00028 -179.999978 -0.000002 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999435 -0.000205 1.209385 -0.000005 0 0.000003 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300144 -2.499401 0.60017 -12.695543 -30.208448 -51.108345 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.762345 0.116964 1.523991 3.675865 99.912554 93.362272 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.441185 0.008663 -0.276363 -19.905644 -0.639589 93.487306 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.600058 -0.000284 0.000664 0.000055 0.000231 -0.000225 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119669 -0.275192 0.000828 0.000339 23.483363 -0.000056 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 5.999769 -0.000379 4.000038 0 0 0.000114 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 8.823002 -0.000002 0 -0.000286 -16.851033 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.11697 -0.000427 -0.000017 0.000286 16.851033 0.000115 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233002 0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598 0.000001 0 0 0.000057 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.481003 -0.201999 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.516998 -0.290999 -0.001 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.241997 -6.38 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512001 -3.547 -1.066 89.999982 0.000057 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456001 -3.517 1.169 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171997 -0.106 -0.902 58.967653 -179.596464 89.995201 0 0 0 0 0 0
$definebone "j_proc_spine4" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_proc_spine4" 9.904995 -5.486003 -6.443002 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 3.999992 -6.500003 0 0.000401 0.056322 0 0 0 0 0 0 0
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
	"mp_vm_arms_kilgore_iw9_1_1_anims\Idle.smd"
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
