// Created by Crowbar 0.74

$modelname "attachment_vm_reflex_east02_tall.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_east02_tall.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.761 -0.79 -0.22 3.43 1.216 2.191

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 2.871 0 1.401 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_east02_tall_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
