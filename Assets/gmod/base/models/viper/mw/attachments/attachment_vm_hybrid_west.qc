// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_hybrid_west.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_hybrid_west.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_hybrid_west_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0
$attachment "reticle2" "tag_reticle_attach2" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.843 -1.077 -0.486 3.589 1.362 3.074

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_hybrid" -1.15 0 1.075 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach2" "tag_hybrid" 2.289 0 2.309 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_hybrid_west_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
