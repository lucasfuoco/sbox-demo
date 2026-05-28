// Created by Crowbar 0.74

$modelname "attachment_vm_4x_west_tall_lens_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_4x_west_tall_lens_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.993 -0.555 0 0 0.547 2.092

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_acog_2" -0.909 -0.008 1.541 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_4x_west_tall_lens_hide_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
