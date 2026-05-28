// Created by Crowbar 0.74

$modelname "attachment_vm_4x_west02.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_4x_west02.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_4x_west02_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.572 -1.295 -0.503 3.532 1.26 2.174

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_acog_2" -1.208 -0.005 1.003 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_acog_2" -1.208 -0.005 1.003 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_4x_west02_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
