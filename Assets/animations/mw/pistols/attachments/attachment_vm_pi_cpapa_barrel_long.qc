// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_cpapa_barrel_long.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_cpapa_barrel_long.smd"
}
$bodygroup "laser"
{
	blank
	studio "attachment_vm_pi_cpapa_barrel_long_laser.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\357\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0
$attachment "laser" "tag_laser_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.038 -0.503 -0.912 6.169 0.55 0.999

$definebone "tag_barrel_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_barrel_attach" 5.934 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser_attach" "tag_barrel_attach" 4.378999 0 -0.9 0 0 0 0 0 0 0 0 0
$definebone "tag_silencer" "tag_barrel_attach" 5.934 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser_show" "tag_barrel_attach" 4.378999 0 -0.9 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_cpapa_barrel_long_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$collisionmodel "attachment_vm_pi_cpapa_barrel_long_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\357\attachment_slide.qc"
//	}
}
