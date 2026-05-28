// Created by Crowbar 0.74

$modelname "attachment_vm_4x_west02_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_4x_west02_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -1.331 -0.607 0 0 0.593 1.601

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_acog_2" -1.208 -0.005 1.003 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_4x_west02_hide_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
