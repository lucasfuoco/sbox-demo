// Created by Crowbar 0.74

$modelname "attachment_vm_minireddot03_mike1911.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_minireddot03_mike1911.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.165 -0.646 -0.383 2.045 0.751 1.358

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 1.552 0.002 0.695 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_minireddot03_mike1911_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
