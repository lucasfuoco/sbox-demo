// Created by Crowbar 0.74

$modelname "weapon_vm_scope_mike14_alt.mdl"

$bodygroup "optic"
{
	studio "weapon_vm_scope_mike14_alt.smd"
}
$bodygroup "lens"
{
	blank
	studio "weapon_vm_scope_mike14_alt_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -4.106 -1.601 -0.514 6.146 1.762 2.918

$definebone "tag_scope" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_scope" -0.463 0 1.314 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_scope" -3.618 -0.002 1.316 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"weapon_vm_scope_mike14_alt_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
