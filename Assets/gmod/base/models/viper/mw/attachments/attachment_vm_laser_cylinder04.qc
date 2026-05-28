// Created by Crowbar 0.74

$modelname "attachment_vm_laser_cylinder04.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser_cylinder04.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.565 -0.587 -0.574 1.343 0.557 0.591

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 1.304997 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser_cylinder04_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
