// Created by Crowbar 0.74

$modelname "attachment_vm_stock_light01.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_stock_light01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -8.484 -0.715 -4.204 0 0.711 0.67

$definebone "tag_stock_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0

$bonemerge "tag_stock_attach"


$sequence "reference" {
	"attachment_vm_stock_light01_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\#shared\stocks_rifle\attachment_stock.qc"
//	}
}
