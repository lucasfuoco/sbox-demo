// Created by Crowbar 0.74

$modelname "attachment_vm_reflex_west04.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_west04.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.104 -0.652 -0.214 2.129 0.719 1.909

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_reflex" 0.012 0 1.255 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_reflex" 0.012 0 1.255 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 0.012 0 1.255 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_west04_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
