// Created by Crowbar 0.74

$modelname "attachment_vm_silencer04.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_silencer04.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment_silenced" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.161 -0.896 -0.806 6.629 0.806 0.9

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment_silenced" "tag_silencer" 6.447 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_silencer04_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
