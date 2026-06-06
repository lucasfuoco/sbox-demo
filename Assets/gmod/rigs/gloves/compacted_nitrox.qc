// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_nitrox.mdl"

$bodygroup "gloves"
{
	studio "compacted_nitrox.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -23.391 -40.968 -0.904 34.756 37.192 80.088

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.11766 0 71.395203 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -1.00344 0 -13.10466 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -15.888538 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -5.40237 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.110104 -0.000019 0.000015 0 0 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 19.050465 -0.000213 0.000242 -0.00063 6.835959 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 19.701839 0.326376 0.000026 -0.000115 -66.408618 0.000057 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 6.009017 0.000431 -0.000005 0 -29.681963 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.019865 0.33277 -0.000002 -0.000229 -3.418438 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 11.099899 -0.0002 0.000144 -0.000917 -0.001375 0 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 5.40237 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.1101 -0.000019 0.000015 0 0 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 13.634834 1.755582 -5.212397 -4.969779 5.167965 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 19.050463 -0.000213 0.000244 -0.00063 6.835959 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 19.701839 0.326376 0.000026 -0.000115 -66.408618 0.000057 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 6.009016 0.000432 -0.000004 0 -29.682079 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.019867 0.33277 -0.000002 -0.000229 -3.418438 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 10.544836 0.000365 0.000137 -0.000917 0.00212 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.921631 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.9375 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 5.029408 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.591068 -0.023312 -2.156734 88.660637 -66.290018 -66.285545 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 6.420921 -0.000067 0.000309 47.370654 -14.200187 -4.286067 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.555241 0.000142 -0.000069 -0.000006 -0.000002 0 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 12.798563 -0.000449 0.000072 -0.000062 -46.967072 -0.000453 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 11.766069 -0.00038 -0.000717 -0.000061 0.000452 -0.000111 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" 6.27352 21.653597 -49.837292 -7.06835 -32.575976 46.57437 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.271522 0.02419 0.119203 5.568918 0.692188 1.341809 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 12.25582 -0.000393 -0.000736 -0.000059 -0.000007 -0.000051 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -20.989985 -9.354652 0.000603 -7.073619 -32.571509 46.574032 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -10.634724 -30.927162 -41.274815 -7.073676 -32.571393 46.573339 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.677439 -1.042879 0.078022 -8.024563 -10.060398 -94.842333 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.907771 0.000137 0.000441 -1.152898 20.05856 11.551799 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 2.073324 -0.000053 -0.000551 -0.00045 26.531668 -0.00046 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 1.021214 -0.000332 -0.000458 -0.000453 36.229611 -0.000454 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.665451 0.444777 0.000259 0.000064 0.000001 0.000003 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.332499 0.442799 -0.000811 0.920119 0.409031 -0.542484 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000121 0.110641 -0.000988 -1.25678 -12.009887 -6.877962 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.71034 -0.221058 0.066799 -7.528267 -3.805649 -95.452986 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.952123 0.000122 -0.000893 -1.910633 27.379187 1.56898 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.229752 -0.000118 -0.000299 0.001035 56.057453 0.001264 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.220654 -0.000468 0.000158 0.000403 26.567544 0.000294 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000244 0.109882 0.000229 0.622236 -13.706816 -1.078714 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.666198 1.199093 -0.376831 1.189915 6.154246 -99.586474 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.441704 0.00058 0.000153 0.000644 35.990855 0.000002 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.30905 0.000248 -0.00075 -0.000795 42.582391 -0.000903 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.754948 -0.00137 0.000488 0.000284 31.29914 0.000301 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000217 0.110588 -0.000034 -0.001759 -17.996495 0.000055 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.665362 1.064163 -0.333759 -0.000563 0.000687 -10.001154 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.676824 0.444187 -0.010437 -3.530971 2.461652 -100.971144 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.842059 -0.000183 0.000034 -2.900931 29.876829 0.142202 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.896709 0.000805 -0.000202 0.000242 47.511674 -0.00034 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.132198 -0.000879 -0.000229 -0.000337 32.470897 -0.000333 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000153 0.111485 0.00036 1.326521 -14.945893 -0.624932 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.698999 -0.765951 -0.255047 34.800422 -67.797352 4.999579 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.330375 0.000532 -0.000462 16.616855 31.033907 -13.889926 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.431904 -0.00025 0.000664 -0.000067 21.034532 0.000628 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.665876 0.4442 -0.000038 -0.000009 -0.000004 -0.000003 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 1.109495 0.00042 -1.343319 0.000055 -0.000003 0.000005 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.552631 -2.774979 -0.665409 12.692961 -30.211665 51.107215 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.70971 0.009602 0.30677 19.90541 -0.639657 -93.486998 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 7.223102 20.148354 -49.960419 -7.509639 -42.528542 -48.030471 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 2.108025 0.000456 -0.000483 -1.90863 27.378151 1.569274 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 7.43923 20.565296 -49.554409 -12.201933 -38.162832 -47.937252 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.997626 -0.000292 0.000266 -1.908059 27.378038 1.568072 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.997626 -0.000292 0.000266 -1.908059 27.378038 1.568072 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 7.724741 21.118368 -49.014793 -16.177172 -34.398612 -48.14741 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 2.109354 -0.000095 -0.000567 -1.908462 27.37993 1.56876 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 4.439383 -0.000589 -0.000378 -0.00006 0.000051 -0.000109 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.132322 -0.306093 -0.000156 0.000224 23.483193 -0.000342 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 6.659804 -0.000447 -4.439941 0 -0.000573 -0.000057 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.592178 -0.023312 2.15673 -88.659721 -66.261537 66.257124 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 6.420923 -0.000004 -0.000202 -47.373127 -14.201505 4.286527 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.55526 0.000153 0.000053 -0.000008 0.001031 0.00109 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 12.797771 -0.000282 -0.001179 0.00057 -46.965641 0.000578 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 4.439888 -0.000002 0.00103 0.000972 -0.000521 -0.000509 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 12.255811 -0.000496 0.000469 0.000628 -0.000463 -0.000511 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -20.989471 -9.354052 0.000408 7.073964 -32.571738 133.425136 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -20.989471 -9.354052 0.000408 7.073964 -32.571738 133.425136 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 8.02341 8.80033 -4.357506 7.074365 -32.571335 133.425546 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.677444 -1.042885 -0.078033 8.025646 -10.060512 94.841432 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.90777 0.000156 -0.000443 1.15382 20.058848 -11.551285 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 2.073329 -0.000061 0.000593 -0.000345 26.531491 0.000453 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 1.020515 0.00045 0.000097 -0.000057 36.22967 0.000169 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.666443 0.443592 -0.000526 -0.0004 179.999978 0.000005 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.332067 0.443932 -0.00016 -0.921893 0.408742 0.542936 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000662 0.111389 0.000359 1.25615 -12.009656 6.878244 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.71034 -0.22106 -0.066811 7.528833 -3.805015 95.452761 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.952485 0.000866 0.000183 1.908407 27.378904 -1.568815 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.229736 -0.000996 -0.000429 0.000455 56.057733 -0.000174 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.221401 0.000015 0.000523 -0.000631 26.568113 0.000569 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000244 0.10989 -0.000229 -0.62063 -13.706523 1.07791 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.666209 1.199089 0.376812 -1.189235 6.154651 99.586371 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.44171 0.000587 -0.000135 -0.000002 35.990627 0.000053 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.309906 0.000416 0.000088 -0.000458 42.582391 0.000283 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.7542 -0.000909 0.000198 0.000229 31.299485 -0.000176 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000214 0.110584 0.000031 -0.000118 -17.996375 0.000166 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.665956 1.064796 0.33308 -0.000005 0.000577 10.001433 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.677347 0.444815 0.011185 3.531595 2.461883 100.971322 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.842063 -0.000187 -0.000029 2.901346 29.876767 -0.142209 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.896706 0.000801 0.000233 0.000004 47.511544 -0.000002 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.131985 -0.000027 -0.000443 -0.000283 32.470952 0.000114 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000648 0.111156 0.000351 -1.325363 -14.94526 0.625666 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.699521 -0.76532 0.255802 -34.800989 -67.796485 -5.000542 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.330266 -0.000124 -0.000469 -16.615881 31.033402 13.890288 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.432571 0.00041 -0.00005 -0.001829 21.034835 -0.000505 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.665884 0.444201 0.000019 -0.001779 -179.999978 -0.000012 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 1.109401 -0.000214 1.342403 -0.000046 0 0.000003 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.553158 -2.774364 0.666138 -12.695938 -30.207137 -51.108468 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 3.066236 0.129805 1.691589 3.67535 99.912328 93.362832 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.709719 0.00959 -0.306797 -19.904607 -0.639768 93.487005 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 7.679585 21.030134 49.226074 6.421936 -22.640146 -129.534579 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 2.108377 -0.00034 -0.000177 1.908242 27.379361 -1.568246 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 7.476897 20.605783 49.630268 1.875003 -27.106408 -130.696722 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.997625 -0.000269 -0.000259 1.90893 27.37861 -1.56968 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.997625 -0.000269 -0.000259 1.90893 27.37861 -1.56968 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 7.207609 20.042316 50.167484 -2.041392 -30.818483 -131.405354 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 2.109816 0.000662 -0.00008 1.909045 27.379933 -1.569912 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 11.766058 -0.000475 0.000458 0.001314 -0.000234 -0.000455 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.132824 -0.305471 0.000912 0.001312 23.482674 0.000291 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 6.659737 -0.000382 4.440063 0 0.000344 0.000115 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 9.793533 -0.000003 0 -0.000745 -16.851491 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.459846 -0.000452 -0.000044 0.000688 16.851492 0.000229 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.918633 -0.000003 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.773781 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.973915 -0.224218 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -6.123871 -0.323007 -0.00111 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.928612 -7.081802 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.898323 -3.937171 -1.183259 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.836159 -3.903874 1.297591 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.190918 -0.11766 -1.00122 58.967598 -179.596641 89.995146 0 0 0 0 0 0
$definebone "j_proc_spine4" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_proc_spine4" 10.994545 -6.089464 -7.151735 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" -53.261131 -1.121096 0.00007 -0.003495 -89.999982 -89.999982 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 4.439999 -7.215002 0 0.000802 0.056723 0 0 0 0 0 0 0
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
	"compacted_nitrox_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_nitrox.qc"
//	}
}
