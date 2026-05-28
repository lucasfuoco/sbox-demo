// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike_stockl.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike_stockl.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\makarov\"

$cbox 0 0 0 0 0 0

$bbox -10.788 -0.836 -0.935 0.385 0.717 3.632

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike_stockl_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
