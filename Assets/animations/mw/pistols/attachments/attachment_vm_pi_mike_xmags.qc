// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike_xmags.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike_xmags.smd"
}
$bodygroup "bullets"
{
	studio "attachment_vm_pi_mike_bullets_10.smd"
	studio "attachment_vm_pi_mike_bullets_9.smd"
	studio "attachment_vm_pi_mike_bullets_8.smd"
	studio "attachment_vm_pi_mike_bullets_7.smd"
	studio "attachment_vm_pi_mike_bullets_6.smd"
	studio "attachment_vm_pi_mike_bullets_5.smd"
	studio "attachment_vm_pi_mike_bullets_4.smd"
	studio "attachment_vm_pi_mike_bullets_3.smd"
	studio "attachment_vm_pi_mike_bullets_2.smd"
	studio "attachment_vm_pi_mike_bullets_1.smd"
	blank
}
$bodygroup "bullets_mag2"
{
	studio "attachment_vm_pi_mike_mag2_bullets_10.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_9.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_8.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_7.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_6.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_5.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_4.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_3.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_2.smd"
	studio "attachment_vm_pi_mike_mag2_bullets_1.smd"
	blank
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\makarov\"

$cbox 0 0 0 0 0 0

$bbox -1.591 -0.593 -1.933 0.481 0.588 4.517

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -0.271999 0 2.687995 0 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -0.271999 0 2.687995 0 0 0 0 0 0 0 0 0
$definebone "j_bullet1" "j_mag1" 0.229999 0.064 1.466997 0 0 0 0 0 0 0 0 0
$definebone "j_bullet10" "j_mag1" -0.183 -0.064 -1.792997 0 0 0 0 0 0 0 0 0
$definebone "j_bullet2" "j_mag1" 0.180999 -0.064 1.095998 0 0 0 0 0 0 0 0 0
$definebone "j_bullet3" "j_mag1" 0.139 0.064 0.743999 0 0 0 0 0 0 0 0 0
$definebone "j_bullet4" "j_mag1" 0.094 -0.064 0.373999 0 0 0 0 0 0 0 0 0
$definebone "j_bullet5" "j_mag1" 0.046 0.064 0.022 0 0 0 0 0 0 0 0 0
$definebone "j_bullet6" "j_mag1" -0.002001 -0.064 -0.348999 0 0 0 0 0 0 0 0 0
$definebone "j_bullet7" "j_mag1" -0.046 0.064 -0.700999 0 0 0 0 0 0 0 0 0
$definebone "j_bullet8" "j_mag1" -0.092 -0.064 -1.070998 0 0 0 0 0 0 0 0 0
$definebone "j_bullet9" "j_mag1" -0.138 0.064 -1.422997 0 0 0 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"
$bonemerge "j_mag2"


$sequence "reference" {
	"attachment_vm_pi_mike_xmags_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\makarov\attachment_mag.qc"
//	}
}
