// Created by Crowbar 0.74

$modelname "viper/mw/weapons/w_glock.mdl"

$bodygroup "receiver"
{
	studio "w_glock.smd"
	blank
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\glock\"

$attachment "muzzle" "tag_pistol_offset" 5.55 0 1.05 rotate 0 0 0
$attachment "right_hand" "ValveBiped.Bip01_R_Hand" 0 0 0 rotate 0 0 0
$attachment "shell_eject" "tag_brass" 0 0 0 rotate -20 0 0
$attachment "reflex" "tag_reflex" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -11.536 -0.899 -2.508 0 0.868 2.815

$definebone "ValveBiped.Bip01_R_Hand" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "ValveBiped.Bip01_R_Hand" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "tag_pistol_offset" -0.6 0 1.6 0 0 0 0 0 0 0 0 0
$definebone "tag_barrel_attach" "tag_pistol_offset" 5.561 0 1.165 0 0 0 0 0 0 0 0 0
$definebone "tag_scope" "tag_barrel_attach" -6.771 0 0.396 0 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_pistol_offset" 1.771 -0.314 1.25 0 -89.999982 0 0 0 0 0 0 0
$definebone "tag_laser_attach" "tag_pistol_offset" 3.818 0 -0.014 0 0 0 0 0 0 0 0 0
$definebone "tag_mag_attach" "tag_pistol_offset" -0.47 0 -3.437 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_attach" "tag_pistol_offset" -2.238 0 -3.188 0 0 0 0 0 0 0 0 0
$definebone "j_trigger" "tag_stock_attach" 3.319 0 3.458 0 0 0 0 0 0 0 0 0
$definebone "tag_trigger_hide" "j_trigger" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_golf21_magrel" "tag_pistol_offset" 0.533 0.511 -0.841 0 0 0 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "tag_pistol_offset"
$bonemerge "tag_reflex"
$bonemerge "tag_barrel_attach"
$bonemerge "tag_scope"
$bonemerge "tag_mag_attach"
$bonemerge "tag_stock_attach"


$sequence "reference" {
	"w_glock_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_glock_physics.smd"
{
	$mass 1
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\weapons\pistols\glock\template\weapon_worldmodel.qc"
//	}
}
