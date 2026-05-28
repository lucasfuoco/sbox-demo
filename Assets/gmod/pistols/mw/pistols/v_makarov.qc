// Created by Crowbar 0.74

$modelname "viper/mw/weapons/v_makarov.mdl"

$bodygroup "receiver"
{
	studio "attachment_vm_pi_mike_parts.smd"
}
$bodygroup "tag_laser"
{
	blank
	studio "attachment_vm_pi_mike_laserrail.smd"
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\makarov\"

$attachment "muzzle" "tag_flash" 0 0 0 rotate 0 0 0
$attachment "shell_eject" "tag_brass" 0 0 0 rotate 0 0 0
$attachment "camera" "tag_playerhelmet" 0 0 0 rotate 0 0 0
$attachment "reflex" "tag_reflex" 0 0 0 rotate 0 0 0
$attachment "align" "tag_align_gun" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -8.272 -33.612 -64.323 22.365 17.575 64.32

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_view" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_ads" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_torso" "tag_ads" -0.904 0 -11.806 0 0 0 0 0 0 0 0 0
$definebone "j_mainroot" "tag_torso" 0 0 -14.313999 -89.999975 90.003472 0 0 0 0 0 0 0
$definebone "j_spinelower" "j_mainroot" 3.533001 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_spineupper" "j_spinelower" 6.25 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_clavicle_le" "j_spineupper" 9.568951 0.000025 -2.111994 88.658164 -66.082886 -66.077914 0 0 0 0 0 0
$definebone "j_clavicle_ri" "j_spineupper" 9.568951 0.000025 2.112006 -88.658164 -66.082886 66.077914 0 0 0 0 0 0
$definebone "j_shoulder_le" "j_clavicle_le" 5.904011 0.166855 -0.156368 47.7024 3.664177 10.448516 0 0 0 0 0 0
$definebone "j_teres_le" "j_clavicle_le" 5.999492 -0.000592 -4.000343 0 0 0.000003 0 0 0 0 0 0
$definebone "j_shoulder_ri" "j_clavicle_ri" 5.967103 0.170556 0.12199 -49.104491 5.752663 -6.074959 0 0 0 0 0 0
$definebone "j_teres_ri" "j_clavicle_ri" 5.999492 -0.000592 4.000336 0 0 -0.000003 0 0 0 0 0 0
$definebone "j_shouldertwist_le" "j_shoulder_le" 0.500225 0.000133 -0.000088 0.000015 -0.000003 0.000004 0 0 0 0 0 0
$definebone "j_elbow_le" "j_shoulder_le" 12.100983 0.769903 -0.141941 6.720928 -2.773005 -0.936209 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "j_shoulder_le" -0.829338 0.893824 0.079659 2.729869 4.999998 -8.527844 0 0 0 0 0 0
$definebone "j_shouldertwist_ri" "j_shoulder_ri" 0.500225 0.000132 0.000076 -0.000012 -0.000004 -0.000003 0 0 0 0 0 0
$definebone "j_elbow_ri" "j_shoulder_ri" 11.923132 0.695859 0.038975 -2.114798 -3.038225 0.050476 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "j_shoulder_ri" -0.829586 0.894698 -0.079464 -1.124217 4.999992 2.599906 0 0 0 0 0 0
$definebone "j_wristfronttwist1_le" "j_elbow_le" 10.599884 0.000105 -0.000553 0.000018 -0.000002 0.000003 0 0 0 0 0 0
$definebone "j_elbowdq_le" "j_elbow_le" 0.119665 -0.275181 -0.000805 0.002705 23.483348 0.004135 0 0 0 0 0 0
$definebone "j_wrist_le" "j_elbow_le" 11.104559 0.046687 0.110176 -10.006688 4.360205 -0.534624 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "j_elbow_le" -1.214832 0.20347 -0.477489 -4.507838 -0.073856 -7.736359 0 0 0 0 0 0
$definebone "j_wristfronttwist1_ri" "j_elbow_ri" 10.59988 0.000105 0.000549 -0.000007 -0.000002 -0.000001 0 0 0 0 0 0
$definebone "j_elbowdq_ri" "j_elbow_ri" 0.119663 -0.275181 0.000801 -0.002694 23.483346 -0.004132 0 0 0 0 0 0
$definebone "j_wrist_ri" "j_elbow_ri" 11.041742 0.018796 -0.027916 2.123489 1.195473 -4.112979 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "j_elbow_ri" -1.063377 0.077663 0.15023 1.148548 -0.736251 2.585241 0 0 0 0 0 0
$definebone "j_metaindex_le_1" "j_wrist_le" 0.610302 -0.93947 0.070343 -8.027281 -10.057929 -94.841425 0 0 0 0 0 0
$definebone "j_metamid_le_1" "j_wrist_le" 0.63994 -0.199121 0.060188 -7.528176 -3.805069 -95.452467 0 0 0 0 0 0
$definebone "j_metapinky_le_1" "j_wrist_le" 0.600155 1.080261 -0.339535 1.189822 6.154765 -99.581385 0 0 0 0 0 0
$definebone "j_metaring_le_1" "j_wrist_le" 0.610207 0.400743 -0.010101 -3.528938 2.459131 -100.970523 0 0 0 0 0 0
$definebone "j_thumb_le_1" "j_wrist_le" 0.701123 -0.842439 -0.310471 16.696341 -69.374969 5.319376 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "j_wrist_le" -0.792125 0.203736 0.4613 -0.197818 -1.048802 82.452876 0 0 0 0 0 0
$definebone "j_metaindex_ri_1" "j_wrist_ri" 0.6103 -0.939469 -0.070351 8.0273 -10.057921 94.841425 0 0 0 0 0 0
$definebone "j_metamid_ri_1" "j_wrist_ri" 0.639937 -0.199121 -0.0602 7.528185 -3.805068 95.452467 0 0 0 0 0 0
$definebone "j_metapinky_ri_1" "j_wrist_ri" 0.600157 1.080259 0.339531 -1.189813 6.154759 99.581385 0 0 0 0 0 0
$definebone "j_metaring_ri_1" "j_wrist_ri" 0.610205 0.400743 0.010086 3.528951 2.459129 100.970523 0 0 0 0 0 0
$definebone "j_thumb_ri_1" "j_wrist_ri" 0.616189 -0.78124 0.454933 -14.505585 -67.695849 0.661829 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "j_wrist_ri" -0.626031 -0.069983 -0.080517 4.936073 1.235234 -82.915758 0 0 0 0 0 0
$definebone "j_index_le_1" "j_metaindex_le_1" 2.660441 -0.018158 -0.005345 -11.62244 40.716564 1.039747 0 0 0 0 0 0
$definebone "j_mid_le_1" "j_metamid_le_1" 2.664743 0.000397 -0.000071 -4.760246 43.526596 -1.745061 0 0 0 0 0 0
$definebone "j_pinky_le_1" "j_metapinky_le_1" 2.339211 0.140091 -0.092709 -1.862049 19.09835 -7.767025 0 0 0 0 0 0
$definebone "j_webbing_le_3" "j_metapinky_le_1" 0.599952 0.95924 -0.300102 -0.003492 0.000303 -10.000698 0 0 0 0 0 0
$definebone "j_ring_le_1" "j_metaring_le_1" 2.522032 -0.05275 0.014172 0.928309 43.711735 2.085103 0 0 0 0 0 0
$definebone "j_thumb_le_2" "j_thumb_le_1" 2.095024 -0.003873 -0.010006 18.300554 31.075581 -14.873613 0 0 0 0 0 0
$definebone "j_webbing_le_2" "j_thumb_le_1" 0.99938 -0.000236 -1.20937 0.000003 0.000015 -0.000031 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "j_thumb_le_1" -0.122639 -0.721856 0.66169 12.832189 13.926109 -27.882671 0 0 0 0 0 0
$definebone "j_index_ri_1" "j_metaindex_ri_1" 2.637738 -0.008461 0.010554 11.666678 35.338374 -11.191924 0 0 0 0 0 0
$definebone "j_mid_ri_1" "j_metamid_ri_1" 2.654002 0.004589 -0.000533 4.949666 42.06304 1.366792 0 0 0 0 0 0
$definebone "j_pinky_ri_1" "j_metapinky_ri_1" 2.39924 0.122761 0.028181 -2.124592 15.817233 2.644368 0 0 0 0 0 0
$definebone "j_webbing_ri_3" "j_metapinky_ri_1" 0.599951 0.959244 0.300102 0.003486 0.0003 10.000689 0 0 0 0 0 0
$definebone "j_ring_ri_1" "j_metaring_ri_1" 2.540944 -0.012104 0.000554 1.16923 35.233845 -0.010428 0 0 0 0 0 0
$definebone "j_thumb_ri_2" "j_thumb_ri_1" 2.107758 0.009521 -0.012733 -11.662155 32.35478 13.618053 0 0 0 0 0 0
$definebone "j_webbing_ri_2" "j_thumb_ri_1" 0.999374 -0.000237 1.209362 -0.000015 0.000029 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "j_thumb_ri_1" 0.310846 -0.606445 -0.498005 -11.321539 17.989475 17.653223 0 0 0 0 0 0
$definebone "j_index_le_2" "j_index_le_1" 1.888695 -0.028179 -0.008807 3.276287 12.563067 -0.406232 0 0 0 0 0 0
$definebone "j_indexbulge_le_1" "j_index_le_1" 1.200941 0.399582 -0.000237 0.92172 0.408358 -0.542309 0 0 0 0 0 0
$definebone "j_proc_index_le_1" "j_index_le_1" 0.000586 0.100342 -0.000319 -1.256266 -12.010148 -6.877503 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "j_index_le_1" -0.161663 0.051712 0.194808 7.013461 -3.448846 -168.56314 0 0 0 0 0 0
$definebone "j_mid_le_2" "j_mid_le_1" 2.010092 -0.136019 -0.007284 1.492845 28.843401 0.427426 0 0 0 0 0 0
$definebone "j_proc_mid_le_1" "j_mid_le_1" 0.00024 0.099802 -0.000395 0.620687 -13.70624 -1.078481 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "j_mid_le_1" -0.203197 0.048607 0.06915 1.903196 -2.676993 -177.234858 0 0 0 0 0 0
$definebone "j_pinky_le_2" "j_pinky_le_1" 1.180428 -0.006214 0.00078 1.469475 48.553448 -0.425825 0 0 0 0 0 0
$definebone "j_proc_pinky_le_1" "j_pinky_le_1" -0.000196 0.099625 -0.000034 0.000002 -17.996707 -0.00001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "j_pinky_le_1" -0.088736 -0.688435 -0.145203 -7.799659 29.393453 167.899942 0 0 0 0 0 0
$definebone "j_ring_le_2" "j_ring_le_1" 1.751133 -0.069736 0.011631 -4.308636 17.202122 1.053952 0 0 0 0 0 0
$definebone "j_proc_ring_le_1" "j_ring_le_1" -0.00058 0.100145 -0.000311 1.32233 -14.945205 -0.621435 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "j_ring_le_1" -0.14603 -0.232426 -0.014225 -5.402928 6.475548 173.517705 0 0 0 0 0 0
$definebone "j_thumb_le_3" "j_thumb_le_2" 1.290632 0.000362 -0.000032 -0.000006 21.034138 -0.000019 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "j_thumb_le_2" -0.658121 -0.003575 0.072645 1.59235 -4.428895 -8.176754 0 0 0 0 0 0
$definebone "j_index_ri_2" "j_index_ri_1" 1.887611 -0.018675 0.006083 -2.208126 15.068284 0.712256 0 0 0 0 0 0
$definebone "j_indexbulge_ri_1" "j_index_ri_1" 1.200079 0.399944 -0.000093 -0.921721 0.408354 0.542315 0 0 0 0 0 0
$definebone "j_proc_index_ri_1" "j_index_ri_1" 0.000591 0.100342 0.000319 1.256265 -12.010165 6.877513 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "j_index_ri_1" 0.068077 0.002285 -0.08005 -3.97438 -3.486266 178.268702 0 0 0 0 0 0
$definebone "j_mid_ri_2" "j_mid_ri_1" 2.05875 -0.192589 0.006086 -0.52466 24.7019 -1.006002 0 0 0 0 0 0
$definebone "j_proc_mid_ri_1" "j_mid_ri_1" 0.000229 0.099802 0.000395 -0.620689 -13.706242 1.078479 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "j_mid_ri_1" -0.018673 -0.001009 0.047544 0.15097 -6.111922 178.146565 0 0 0 0 0 0
$definebone "j_pinky_ri_2" "j_pinky_ri_1" 1.178665 0.001595 0.000845 -1.895229 47.372044 0.307956 0 0 0 0 0 0
$definebone "j_proc_pinky_ri_1" "j_pinky_ri_1" -0.000198 0.099628 0.000034 -0.000009 -17.996691 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "j_pinky_ri_1" 0.036892 -0.634449 0.266284 9.9867 28.127325 -160.489023 0 0 0 0 0 0
$definebone "j_ring_ri_2" "j_ring_ri_1" 1.70435 -0.076727 -0.004592 2.527541 25.25165 -0.934442 0 0 0 0 0 0
$definebone "j_proc_ring_ri_1" "j_ring_ri_1" -0.000576 0.100136 0.000311 -1.322334 -14.945209 0.621428 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "j_ring_ri_1" -0.003952 -0.281811 0.115047 5.099542 9.623606 -175.277052 0 0 0 0 0 0
$definebone "j_thumb_ri_3" "j_thumb_ri_2" 1.289627 0.007855 0.000061 0.019375 22.694803 -0.103775 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "j_thumb_ri_2" -0.171528 -0.018148 -0.099873 -3.56288 -0.674968 0.772563 0 0 0 0 0 0
$definebone "j_index_le_3" "j_index_le_2" 0.912716 0.00724 0.001326 2.074225 26.011102 1.275514 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "j_index_le_2" -0.342617 0.053404 -0.025571 -0.988234 4.312985 -166.690657 0 0 0 0 0 0
$definebone "j_mid_le_3" "j_mid_le_2" 1.100231 -0.051713 -0.002434 0.919543 3.580833 0.993451 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "j_mid_le_2" -0.384983 0.330998 0.006848 -1.075154 -10.558389 -176.883922 0 0 0 0 0 0
$definebone "j_pinky_le_3" "j_pinky_le_2" 0.678146 0.014005 -0.003905 -2.230685 22.491395 -0.303153 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "j_pinky_le_2" -0.123848 0.072737 0.029507 -3.473659 5.433616 166.053729 0 0 0 0 0 0
$definebone "j_ring_le_3" "j_ring_le_2" 1.017166 -0.000154 -0.000252 -0.267222 30.32562 -0.172288 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "j_ring_le_2" -0.344986 0.123129 0.143151 0.710245 3.388455 171.59976 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "j_thumb_le_3" -0.730988 0.177046 0.039141 4.384142 -4.830606 -7.089283 0 0 0 0 0 0
$definebone "j_index_ri_3" "j_index_ri_2" 0.9259 0.016924 -0.000896 -1.080089 18.356845 -0.417621 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "j_index_ri_2" -0.124027 -0.052092 0.038496 -0.488109 2.247674 176.345676 0 0 0 0 0 0
$definebone "j_mid_ri_3" "j_mid_ri_2" 1.10043 -0.085586 0.000503 0.080671 6.372236 -0.820936 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "j_mid_ri_2" -0.330082 0.160641 0.04278 1.949944 -9.811124 179.225366 0 0 0 0 0 0
$definebone "j_pinky_ri_3" "j_pinky_ri_2" 0.671947 0.005438 0.003272 4.458703 19.839562 1.107688 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "j_pinky_ri_2" -0.019516 -0.016531 0.038578 2.882262 4.40194 -158.352977 0 0 0 0 0 0
$definebone "j_ring_ri_3" "j_ring_ri_2" 0.995453 0.009019 0.001121 1.793984 17.137949 0.501617 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "j_ring_ri_2" -0.155312 0.130643 -0.021921 1.285311 -1.426812 -173.174529 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "j_thumb_ri_3" -0.252209 0.061937 -0.024914 -3.619423 -2.543467 -0.439531 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "j_index_le_3" -0.085991 0.185203 -0.01518 -6.529993 -7.963623 -168.281313 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "j_mid_le_3" -0.286537 0.179852 0.024264 -2.84445 -1.713988 -178.152821 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "j_pinky_le_3" -0.019489 0.147084 0.079203 2.210767 -3.471783 165.803375 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "j_ring_le_3" -0.046482 0.251898 0.129548 4.418196 -2.455942 172.813526 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "j_index_ri_3" 0.03912 -0.040298 0.047739 1.745797 -2.143637 176.712717 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "j_mid_ri_3" -0.233757 0.06663 0.001754 2.29991 -3.747861 -179.51263 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "j_pinky_ri_3" 0.044266 0.020128 0.001684 -6.81086 -2.319812 -159.211382 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "j_ring_ri_3" 0.071495 0.074127 -0.048302 -3.408068 5.979715 -173.94522 0 0 0 0 0 0
$definebone "ValveBiped.Anim_Attachment_RH" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "ValveBiped.Anim_Attachment_RH" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_gun" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_hammer" "tag_pistol_offset" -0.348999 0 0.342999 0 0 0 0 0 0 0 0 0
$definebone "j_trigger" "tag_pistol_offset" 2.394995 0 0.034 0 0 0 0 0 0 0 0 0
$definebone "tag_align_gun" "tag_pistol_offset" 0.008 0 1.401997 0 0 0 0 0 0 0 0 0
$definebone "tag_barrel_attach" "tag_pistol_offset" 1.148998 0 0.626999 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_barrel_attach" 1.107998 0 0.153 0 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "j_slide" -2.457995 0 0.449999 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on" "j_slide" 0.283 0 0.659998 0 0 0 0 0 0 0 0 0
$definebone "tag_flash" "tag_barrel_attach" 4.293992 0 0.136 0 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_pistol_offset" 1.511997 -0.417999 1.094998 0 -89.997626 0 0 0 0 0 0 0
$definebone "tag_laser_show" "tag_pistol_offset" 4.229991 0 0.042 0 0 0 0 0 0 0 0 0
$definebone "tag_laser_attach" "tag_laser_show" 0.24 0 -0.662999 0 0 0 0 0 0 0 0 0
$definebone "tag_mag_attach" "tag_pistol_offset" 1.060998 0 -3.633993 0 0 0 0 0 0 0 0 0
$definebone "tag_pistolgrip_attach" "tag_pistol_offset" 0.193999 0 -2.057996 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_attach" "tag_pistol_offset" -0.774998 0 -2.394995 0 0 0 0 0 0 0 0 0
$definebone "tag_sync" "tag_origin" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_camera_scripted" "tag_origin" -0.106 0 64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_cambone" "tag_view" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_camera" "tag_cambone" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_weapon" "tag_torso" 23.292503 -0.967643 5.968346 -0.003209 -0.028648 -18.005026 0 0 0 0 0 0
$definebone "tag_player" "tag_camera" 0.106 0 -64.32 0 0 0 0 0 0 0 0 0
$definebone "tag_playerhelmet" "tag_camera" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_hip_le" "j_mainroot" 0 0 -4.867002 -0.000019 -179.255077 -179.999978 0 0 0 0 0 0
$definebone "j_hip_ri" "j_mainroot" 0 0 4.867 -0.000019 -179.255077 -179.999978 0 0 0 0 0 0
$definebone "j_groinprotector" "j_mainroot" 4 -6.5 0 0 0.055978 0 0 0 0 0 0 0
$definebone "j_crotch" "j_mainroot" -6.5 0 0 89.999975 0 0 0 0 0 0 0 0
$definebone "j_hiptwist_le" "j_hip_le" 1.000088 -0.000029 0 0 0 0 0 0 0 0 0 0
$definebone "j_knee_le" "j_hip_le" 17.162516 -0.000404 0 0 6.830459 0 0 0 0 0 0 0
$definebone "j_hip_proc_le" "j_hip_le" 9.999891 -0.000303 0 0 0 0 0 0 0 0 0 0
$definebone "j_hiptwist_ri" "j_hip_ri" 1.000088 -0.000029 0 0 0 0 0 0 0 0 0 0
$definebone "j_knee_ri" "j_hip_ri" 17.162516 -0.000404 0 0 6.830459 0 0 0 0 0 0 0
$definebone "j_hip_proc_ri" "j_hip_ri" 9.499836 0.000212 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_spinelower" "j_spinelower" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_ankle_le" "j_knee_le" 17.749374 0.295515 0 0 -66.403386 0 0 0 0 0 0 0
$definebone "j_kneedq_le" "j_knee_le" 0.017889 0.299792 0 0 -3.413797 0 0 0 0 0 0 0
$definebone "tag_stowed_thigh" "j_hiptwist_ri" 12.283573 1.581456 -4.696 -4.969035 5.16722 83.781839 0 0 0 0 0 0
$definebone "j_ankle_ri" "j_knee_ri" 17.749376 0.295515 0 0 -66.403386 0 0 0 0 0 0 0
$definebone "j_kneedq_ri" "j_knee_ri" 0.017889 0.299792 0 0 -3.413797 0 0 0 0 0 0 0
$definebone "j_neck" "j_spineupper" 13.354 0 0 0 -16.850744 0 0 0 0 0 0 0
$definebone "j_spine4" "j_spineupper" 4.530998 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_spineupper" "j_spineupper" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_ball_le" "j_ankle_le" 5.413524 0.000347 0 0 -29.682366 0 0 0 0 0 0 0
$definebone "j_ball_ri" "j_ankle_ri" 5.413524 0.000347 0 0 -29.682366 0 0 0 0 0 0 0
$definebone "tag_carry_attach" "j_clavicle_le" 4.662002 -5.366333 4.825191 89.456183 -178.832357 89.93793 0 0 0 0 0 0
$definebone "j_head" "j_neck" 3.116966 -0.000443 0 0 16.850744 0 0 0 0 0 0 0
$definebone "j_chest" "j_spine4" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -0.271999 0 2.688 0 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -13.659218 19.14163 -53.645393 -0.011287 0.026528 18.000158 0 0 0 0 0 0
$definebone "j_eyeball_le" "j_head" 3.512001 -3.547 -1.066 89.999975 0 0 0 0 0 0 0 0
$definebone "j_eyeball_ri" "j_head" 3.456001 -3.517 1.169 89.999975 0 0 0 0 0 0 0 0
$definebone "j_head_end" "j_head" 6.233002 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_jaw" "j_head" -0.171997 -0.106 -0.902 58.967434 -179.596477 89.995221 0 0 0 0 0 0
$definebone "j_nvg" "j_head" 6.241997 -6.38 0 0 0 0 0 0 0 0 0 0
$definebone "j_bullet2" "j_mag1" 0.181 -0.064 1.096 0 0 0 0 0 0 0 0 0
$definebone "j_shield_le" "j_elbow_le" 3.999434 -0.000528 -0.000332 -0.003373 0.00091 -29.982652 0 0 0 0 0 0
$definebone "j_shield_ri" "j_elbow_ri" 3.999901 0.000041 0.001011 -0.000012 -0.000006 4.050525 0 0 0 0 0 0
$definebone "j_helmet" "j_head_end" 1.598 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_proc_wristfronttwist1_le" "j_wristfronttwist1_le" -1.145525 0.00013 0.000668 0.000012 -0.000004 0.000003 0 0 0 0 0 0
$definebone "j_webbing_le_1" "j_wrist_le" 2.299679 -2.499979 -0.59948 12.687922 -30.208957 51.108274 0 0 0 0 0 0
$definebone "tag_weapon_left" "j_wrist_le" 11.207076 -0.718225 0.644222 -14.572482 -0.169543 102.985599 0 0 0 0 0 0
$definebone "tag_accessory_left" "j_wrist_le" -9.580673 -27.862106 -37.184681 -7.07367 -32.571331 46.574527 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_1" "j_wrist_le" 0.649933 -0.548295 0.093651 -7.528597 -6.420683 -95.449783 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_le_1" "j_wrist_le" 0.657074 0.008402 0.040371 -7.529052 -0.000749 -95.45162 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_1" "j_wrist_le" 0.665776 0.747221 -0.02919 -7.529115 5.441719 -95.45104 0 0 0 0 0 0
$definebone "j_webbing_ri_1" "j_wrist_ri" 2.300138 -2.499413 0.600155 -12.693429 -30.206938 -51.10382 0 0 0 0 0 0
$definebone "tag_weapon_right" "j_wrist_ri" 11.469488 -0.466384 4.428192 -20.476654 0.51698 121.14018 0 0 0 0 0 0
$definebone "tag_knife_attach2" "j_wrist_ri" 2.762354 0.116951 1.523975 3.6757 99.91239 93.362436 0 0 0 0 0 0
$definebone "tag_accessory_right" "j_wrist_ri" 7.228323 7.928198 -3.925648 7.073666 -32.571311 133.42541 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_1" "j_wrist_ri" 0.650394 -0.54773 -0.092979 7.528592 -6.420672 95.449776 0 0 0 0 0 0
$definebone "j_proc_metaknuckle_ri_1" "j_wrist_ri" 0.657069 0.008398 -0.040379 7.529052 -0.000742 95.451614 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_1" "j_wrist_ri" 0.665777 0.74722 0.029182 7.52911 5.441721 95.451033 0 0 0 0 0 0
$definebone "j_visor" "j_helmet" -4.481003 -0.202 0 0 0 0 0 0 0 0 0 0
$definebone "j_visor_inner" "j_helmet" -5.516998 -0.291 -0.001 0 0 0 0 0 0 0 0 0
$definebone "tag_wrist_attach_le" "j_proc_wristfronttwist1_le" -0.8577 0.104073 0.104687 9.392165 0.781046 1.348519 0 0 0 0 0 0
$definebone "j_proc_metaindex_le_2" "j_proc_metaindex_le_1" 1.899121 0.000427 -0.000439 -1.908578 27.378682 1.569108 0 0 0 0 0 0
$definebone "j_proc_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799659 -0.00024 0.000231 -1.908579 27.37869 1.569113 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799659 -0.00024 0.000231 -1.908579 27.37869 1.569113 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_le_1" "j_proc_metaknuckle_le_1" 1.799659 -0.00024 0.000231 -1.908579 27.37869 1.569113 0 0 0 0 0 0
$definebone "j_proc_metapinky_le_2" "j_proc_metapinky_le_1" 1.900308 -0.000145 -0.000518 -1.908576 27.378685 1.569105 0 0 0 0 0 0
$definebone "j_proc_metaindex_ri_2" "j_proc_metaindex_ri_1" 1.899433 -0.000317 -0.000151 1.908586 27.378684 -1.569094 0 0 0 0 0 0
$definebone "j_proc_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799659 -0.000237 -0.000233 1.908583 27.378677 -1.5691 0 0 0 0 0 0
$definebone "j_proc_idle_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799659 -0.000237 -0.000233 1.908583 27.378677 -1.5691 0 0 0 0 0 0
$definebone "j_proc_orient_knuckle_ri_1" "j_proc_metaknuckle_ri_1" 1.799659 -0.000237 -0.000233 1.908583 27.378677 -1.5691 0 0 0 0 0 0
$definebone "j_proc_metapinky_ri_2" "j_proc_metapinky_ri_1" 1.900724 0.000553 -0.000072 1.908576 27.378689 -1.569099 0 0 0 0 0 0
$definebone "j_thumb_le_4" "j_thumb_le_3" 0.599884 0.400187 -0.000031 -0.000009 -0.00001 -0.00001 0 0 0 0 0 0
$definebone "j_thumb_ri_4" "j_thumb_ri_3" 0.599888 0.400187 0.000031 -0.000004 -179.999964 -0.000001 0 0 0 0 0 0
$definebone "j_index_le_4" "j_index_le_3" 0.599503 0.400696 0.000234 0.000002 -0.000016 -0.000003 0 0 0 0 0 0
$definebone "j_index_ri_4" "j_index_ri_3" 0.600399 0.399632 -0.000466 -0.000003 -179.99995 -0.000001 0 0 0 0 0 0

$bonemerge "tag_origin"
$bonemerge "tag_view"
$bonemerge "tag_ads"
$bonemerge "tag_torso"
$bonemerge "j_mainroot"
$bonemerge "j_spinelower"
$bonemerge "j_spineupper"
$bonemerge "j_clavicle_le"
$bonemerge "j_clavicle_ri"
$bonemerge "j_shoulder_le"
$bonemerge "j_teres_le"
$bonemerge "j_shoulder_ri"
$bonemerge "j_teres_ri"
$bonemerge "j_shouldertwist_le"
$bonemerge "j_elbow_le"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "j_shouldertwist_ri"
$bonemerge "j_elbow_ri"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "j_wristfronttwist1_le"
$bonemerge "j_elbowdq_le"
$bonemerge "j_wrist_le"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "j_wristfronttwist1_ri"
$bonemerge "j_elbowdq_ri"
$bonemerge "j_wrist_ri"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "j_metaindex_le_1"
$bonemerge "j_metamid_le_1"
$bonemerge "j_metapinky_le_1"
$bonemerge "j_metaring_le_1"
$bonemerge "j_thumb_le_1"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "j_metaindex_ri_1"
$bonemerge "j_metamid_ri_1"
$bonemerge "j_metapinky_ri_1"
$bonemerge "j_metaring_ri_1"
$bonemerge "j_thumb_ri_1"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "j_index_le_1"
$bonemerge "j_mid_le_1"
$bonemerge "j_pinky_le_1"
$bonemerge "j_webbing_le_3"
$bonemerge "j_ring_le_1"
$bonemerge "j_thumb_le_2"
$bonemerge "j_webbing_le_2"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "j_index_ri_1"
$bonemerge "j_mid_ri_1"
$bonemerge "j_pinky_ri_1"
$bonemerge "j_webbing_ri_3"
$bonemerge "j_ring_ri_1"
$bonemerge "j_thumb_ri_2"
$bonemerge "j_webbing_ri_2"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "j_index_le_2"
$bonemerge "j_indexbulge_le_1"
$bonemerge "j_proc_index_le_1"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "j_mid_le_2"
$bonemerge "j_proc_mid_le_1"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "j_pinky_le_2"
$bonemerge "j_proc_pinky_le_1"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "j_ring_le_2"
$bonemerge "j_proc_ring_le_1"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "j_thumb_le_3"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "j_index_ri_2"
$bonemerge "j_indexbulge_ri_1"
$bonemerge "j_proc_index_ri_1"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "j_mid_ri_2"
$bonemerge "j_proc_mid_ri_1"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "j_pinky_ri_2"
$bonemerge "j_proc_pinky_ri_1"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "j_ring_ri_2"
$bonemerge "j_proc_ring_ri_1"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "j_thumb_ri_3"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "j_index_le_3"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "j_mid_le_3"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "j_pinky_le_3"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "j_ring_le_3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "j_index_ri_3"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "j_mid_ri_3"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "j_pinky_ri_3"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "j_ring_ri_3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger02"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger42"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger42"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Anim_Attachment_RH"
$bonemerge "tag_pistol_offset"
$bonemerge "j_gun"
$bonemerge "j_hammer"
$bonemerge "j_trigger"
$bonemerge "tag_barrel_attach"
$bonemerge "j_slide"
$bonemerge "tag_sight_on"
$bonemerge "tag_laser_show"
$bonemerge "tag_laser_attach"
$bonemerge "tag_mag_attach"
$bonemerge "tag_pistolgrip_attach"
$bonemerge "tag_stock_attach"
$bonemerge "tag_sync"
$bonemerge "tag_camera_scripted"
$bonemerge "tag_cambone"
$bonemerge "tag_camera"
$bonemerge "tag_weapon"
$bonemerge "tag_player"
$bonemerge "tag_playerhelmet"
$bonemerge "j_hip_le"
$bonemerge "j_hip_ri"
$bonemerge "j_groinprotector"
$bonemerge "j_crotch"
$bonemerge "j_hiptwist_le"
$bonemerge "j_knee_le"
$bonemerge "j_hip_proc_le"
$bonemerge "j_hiptwist_ri"
$bonemerge "j_knee_ri"
$bonemerge "j_hip_proc_ri"
$bonemerge "j_proc_spinelower"
$bonemerge "j_ankle_le"
$bonemerge "j_kneedq_le"
$bonemerge "tag_stowed_thigh"
$bonemerge "j_ankle_ri"
$bonemerge "j_kneedq_ri"
$bonemerge "j_neck"
$bonemerge "j_spine4"
$bonemerge "j_proc_spineupper"
$bonemerge "j_ball_le"
$bonemerge "j_ball_ri"
$bonemerge "tag_carry_attach"
$bonemerge "j_head"
$bonemerge "j_chest"
$bonemerge "j_mag1"
$bonemerge "j_mag2"
$bonemerge "j_eyeball_le"
$bonemerge "j_eyeball_ri"
$bonemerge "j_head_end"
$bonemerge "j_jaw"
$bonemerge "j_nvg"
$bonemerge "j_bullet2"
$bonemerge "j_shield_le"
$bonemerge "j_shield_ri"
$bonemerge "j_helmet"
$bonemerge "j_proc_wristfronttwist1_le"
$bonemerge "j_webbing_le_1"
$bonemerge "tag_weapon_left"
$bonemerge "tag_accessory_left"
$bonemerge "j_proc_metaindex_le_1"
$bonemerge "j_proc_metaknuckle_le_1"
$bonemerge "j_proc_metapinky_le_1"
$bonemerge "j_webbing_ri_1"
$bonemerge "tag_weapon_right"
$bonemerge "tag_knife_attach2"
$bonemerge "tag_accessory_right"
$bonemerge "j_proc_metaindex_ri_1"
$bonemerge "j_proc_metaknuckle_ri_1"
$bonemerge "j_proc_metapinky_ri_1"
$bonemerge "j_visor"
$bonemerge "j_visor_inner"
$bonemerge "tag_wrist_attach_le"
$bonemerge "j_proc_metaindex_le_2"
$bonemerge "j_proc_knuckle_le_1"
$bonemerge "j_proc_idle_knuckle_le_1"
$bonemerge "j_proc_orient_knuckle_le_1"
$bonemerge "j_proc_metapinky_le_2"
$bonemerge "j_proc_metaindex_ri_2"
$bonemerge "j_proc_knuckle_ri_1"
$bonemerge "j_proc_idle_knuckle_ri_1"
$bonemerge "j_proc_orient_knuckle_ri_1"
$bonemerge "j_proc_metapinky_ri_2"
$bonemerge "j_thumb_le_4"
$bonemerge "j_thumb_ri_4"
$bonemerge "j_index_le_4"
$bonemerge "j_index_ri_4"


$sectionframes 30 39

$poseparameter "aim_offset" 0 1 loop 0
$poseparameter "jog_offset" 0 1 loop 0
$poseparameter "jog_loop" 0 1 loop 0
$poseparameter "walk_loop" 0 1 loop 0
$poseparameter "sprint_loop" 0 1 loop 0
$poseparameter "sprint_offset" 0 1 loop 0
$poseparameter "freefall_loop" 0 1 loop 0
$poseparameter "empty_offset" 0 1 loop 0
$poseparameter "super_sprint_loop" 0 1 loop 0
$poseparameter "super_sprint_offset" 0 1 loop 0

$ikchain "rhand" "j_wrist_ri" knee 0.707 0.707 0
$ikchain "lhand" "j_wrist_le" knee 0.707 0.707 0

$animation "a_aim_idle_to_sub_corrective_animation" "v_makarov_anims\a_aim_idle_to_sub_corrective_animation.smd" {
}

$animation "a_delta_ads_additive_for_offset_corrective_animation" "v_makarov_anims\a_delta_ads_additive_for_offset_corrective_animation.smd" {
}

$animation "a_jog_offset_idle_corrective_animation" "v_makarov_anims\a_jog_offset_idle_corrective_animation.smd" {
}

$animation "a_jog_offset_corrective_animation" "v_makarov_anims\a_jog_offset_corrective_animation.smd" {
}

$animation "@a_walk_to_jog_corrective_animation" "v_makarov_anims\@a_walk_to_jog_corrective_animation.smd" {
}

$animation "@a_jog_to_walk_corrective_animation" "v_makarov_anims\@a_jog_to_walk_corrective_animation.smd" {
}

$animation "a_jog_idle_corrective_animation" "v_makarov_anims\a_jog_idle_corrective_animation.smd" {
}

$animation "a_jog_corrective_animation" "v_makarov_anims\a_jog_corrective_animation.smd" {
}

$animation "a_walk_idle_corrective_animation" "v_makarov_anims\a_walk_idle_corrective_animation.smd" {
}

$animation "a_walk_corrective_animation" "v_makarov_anims\a_walk_corrective_animation.smd" {
}

$animation "@a_walk_to_sprint_corrective_animation" "v_makarov_anims\@a_walk_to_sprint_corrective_animation.smd" {
}

$animation "a_sprint_idle_corrective_animation" "v_makarov_anims\a_sprint_idle_corrective_animation.smd" {
}

$animation "a_sprint_corrective_animation" "v_makarov_anims\a_sprint_corrective_animation.smd" {
}

$animation "@a_sprint_to_walk_corrective_animation" "v_makarov_anims\@a_sprint_to_walk_corrective_animation.smd" {
}

$animation "a_sprint_offset_idle_corrective_animation" "v_makarov_anims\a_sprint_offset_idle_corrective_animation.smd" {
}

$animation "a_sprint_offset_corrective_animation" "v_makarov_anims\a_sprint_offset_corrective_animation.smd" {
}

$animation "a_fidget_corrective_animation" "v_makarov_anims\a_fidget_corrective_animation.smd" {
}

$animation "a_zerodiff_corrective_animation" "v_makarov_anims\a_zerodiff_corrective_animation.smd" {
}

$animation "a_freefall_idle_corrective_animation" "v_makarov_anims\a_freefall_idle_corrective_animation.smd" {
}

$animation "a_freefall_corrective_animation" "v_makarov_anims\a_freefall_corrective_animation.smd" {
}

$animation "@a_landdelta_corrective_animation" "v_makarov_anims\@a_landdelta_corrective_animation.smd" {
}

$animation "@a_jumpdelta_corrective_animation" "v_makarov_anims\@a_jumpdelta_corrective_animation.smd" {
}

$animation "a_empty_idle_to_sub_corrective_animation" "v_makarov_anims\a_empty_idle_to_sub_corrective_animation.smd" {
}

$animation "a_delta_empty_additive_for_offset_corrective_animation" "v_makarov_anims\a_delta_empty_additive_for_offset_corrective_animation.smd" {
}

$animation "@a_walk_to_super_sprint_corrective_animation" "v_makarov_anims\@a_walk_to_super_sprint_corrective_animation.smd" {
}

$animation "a_super_sprint_idle_corrective_animation" "v_makarov_anims\a_super_sprint_idle_corrective_animation.smd" {
}

$animation "a_super_sprint_corrective_animation" "v_makarov_anims\a_super_sprint_corrective_animation.smd" {
}

$animation "@a_super_sprint_to_walk_corrective_animation" "v_makarov_anims\@a_super_sprint_to_walk_corrective_animation.smd" {
}

$animation "a_aim_idle_to_sub_corrective_animation" "v_makarov_anims\a_aim_idle_to_sub_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_delta_ads_additive_for_offset_corrective_animation" "v_makarov_anims\a_delta_ads_additive_for_offset_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_jog_offset_idle_corrective_animation" "v_makarov_anims\a_jog_offset_idle_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_jog_offset_corrective_animation" "v_makarov_anims\a_jog_offset_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_jog_idle_corrective_animation" "v_makarov_anims\a_jog_idle_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_jog_corrective_animation" "v_makarov_anims\a_jog_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_walk_idle_corrective_animation" "v_makarov_anims\a_walk_idle_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_walk_corrective_animation" "v_makarov_anims\a_walk_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_sprint_idle_corrective_animation" "v_makarov_anims\a_sprint_idle_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_sprint_corrective_animation" "v_makarov_anims\a_sprint_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_sprint_offset_idle_corrective_animation" "v_makarov_anims\a_sprint_offset_idle_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_sprint_offset_corrective_animation" "v_makarov_anims\a_sprint_offset_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_fidget_corrective_animation" "v_makarov_anims\a_fidget_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_zerodiff_corrective_animation" "v_makarov_anims\a_zerodiff_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_freefall_idle_corrective_animation" "v_makarov_anims\a_freefall_idle_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_freefall_corrective_animation" "v_makarov_anims\a_freefall_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_empty_idle_to_sub_corrective_animation" "v_makarov_anims\a_empty_idle_to_sub_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_delta_empty_additive_for_offset_corrective_animation" "v_makarov_anims\a_delta_empty_additive_for_offset_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_super_sprint_idle_corrective_animation" "v_makarov_anims\a_super_sprint_idle_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "a_super_sprint_corrective_animation" "v_makarov_anims\a_super_sprint_corrective_animation.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 0 0 target 1
}

