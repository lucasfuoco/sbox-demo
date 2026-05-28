// Created by Crowbar 0.74

$modelname "attachment_vm_reflex_east02_LOD0.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_east02_LOD0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.094 -1.033 -0.502 3.559 1.421 1.994

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_reflex" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 2.75 0 0.944 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_east02_lod0_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
