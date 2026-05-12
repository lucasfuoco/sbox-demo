// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_golf21_mag_xmags2.mdl"

$bodygroup "body"
{
	studio "attachment_vm_pi_golf21_mag_xmags2_lod0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\mw\weapons\glock\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -2.811 -0.695 -4.226 1.465 0.695 4.818

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -0.024 0 3.199993 17.487067 0 0 0 0 0 0 0 0
$definebone "j_bullet" "j_mag1" -0.056004 0 1.166067 -21.913851 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -0.024 0 3.199993 17.487067 0 0 0 0 0 0 0 0


$sequence "idle" {
	"attachment_vm_pi_golf21_mag_xmags2_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\_conv\cod_mw\modernmodellingwarfare\exported_files\xmodels\attachment_vm_pi_golf21_mag_xmags2\attachment_vm_pi_golf21_mag_xmags2_lod0.qc"
//	}
}
