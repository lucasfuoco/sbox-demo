// Created by Crowbar 0.74

$modelname "attachment_vm_muzzlemelee02.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_muzzlemelee02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox 0 -0.461 -0.468 2.952 0.457 0.468

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_muzzlemelee02_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
