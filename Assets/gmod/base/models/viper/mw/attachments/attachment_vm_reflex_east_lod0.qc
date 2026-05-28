// Created by Crowbar 0.74

$modelname "attachment_vm_reflex_east_LOD0.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_east.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.36 -1.021 -0.508 4.124 1.132 2.046

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 3.687 0 1.262 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_east_lod0_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
