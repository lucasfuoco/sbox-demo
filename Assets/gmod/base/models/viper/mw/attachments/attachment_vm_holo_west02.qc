// Created by Crowbar 0.74

$modelname "attachment_vm_holo_west02.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_holo_west02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.188 -1.035 -0.277 2.999 1.163 1.871

$definebone "tag_holo" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_holo" 0.706 0.003 1.22 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_holo_west02_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
