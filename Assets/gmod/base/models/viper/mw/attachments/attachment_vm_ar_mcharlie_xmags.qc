// Created by Crowbar 0.74

$modelname "attachment_vm_ar_mcharlie_xmags.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_ar_mcharlie_xmags.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\mcharlie\"

$cbox 0 0 0 0 0 0

$bbox -22.857 -0.706 -5.121 0.772 0.706 2.445

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_loose_round" "tag_mag_attach" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -1.323 0 0.184 0 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -1.323 0 0.184 0 0 0 0 0 0 0 0 0
$definebone "j_loose_bullet" "j_loose_round" -22.857 -0.07 2.287 0 0 0 0 0 0 0 0 0
$definebone "j_bullet_01" "j_mag1" 0 -0.127 1.693 0 0 0 0 0 0 0 0 0
$definebone "j_bullet_02" "j_mag1" 0 0.121 1.531 0 0 0 0 0 0 0 0 0
$definebone "j_bullet_03" "j_mag1" 0.007 -0.127 1.363 0 0 0 0 0 0 0 0 0
$definebone "j_bullet_04" "j_mag1" 0.008 0.119 1.202 0 0 0 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"
$bonemerge "j_mag2"


$sequence "reference" {
	"attachment_vm_ar_mcharlie_xmags_anims\reference.smd"
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
//		"value" "g:\other\gmod\source-files-mw\attachments\mcharlie\attachment_mag.qc"
//	}
}
