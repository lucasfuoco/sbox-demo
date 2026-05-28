// Created by Crowbar 0.74

$modelname "attachment_vm_flashhider02.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_flashhider02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.003 -0.55 -0.549 2.756 0.549 0.549

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_flashhider02_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
