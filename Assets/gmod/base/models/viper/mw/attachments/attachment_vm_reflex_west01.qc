// Created by Crowbar 0.74

$modelname "attachment_vm_reflex_west01.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_west01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.641 -0.967 -0.185 2.347 0.967 1.726

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 1.638997 0 0.914998 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_west01_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
