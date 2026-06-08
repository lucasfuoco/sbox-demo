// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike9_mag.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike9_mag.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m9\"

$cbox 0 0 0 0 0 0

$bbox -2.049 -0.765 -0.58 1.046 0.762 4.709

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -0.537998 0 2.586995 0 0 0 0 0 0 0 0 0
$definebone "j_bullet1" "j_mag1" 0.874998 0 1.718997 0 0 0 0 0 0 0 0 0
$definebone "j_follower" "j_mag1" 0.732999 -0.003 1.416997 0 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -0.537998 0 2.586995 0 0 0 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"
$bonemerge "j_mag2"


$sequence "reference" {
	"attachment_vm_pi_mike9_mag_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\m9\attachment_mag.qc"
//	}
}
