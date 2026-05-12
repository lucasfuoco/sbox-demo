// Created by Crowbar 0.74

$modelname "attachment_vm_pi_cpapa_grip_stock.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_cpapa_grip_stock.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\357\"

$cbox 0 0 0 0 0 0

$bbox -10.657 -0.794 -4.281 2.081 0.798 0.263

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_cpapa_grip_stock_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
