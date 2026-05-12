// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_mike9_xmagslrg.mdl"

$bodygroup "body"
{
	studio "attachment_vm_pi_mike9_xmagslrg_lod0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\mw\weapons\m9\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -2.756 -0.625 -3.279 0.907 0.625 4.512

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -0.537998 0 2.586995 0 0 0 0 0 0 0 0 0
$definebone "j_bullet1" "j_mag1" 0.874998 0 1.718997 0 0 0 0 0 0 0 0 0
$definebone "j_follower" "j_mag1" 0.732998 -0.003 1.416997 0 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -0.537998 0 2.586995 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"attachment_vm_pi_mike9_xmagslrg_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\_conv\cod_mw\modernmodellingwarfare\exported_files\xmodels\attachment_vm_pi_mike9_xmagslrg\attachment_vm_pi_mike9_xmagslrg_lod0.qc"
//	}
}
