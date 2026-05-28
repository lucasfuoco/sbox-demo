// Created by Crowbar 0.74

$modelname "attachment_vm_minireddot_tall.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_minireddot_tall_2.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.25 -0.783 -0.414 3.042 0.849 1.71

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" 2.158 0.003 1.079 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_minireddot_tall_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
