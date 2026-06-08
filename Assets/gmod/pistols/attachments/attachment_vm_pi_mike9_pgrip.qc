// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike9_pgrip.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike9_pgrip.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m9\"

$cbox 0 0 0 0 0 0

$bbox -10.705 -0.808 -2.074 0 0.955 2.423

$definebone "j_gun" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "j_gun" -9.10498 0 1.345997 0 0 0 0 0 0 0 0 0
$definebone "tag_pistolgrip_hide" "tag_pistol_offset" -0.126 0 -1.241997 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike9_pgrip_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\m9\attachment_pgrip.qc"
//	}
}
