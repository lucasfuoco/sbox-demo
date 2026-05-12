// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_golf21_slide_v3.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_golf21_slide_v3.smd"
}
$bodygroup "tag_tip"
{
	studio "attachment_vm_pi_golf21_slide_v3_tip.smd"
	blank
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\glock\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -7.783 -0.79 -1.092 1.605 0.722 0.934

$definebone "tag_barrel_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_barrel" "tag_barrel_attach" -1.912 0.003 0.278 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_barrel_attach" -3.83 0.003 0.015 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "j_barrel" 3.299 -0.003 -0.278 0 0 0 0 0 0 0 0 0
$definebone "tag_silencer" "j_barrel" 2.88 -0.003 -0.282 0 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "j_slide" -2.941 -0.003 0.381 0 0 0 0 0 0 0 0 0
$definebone "tag_tip" "j_barrel" 0 0 0 0 0 0 0 0 0 0 0 0

$bonemerge "tag_barrel_attach"
$bonemerge "j_barrel"
$bonemerge "j_slide"
$bonemerge "tag_reflex"


$sequence "reference" {
	"attachment_vm_pi_golf21_slide_v3_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\glock\attachment_slide.qc"
//	}
}
