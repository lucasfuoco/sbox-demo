// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_decho_cust_grip.mdl"

$bodygroup "cust_grip"
{
	studio "attachment_vm_pi_decho_cust_grip_lod0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\mw\weapons\deagle\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -0.847 -1.567 -1.782 0.847 1.373 2.267

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"attachment_vm_pi_decho_cust_grip_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\_conv\cod_mw\modernmodellingwarfare\exported_files\vm_pi_decho\attachment_vm_pi_decho_cust_grip\attachment_vm_pi_decho_cust_grip_lod0.qc"
//	}
}
