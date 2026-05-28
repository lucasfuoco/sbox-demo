// Created by Crowbar 0.74

$modelname "vfx_rifle_shell_LOD0.mdl"

$bodygroup "weapon"
{
	studio "vfx_rifle_shell_LOD0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MW\shells\rifle\"

$cbox 0 0 0 0 0 0

$bbox -1.156 -0.251 -0.251 1.156 0.251 0.251

$definebone "average5" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"vfx_rifle_shell_lod0_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
