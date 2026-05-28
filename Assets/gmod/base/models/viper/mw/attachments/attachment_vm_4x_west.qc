// Created by Crowbar 0.74

$modelname "attachment_vm_4x_west.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_4x_west.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_4x_west_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.953 -1.162 -0.433 4.29 1.347 2.136

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_acog_2" -0.524 0.001 1.114 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_acog_2" -0.524 0.001 1.114 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_4x_west_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
