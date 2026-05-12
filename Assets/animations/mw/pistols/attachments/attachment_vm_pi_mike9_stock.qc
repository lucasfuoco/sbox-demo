// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike9_stock.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike9_stock.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m9\"

$cbox 0 0 0 0 0 0

$bbox -14.758 -0.778 -4.191 0.459 0.739 1.09

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike9_stock_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\m9\attachment_stock.qc"
//	}
}
