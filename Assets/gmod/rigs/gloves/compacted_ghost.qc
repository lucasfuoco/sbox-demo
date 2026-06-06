// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_ghost.mdl"

$bodygroup "gloves"
{
	studio "compacted_ghost.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -23.391 -40.969 -0.905 34.738 37.089 80.088

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.11766 0 71.395203 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -1.00344 0 -13.10466 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -15.888538 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -5.402371 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.110104 -0.000019 0.000015 0 -0.000057 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 19.050428 -0.000215 0.000244 -0.00063 6.833151 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 19.70182 0.32734 0.000036 -0.000057 -66.405524 0.000115 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 6.009016 0.000399 -0.000004 0 -29.682079 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.019857 0.33277 0 -0.000286 -3.41563 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 11.09989 -0.000201 0.000142 -0.000917 0.000229 0 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 5.402371 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.110104 -0.000019 0.000014 0 -0.000057 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 13.634825 1.755587 -5.212392 -4.96955 5.167966 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 19.05043 -0.000216 0.000243 -0.00063 6.833151 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 19.701824 0.32734 0.000036 -0.000115 -66.405462 0.000115 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 6.009015 0.000393 -0.000004 0 -29.682366 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.019859 0.332769 0 -0.000286 -3.41563 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 10.544832 0.000364 0.000135 -0.000917 0.00212 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.921631 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.9375 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 5.029411 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.591068 -0.023311 -2.156732 88.660466 -66.293051 -66.288584 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 6.420922 -0.000047 0.000309 47.370661 -14.199956 -4.286068 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.555252 0.000143 -0.000076 -0.000002 -0.000057 0.000058 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 12.798573 -0.000459 0.000061 -0.000059 -46.966959 -0.000569 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 11.766069 -0.000425 -0.000732 0.000056 -0.000007 0.000117 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" 6.27344 21.653561 -49.837341 -7.068864 -32.575235 46.575057 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.271524 0.024201 0.119206 5.568919 0.691441 1.340955 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 12.255824 -0.000439 -0.000755 0.000056 -0.000007 0.000173 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -20.990017 -9.354584 0.00061 -7.073737 -32.571618 46.573844 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -10.634796 -30.927185 -41.274773 -7.073852 -32.571509 46.57299 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.677435 -1.042889 0.078026 -8.024619 -10.06057 -94.84245 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.907772 0.000141 0.000441 -1.153015 20.058679 11.551802 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 2.073331 -0.000057 -0.000555 -0.000453 26.531665 -0.000458 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 1.021215 -0.000332 -0.000462 -0.000397 36.229605 -0.000454 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.665451 0.444773 0.000259 0.000004 -0.000005 0.000003 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.332503 0.442802 -0.000807 0.92023 0.408978 -0.542477 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000122 0.110645 -0.000988 -1.256724 -12.00994 -6.87796 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.710343 -0.221062 0.066799 -7.528322 -3.80582 -95.453048 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.952123 0.000126 -0.000889 -1.91058 27.379245 1.569044 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.229753 -0.000114 -0.000303 0.001035 56.057442 0.001207 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.220657 -0.000466 0.000158 0.000402 26.567597 0.00029 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000244 0.109886 0.000223 0.622183 -13.706813 -1.078655 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.666203 1.199089 -0.376827 1.189862 6.154079 -99.586542 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.441706 0.00058 0.000147 0.00069 35.990808 0.000003 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.309052 0.000248 -0.000751 -0.000861 42.582456 -0.000912 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.754944 -0.001369 0.00049 0.000284 31.299134 0.000294 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000214 0.110584 -0.000031 -0.00166 -17.99643 0.000061 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.665366 1.064152 -0.333763 -0.000509 0.000688 -10.001207 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.676831 0.444183 -0.010429 -3.530969 2.461481 -100.97126 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.84206 -0.000183 0.000036 -2.900939 29.876835 0.142208 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.896717 0.000805 -0.000202 0.000176 47.51168 -0.000342 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.132206 -0.000883 -0.000227 -0.00034 32.470835 -0.000335 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000153 0.111488 0.000359 1.326514 -14.945893 -0.624924 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.698996 -0.765949 -0.255039 34.80037 -67.797578 4.999572 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.330373 0.000528 -0.000462 16.616809 31.033972 -13.889929 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.431904 -0.00025 0.000664 -0.00006 21.034537 0.000625 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.665871 0.444201 -0.000038 0 -0.000003 -0.000005 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 1.109494 0.000423 -1.343315 -0.000003 0.000002 -0.000056 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.552627 -2.774994 -0.665405 12.692962 -30.211955 51.10715 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.709714 0.009588 0.306782 19.905355 -0.639998 -93.487121 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 7.223198 20.148266 -49.960468 -7.510275 -42.529228 -48.031386 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 2.108029 0.000493 -0.000486 -1.909034 27.378842 1.570073 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 7.439326 20.565214 -49.554462 -12.203026 -38.163976 -47.937655 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.997631 -0.000244 0.000264 -1.908292 27.379302 1.568529 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.997631 -0.000244 0.000264 -1.908292 27.379302 1.568529 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 7.724848 21.11829 -49.014835 -16.175975 -34.397584 -48.148739 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 2.109347 -0.000162 -0.000571 -1.908863 27.378263 1.569561 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 4.439383 -0.000608 -0.000381 0.000057 -0.000118 0.000058 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.132318 -0.306097 -0.00016 0.000229 23.483012 -0.000228 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 6.659807 -0.000427 -4.439945 0 -0.000114 0 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.592178 -0.023311 2.15673 -88.659899 -66.258559 66.254092 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 6.420924 -0.000023 -0.000202 -47.373181 -14.200819 4.286524 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.555252 0.000149 0.000061 0 0.0004 0.0004 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 12.79777 -0.000419 -0.001175 0.000457 -46.966382 -0.000231 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 4.439888 0.000015 0.001057 0.000629 -0.000342 -0.000055 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 12.255816 -0.000458 0.000534 0.000629 -0.000456 -0.000171 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -20.989449 -9.354082 0.000286 7.073965 -32.571331 133.425819 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -20.989449 -9.354082 0.000286 7.073965 -32.571331 133.425819 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 8.023413 8.800345 -4.35746 7.073965 -32.57128 133.425888 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.677445 -1.042881 -0.078033 8.025306 -10.060394 94.841473 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.907768 0.00016 -0.000452 1.153825 20.058855 -11.551234 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 2.073328 -0.000057 0.000586 -0.000285 26.531513 0.000456 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 1.020512 0.00045 0.000101 -0.000056 36.22967 0.000172 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.666443 0.443592 -0.000528 -0.000402 -179.999978 0.000002 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.332067 0.443935 -0.000164 -0.921888 0.408756 0.542935 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000661 0.111393 0.00036 1.256152 -12.009651 6.87824 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.710338 -0.221056 -0.066811 7.528494 -3.804953 95.452829 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.952487 0.00087 0.000181 1.908467 27.378904 -1.568763 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.229742 -0.000988 -0.000423 0.000464 56.057733 -0.000172 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.221397 0.000012 0.000519 -0.000624 26.568109 0.000577 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.00025 0.10989 -0.000225 -0.620685 -13.706466 1.077903 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.6662 1.199097 0.37682 -1.189575 6.154771 99.586364 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.44171 0.000587 -0.000135 -0.000056 35.990688 0.000056 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.309906 0.000416 0.000086 -0.000399 42.582391 0.000347 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.754189 -0.000908 0.000195 0.000227 31.299482 -0.000172 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000214 0.11058 0.000029 -0.000058 -17.996375 0.00017 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.665956 1.064793 0.333084 0.000002 0.000577 10.001434 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.677344 0.444817 0.011185 3.531252 2.462004 100.971322 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.842062 -0.000175 -0.000032 2.901407 29.876719 -0.142205 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.896709 0.000813 0.000229 0.000003 47.511554 0.000009 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.131989 -0.000022 -0.000435 -0.000289 32.470945 0.000123 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000645 0.11116 0.000351 -1.325358 -14.945195 0.62567 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.699517 -0.765316 0.255802 -34.801115 -67.796608 -5.000148 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.330263 -0.000117 -0.000469 -16.6159 31.033456 13.890275 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.432571 0.000404 -0.000053 -0.001668 21.034831 -0.000519 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.66588 0.444204 0.000019 -0.0016 -179.999978 0.000004 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 1.109396 -0.000216 1.3424 -0.000005 -0.000007 0.000003 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.553162 -2.774355 0.666145 -12.696289 -30.207027 -51.108403 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 3.066222 0.129812 1.691605 3.67541 99.912437 93.362498 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.709721 0.009605 -0.306786 -19.904901 -0.639706 93.487005 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 7.679253 21.030136 49.226143 6.421882 -22.640202 -129.533513 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 2.108376 -0.000344 -0.000171 1.908636 27.378851 -1.569155 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 7.476557 20.605783 49.630337 1.875119 -27.106634 -130.696653 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.997622 -0.000293 -0.000259 1.908925 27.37805 -1.569615 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.997622 -0.000293 -0.000259 1.908925 27.37805 -1.569615 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 7.207273 20.042316 50.167553 -2.040994 -30.819002 -131.405477 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 2.109811 0.000623 -0.00008 1.908866 27.37902 -1.569671 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 11.766064 -0.000446 0.000523 0.000972 -0.000227 -0.000173 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.132828 -0.305466 0.000908 0.000916 23.48279 0.000458 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 6.659736 -0.000403 4.44006 0 0.000229 -0.000002 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 9.79353 -0.000002 0 -0.000745 -16.851491 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.459846 -0.00045 -0.000044 0.000688 16.851492 0.000229 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.918633 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.773781 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.973915 -0.224219 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -6.123871 -0.323009 -0.00111 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.928612 -7.081801 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.898323 -3.937171 -1.18326 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.836159 -3.903872 1.29759 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.190918 -0.11766 -1.00122 58.967598 -179.596532 89.995201 0 0 0 0 0 0
$definebone "j_proc_spine4" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_proc_spine4" 10.994549 -6.089463 -7.151734 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" -53.261135 -1.121102 0.00007 -0.003495 -89.999982 -89.999982 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 4.439999 -7.215003 0 0.000802 0.056723 0 0 0 0 0 0 0
$definebone "j_crotch" "j_mainroot" -7.215 0.000001 0 89.999982 0 0 0 0 0 0 0 0
$definebone "tag_weapon" "tag_torso" 15.748681 0 0.157619 0 0 0 0 0 0 0 0 0
$definebone "tag_cambone" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_camera" "tag_cambone" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_player" "tag_camera" 0.11766 0 -71.395203 0 0 0 0 0 0 0 0 0
$definebone "tag_playerhelmet" "tag_camera" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_camera_scripted" "tag_origin" -0.11766 0 71.395203 0 0 0 0 0 0 0 0 0

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
	"compacted_ghost_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_ghost.qc"
//	}
}
