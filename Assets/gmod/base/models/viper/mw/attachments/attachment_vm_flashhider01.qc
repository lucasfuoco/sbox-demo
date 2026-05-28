// Created by Crowbar 0.74

$modelname "attachment_vm_flashhider01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_flashhider01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.004 -0.501 -0.5 2.752 0.501 0.502

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_flashhider01_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