$animation "aim_idle_to_sub" "v_makarov_anims\aim_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1
}

$animation "a_aim_idle_to_sub" "v_makarov_anims\a_aim_idle_to_sub.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_aim_idle_to_sub_corrective_animation" 0
}

$animation "a_delta_ads_additive_for_offset" "v_makarov_anims\a_delta_ads_additive_for_offset.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_delta_ads_additive_for_offset_corrective_animation" 0
}

$animation "jog_offset_to_sub" "v_makarov_anims\jog_offset_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 1
}

$animation "jog_idle_to_sub" "v_makarov_anims\jog_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1
}

$animation "a_jog_offset_idle" "v_makarov_anims\a_jog_offset_idle.smd" {
	fps 0.416
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_jog_offset_idle_corrective_animation" 0
}

$animation "a_jog_offset" "v_makarov_anims\a_jog_offset.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_jog_offset_corrective_animation" 0
}

$animation "jog_in_to_sub" "v_makarov_anims\jog_in_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 1
}

$animation "jog_out_to_sub" "v_makarov_anims\jog_out_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 1
}

$animation "a_jog_idle_to_sub" "v_makarov_anims\a_jog_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 73 73 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 73 73 target 1
}

$animation "a_jog_to_sub" "v_makarov_anims\a_jog_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 73 73 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 73 73 target 1
}

