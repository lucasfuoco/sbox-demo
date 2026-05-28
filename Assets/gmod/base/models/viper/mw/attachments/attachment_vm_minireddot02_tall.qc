// Created by Crowbar 0.74

$modelname "attachment_vm_minireddot02_tall.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_minireddot02_tall.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.245 -0.881 -0.453 3.043 0.849 1.704

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 2.003 0 1.078 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_minireddot02_tall_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
