// Created by Crowbar 0.74

$modelname "attachment_vm_vertgrip_stubby01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_vertgrip_stubby01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -0.013 -0.756 -3.488 1.991 0.753 0.284

$definebone "tag_folding_grip" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_vertgrip_stubby01_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\#shared\grips\grips.qc"
//	}
}