$animation "a_jog_idle" "v_makarov_anims\a_jog_idle.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_jog_idle_corrective_animation" 0
}

$animation "a_jog" "v_makarov_anims\a_jog.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_jog_corrective_animation" 0
}

$animation "a_walk_idle_to_sub" "v_makarov_anims\a_walk_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 112 112 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 112 112 target 1
}

$animation "a_walk_to_sub" "v_makarov_anims\a_walk_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 112 112 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 112 112 target 1
}

$animation "a_walk_idle" "v_makarov_anims\a_walk_idle.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_walk_idle_corrective_animation" 0
}

$animation "a_walk" "v_makarov_anims\a_walk.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_walk_corrective_animation" 0
}

$animation "sprint_in_to_sub" "v_makarov_anims\sprint_in_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 1
}

$animation "a_sprint_idle_to_sub" "v_makarov_anims\a_sprint_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 64 64 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 64 64 target 1
}

$animation "a_sprint_to_sub" "v_makarov_anims\a_sprint_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 64 64 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 64 64 target 1
}

$animation "a_sprint_idle" "v_makarov_anims\a_sprint_idle.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_sprint_idle_corrective_animation" 0
}

$animation "a_sprint" "v_makarov_anims\a_sprint.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_sprint_corrective_animation" 0
}

