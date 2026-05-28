// Created by Crowbar 0.74

$modelname "attachment_vm_reflex_west03.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_west03.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.391 -0.809 -0.213 2.102 0.727 1.913

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 1.639 0 1.341 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_west03_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
