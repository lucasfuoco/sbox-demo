// Created by Crowbar 0.74

$modelname "attachment_vm_ar_tango21_hybrid_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_ar_tango21_hybrid_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.639 -0.577 0 2.969 0.579 1.818

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_hybrid" -0.628 0.001 1.24 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_ar_tango21_hybrid_hide_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
