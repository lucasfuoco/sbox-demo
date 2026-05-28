// Created by Crowbar 0.74

$modelname "attachment_vm_muzzlebrake01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_muzzlebrake01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox 0 -0.456 -0.456 2.73 0.456 0.456

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_muzzlebrake01_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
