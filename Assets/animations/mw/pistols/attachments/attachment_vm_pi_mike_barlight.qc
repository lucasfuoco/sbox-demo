// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_mike_barlight.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_pi_mike_barlight.smd"
}
$bodygroup "sight"
{
	studio "attachment_vm_pi_mike_barlight_sight_on.smd"
	blank
	blank
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\makarov\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -2.036 -0.492 -4.326 4.326 0.65 0.813

$definebone "tag_barrel_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_barrel_attach" 1.108 0 0.153 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_barrel_attach" 4.326 0 0.136 0 0 0 0 0 0 0 0 0
$definebone "tag_silencer" "tag_barrel_attach" 4.304 0 0.13 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on" "j_slide" 0.283 0 0.66 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike_barlight_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\makarov\attachment_slide.qc"
//	}
}
