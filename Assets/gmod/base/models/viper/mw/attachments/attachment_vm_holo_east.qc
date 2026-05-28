// Created by Crowbar 0.74

$modelname "attachment_vm_holo_east.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_holo_east.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_holo_east_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.742 -0.92 -0.505 3.198 1.072 2.033

$definebone "tag_holo" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_holo" -0.229174 -0.018014 1.101837 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_holo" -0.229174 -0.018014 1.101837 0 0 0 0 0 0 0 0 0

$bonemerge "tag_holo"
$bonemerge "tag_lense"


$sequence "reference" {
	"attachment_vm_holo_east_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
