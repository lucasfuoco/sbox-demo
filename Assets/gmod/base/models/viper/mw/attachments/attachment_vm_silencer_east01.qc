// Created by Crowbar 0.74

$modelname "attachment_vm_silencer_east01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_silencer_east01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment_silenced" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.016 -1.101 -1.027 8.177 1.024 1.025

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment_silenced" "tag_silencer" 8.177 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_silencer_east01_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
