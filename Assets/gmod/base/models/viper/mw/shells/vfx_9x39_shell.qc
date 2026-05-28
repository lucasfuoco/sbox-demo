// Created by Crowbar 0.74

$modelname "vfx_9x39_shell.mdl"

$bodygroup "weapon"
{
	studio "vfx_9x39_shell.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MW\shells\9x39\"

$cbox 0 0 0 0 0 0

$bbox -0.61 -2.811 -0.67 0.61 1.149 0.67

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"vfx_9x39_shell_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
