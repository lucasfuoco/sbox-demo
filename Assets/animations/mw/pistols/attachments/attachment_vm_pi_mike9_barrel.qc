// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_mike9_barrel.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_pi_mike9_barrel.smd"
}
$bodygroup "sight"
{
	studio "attachment_vm_pi_mike9_barrel_sight_on.smd"
	blank
	blank
}
$bodygroup "tip"
{
	studio "attachment_vm_pi_mike9_barrel_tip.smd"
	blank
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m9\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.716 -0.782 -0.763 6.748 0.782 1.124

$definebone "tag_barrel_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_barrel_attach" 2.302999 0 0.188 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_barrel_attach" 6.748 0 0.546 0 0 0 0 0 0 0 0 0
$definebone "tag_silencer" "tag_barrel_attach" 6.33 0 0.537 0 0 0 0 0 0 0 0 0
$definebone "tag_tip" "tag_barrel_attach" 6.33 0 0.537 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike9_barrel_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$collisionmodel "attachment_vm_pi_mike9_barrel_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\m9\attachment_slide.qc"
//	}
}
