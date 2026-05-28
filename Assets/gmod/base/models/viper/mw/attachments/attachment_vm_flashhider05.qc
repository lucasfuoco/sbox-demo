// Created by Crowbar 0.74

$modelname "attachment_vm_flashhider05.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_flashhider05.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.004 -0.546 -0.585 3.48 0.546 0.582

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_flashhider05_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
