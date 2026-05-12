// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_mike_stockh.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike_stockh.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\makarov\"

$cbox 0 0 0 0 0 0

$bbox -13.82 -1.284 -2.472 0.09 1.284 2.264

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike_stockh_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\makarov\attachment_stock.qc"
//	}
}
