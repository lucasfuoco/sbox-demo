// Created by Crowbar 0.74

$modelname "vfx_sgcaldb_shell.mdl"

$bodygroup "weapon"
{
	studio "vfx_sgcaldb_shell.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\MW\shells\shotgun\"

$cbox 0 0 0 0 0 0

$bbox -1.115 -3.574 -1.115 1.115 3.574 1.115

$definebone "tag_origin" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"vfx_sgcaldb_shell_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}
