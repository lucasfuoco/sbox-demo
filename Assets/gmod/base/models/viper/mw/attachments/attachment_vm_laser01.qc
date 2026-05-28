// Created by Crowbar 0.74

$modelname "attachment_vm_laser01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.205 -1.042 -0.235 3.038 0.952 0.52

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 2.999 0.669 0.111 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser01_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
