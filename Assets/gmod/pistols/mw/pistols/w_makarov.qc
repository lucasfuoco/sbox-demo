// Created by Crowbar 0.74

$modelname "viper/mw/weapons/w_makarov.mdl"

$bodygroup "worldmodel"
{
	studio "w_makarov.smd"
}
$bodygroup "tag_laser"
{
	blank
	studio "attachment_vm_pi_mike_laserrail.smd"
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\makarov\"

$attachment "muzzle" "tag_pistol_offset" 5.55 0 1.05 rotate 0 0 0
$attachment "right_hand" "ValveBiped.Bip01_R_Hand" 0 0 0 rotate 0 0 0
$attachment "shell_eject" "tag_brass" 0 0 0 rotate -20 0 0
$attachment "reflex" "tag_reflex" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.205 -1.887 -2.081 0.142 3.619 4.863

$definebone "ValveBiped.Bip01_R_Hand" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "ValveBiped.Bip01_R_Hand" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_hammer" "tag_pistol_offset" -0.348999 0 0.342999 0 0 0 0 0 0 0 0 0
$definebone "j_trigger" "tag_pistol_offset" 2.394995 0 0.034 0 0 0 0 0 0 0 0 0
$definebone "tag_barrel_attach" "tag_pistol_offset" 1.148998 0 0.626999 0 0 0 0 0 0 0 0 0
$definebone "j_slide" "tag_barrel_attach" 1.107998 0 0.153 0 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "j_slide" -2.457995 0 0.45 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on" "j_slide" 0.283 0 0.659998 0 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_pistol_offset" 1.511997 -0.417999 1.094998 0 -89.997632 0 0 0 0 0 0 0
$definebone "tag_laser_show" "tag_pistol_offset" 4.229991 0 0.042 0 0 0 0 0 0 0 0 0
$definebone "tag_laser_attach" "tag_laser_show" 0.24 0 -0.662999 0 0 0 0 0 0 0 0 0
$definebone "tag_mag_attach" "tag_pistol_offset" 1.060998 0 -3.633993 0 0 0 0 0 0 0 0 0
$definebone "tag_pistolgrip_attach" "tag_pistol_offset" 0.194 0 -2.057996 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_attach" "tag_pistol_offset" -0.774998 0 -2.394995 0 0 0 0 0 0 0 0 0
$definebone "j_gun" "" 0 0 0 0 0 0 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "tag_pistol_offset"
$bonemerge "tag_barrel_attach"
$bonemerge "tag_laser_show"
$bonemerge "tag_laser_attach"
$bonemerge "tag_mag_attach"
$bonemerge "tag_pistolgrip_attach"
$bonemerge "tag_stock_attach"


$sequence "reference" {
	"w_makarov_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_makarov_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\weapons\pistols\makarov\template\weapon_worldmodel.qc"
//	}
}
