// Created by Crowbar 0.74

$modelname "attachment_vm_pi_papa320_mag_ext2.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_papa320_mag_ext2.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\p320\"

$cbox 0 0 0 0 0 0

$bbox -2.103 -0.882 -1.812 0.778 0.882 4.777

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -0.279999 0 2.917994 0 0 0 0 0 0 0 0 0
$definebone "j_bullet_01" "j_mag1" 0.213999 -0.019 1.450997 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_bullet_02" "j_mag1" 0.16 -0.132 1.122998 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_bullet_04" "j_mag1" 0.13 -0.146 0.547999 0 179.999978 89.999982 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -0.279999 0 2.917994 0 0 0 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"
$bonemerge "j_mag2"


$sequence "reference" {
	"attachment_vm_pi_papa320_mag_ext2_anims\reference.smd"
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
