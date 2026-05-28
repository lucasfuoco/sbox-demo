// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_hybrid_west03.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_hybrid_west03.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_hybrid_west03_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0
$attachment "reticle2" "tag_reticle_attach2" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.568 -2.379 -0.914 3.525 1.259 2.2

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_hybrid" -1.203 -0.005 1.014 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach2" "tag_hybrid" 1.311 -1.575 0.205 0 0 44.998444 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_hybrid_west03_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
