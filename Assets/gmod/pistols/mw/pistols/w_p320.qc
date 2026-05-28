// Created by Crowbar 0.74

$modelname "viper/mw/weapons/w_p320.mdl"

$bodygroup "receiver"
{
	studio "w_p320.smd"
	blank
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\p320\"

$attachment "muzzle" "tag_pistol_offset" 5.55 0 1.05 rotate 0 0 0
$attachment "right_hand" "ValveBiped.Anim_Attachment_RH" 0 0 0 rotate 0 0 0
$attachment "shell_eject" "tag_brass" 0 0 0 rotate -20 0 0
$attachment "reflex" "tag_reflex" 0 0 0 rotate 0 0 0
$attachment "scope" "tag_scope" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.859 -1.849 -1.551 0 3.546 9.519

$definebone "ValveBiped.Bip01_R_Hand" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "ValveBiped.Bip01_R_Hand" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_barrel_attach" "tag_pistol_offset" 5.931987 0.000001 1.186 0 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_pistol_offset" 0.950998 -0.450999 1.342998 -22.81541 -89.996143 0 0 0 0 0 0 0
$definebone "tag_laser_attach" "tag_pistol_offset" 3.846992 0.001001 -0.298998 0 0 0 0 0 0 0 0 0
$definebone "tag_mag_attach" "tag_pistol_offset" -0.006 0.000001 -3.735992 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_attach" "tag_pistol_offset" 1.437997 0 0.135 0 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "" -9.75598 0 3.120995 0 0 0 0 0 0 0 0 0
$definebone "tag_scope" "" -6.149988 0 3.251994 0 0 0 0 0 0 0 0 0
$definebone "j_trigger" "tag_stock_attach" 0 0 0 0.000036 -180.000005 90.000016 0 0 0 0 0 0
$definebone "tag_trigger_hide" "j_trigger" 0 0 0 0 -179.999964 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.Anim_Attachment_RH" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_gun" "" -0.939876 0.293956 9.518689 -89.999982 -89.999982 0 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "tag_pistol_offset"
$bonemerge "tag_barrel_attach"
$bonemerge "tag_laser_attach"
$bonemerge "tag_mag_attach"
$bonemerge "tag_stock_attach"
$bonemerge "tag_reflex"
$bonemerge "tag_scope"


$sequence "reference" {
	"w_p320_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_p320_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\weapons\pistols\p320\template\weapon_worldmodel.qc"
//	}
}
