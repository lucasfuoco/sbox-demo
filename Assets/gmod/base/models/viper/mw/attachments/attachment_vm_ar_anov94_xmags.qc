// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_ar_anov94_xmags.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_ar_anov94_xmags.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\anovember94\"

$cbox 0 0 0 0 0 0

$bbox -9.377 -3.07 -8.352 0 0.486 1.547

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -7.903 -0.295 0.602 0 0 -13.998964 0 0 0 0 0 0
$definebone "j_bullet01" "j_mag1" 0.057001 0.157245 0.510197 0 0 0.000114 0 0 0 0 0 0
$definebone "j_bullet02" "j_mag1" 0.063001 -0.177576 0.319533 0 0 0 0 0 0 0 0 0
$definebone "j_bullet03" "j_mag1" 0.065001 0.153365 0.128932 0 0 0 0 0 0 0 0 0
$definebone "j_bullet04" "j_mag1" 0.076001 -0.178546 -0.061006 0 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -7.903 -0.295 0.602 0 0 -13.998964 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"
$bonemerge "j_mag2"


$sequence "reference" {
	"attachment_vm_ar_anov94_xmags_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\assault rifles\anovember94\attachment_mag.qc"
//	}
}
