// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_golf21_slide_black.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_golf21_slide_black.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\glock\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -7.558 -0.495 -0.855 0.074 0.497 0.645

$definebone "tag_barrel_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_barrel" "tag_barrel_attach" -1.911996 0.003 0.277999 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "j_barrel" 1.946996 -0.003 -0.277999 0 0 0 0 0 0 0 0 0
$definebone "tag_silencer" "j_barrel" 1.946996 -0.003 -0.281999 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_barrel_attach" -3.829992 0.003 0.015 0 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "j_slide" -2.940994 -0.003 0.380999 0 0 0 0 0 0 0 0 0

$bonemerge "tag_barrel_attach"
$bonemerge "j_barrel"
$bonemerge "j_slide"
$bonemerge "tag_reflex"


$sequence "reference" {
	"attachment_vm_pi_golf21_slide_black_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$collisionmodel "attachment_vm_pi_golf21_slide_black_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\glock\attachment_slide.qc"
//	}
}
