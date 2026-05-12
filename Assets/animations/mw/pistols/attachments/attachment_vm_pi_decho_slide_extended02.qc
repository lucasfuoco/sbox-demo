// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_decho_slide_extended02.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_decho_slide_extended02.smd"
}
$bodygroup "sight"
{
	studio "attachment_vm_pi_decho_slide_extended02_sight_on.smd"
	blank
	blank
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\deagle\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -5.683 -0.858 -0.309 4.603 0.858 1.647

$definebone "tag_barrel_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_barrel_attach" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_barrel_attach" 4.589 0 0.881 0 0 0 0 0 0 0 0 0
$definebone "tag_silencer" "tag_barrel_attach" 4.597 0 0.881 0 0 0 0 0 0 0 0 0
$definebone "j_safety" "j_slide" -4.745 0 0.792 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on" "tag_barrel_attach" 3.016 0 1.43 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on2" "j_slide" -2.446 -0.025 1.124 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_decho_slide_extended02_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\deagle\attachment_barrel.qc"
//	}
}
