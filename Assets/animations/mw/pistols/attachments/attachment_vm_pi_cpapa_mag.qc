// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_cpapa_mag.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_cpapa_mag.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\357\"

$cbox 0 0 0 0 0 0

$bbox -15.208 -0.738 0 0 0.738 2.991

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag1" "tag_mag_attach" -14.255 0 2.25 0 0 0 0 0 0 0 0 0
$definebone "j_b_loader" "j_mag1" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_b_loader_top" "j_mag1" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_b_loader_01" "j_b_loader_top" 0.452 0 0.466 0 0 0 0 0 0 0 0 0
$definebone "j_b_loader_02" "j_b_loader_top" 0.452 -0.403 0.233 0 0 0 0 0 0 0 0 0
$definebone "j_b_loader_03" "j_b_loader_top" 0.452 -0.403 -0.232 0 0 0 0 0 0 0 0 0
$definebone "j_b_loader_04" "j_b_loader_top" 0.452 0 -0.465 0 0 0 0 0 0 0 0 0
$definebone "j_b_loader_05" "j_b_loader_top" 0.452 0.403 -0.232 0 0 0 0 0 0 0 0 0
$definebone "j_b_loader_06" "j_b_loader_top" 0.452 0.403 0.233 0 0 0 0 0 0 0 0 0

$bonemerge "tag_mag_attach"
$bonemerge "j_mag1"


$sequence "reference" {
	"attachment_vm_pi_cpapa_mag_anims\reference.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\357\attachment_mag.qc"
//	}
}
