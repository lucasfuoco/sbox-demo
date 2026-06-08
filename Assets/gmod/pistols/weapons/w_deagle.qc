// Created by Crowbar 0.74

$modelname "viper/mw/weapons/w_deagle.mdl"

$bodygroup "receiver"
{
	studio "attachment_vm_pi_decho_receiver_world.smd"
	blank
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\deagle\"
$cdmaterials ""

$attachment "muzzle" "tag_pistol_offset" 8 0 1.65 rotate 0 0 0
$attachment "right_hand" "ValveBiped.Bip01_R_Hand" 0 0 0 rotate 0 0 0
$attachment "shell_eject" "tag_brass" 0 0 0 rotate -20 0 0
$attachment "reflex" "tag_reflex" 0 0 0 rotate 0 0 0
$attachment "align" "tag_align_gun" 0 0 0 rotate 0 0 0
$attachment "scope" "tag_scope" 0 0 0 rotate 0 0 0
$attachment "holo" "tag_holo" 0 0 0 rotate 0 0 0
$attachment "acog" "tag_acog_2" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.381 -2.139 -2.717 0.663 3.985 8.245

$definebone "ValveBiped.Bip01_R_Hand" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "ValveBiped.Bip01_R_Hand" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_attach" "tag_pistol_offset" -0.242999 0.000001 -1.740997 -0.000019 0.000038 0 0 0 0 0 0 0
$definebone "tag_barrel_attach" "tag_pistol_offset" 4.059992 0 0.733998 0.000026 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_pistol_offset" 0.518999 -0.509 1.733996 0.000039 -89.997687 0 0 0 0 0 0 0
$definebone "tag_laser_attach" "tag_pistol_offset" 5.792989 0 0.083 0.000026 0 0 0 0 0 0 0 0
$definebone "tag_mag_attach" "tag_pistol_offset" 0.503999 0.000001 -3.543993 0.000019 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "tag_pistol_offset" 4.103993 -0.000001 2.042996 0.000026 0 0 0 0 0 0 0 0
$definebone "tag_scope" "tag_pistol_offset" 4.396992 -0.000001 2.097996 0.000026 0 0 0 0 0 0 0 0
$definebone "j_trigger" "tag_stock_attach" 1.718997 -0.000002 2.121995 0.000045 0 0 0 0 0 0 0 0
$definebone "tag_trigger_hide" "j_trigger" 2.920993 -0.000002 1.661998 0 0 0 0 0 0 0 0 0
$definebone "j_magrel" "tag_pistol_offset" 0.990999 0.378 -0.799998 0.000026 0 0 0 0 0 0 0 0
$definebone "j_slidelock" "tag_pistol_offset" 1.464997 0.576999 0.336999 0.000019 0 0 0 0 0 0 0 0
$definebone "j_hammer" "tag_pistol_offset" -1.322997 0 0.598999 0.000019 0 0 0 0 0 0 0 0
$definebone "tag_acog_2" "tag_pistol_offset" 4.103992 0 2.042996 0 0 0 0 0 0 0 0 0
$definebone "tag_holo" "tag_pistol_offset" 4.396992 0 2.097996 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Anim_Attachment_RH" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_align_gun" "tag_pistol_offset" -0.569999 -0.000001 2.329995 0.000019 0 0 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "tag_pistol_offset"
$bonemerge "tag_stock_attach"
$bonemerge "tag_barrel_attach"
$bonemerge "tag_laser_attach"
$bonemerge "tag_mag_attach"
$bonemerge "tag_reflex"
$bonemerge "tag_scope"
$bonemerge "tag_holo"


$sequence "reference" {
	"w_deagle_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_deagle_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\weapons\pistols\deagle\template\weapon_worldmodel.qc"
//	}
}
