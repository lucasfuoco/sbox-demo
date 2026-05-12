// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_mike1911_v2_slide.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_pi_mike1911_v2_slide.smd"
}
$bodygroup "tip"
{
	studio "attachment_vm_pi_mike1911_v2_slide_tip.smd"
	blank
}
$bodygroup "sight"
{
	studio "attachment_vm_pi_mike1911_v2_slide_sight_on.smd"
	blank
	blank
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m1911\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -3.941 -0.748 -1.029 4.527 0.731 1.189

$definebone "tag_rail_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_rail_attach" 0 -0.001 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_rail_attach" 4.28 0 0.133 0 0 0 0 0 0 0 0 0
$definebone "tag_silencer" "tag_rail_attach" 3.708 0 0.135 0 0 0 0 0 0 0 0 0
$definebone "tag_tip" "tag_rail_attach" 4.051 0 0.133 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on" "j_slide" -3.252 0 0.54 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike1911_v2_slide_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$collisionmodel "attachment_vm_pi_mike1911_v2_slide_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\m1911\attachment_slide.qc"
//	}
}
