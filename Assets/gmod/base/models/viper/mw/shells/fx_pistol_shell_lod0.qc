// Created by Crowbar 0.74

$modelname "fx_pistol_shell_LOD0.mdl"

$bodygroup "weapon"
{
	studio "fx_pistol_shell_LOD0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MW\shells\pistol\"

$cbox 0 0 0 0 0 0

$bbox -0.433 -0.203 -0.203 0.433 0.203 0.203

$definebone "pcylinder5" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"fx_pistol_shell_lod0_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
