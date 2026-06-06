// Created by Crowbar 0.74

$modelname "viper/mwii/rigs/gloves/compacted_kilgore.mdl"

$bodygroup "gloves"
{
	studio "compacted_kilgore.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MWII\rigs\gloves\"
$cdmaterials "viper\MW\rigs\skin\"

$cbox 0 0 0 0 0 0

$bbox -21.073 -36.909 -0.815 31.316 33.534 72.151

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999982 90.003479 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -4.867 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000084 -0.000017 0.000013 0 0 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.162579 -0.000192 0.000219 -0.00063 6.835959 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.749403 0.294033 0.000023 -0.000115 -66.408618 0.000057 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413529 0.000389 -0.000004 0 -29.681963 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017895 0.299793 -0.000002 -0.000229 -3.418438 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999905 -0.00018 0.000129 -0.000917 -0.001375 0 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 4.867 0.499309 -179.257905 -179.996754 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000088 -0.000017 0.000013 0 0 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283638 1.581605 -4.695852 -4.969779 5.167965 83.781785 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.16258 -0.000192 0.000219 -0.00063 6.835959 -0.000115 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.749403 0.294033 0.000023 -0.000115 -66.408618 0.000057 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413528 0.000389 -0.000004 0 -29.682079 -0.000057 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017895 0.299793 -0.000002 -0.000229 -3.418438 0.000057 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.499851 0.000329 0.000123 -0.000917 0.00212 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.533001 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.25 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.530998 -0.000002 0 0 0 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spine4" 5.036999 -0.021002 -1.943003 88.660637 -66.290018 -66.285545 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.784613 -0.00006 0.000278 47.370654 -14.200187 -4.286067 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500217 0.000128 -0.000061 -0.000006 -0.000002 0 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 11.530233 -0.000405 0.000065 -0.000062 -46.967072 -0.000453 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.600061 -0.000341 -0.000641 -0.000061 0.000452 -0.000111 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" 5.651818 19.507744 -44.898464 -7.06835 -32.575976 46.57437 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.244614 0.021793 0.10739 5.568918 0.692188 1.341809 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.041282 -0.000353 -0.000656 -0.000059 -0.000007 -0.000051 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" -18.909895 -8.42762 0.000546 -7.073619 -32.571509 46.574032 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.580832 -27.862307 -37.184517 -7.073676 -32.571393 46.573339 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.610306 -0.939531 0.07029 -8.024563 -10.060398 -94.842333 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.619613 0.00013 0.000399 -1.152898 20.05856 11.551799 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.867861 -0.000053 -0.000496 -0.00045 26.531668 -0.00046 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.92001 -0.000298 -0.000414 -0.000453 36.229611 -0.000454 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.599506 0.400698 0.000233 0.000064 0.000001 0.000003 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.20045 0.398918 -0.00073 0.920119 0.409031 -0.542484 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000109 0.099678 -0.000887 -1.25678 -12.009887 -6.877962 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.639948 -0.199152 0.060173 -7.528267 -3.805649 -95.452986 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.659571 0.000111 -0.000807 -1.910633 27.379187 1.56898 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.008786 -0.000111 -0.000269 0.001035 56.057453 0.001264 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.099693 -0.000422 0.000141 0.000403 26.567544 0.000294 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.000221 0.098991 0.000208 0.622236 -13.706816 -1.078714 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600178 1.080263 -0.339485 1.189915 6.154246 -99.586474 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.199734 0.000519 0.000134 0.000644 35.990855 0.000002 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.179325 0.000221 -0.000675 -0.000795 42.582391 -0.000903 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.68013 -0.001237 0.000444 0.000284 31.29914 0.000301 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000202 0.099627 -0.000034 -0.001759 -17.996495 0.000055 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.599426 0.958702 -0.300684 -0.000563 0.000687 -10.001154 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.609751 0.400167 -0.009399 -3.530971 2.461652 -100.971144 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.560412 -0.00016 0.000032 -2.900931 29.876829 0.142202 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.708746 0.000725 -0.000181 0.000242 47.511674 -0.00034 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.02 -0.000793 -0.000206 -0.000337 32.470897 -0.000333 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" 0.000137 0.100441 0.000326 1.326521 -14.945893 -0.624932 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.629726 -0.690046 -0.229767 34.800422 -67.797352 4.999579 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.099436 0.000475 -0.00042 16.616855 31.033907 -13.889926 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290005 -0.000226 0.000595 -0.000067 21.034532 0.000628 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.59989 0.40018 -0.000038 -0.000009 -0.000004 -0.000003 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.999546 0.000378 -1.210201 0.000055 -0.000003 0.000005 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299668 -2.499983 -0.599472 12.692961 -30.211665 51.107215 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_wrist_le" 2.44118 0.008648 0.276371 19.90541 -0.639657 -93.486998 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 6.5073 18.15167 -45.009384 -7.509639 -42.528542 -48.030471 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 1.899122 0.000411 -0.000435 -1.90863 27.378151 1.569274 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 6.702008 18.527292 -44.643608 -12.201933 -38.162832 -47.937252 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799663 -0.000263 0.00024 -1.908059 27.378038 1.568072 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799663 -0.000263 0.00024 -1.908059 27.378038 1.568072 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 6.959225 19.025557 -44.157471 -16.177172 -34.398612 -48.14741 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 1.900319 -0.000086 -0.000511 -1.908462 27.37993 1.56876 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.999445 -0.000526 -0.00034 -0.00006 0.000051 -0.000109 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119207 -0.275761 -0.000137 0.000224 23.483193 -0.000342 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 5.999825 -0.000403 -3.999947 0 -0.000573 -0.000057 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spine4" 5.037998 -0.021002 1.943 -88.659721 -66.261537 66.257124 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.784616 -0.000004 -0.000175 -47.373127 -14.201505 4.286527 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500233 0.000138 0.00005 -0.000008 0.001031 0.00109 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.529522 -0.000254 -0.001057 0.00057 -46.965641 0.000578 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999899 0 0.000927 0.000972 -0.000521 -0.000509 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041269 -0.00045 0.00042 0.000628 -0.000463 -0.000511 0 0 0 0 0 0
$definebone "j_gun" "j_wrist_ri" -18.909433 -8.427076 0.000362 7.073964 -32.571738 133.425136 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" -18.909433 -8.427076 0.000362 7.073964 -32.571738 133.425136 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228298 7.928225 -3.925682 7.074365 -32.571335 133.425546 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.610312 -0.939535 -0.070305 8.025646 -10.060512 94.841432 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.619611 0.000145 -0.000397 1.15382 20.058848 -11.551285 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.867866 -0.00005 0.000534 -0.000345 26.531491 0.000453 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.919384 0.000408 0.000088 -0.000057 36.22967 0.000169 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.600395 0.399632 -0.000475 -0.0004 179.999978 0.000005 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.200061 0.39994 -0.000147 -0.921893 0.408742 0.542936 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000593 0.100349 0.000325 1.25615 -12.009656 6.878244 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639947 -0.199156 -0.060192 7.528833 -3.805015 95.452761 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.659899 0.000778 0.000166 1.908407 27.378904 -1.568815 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.008773 -0.000896 -0.000385 0.000455 56.057733 -0.000174 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.100361 0.00001 0.000469 -0.000631 26.568113 0.000569 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000221 0.098999 -0.000208 -0.62063 -13.706523 1.07791 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600186 1.080259 0.33947 -1.189235 6.154651 99.586371 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.199737 0.000526 -0.000122 -0.000002 35.990627 0.000053 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.180098 0.000376 0.000074 -0.000458 42.582391 0.000283 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.679459 -0.00082 0.000175 0.000229 31.299485 -0.000176 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000191 0.099627 0.000031 -0.000118 -17.996375 0.000166 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599958 0.959274 0.300074 -0.000005 0.000577 10.001433 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610223 0.400734 0.010071 3.531595 2.461883 100.971322 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.56042 -0.000172 -0.000029 2.901346 29.876767 -0.142209 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.708748 0.000725 0.000212 0.000004 47.511544 -0.000002 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 1.01981 -0.000022 -0.000399 -0.000283 32.470952 0.000114 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.00058 0.100136 0.000319 -1.325363 -14.94526 0.625666 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.630199 -0.689476 0.230446 -34.800989 -67.796485 -5.000542 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.099339 -0.000114 -0.000427 -16.615881 31.033402 13.890288 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.290604 0.000368 -0.00005 -0.001829 21.034835 -0.000505 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599895 0.400182 0.000015 -0.001779 -179.999978 -0.000012 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999457 -0.000197 1.209373 -0.000046 0 0.000003 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300145 -2.499426 0.600124 -12.695938 -30.207137 -51.108468 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.762376 0.116941 1.523956 3.67535 99.912328 93.362832 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_wrist_ri" 2.441189 0.00864 -0.276398 -19.904607 -0.639768 93.487005 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 6.918546 18.94607 44.347813 6.421936 -22.640146 -129.534579 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 1.899439 -0.000306 -0.000159 1.908242 27.379361 -1.568246 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 6.735942 18.563766 44.711956 1.875003 -27.106408 -130.696722 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.000242 -0.000233 1.90893 27.37861 -1.56968 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799662 -0.000242 -0.000233 1.90893 27.37861 -1.56968 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 6.493342 18.056145 45.195934 -2.041392 -30.818483 -131.405354 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 1.900735 0.000596 -0.000072 1.909045 27.379933 -1.569912 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.600052 -0.000427 0.000404 0.001314 -0.000234 -0.000455 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119661 -0.275202 0.000824 0.001312 23.482674 0.000291 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 5.999763 -0.000344 4.000057 0 0.000344 0.000115 0 0 0 0 0 0
$definebone "j_neck" "j_spine4" 8.823002 -0.000003 0 -0.000745 -16.851491 0 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.11697 -0.000408 -0.00004 0.000688 16.851492 0.000229 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233002 -0.000003 0 0 0 0 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598 -0.000001 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.481003 -0.201998 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.516998 -0.290997 -0.001 0 0 0 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.241997 -6.380002 0 0 0 0 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512001 -3.547001 -1.065999 89.999982 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456001 -3.517004 1.169001 89.999982 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171997 -0.106 -0.902 58.967598 -179.596641 89.995146 0 0 0 0 0 0
$definebone "j_proc_spine4" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_proc_spine4" 9.904999 -5.486004 -6.443005 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" -47.983002 -1.009996 0.000063 -0.003495 -89.999982 -89.999982 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 3.999992 -6.500002 0 0.000802 0.056723 0 0 0 0 0 0 0
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
	"compacted_kilgore_anims\Idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\rigs\mwii\gloves\compacted_kilgore.qc"
//	}
}
