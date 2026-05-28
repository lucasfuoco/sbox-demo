// Created by Crowbar 0.74

$modelname "attachment_vm_laser_cylinder01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser_cylinder01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.845 -0.678 -0.509 1.93 0.374 0.682

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 1.900996 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser_cylinder01_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
