// Created by Crowbar 0.74

$modelname "viper/mw/weapons/w_m9.mdl"

$bodygroup "receiver"
{
	studio "w_m9.smd"
	blank
}
$bodygroup "rail"
{
	blank
	studio "attachment_vm_pi_mike9_rail.smd"
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m9\"

$attachment "muzzle" "tag_pistol_offset" 5.55 0 1.05 rotate 0 0 0
$attachment "right_hand" "ValveBiped.Bip01_R_Hand" 0 0 0 rotate 0 0 0
$attachment "shell_eject" "tag_brass" 0 0 0 rotate -20 0 0
$attachment "reflex" "tag_reflex" 0 0 0 rotate 0 0 0
$attachment "scope" "tag_scope" 0 0 0 rotate 0 0 0
$attachment "acog" "tag_acog_2" 0 0 0 rotate 0 0 0
$attachment "holo" "tag_holo" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.928 -2.113 -11.042 1.027 3.722 0

$definebone "ValveBiped.Bip01_R_Hand" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "ValveBiped.Bip01_R_Hand" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_holo" "tag_pistol_offset" 1.572996 0 2.342995 0.000001 -0.000008 -0.000001 0 0 0 0 0 0
$definebone "tag_acog_2" "tag_pistol_offset" 1.201996 0 2.375994 0.000001 -0.000008 -0.000001 0 0 0 0 0 0
$definebone "j_hammer" "tag_pistol_offset" -0.576 -0.004 0.701999 0 0 0 0 0 0 0 0 0
$definebone "tag_barrel_attach" "tag_pistol_offset" 0.414998 0 0.937998 0 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_pistol_offset" 1.086997 -0.554999 1.709997 0 -89.997632 0 0 0 0 0 0 0
$definebone "tag_folding_grip" "tag_pistol_offset" 4.65499 0 0.242 0 0 0 0 0 0 0 0 0
$definebone "tag_laser_attach" "tag_pistol_offset" 4.36799 0 0.177 0 0 0 0 0 0 0 0 0
$definebone "tag_mag_attach" "tag_pistol_offset" 0.537998 0 -3.214993 0 0 0 0 0 0 0 0 0
$definebone "tag_pistolgrip_attach" "tag_pistol_offset" -0.126001 0 -1.241997 0 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "tag_pistol_offset" 1.572996 0 2.342995 0 0 0 0 0 0 0 0 0
$definebone "tag_scope" "tag_pistol_offset" 1.201997 0 2.375995 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_attach" "tag_pistol_offset" -1.451998 0 -3.396993 0 0 0 0 0 0 0 0 0
$definebone "j_trigger" "tag_stock_attach" 3.501993 0.017 3.580993 0 0 0 0 0 0 0 0 0
$definebone "tag_trigger_hide" "j_trigger" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_magrelease" "tag_pistol_offset" 0.745997 0.09 -0.642999 0 0 0 0 0 0 0 0 0
$definebone "j_safety" "tag_pistol_offset" -0.716001 0.604999 0.624999 0 0 0 0 0 0 0 0 0
$definebone "j_slidestop" "tag_pistol_offset" 2.751994 0.107 0.669999 0 0 0 0 0 0 0 0 0
$definebone "j_gun" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_rail" "tag_pistol_offset" 3.184993 0 1.365997 0 0 0 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "tag_pistol_offset"
$bonemerge "tag_barrel_attach"
$bonemerge "tag_folding_grip"
$bonemerge "tag_laser_attach"
$bonemerge "tag_mag_attach"
$bonemerge "tag_pistolgrip_attach"
$bonemerge "tag_reflex"
$bonemerge "tag_scope"
$bonemerge "tag_stock_attach"


$sequence "reference" {
	"w_m9_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_m9_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\weapons\pistols\m9\template\weapon_worldmodel.qc"
//	}
}
