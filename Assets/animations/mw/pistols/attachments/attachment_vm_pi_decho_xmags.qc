// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_decho_xmags.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_decho_xmags.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\deagle\"

$cbox 0 0 0 0 0 0

$bbox -2.369 -0.65 -1.478 0.937 0.694 5.223

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -0.232 0 4.073992 9.996337 0 0 0 0 0 0 0 0
$definebone "j_bullet" "j_mag1" -0.015439 -0.004 0.773043 -14.999404 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -0.232 0 4.073992 9.996337 0 0 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"
$bonemerge "j_bullet"
$bonemerge "j_mag2"


$sequence "reference" {
	"attachment_vm_pi_decho_xmags_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$collisionmodel "attachment_vm_pi_decho_xmags_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\deagle\attachment_mag.qc"
//	}
}
