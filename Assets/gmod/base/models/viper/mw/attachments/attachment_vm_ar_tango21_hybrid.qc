// Created by Crowbar 0.74

$modelname "attachment_vm_ar_tango21_hybrid.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_ar_tango21_hybrid.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_ar_tango21_hybrid_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.151 -1.373 -0.511 6.456 1.13 2.184

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_hybrid" -0.628 0.001 1.24 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_hybrid" -0.628 0.001 1.24 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_ar_tango21_hybrid_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
