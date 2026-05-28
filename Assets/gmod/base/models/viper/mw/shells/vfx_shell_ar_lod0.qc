// Created by Crowbar 0.74

$modelname "vfx_shell_ar_LOD0.mdl"

$bodygroup "weapon"
{
	studio "vfx_shell_ar_LOD0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MW\shells\ar\"

$cbox 0 0 0 0 0 0

$bbox -1.003 -0.198 -0.198 1.003 0.198 0.198

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"vfx_shell_ar_lod0_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