$animation "sprint_out_to_sub" "v_makarov_anims\sprint_out_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 1
}

$animation "sprint_offset_to_sub" "v_makarov_anims\sprint_offset_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 23 23 target 1
}

$animation "sprint_idle_to_sub" "v_makarov_anims\sprint_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1
}

$animation "a_sprint_offset_idle" "v_makarov_anims\a_sprint_offset_idle.smd" {
	fps 0.416
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_sprint_offset_idle_corrective_animation" 0
}

$animation "a_sprint_offset" "v_makarov_anims\a_sprint_offset.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_sprint_offset_corrective_animation" 0
}

$animation "a_normalidle_to_sub" "v_makarov_anims\a_normalidle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1
}

$animation "fuckedpose_to_sub" "v_makarov_anims\fuckedpose_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 770 770 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 770 770 target 1
}

$animation "a_zerodiff" "v_makarov_anims\a_zerodiff.smd" {
	fps 0.0389
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_zerodiff_corrective_animation" 0
}

$animation "a_fidget" "v_makarov_anims\a_fidget.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_fidget_corrective_animation" 0
}

$animation "freefall_idle_to_sub" "v_makarov_anims\freefall_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1
}

$animation "freefall_to_sub" "v_makarov_anims\freefall_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 99 99 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 99 99 target 1
}

