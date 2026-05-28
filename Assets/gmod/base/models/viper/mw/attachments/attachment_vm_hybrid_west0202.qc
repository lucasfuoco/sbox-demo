// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_hybrid_west0202.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_hybrid_west02.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_hybrid_west02_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0
$attachment "reticle2" "tag_reticle_attach2" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.43 -1.329 -0.694 6.309 1.432 2.529

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_hybrid_scope" "tag_hybrid" 1.086 -0.661 -0.149 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "j_hybrid_scope" -2.112 0.642 1.495 0 0 0 0 0 0 0 0 0
$definebone "j_magnifier_lever" "tag_hybrid" 1.067 0.589 0.076 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_hybrid" 0 -0.019 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_hybrid" 0 -0.019 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach2" "tag_hybrid" 3.3 -0.019 1.346 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_hybrid_west0202_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
