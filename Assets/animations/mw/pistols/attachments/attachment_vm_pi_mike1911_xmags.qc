// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike1911_xmags.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike1911_xmags_lod0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m1911\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -4.6 -0.769 -5.954 0 0.691 1.775

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -1.606997 0 0.564999 18.000625 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -1.606997 0 0.564999 18.000625 0 0 0 0 0 0 0 0
$definebone "j_bullet" "tag_mag_attach" -1.532997 0 1.130998 -0.000868 89.997564 -15.038156 0 0 0 0 0 0
$definebone "j_bullet2" "tag_mag_attach" -1.532997 0 1.130998 -0.000868 89.997564 -15.038156 0 0 0 0 0 0
$definebone "j_bullet_grp2" "tag_mag_attach" -1.592997 0 0.615999 0 0 0 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"
$bonemerge "j_mag2"
$bonemerge "j_bullet"


$sequence "reference" {
	"attachment_vm_pi_mike1911_xmags_anims\reference.smd"
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
//		"value" "c:\_conv\cod_mw\modernmodellingwarfarex.0.0.4.0\exported_files\xmodels\attachment_vm_pi_mike1911_xmags\attachment_mag.qc"
//	}
}
