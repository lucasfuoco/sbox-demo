// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_stock_heavy02.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_stock_heavy02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.927 -9.972 -4.558 0.907 0 0.917

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0

$bonemerge "tag_stock_attach"


$sequence "reference" {
	"attachment_vm_stock_heavy02_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\stocks_rifle\attachment_stock.qc"
//	}
}
