// Created by Crowbar 0.74

$modelname "attachment_vm_holo_west_LOD0.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_holo_west_LOD0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.468 -1.328 -0.584 3.496 1.433 2.266

$definebone "tag_holo" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_holo" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_holo" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_holo" 0.515 0 1.317 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_holo_west_lod0_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