$animation "a_freefall_idle" "v_makarov_anims\a_freefall_idle.smd" {
	fps 0.303
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_freefall_idle_corrective_animation" 0
}

$animation "a_freefall" "v_makarov_anims\a_freefall.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_freefall_corrective_animation" 0
}

$animation "jump_land_to_sub" "v_makarov_anims\jump_land_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 22 22 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 22 22 target 1
}

$animation "jump_to_sub" "v_makarov_anims\jump_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 11 11 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 11 11 target 1
}

$animation "empty_idle_to_sub" "v_makarov_anims\empty_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1
}

$animation "a_empty_idle_to_sub" "v_makarov_anims\a_empty_idle_to_sub.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_empty_idle_to_sub_corrective_animation" 0
}

$animation "a_delta_empty_additive_for_offset" "v_makarov_anims\a_delta_empty_additive_for_offset.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_delta_empty_additive_for_offset_corrective_animation" 0
}

$animation "a_super_sprint_idle_to_sub" "v_makarov_anims\a_super_sprint_idle_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 60 60 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 60 60 target 1
}

$animation "a_super_sprint_to_sub" "v_makarov_anims\a_super_sprint_to_sub.smd" {
	fps 30
	ikrule "rhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 60 60 target 0
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 60 60 target 1
}

