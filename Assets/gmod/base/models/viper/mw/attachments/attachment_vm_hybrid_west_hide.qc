// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_hybrid_west_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_hybrid_west_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -1.115 -0.629 0 0 0.631 1.709

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_hybrid_west_hide_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
