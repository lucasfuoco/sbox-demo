// Created by Crowbar 0.74

$modelname "attachment_vm_laser_pstl03.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser_pstl03.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.069 -0.658 -0.896 1.544 0.65 0.253

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 1.508 -0.171 -0.234 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser_pstl03_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
