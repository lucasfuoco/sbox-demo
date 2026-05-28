// Created by Crowbar 0.74

$modelname "attachment_vm_holo_east_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_holo_east_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.229 -0.462 0 0 0.427 1.546

$definebone "tag_holo" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_holo" -0.229174 -0.018014 1.101837 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_holo_east_hide_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
