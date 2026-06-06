// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_soap.mdl"

$bodygroup "gloves"
{
	studio "compacted_soap.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -22.548 -39.492 -0.872 33.484 35.74 77.202

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.11342 0 68.822403 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.96728 0 -12.63242 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -15.315979 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -5.20769 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.070095 -0.000018 0.000015 0 0 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 18.363962 -0.000206 0.000234 -0.00063 6.835959 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 18.991863 0.314615 0.000024 -0.000115 -66.408618 0.000057 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.792477 0.000416 -0.000004 0 -29.681963 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.019148 0.320778 -0.000002 -0.000229 -3.418438 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 10.6999 -0.000193 0.000138 -0.000917 -0.001375 0 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 5.20769 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.070099 -0.000018 0.000014 0 0 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 13.143496 1.692317 -5.024563 -4.969779 5.167965 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 18.363966 -0.000205 0.000235 -0.00063 6.835959 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 18.991863 0.314615 0.000025 -0.000115 -66.408618 0.000057 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.792476 0.000416 -0.000004 0 -29.682079 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.019148 0.320778 -0.000002 -0.000229 -3.418438 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 10.164848 0.000352 0.000132 -0.000917 0.00212 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.780312 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.6875 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.848167 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.389591 -0.022472 -2.079014 88.660637 -66.290018 -66.285545 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 6.189537 -0.000064 0.000294 47.370654 -14.200187 -4.286067 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.535233 0.000137 -0.000061 -0.000006 -0.000002 0 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 12.337353 -0.000433 0.000072 -0.000062 -46.967072 -0.000453 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 11.342065 -0.000364 -0.000687 -0.000061 0.000452 -0.000111 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" 6.047449 20.873287 -48.041359 -7.06835 -32.575976 46.57437 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.261737 0.023319 0.114907 5.568918 0.692188 1.341809 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.81417 -0.00038 -0.00071 -0.000059 -0.000007 -0.000051 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -20.233589 -9.017555 0.00058 -7.073619 -32.571509 46.574032 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -10.25149 -29.812668 -39.787434 -7.073676 -32.571393 46.573339 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.653027 -1.005301 0.075207 -8.024563 -10.060398 -94.842333 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.802987 0.000137 0.000423 -1.152898 20.05856 11.551799 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.998613 -0.000053 -0.000532 -0.00045 26.531668 -0.00046 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.984411 -0.00032 -0.000443 -0.000453 36.229611 -0.000454 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.641468 0.428749 0.000246 0.000064 0.000001 0.000003 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.284483 0.426842 -0.000782 0.920119 0.409031 -0.542484 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000117 0.106659 -0.000952 -1.25678 -12.009887 -6.877962 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.684743 -0.213093 0.064388 -7.528267 -3.805649 -95.452986 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.845741 0.000122 -0.000858 -1.910633 27.379187 1.56898 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.149402 -0.000118 -0.00029 0.001035 56.057453 0.001264 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.176666 -0.000453 0.000149 0.000403 26.567544 0.000294 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000237 0.105919 0.000221 0.622236 -13.706816 -1.078714 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.642189 1.15588 -0.363247 1.189915 6.154246 -99.586474 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.353713 0.000557 0.000145 0.000644 35.990855 0.000002 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.261871 0.000237 -0.000725 -0.000795 42.582391 -0.000903 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.727745 -0.001322 0.000477 0.000284 31.29914 0.000301 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000212 0.1066 -0.000032 -0.001759 -17.996495 0.000055 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.641386 1.025814 -0.321728 -0.000563 0.000687 -10.001154 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.652436 0.428179 -0.010056 -3.530971 2.461652 -100.971144 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.739641 -0.000175 0.000031 -2.900931 29.876829 0.142202 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.828362 0.000771 -0.000195 0.000242 47.511674 -0.00034 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.0914 -0.000851 -0.000221 -0.000337 32.470897 -0.000333 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000153 0.107468 0.000349 1.326521 -14.945893 -0.624932 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.673808 -0.738354 -0.24585 34.800422 -67.797352 4.999579 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.246399 0.000509 -0.000446 16.616855 31.033907 -13.889926 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.380302 -0.000241 0.000641 -0.000067 21.034532 0.000628 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.64188 0.428192 -0.000038 -0.000009 -0.000004 -0.000003 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 1.069516 0.000408 -1.294914 0.000055 -0.000003 0.000005 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.460647 -2.674982 -0.641434 12.692961 -30.211665 51.107215 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.612063 0.009251 0.295712 19.90541 -0.639657 -93.486998 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 6.962809 19.422283 -48.160042 -7.509639 -42.528542 -48.030471 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 2.032061 0.00044 -0.000466 -1.90863 27.378151 1.569274 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 7.171148 19.824203 -47.768669 -12.201933 -38.162832 -47.937252 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.925639 -0.000281 0.000257 -1.908059 27.378038 1.568072 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.925639 -0.000281 0.000257 -1.908059 27.378038 1.568072 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 7.446373 20.357346 -47.248505 -16.177172 -34.398612 -48.14741 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 2.033341 -0.000092 -0.000547 -1.908462 27.37993 1.56876 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 4.279404 -0.000566 -0.000359 -0.00006 0.000051 -0.000109 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.127554 -0.295063 -0.000153 0.000224 23.483193 -0.000342 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 6.419812 -0.000431 -4.279945 0 -0.000573 -0.000057 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.390659 -0.022472 2.07901 -88.659721 -66.261537 66.257124 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 6.18954 -0.000004 -0.000191 -47.373127 -14.201505 4.286527 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.535252 0.000148 0.00005 -0.000008 0.001031 0.00109 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 12.336592 -0.000272 -0.001137 0.00057 -46.965641 0.000578 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 4.279894 -0.000002 0.001003 0.000972 -0.000521 -0.000509 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.81416 -0.000481 0.000458 0.000628 -0.000463 -0.000511 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -20.233099 -9.016968 0.000389 7.073964 -32.571738 133.425136 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -20.233099 -9.016968 0.000389 7.073964 -32.571738 133.425136 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.734278 8.4832 -4.200478 7.074365 -32.571335 133.425546 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.653032 -1.005301 -0.07523 8.025646 -10.060512 94.841432 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.802985 0.000153 -0.000422 1.15382 20.058848 -11.551285 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.998612 -0.00005 0.000572 -0.000345 26.531491 0.000453 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.983742 0.000435 0.000093 -0.000057 36.22967 0.000169 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.642426 0.427607 -0.000507 -0.0004 179.999978 0.000005 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.284066 0.42794 -0.000154 -0.921893 0.408742 0.542936 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000636 0.10738 0.000347 1.25615 -12.009656 6.878244 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.684742 -0.213093 -0.064407 7.528833 -3.805015 95.452761 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.846092 0.000835 0.000174 1.908407 27.378904 -1.568815 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.14939 -0.000954 -0.000412 0.000455 56.057733 -0.000174 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.177387 0.000012 0.000502 -0.000631 26.568113 0.000569 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000238 0.10593 -0.000221 -0.62063 -13.706523 1.07791 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.642199 1.155878 0.363232 -1.189235 6.154651 99.586371 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.353719 0.000557 -0.000132 -0.000002 35.990627 0.000053 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.262705 0.000401 0.00008 -0.000458 42.582391 0.000283 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.72702 -0.000875 0.000187 0.000229 31.299485 -0.000176 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000208 0.106596 0.000031 -0.000118 -17.996375 0.000166 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.641956 1.026421 0.321079 -0.000005 0.000577 10.001433 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.652936 0.428785 0.010777 3.531595 2.461883 100.971322 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.739649 -0.000175 -0.000032 2.901346 29.876767 -0.142209 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.828356 0.000771 0.000225 0.000004 47.511544 -0.000002 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.091194 -0.000025 -0.000427 -0.000283 32.470952 0.000114 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000626 0.107147 0.000343 -1.325363 -14.94526 0.625666 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.674311 -0.73774 0.246578 -34.800989 -67.796485 -5.000542 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.24629 -0.000118 -0.00045 -16.615881 31.033402 13.890288 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.380947 0.000396 -0.00005 -0.001829 21.034835 -0.000505 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.641895 0.428195 0.000015 -0.001779 -179.999978 -0.000012 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 1.069422 -0.000207 1.294025 -0.000046 0 0.000003 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.461153 -2.674387 0.642136 -12.695938 -30.207137 -51.108468 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.955741 0.125128 1.63063 3.67535 99.912328 93.362832 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.612069 0.009247 -0.295746 -19.904607 -0.639768 93.487005 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 7.40284 20.272293 47.45216 6.421936 -22.640146 -129.534579 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 2.0324 -0.000327 -0.00017 1.908242 27.379361 -1.568246 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 7.207457 19.863234 47.841793 1.875003 -27.106408 -130.696722 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.925639 -0.000259 -0.000249 1.90893 27.37861 -1.56968 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.925639 -0.000259 -0.000249 1.90893 27.37861 -1.56968 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 6.947873 19.320072 48.35965 -2.041392 -30.818483 -131.405354 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 2.033787 0.000638 -0.000077 1.909045 27.379933 -1.569912 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 11.342059 -0.00046 0.000443 0.001314 -0.000234 -0.000455 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.128042 -0.294464 0.000889 0.001312 23.482674 0.000291 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 6.419746 -0.000368 4.280064 0 0.000344 0.000115 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 9.440617 -0.000003 0 -0.000745 -16.851491 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.335159 -0.000435 -0.000043 0.000688 16.851492 0.000229 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.669312 -0.000003 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.709862 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.79467 -0.216138 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.903191 -0.311367 -0.00107 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.678932 -6.826602 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.757843 -3.795291 -1.140619 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.697922 -3.763195 1.250831 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.184036 -0.11342 -0.96514 58.967598 -179.596641 89.995146 0 0 0 0 0 0
$definebone "j_proc_spine4" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_proc_spine4" 10.598347 -5.870024 -6.894015 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" -51.341816 -1.080696 0.000067 -0.003495 -89.999982 -89.999982 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 4.279995 -6.955002 0 0.000802 0.056723 0 0 0 0 0 0 0
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
	"compacted_soap_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_soap.qc"
//	}
}
