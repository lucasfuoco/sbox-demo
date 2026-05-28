// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_stock_no.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_stock_no.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.678 -0.999 -0.678 0.678 0 0.678

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_sling_loop" "tag_stock_attach" -0.726 -0.001 0.022 0 0 0 0 0 0 0 0 0
$definebone "j_sling_pivot" "tag_stock_attach" -0.803 0 0.008 0 0 0 0 0 0 0 0 0

$bonemerge "tag_stock_attach"


$sequence "reference" {
	"attachment_vm_stock_no_anims\reference.smd"
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
