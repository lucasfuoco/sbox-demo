// Created by Crowbar 0.74

$modelname "attachment_vm_stock_heavy.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_stock_heavy.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -8.59 -0.996 -4.056 0 1.002 0.823

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0

$bonemerge "tag_stock_attach"


$sequence "reference" {
	"attachment_vm_stock_heavy_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
