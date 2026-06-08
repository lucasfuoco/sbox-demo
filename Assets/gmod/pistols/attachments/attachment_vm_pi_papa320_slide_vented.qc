// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_papa320_slide_vented.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_pi_papa320_slide_vented.smd"
}
$bodygroup "sight"
{
	studio "attachment_vm_pi_papa320_slide_vented_sight_on.smd"
	blank
	blank
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\p320\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -7.539 -0.78 -1.374 0.27 0.725 0.551

$definebone "tag_barrel_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_barrel" "tag_barrel_attach" -3.182 -0.021 -0.127 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_barrel_attach" -3.395 0 -0.111 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "j_barrel" 3.312 0.021 0 0 0 0 0 0 0 0 0 0
$definebone "tag_silencer" "j_barrel" 3.21 0.021 0 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on" "j_slide" -0.141 0 0.514 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_papa320_slide_vented_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$collisionmodel "attachment_vm_pi_papa320_slide_vented_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\p320\attachment_slide.qc"
//	}
}
