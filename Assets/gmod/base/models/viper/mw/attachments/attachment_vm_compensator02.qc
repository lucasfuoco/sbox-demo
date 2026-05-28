// Created by Crowbar 0.74

$modelname "attachment_vm_compensator02.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_compensator02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox 0 -0.519 -0.519 2.166 0.519 0.519

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_compensator02_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
