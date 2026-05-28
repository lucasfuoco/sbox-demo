// Created by Crowbar 0.74

$modelname "attachment_vm_laser02.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.246 -1.022 -0.327 3.115 1.215 0.538

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 2.962 -0.654 -0.093 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser02_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
