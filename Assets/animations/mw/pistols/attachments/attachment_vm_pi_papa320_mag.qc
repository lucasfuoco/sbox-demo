// Created by Crowbar 0.74

$modelname "attachment_vm_pi_papa320_mag.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_papa320_mag.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\p320\"

$cbox 0 0 0 0 0 0

$bbox -1.551 -0.833 -0.178 0.597 0.857 4.803

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -0.279999 0 2.917994 0 0 0 0 0 0 0 0 0
$definebone "j_bullet_01" "j_mag1" 0.213999 -0.019 1.450997 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_bullet_02" "j_mag1" 0.16 -0.132 1.122998 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_bullet_03" "j_mag1" 0.149999 0.079 0.834998 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_bullet_04" "j_mag1" 0.13 -0.146 0.547999 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_mag_pusher" "j_mag1" 0.123 -0.015 0.884998 0 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -0.279999 0 2.917994 0 0 0 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"
$bonemerge "j_mag2"


$sequence "reference" {
	"attachment_vm_pi_papa320_mag_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\p320\attachment_mag.qc"
//	}
}
