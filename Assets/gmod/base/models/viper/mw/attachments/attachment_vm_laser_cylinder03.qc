// Created by Crowbar 0.74

$modelname "attachment_vm_laser_cylinder03.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser_cylinder03.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.847 -0.429 -0.441 1.166 0.58 0.402

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 1.106998 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser_cylinder03_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
