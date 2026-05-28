// Created by Crowbar 0.74

$modelname "viper/mw/attachments/ubgl/attachment_vm_ub_gpapa25.mdl"

$bodygroup "smgbarrel"
{
	studio "attachment_vm_ub_gpapa25_LOD0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\mw\weapons\akilo47\"
$cdmaterials "viper\MW\attachments\"

$attachment "muzzle_ubgl" "tag_flash_alt" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.005 -1.048 -2.936 14.056 2.701 2.833

$definebone "tag_grenade_launcher" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_barrel_hide" "tag_grenade_launcher" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_alt" "tag_grenade_launcher" 12.114 0 -0.802 0 0 0 0 0 0 0 0 0
$definebone "j_gpapa25_chamber" "tag_grenade_launcher" 9.619 0 -0.802 0 0 0 0 0 0 0 0 0
$definebone "j_gpapa25_grenade" "tag_grenade_launcher" 9.812 0 -0.802 0 0 0 0 0 0 0 0 0
$definebone "j_gpapa25_grenade_empty" "tag_grenade_launcher" 9.812 0 -0.802 0 0 0 0 0 0 0 0 0
$definebone "j_gpapa25_safety" "tag_grenade_launcher" 6.343 0.466 -0.384 0 0 0 0 0 0 0 0 0
$definebone "j_gpapa25_shelleject" "tag_grenade_launcher" 6.663 0.848 -0.863 0 0 0 0 0 0 0 0 0
$definebone "j_gpapa25_trigger" "tag_grenade_launcher" 4.198 0 -0.787 0 0 0 0 0 0 0 0 0
$definebone "j_gpapa25_ironsight_front" "tag_barrel_hide" 11.179 1.236 0.82 10.580983 29.512196 5.935385 0 0 0 0 0 0
$definebone "j_gpapa25_ironsight_rear" "tag_barrel_hide" 7.153 1.978 1.78 -12.115766 179.864863 0.014324 0 0 0 0 0 0
$definebone "j_gpapa25_sightknob" "tag_barrel_hide" 10.551 1.374 0.955 12.115765 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_ub_gpapa25_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\weapons\assault rifles\akilo47\meshes\attachments\attachment_vm_ub_gpapa25_LOD0.qc"
//	}
}
