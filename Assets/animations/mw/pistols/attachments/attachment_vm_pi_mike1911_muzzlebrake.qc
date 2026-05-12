// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike1911_muzzlebrake.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike1911_muzzlebrake_lod0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m1911\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -0.043 -0.393 -0.9 1.712 0.393 0.439

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike1911_muzzlebrake_anims\reference.smd"
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
//		"value" "c:\_conv\cod_mw\modernmodellingwarfarex.0.0.4.0\exported_files\xmodels\attachment_vm_pi_mike1911_muzzlebrake\attachment.qc"
//	}
}
