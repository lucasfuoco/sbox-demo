// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_hybrid_west02_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_hybrid_west02_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -1.03 -0.661 -0.149 1.086 0.502 1.868

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_hybrid_scope" "tag_hybrid" 1.086 -0.661 -0.149 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_hybrid_west02_hide_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
