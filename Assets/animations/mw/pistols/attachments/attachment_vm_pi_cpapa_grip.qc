// Created by Crowbar 0.74

$modelname "attachment_vm_pi_cpapa_grip.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_cpapa_grip.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\357\"

$cbox 0 0 0 0 0 0

$bbox -11.481 -0.675 -2.165 0 0.738 1.888

$definebone "j_gun" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "j_gun" -8.911982 0 1.392997 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_hide" "tag_pistol_offset" -0.965999 0 0.494999 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_cpapa_grip_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
