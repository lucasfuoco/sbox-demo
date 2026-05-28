// Created by Crowbar 0.74

$modelname "attachment_vm_laser03.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser03.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.138 -0.937 -0.256 2.811 0.937 0.407

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 2.628 0.474 0.125 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser03_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
