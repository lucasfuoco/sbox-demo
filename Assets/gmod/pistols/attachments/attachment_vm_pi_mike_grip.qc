// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike_grip.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike_grip.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\makarov\"

$cbox 0 0 0 0 0 0

$bbox -11.031 -0.82 -1.967 0 0.795 2.068

$definebone "j_gun" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "j_gun" -9.662981 0 2.004996 0 0 0 0 0 0 0 0 0
$definebone "tag_pistolgrip_hide" "tag_pistol_offset" 0.193999 0 -2.057996 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike_grip_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\makarov\attachment_slide.qc"
//	}
}
