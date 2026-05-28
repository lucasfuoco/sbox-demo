// Created by Crowbar 0.74

$modelname "viper/mw/weapons/w_m1911.mdl"

$bodygroup "receiver"
{
	studio "attachment_vm_pi_mike1911_v1_receiver_world.smd"
	blank
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m1911\"
$cdmaterials ""

$attachment "muzzle" "tag_pistol_offset" 5.5 0 0.5 rotate 0 0 0
$attachment "right_hand" "ValveBiped.Bip01_R_Hand" 0 0 0 rotate 0 0 0
$attachment "shell_eject" "tag_brass" 0 0 0 rotate -20 0 0

$cbox 0 0 0 0 0 0

$bbox -1.066 -2.146 -2.492 0.794 3.384 5.379

$definebone "ValveBiped.Bip01_R_Hand" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "ValveBiped.Bip01_R_Hand" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "tag_pistol_offset" -0.6 0 1.6 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Anim_Attachment_RH" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_hammer" "tag_pistol_offset" -1.142998 -0.001 0.274 -0.000088 89.997639 0 0 0 0 0 0 0
$definebone "tag_barrel_attach" "tag_pistol_offset" 1.342997 -0.000002 1.043998 0.000082 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_pistol_offset" 2.039996 -0.297001 1.310998 0.000109 -89.997639 0 0 0 0 0 0 0
$definebone "tag_grip_hide" "tag_pistol_offset" -0.653999 0.000003 -1.549997 0.000041 0 0.000163 0 0 0 0 0 0
$definebone "tag_laser_attach" "tag_pistol_offset" 3.524992 0 -0.14 0.000082 0 0 0 0 0 0 0 0
$definebone "tag_mag_attach" "tag_pistol_offset" 1.850996 0.000001 -0.471998 0.000082 0 0 0 0 0 0 0 0
$definebone "tag_rail_attach" "tag_pistol_offset" 2.439994 -0.000001 0.838998 0.000082 0 0 0 0 0 0 0 0
$definebone "tag_stock_attach" "tag_pistol_offset" -0.898999 0.000002 -1.088997 0.000012 -0.000325 0 0 0 0 0 0 0
$definebone "j_trigger" "tag_stock_attach" 2.025996 -0.00099 0.681 -0.000086 89.99796 0 0 0 0 0 0 0
$definebone "tag_trigger_hide" "j_trigger" 0 0 0 0.000015 -89.99766 -0.000086 0 0 0 0 0 0
$definebone "j_magrel" "tag_pistol_offset" 0.711998 0.44 -0.805998 -0.000068 89.997639 0 0 0 0 0 0 0
$definebone "j_safety" "tag_pistol_offset" -1.474997 0 0.073 -0.000088 89.997639 0.00001 0 0 0 0 0 0
$definebone "j_sliderelease" "tag_pistol_offset" 1.889996 0.409999 0.285 0 -0.000002 89.997755 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "tag_pistol_offset"
$bonemerge "tag_reflex"
$bonemerge "tag_barrel_attach"
$bonemerge "tag_laser_attach"
$bonemerge "tag_mag_attach"
$bonemerge "tag_rail_attach"
$bonemerge "tag_stock_attach"


$sequence "reference" {
	"w_m1911_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_m1911_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\weapons\pistols\m1911\template\weapon_worldmodel.qc"
//	}
}
