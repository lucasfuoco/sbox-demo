// Created by Crowbar 0.74

$modelname "viper/mw/weapons/w_357.mdl"

$bodygroup "receiver"
{
	studio "w_357.smd"
	blank
}
$bodygroup "pgrip"
{
	studio "attachment_vm_pi_cpapa_pgrip.smd"
	blank
}
$bodygroup "tag_rail"
{
	blank
	studio "attachment_vm_pi_cpapa_rail.smd"
}
$bodygroup "sight"
{
	studio "attachment_vm_pi_cpapa_sight_on.smd"
	blank
}


$surfaceprop "weapon"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\357\"

$attachment "muzzle" "tag_pistol_offset" 5.55 0 1.05 rotate 0 0 0
$attachment "right_hand" "ValveBiped.Bip01_R_Hand" 0 0 0 rotate 0 0 0
$attachment "shell_eject" "tag_brass" 0 0 0 rotate -20 0 0
$attachment "reflex" "tag_reflex" 0 0 0 rotate 0 0 0
$attachment "scope" "tag_scope" 0 0 0 rotate 0 0 0
$attachment "align" "tag_align_gun" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -2.05 -1.49 -1.3 0 4.262 10.024

$definebone "ValveBiped.Bip01_R_Hand" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_pistol_offset" "ValveBiped.Bip01_R_Hand" -1.072254 1.936601 1.112132 -89.999982 -89.999982 0 0 0 0 0 0 0
$definebone "j_cylinder" "tag_pistol_offset" 1.929995 0 0.856999 0 0 0 0 0 0 0 0 0
$definebone "j_hammer" "tag_pistol_offset" 0.005 0 0.459999 0 0 0 0 0 0 0 0 0
$definebone "tag_align_gun" "tag_pistol_offset" 0.754997 0 2.075996 0 0 0 0 0 0 0 0 0
$definebone "tag_barrel_attach" "tag_pistol_offset" 3.515992 0.000001 1.323999 0 0 0 0 0 0 0 0 0
$definebone "tag_brass" "tag_pistol_offset" 1.123997 0 0.917999 0.000057 -179.999978 0 0 0 0 0 0 0
$definebone "tag_frontend_show" "tag_pistol_offset" 2.209995 0 0.917999 0.000057 -179.999978 0 0 0 0 0 0 0
$definebone "tag_mag_attach" "tag_pistol_offset" 8.911983 0.000004 -1.392992 0 0 0 0 0 0 0 0 0
$definebone "tag_pistolgrip_attach" "tag_pistol_offset" -1.206998 0 -1.777997 -0.000057 0 0 0 0 0 0 0 0
$definebone "tag_reflex" "tag_pistol_offset" 0.917997 0 2.174996 0 0 0 0 0 0 0 0 0
$definebone "tag_scope" "tag_pistol_offset" 0.917997 0 2.222996 0 0 0 0 0 0 0 0 0
$definebone "tag_sight_on" "tag_pistol_offset" 8.911983 0.000004 -1.392992 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_attach" "tag_pistol_offset" -0.965999 0 0.494998 -0.000057 0 0 0 0 0 0 0 0
$definebone "j_trigger" "tag_stock_attach" 2.297995 0.000001 -0.919998 0.000057 0 0 0 0 0 0 0 0
$definebone "tag_trigger_hide" "j_trigger" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_b_top" "tag_pistol_offset" 1.721996 0 0.856999 0 0 0 0 0 0 0 0 0
$definebone "j_b_01" "j_b_top" 0 0 0.465999 0 0 0 0 0 0 0 0 0
$definebone "j_b_02" "j_b_top" 0 0.402999 0.233 0 0 0 0 0 0 0 0 0
$definebone "j_b_03" "j_b_top" 0 0.402999 -0.231999 0 0 0 0 0 0 0 0 0
$definebone "j_b_04" "j_b_top" 0 0 -0.464999 0 0 0 0 0 0 0 0 0
$definebone "j_b_05" "j_b_top" 0 -0.402999 -0.231999 0 0 0 0 0 0 0 0 0
$definebone "j_b_06" "j_b_top" 0 -0.402999 0.233 0 0 0 0 0 0 0 0 0
$definebone "j_cylinder_ejector" "tag_pistol_offset" 3.745991 -0.003999 0.840001 0 0 0 0 0 0 0 0 0
$definebone "j_cylinder_hinge" "tag_pistol_offset" 2.975995 0.206001 -0.110998 0 0 0 0 0 0 0 0 0
$definebone "j_cylinder_rel" "tag_pistol_offset" 0.466999 0.293999 0.804999 0 0 0 0 0 0 0 0 0
$definebone "j_gun" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_stock_hide" "tag_pistol_offset" -0.966001 0 0.495 0 0 0 0 0 0 0 0 0
$definebone "tag_rail" "tag_pistol_offset" 8.911999 0 -1.393 0 0 0 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "tag_pistol_offset"
$bonemerge "tag_barrel_attach"
$bonemerge "tag_mag_attach"
$bonemerge "tag_pistolgrip_attach"
$bonemerge "tag_reflex"
$bonemerge "tag_scope"
$bonemerge "tag_stock_attach"


$sequence "reference" {
	"w_357_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "w_357_physics.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\weapons\pistols\357\template\weapon_worldmodel.qc"
//	}
}
