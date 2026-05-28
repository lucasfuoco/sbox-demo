// Created by Crowbar 0.74

$modelname "attachment_vm_4x_east.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_4x_east.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_4x_east_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -2.041 -1.045 -0.476 3.093 1.275 2.2

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_acog_2" -1.621 0.114 1.011 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_acog_2" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_4x_east_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
