// Created by Crowbar 0.74

$modelname "attachment_vm_pi_cpapa_stockl.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_cpapa_stockl.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\357\"

$cbox 0 0 0 0 0 0

$bbox -10.482 -0.64 -4.456 1.897 0.78 0.236

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_cpapa_stockl_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
