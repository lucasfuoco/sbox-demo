// Created by Crowbar 0.74

$modelname "attachment_vm_compensator01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_compensator01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox 0 -0.506 -0.508 2.065 0.506 0.507

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_compensator01_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
