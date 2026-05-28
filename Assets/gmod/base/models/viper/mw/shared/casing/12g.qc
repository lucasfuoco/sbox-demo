// Created by Crowbar 0.74

$modelname "viper/mw/shared/casing/12g.mdl"

$bodygroup "Bullet"
{
	studio "12-Gauge_Shell_SpentLOD0.smd"
}

$lod 3
{
	replacemodel "12-Gauge_Shell_SpentLOD0.smd" "12-Gauge_Shell_SpentLOD0_lod1.smd"
	nofacial
}
$lod 8
{
	replacemodel "12-Gauge_Shell_SpentLOD0.smd" "12-Gauge_Shell_SpentLOD0_lod2.smd"
	nofacial
}

$surfaceprop "metal"

$contents "solid"

$illumposition 0.199 0 0

$forcephonemecrossfade

$ambientboost

$mostlyopaque

$cdmaterials "viper\mw\newshells\12g\"

$cbox 0 0 0 0 0 0

$bbox -0.448 -1.192 -0.448 0.448 1.591 0.448

$definebone "root" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "Ref" {
	"12g_anims\Ref.smd"
	fadein 0.2
	fadeout 0.2
	fps 0.01
}