$animation "a_super_sprint_idle" "v_makarov_anims\a_super_sprint_idle.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_super_sprint_idle_corrective_animation" 0
}

$animation "a_super_sprint" "v_makarov_anims\a_super_sprint.smd" {
	fps 30
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "a_super_sprint_corrective_animation" 0
}

$sequence "idle" {
	"v_makarov_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	addlayer "a_idle_active"
	fps 0.416
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "holster" {
	"v_makarov_anims\holster.smd"
	{ event 9011 0 "0" }
	{ event 5004 0 "wfoly_plr_pi_mike_drop_01" }
	fadein 0.2
	fadeout 0.2
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 11 11 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 11 11 target 1 usesequence 
}

$sequence "draw" {
	"v_makarov_anims\draw.smd"
	{ event 9011 0 "0" }
	{ event 5004 0 "wfoly_plr_pi_mike_raise_01" }
	{ event 9011 6 "1" }
	{ event 5004 9 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 20 20 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 20 20 target 1 usesequence 
}

$sequence "draw_first" {
	"v_makarov_anims\draw_first.smd"
	{ event 5004 0 "wfoly_plr_pi_mike_raise_first_01" }
	{ event 9011 0 "0" }
	{ event 5004 6 "wfoly_plr_pi_mike_raise_first_02" }
	{ event 5004 10 "Viewmodel.Small" }
	{ event 5004 15 "wfoly_plr_pi_mike_raise_first_03" }
	{ event 5004 19 "wfoly_plr_pi_mike_raise_first_04" }
	{ event 5004 20 "Viewmodel.Large" }
	{ event 9011 24 "1" }
	{ event 5004 31 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 44 44 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 44 44 target 1 usesequence 
}

$sequence "draw_first_drum" {
	"v_makarov_anims\draw_first_drum.smd"
	{ event 9011 0 "0" }
	{ event 5004 2 "wfoly_plr_pi_mike_raise_first_drum_01" }
	{ event 5004 10 "Viewmodel.Small" }
	{ event 5004 17 "wfoly_plr_pi_mike_raise_first_drum_02" }
	{ event 5004 20 "Viewmodel.Large" }
	{ event 5004 22 "wfoly_plr_pi_mike_raise_first_drum_03" }
	{ event 9011 24 "1" }
	{ event 5004 31 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 44 44 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 44 44 target 1 usesequence 
}

$sequence "reload_empty" {
	"v_makarov_anims\reload_empty.smd"
	"v_makarov_anims\reload_empty_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 0 "wfoly_plr_pi_mike_reload_empty_01" }
	{ event 5004 9 "wfoly_plr_pi_mike_reload_empty_02" }
	{ event 5004 15 "Viewmodel.Medium" }
	{ event 5004 27 "Viewmodel.Small" }
	{ event 5004 28 "wfoly_plr_pi_mike_reload_empty_03" }
	{ event 5004 30 "wfoly_plr_pi_mike_reload_empty_04" }
	{ event 5004 34 "Viewmodel.Large" }
	{ event 5004 47 "wfoly_plr_pi_mike_reload_empty_05" }
	{ event 5004 52 "Viewmodel.Small" }
	{ event 5004 54 "Viewmodel.Large" }
	{ event 5004 56 "wfoly_plr_pi_mike_reload_empty_06" }
	{ event 9031 53 "ResetBullets" }
	{ event 9011 62 "1" }
	{ event 5004 65 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 82 82 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 82 82 target 1 usesequence 
}

$sequence "reload_empty_fast" {
	"v_makarov_anims\reload_empty_fast.smd"
	"v_makarov_anims\reload_empty_fast_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 1 "wfoly_plr_pi_mike_reload_fast_empty_01" }
	{ event 5004 14 "wfoly_plr_pi_mike_reload_fast_empty_02" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 16 "MW_MagazineDrop.SMG.Metal 10,10,40" }
	{ event 5004 22 "wfoly_plr_pi_mike_reload_fast_empty_03" }
	{ event 5004 27 "Viewmodel.Large" }
	{ event 5004 31 "wfoly_plr_pi_mike_reload_fast_empty_04" }
	{ event 9011 31 "1" }
	{ event 5004 37 "Viewmodel.Large" }
	{ event 5004 43 "wfoly_plr_pi_mike_reload_fast_empty_05" }
	{ event 5004 44 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 62 62 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 62 62 target 1 usesequence 
}

$sequence "reload_empty_xmag" {
	"v_makarov_anims\reload_empty_xmag.smd"
	"v_makarov_anims\reload_empty_xmag_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 5 "wfoly_plr_pi_mike_reload_empty_xmag_01" }
	{ event 5004 11 "wfoly_plr_pi_mike_reload_empty_xmag_02" }
	{ event 5004 15 "Viewmodel.Medium" }
	{ event 5004 26 "wfoly_plr_pi_mike_reload_empty_xmag_03" }
	{ event 5004 27 "Viewmodel.Small" }
	{ event 5004 34 "Viewmodel.Large" }
	{ event 5004 41 "wfoly_plr_pi_mike_reload_empty_xmag_04" }
	{ event 5004 52 "Viewmodel.Small" }
	{ event 5004 54 "Viewmodel.Large" }
	{ event 9031 58 "ResetBullets" }
	{ event 5004 61 "wfoly_plr_pi_mike_reload_empty_xmag_05" }
	{ event 9011 62 "1" }
	{ event 5004 65 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 82 82 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 82 82 target 1 usesequence 
}

$sequence "reload_empty_xmag_fast" {
	"v_makarov_anims\reload_empty_xmag_fast.smd"
	"v_makarov_anims\reload_empty_xmag_fast_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 2 "wfoly_plr_pi_mike_reload_fast_empty_xmag_01" }
	{ event 5004 13 "wfoly_plr_pi_mike_reload_fast_empty_xmag_02" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 16 "MW_MagazineDrop.SMG.Metal 10,10,40" }
	{ event 5004 23 "wfoly_plr_pi_mike_reload_fast_empty_xmag_03" }
	{ event 5004 24 "wfoly_plr_pi_mike_reload_fast_empty_xmag_04" }
	{ event 5004 27 "Viewmodel.Large" }
	{ event 9011 31 "1" }
	{ event 5004 33 "wfoly_plr_pi_mike_reload_fast_empty_xmag_05" }
	{ event 5004 37 "Viewmodel.Large" }
	{ event 5004 42 "wfoly_plr_pi_mike_reload_fast_empty_xmag_06" }
	{ event 5004 44 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 62 62 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 62 62 target 1 usesequence 
}

$sequence "reload_empty_xmaglrg" {
	"v_makarov_anims\reload_empty_xmaglrg.smd"
	"v_makarov_anims\reload_empty_xmaglrg_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 0 "wfoly_plr_pi_mike_reload_empty_drum_01" }
	{ event 5004 7 "wfoly_plr_pi_mike_reload_empty_drum_02" }
	{ event 5004 11 "Viewmodel.Small" }
	{ event 5004 14 "wfoly_plr_pi_mike_reload_empty_drum_03" }
	{ event 5004 15 "Viewmodel.Medium" }
	{ event 9031 30 "ResetBullets" }
	{ event 5004 37 "wfoly_plr_pi_mike_reload_empty_drum_04" }
	{ event 5004 39 "Viewmodel.Small" }
	{ event 5004 46 "wfoly_plr_pi_mike_reload_empty_drum_05" }
	{ event 5004 48 "Viewmodel.Large" }
	{ event 5004 52 "wfoly_plr_pi_mike_reload_empty_drum_06" }
	{ event 5004 65 "wfoly_plr_pi_mike_reload_empty_drum_07" }
	{ event 5004 66 "Viewmodel.Small" }
	{ event 5004 68 "Viewmodel.Large" }
	{ event 9011 71 "1" }
	{ event 5004 77 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 94 94 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 94 94 target 1 usesequence 
}

$sequence "reload_empty_xmaglrg_fast" {
	"v_makarov_anims\reload_empty_xmaglrg_fast.smd"
	"v_makarov_anims\reload_empty_xmaglrg_fast_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 1 "wfoly_plr_pi_mike_reload_fast_empty_drum_01" }
	{ event 5004 8 "wfoly_plr_pi_mike_reload_fast_empty_drum_02" }
	{ event 5004 12 "wfoly_plr_pi_mike_reload_fast_empty_drum_03" }
	{ event 5004 14 "Viewmodel.Medium" }
	{ event 5004 15 "MW_MagazineDrop.Drum 10,10,40" }
	{ event 9031 22 "ResetBullets" }
	{ event 5004 25 "wfoly_plr_pi_mike_reload_fast_empty_drum_04" }
	{ event 5004 31 "Viewmodel.Small" }
	{ event 5004 32 "wfoly_plr_pi_mike_reload_fast_empty_drum_05" }
	{ event 5004 36 "Viewmodel.Large" }
	{ event 5004 43 "wfoly_plr_pi_mike_reload_fast_empty_drum_06" }
	{ event 5004 45 "wfoly_plr_pi_mike_reload_fast_empty_drum_07" }
	{ event 5004 46 "Viewmodel.Large" }
	{ event 9011 47 "1" }
	{ event 5004 53 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 71 71 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 71 71 target 1 usesequence 
}

$sequence "reload" {
	"v_makarov_anims\reload.smd"
	"v_makarov_anims\reload_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 0 "wfoly_plr_pi_mike_reload_01" }
	{ event 5004 15 "wfoly_plr_pi_mike_reload_02" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 25 "wfoly_plr_pi_mike_reload_03" }
	{ event 5004 27 "Viewmodel.Small" }
	{ event 5004 31 "wfoly_plr_pi_mike_reload_04" }
	{ event 5004 34 "Viewmodel.Large" }
	{ event 5004 41 "wfoly_plr_pi_mike_reload_05" }
	{ event 9031 44 "ResetBullets" }
	{ event 9011 45 "1" }
	{ event 5004 48 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 68 68 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 68 68 target 1 usesequence 
}

$sequence "reload_fast" {
	"v_makarov_anims\reload_fast.smd"
	"v_makarov_anims\reload_fast_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 2 "wfoly_plr_pi_mike_reload_fast_01" }
	{ event 5004 14 "wfoly_plr_pi_mike_reload_fast_02" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 16 "MW_MagazineDrop.SMG.Metal 10,10,40" }
	{ event 5004 23 "wfoly_plr_pi_mike_reload_fast_03" }
	{ event 5004 27 "Viewmodel.Large" }
	{ event 5004 28 "wfoly_plr_pi_mike_reload_fast_04" }
	{ event 9011 29 "1" }
	{ event 5004 34 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 53 53 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 53 53 target 1 usesequence 
}

$sequence "reload_xmag" {
	"v_makarov_anims\reload_xmag.smd"
	"v_makarov_anims\reload_xmag_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 1 "wfoly_plr_pi_mike_reload_xmag_01" }
	{ event 5004 14 "wfoly_plr_pi_mike_reload_xmag_02" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 26 "wfoly_plr_pi_mike_reload_xmag_03" }
	{ event 5004 27 "Viewmodel.Small" }
	{ event 5004 29 "wfoly_plr_pi_mike_reload_xmag_04" }
	{ event 5004 34 "Viewmodel.Large" }
	{ event 5004 44 "wfoly_plr_pi_mike_reload_xmag_05" }
	{ event 9031 44 "ResetBullets" }
	{ event 9011 45 "1" }
	{ event 5004 48 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 68 68 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 68 68 target 1 usesequence 
}

$sequence "reload_xmag_fast" {
	"v_makarov_anims\reload_xmag_fast.smd"
	"v_makarov_anims\reload_xmag_fast_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 2 "wfoly_plr_pi_mike_reload_fast_xmag_01" }
	{ event 5004 14 "wfoly_plr_pi_mike_reload_fast_xmag_02" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 16 "MW_MagazineDrop.SMG.Metal 10,10,40" }
	{ event 5004 23 "wfoly_plr_pi_mike_reload_fast_xmag_03" }
	{ event 5004 27 "Viewmodel.Large" }
	{ event 9011 29 "1" }
	{ event 5004 31 "wfoly_plr_pi_mike_reload_fast_xmag_04" }
	{ event 5004 34 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 53 53 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 53 53 target 1 usesequence 
}

$sequence "reload_xmaglrg" {
	"v_makarov_anims\reload_xmaglrg.smd"
	"v_makarov_anims\reload_xmaglrg_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 0 "wfoly_plr_pi_mike_reload_drum_01" }
	{ event 5004 8 "wfoly_plr_pi_mike_reload_drum_02" }
	{ event 5004 11 "Viewmodel.Small" }
	{ event 5004 14 "wfoly_plr_pi_mike_reload_drum_03" }
	{ event 5004 15 "Viewmodel.Medium" }
	{ event 9031 30 "ResetBullets" }
	{ event 5004 37 "wfoly_plr_pi_mike_reload_drum_04" }
	{ event 5004 39 "Viewmodel.Small" }
	{ event 5004 47 "wfoly_plr_pi_mike_reload_drum_05" }
	{ event 5004 48 "Viewmodel.Large" }
	{ event 5004 49 "wfoly_plr_pi_mike_reload_drum_06" }
	{ event 9011 56 "1" }
	{ event 5004 60 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 80 80 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 80 80 target 1 usesequence 
}

$sequence "reload_xmaglrg_fast" {
	"v_makarov_anims\reload_xmaglrg_fast.smd"
	"v_makarov_anims\reload_xmaglrg_fast_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9011 0 "0" }
	{ event 5004 2 "wfoly_plr_pi_mike_reload_fast_drum_01" }
	{ event 5004 7 "wfoly_plr_pi_mike_reload_fast_drum_02" }
	{ event 5004 12 "wfoly_plr_pi_mike_reload_fast_drum_03" }
	{ event 5004 14 "Viewmodel.Medium" }
	{ event 5004 15 "MW_MagazineDrop.Drum 10,10,40" }
	{ event 9031 22 "ResetBullets" }
	{ event 5004 31 "wfoly_plr_pi_mike_reload_fast_drum_04" }
	{ event 5004 31 "Viewmodel.Small" }
	{ event 5004 36 "wfoly_plr_pi_mike_reload_fast_drum_05" }
	{ event 5004 36 "Viewmodel.Large" }
	{ event 5004 37 "wfoly_plr_pi_mike_reload_fast_drum_06" }
	{ event 9011 43 "1" }
	{ event 5004 48 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "aim_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 67 67 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 67 67 target 1 usesequence 
}

$sequence "fire" {
	"v_makarov_anims\fire.smd"
	"v_makarov_anims\fire_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9001 1 "MuzzleFlash muzzle" }
	{ event 6001 1 "shell_eject" }
	{ event 9001 1 "Ejection shell_eject" }
	{ event 9011 0 "1" }
	{ event 9011 0 "1" }
	fadein 0.2
	fadeout 0.2
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 27 27 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 27 27 target 1 usesequence 
}

$sequence "fire_last" {
	"v_makarov_anims\fire_last.smd"
	"v_makarov_anims\fire_last_2.smd"
	blend "aim_offset" 0 1
	blendwidth 2
	{ event 9001 1 "MuzzleFlash muzzle" }
	{ event 6001 1 "shell_eject" }
	{ event 9001 1 "Ejection shell_eject" }
	{ event 9011 0 "1" }
	{ event 9011 0 "1" }
	fadein 0.2
	fadeout 0.2
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 8 8 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 8 8 target 1 usesequence 
}

$sequence "melee_miss_01" {
	"v_makarov_anims\melee_miss_01.smd"
	{ event 9011 0 "0" }
	{ event 9021 0 "0" }
	{ event 5004 0 "MW_Melee.Miss_Medium" }
	{ event 5004 7 "Viewmodel.Large" }
	{ event 5004 8 "Viewmodel.Medium" }
	{ event 9021 26 "1" }
	{ event 9011 26 "1" }
	{ event 5004 31 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 1 usesequence 
}

$sequence "melee_miss_02" {
	"v_makarov_anims\melee_miss_02.smd"
	{ event 9011 0 "0" }
	{ event 9021 0 "0" }
	{ event 5004 0 "MW_Melee.Miss_Medium" }
	{ event 5004 7 "Viewmodel.Large" }
	{ event 5004 8 "Viewmodel.Medium" }
	{ event 9021 26 "1" }
	{ event 9011 26 "1" }
	{ event 5004 31 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 1 usesequence 
}

$sequence "melee_miss_03" {
	"v_makarov_anims\melee_miss_03.smd"
	{ event 9011 0 "0" }
	{ event 9021 0 "0" }
	{ event 5004 0 "MW_Melee.Miss_Medium" }
	{ event 5004 7 "Viewmodel.Large" }
	{ event 5004 8 "Viewmodel.Medium" }
	{ event 9021 26 "1" }
	{ event 9011 26 "1" }
	{ event 5004 31 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 1 usesequence 
}

$sequence "melee_hit_01" {
	"v_makarov_anims\melee_hit_01.smd"
	{ event 9011 0 "0" }
	{ event 9021 0 "0" }
	{ event 5004 7 "Viewmodel.Large" }
	{ event 5004 0 "MW_Melee.Flesh_Medium" }
	{ event 5004 8 "Viewmodel.Medium" }
	{ event 9021 26 "1" }
	{ event 9011 26 "1" }
	{ event 5004 31 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 1 usesequence 
}

$sequence "melee_hit_02" {
	"v_makarov_anims\melee_hit_02.smd"
	{ event 9011 0 "0" }
	{ event 9021 0 "0" }
	{ event 5004 7 "Viewmodel.Large" }
	{ event 5004 0 "MW_Melee.Flesh_Medium" }
	{ event 5004 8 "Viewmodel.Medium" }
	{ event 9021 26 "1" }
	{ event 9011 26 "1" }
	{ event 5004 31 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 1 usesequence 
}

$sequence "melee_hit_03" {
	"v_makarov_anims\melee_hit_03.smd"
	{ event 9011 0 "0" }
	{ event 9021 0 "0" }
	{ event 5004 7 "Viewmodel.Large" }
	{ event 5004 0 "MW_Melee.Flesh_Medium" }
	{ event 5004 8 "Viewmodel.Medium" }
	{ event 9021 26 "1" }
	{ event 9011 26 "1" }
	{ event 5004 31 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	snap
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 39 39 target 1 usesequence 
}

$sequence "inspect" {
	"v_makarov_anims\inspect.smd"
	{ event 9011 0 "0" }
	{ event 5004 1 "wfoly_plr_pi_mike_inspect_01" }
	{ event 5004 12 "Viewmodel.Small" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 35 "wfoly_plr_pi_mike_inspect_02" }
	{ event 5004 38 "Viewmodel.Small" }
	{ event 5004 44 "Viewmodel.Large" }
	{ event 5004 49 "wfoly_plr_pi_mike_inspect_03" }
	{ event 5004 56 "Viewmodel.Small" }
	{ event 5004 93 "wfoly_plr_pi_mike_inspect_04" }
	{ event 9011 93 "1" }
	{ event 5004 101 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 120 120 target 0
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 120 120 target 1
}

$sequence "inspect_xmag" {
	"v_makarov_anims\inspect_xmag.smd"
	{ event 9011 0 "0" }
	{ event 5004 1 "wfoly_plr_pi_mike_inspect_xmag_01" }
	{ event 5004 12 "Viewmodel.Small" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 38 "Viewmodel.Small" }
	{ event 5004 41 "wfoly_plr_pi_mike_inspect_xmag_02" }
	{ event 5004 44 "Viewmodel.Large" }
	{ event 5004 56 "Viewmodel.Small" }
	{ event 5004 73 "wfoly_plr_pi_mike_inspect_xmag_03" }
	{ event 9011 93 "1" }
	{ event 5004 93 "wfoly_plr_pi_mike_inspect_xmag_04" }
	{ event 5004 101 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 120 120 target 0
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 120 120 target 1
}

$sequence "inspect_drum" {
	"v_makarov_anims\inspect_drum.smd"
	{ event 9011 0 "0" }
	{ event 5004 2 "wfoly_plr_pi_mike_inspect_drum_01" }
	{ event 5004 12 "Viewmodel.Small" }
	{ event 5004 16 "Viewmodel.Medium" }
	{ event 5004 38 "Viewmodel.Small" }
	{ event 5004 38 "wfoly_plr_pi_mike_inspect_drum_02" }
	{ event 5004 44 "Viewmodel.Large" }
	{ event 5004 51 "wfoly_plr_pi_mike_inspect_drum_03" }
	{ event 5004 56 "Viewmodel.Small" }
	{ event 5004 76 "wfoly_plr_pi_mike_inspect_drum_04" }
	{ event 5004 90 "wfoly_plr_pi_mike_inspect_drum_05" }
	{ event 9011 93 "1" }
	{ event 5004 101 "Viewmodel.Small" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 120 120 target 0
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 120 120 target 1
}

$sequence "ads_in" {
	"v_makarov_anims\ads_in.smd"
	{ event 5004 3 "weap_pi_mike1911_ads_up" }
	{ event 9011 0 "1" }
	{ event 9011 0 "1" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 10 10 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 10 10 target 1 usesequence 
}

$sequence "ads_out" {
	"v_makarov_anims\ads_out.smd"
	{ event 5004 3 "weap_pi_mike1911_ads_down" }
	{ event 9011 0 "1" }
	{ event 9011 0 "1" }
	fadein 0.2
	fadeout 0.2
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 30
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 22 22 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 22 22 target 1 usesequence 
}

$sequence "aim_offset" {
	"a_aim_idle_to_sub"
	"a_delta_ads_additive_for_offset"
	blend "aim_offset" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "jog_offset" {
	"a_jog_offset_idle"
	"a_jog_offset"
	blend "jog_offset" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "a_walk_to_jog" {
	"v_makarov_anims\a_walk_to_jog.smd"
	delta
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "@a_walk_to_jog_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "jog_in" {
	"v_makarov_anims\jog_in.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "a_walk_to_jog"
	fps 1.304
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "a_jog_to_walk" {
	"v_makarov_anims\a_jog_to_walk.smd"
	delta
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "@a_jog_to_walk_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "jog_out" {
	"v_makarov_anims\jog_out.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "a_jog_to_walk"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 1.304
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "jog_loop" {
	"a_jog_idle"
	"a_jog"
	blend "jog_loop" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "walk_loop" {
	"a_walk_idle"
	"a_walk"
	blend "walk_loop" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "a_walk_to_sprint" {
	"v_makarov_anims\a_walk_to_sprint.smd"
	delta
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "@a_walk_to_sprint_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sprint_in" {
	"v_makarov_anims\sprint_in.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "a_walk_to_sprint"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 1.25
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "sprint_loop" {
	"a_sprint_idle"
	"a_sprint"
	blend "sprint_loop" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "a_sprint_to_walk" {
	"v_makarov_anims\a_sprint_to_walk.smd"
	delta
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "@a_sprint_to_walk_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "sprint_out" {
	"v_makarov_anims\sprint_out.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "a_sprint_to_walk"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 1.25
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "sprint_offset" {
	"a_sprint_offset_idle"
	"a_sprint_offset"
	blend "sprint_offset" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "a_idle_active" {
	"a_fidget"
	"a_zerodiff"
	blend "aim_offset" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "freefall_loop" {
	"a_freefall_idle"
	"a_freefall"
	blend "freefall_loop" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "a_landdelta" {
	"v_makarov_anims\a_landdelta.smd"
	delta
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "@a_landdelta_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "jump_land" {
	"v_makarov_anims\jump_land.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "a_landdelta"
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 1.363
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "a_jumpdelta" {
	"v_makarov_anims\a_jumpdelta.smd"
	delta
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "@a_jumpdelta_corrective_animation" 0
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "jump" {
	"v_makarov_anims\jump.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "a_jumpdelta"
	addlayer "aim_offset"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "sprint_loop"
	addlayer "sprint_offset"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 2.727
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "empty_offset" {
	"a_empty_idle_to_sub"
	"a_delta_empty_additive_for_offset"
	blend "empty_offset" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "a_walk_to_super_sprint" {
	"v_makarov_anims\a_walk_to_super_sprint.smd"
	delta
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "@a_walk_to_super_sprint_corrective_animation" 0
	{ event 9011 0 "1" }
	{ event 9011 4 "0" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "super_sprint_in" {
	"v_makarov_anims\super_sprint_in.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "a_walk_to_super_sprint"
	addlayer "walk_loop"
	addlayer "super_sprint_loop"
	addlayer "super_sprint_offset"
	addlayer "freefall_loop"
	fps 1.25
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" release contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "super_sprint_loop" {
	"a_super_sprint_idle"
	"a_super_sprint"
	blend "super_sprint_loop" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}

$sequence "a_super_sprint_to_walk" {
	"v_makarov_anims\a_super_sprint_to_walk.smd"
	delta
	// Crowbar writes this subtract option to prevent jigglebone and poseparameter problems when delta sequences are recompiled.
	subtract "@a_super_sprint_to_walk_corrective_animation" 0
	{ event 9011 0 "0" }
	{ event 9011 3 "1" }
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "super_sprint_out" {
	"v_makarov_anims\super_sprint_out.smd"
	fadein 0.2
	fadeout 0.2
	addlayer "a_super_sprint_to_walk"
	addlayer "jog_loop"
	addlayer "jog_offset"
	addlayer "walk_loop"
	addlayer "super_sprint_loop"
	addlayer "freefall_loop"
	addlayer "empty_offset"
	fps 1.25
	ikrule "rhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 0 usesequence 
	ikrule "lhand" touch "tag_pistol_offset" contact 0 fakeorigin 0 0 0 fakerotate 0 0 0 floor 0 height 0 radius 0 range 0 0 1 1 target 1 usesequence 
}

$sequence "super_sprint_offset" {
	"a_super_sprint_idle"
	"a_super_sprint"
	blend "super_sprint_offset" 0 1
	blendwidth 2
	delta
	fadein 0.2
	fadeout 0.2
	realtime
}
