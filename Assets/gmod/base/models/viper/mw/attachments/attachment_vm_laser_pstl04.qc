// Created by Crowbar 0.74

$modelname "attachment_vm_laser_pstl04.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser_pstl04.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.959 -0.637 -1.376 0.85 0.637 0.29

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 0.817 -0.326 -0.423 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser_pstl04_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
