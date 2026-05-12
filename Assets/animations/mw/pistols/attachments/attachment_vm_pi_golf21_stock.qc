// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_golf21_stock.mdl"

$bodygroup "body"
{
	studio "attachment_vm_pi_golf21_stock_lod0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$cdmaterials "viper\mw\weapons\glock\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -11.194 -0.651 -4.007 0.387 0.651 2.948

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"attachment_vm_pi_golf21_stock_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "c:\_conv\cod_mw\modernmodellingwarfare\exported_files\xmodels\attachment_vm_pi_golf21_stock\attachment_vm_pi_golf21_stock_lod0.qc"
//	}
}
