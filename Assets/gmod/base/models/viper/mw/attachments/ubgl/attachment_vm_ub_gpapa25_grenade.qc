// Created by Crowbar 0.74

$modelname "viper/mw/attachments/ubgl/attachment_vm_ub_gpapa25_grenade.mdl"

$bodygroup "smgbarrel"
{
	studio "attachment_vm_ub_gpapa25_grenade.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\mw\weapons\akilo47\"
$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox 0 -1.04 -1.842 12.358 1.04 0.238

$definebone "tag_grenade_launcher" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_gpapa25_grenade" "tag_grenade_launcher" 9.812 0 -0.802 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_ub_gpapa25_grenade_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$collisionmodel "attachment_vm_ub_gpapa25_grenade_physics.smd"
{
	$mass 1
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\weapons\assault rifles\akilo47\meshes\attachments\attachment_vm_ub_gpapa25_grenade.qc"
//	}
}
