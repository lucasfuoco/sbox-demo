// Created by Crowbar 0.74

$modelname "attachment_vm_laser_pstl.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser_pstl.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.071 -0.69 -1.729 2.793 0.698 0.291

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 1.052 0 -1.331 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser_pstl_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
