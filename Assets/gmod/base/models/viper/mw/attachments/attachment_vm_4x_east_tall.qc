// Created by Crowbar 0.74

$modelname "attachment_vm_4x_east_tall.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_4x_east_tall.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_4x_east_tall_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.943 -1.045 -0.473 3.19 1.281 2.64

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_acog_2" -1.47 0.114 1.438 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_acog_2" -1.47 0.114 1.438 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_4x_east_tall_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
