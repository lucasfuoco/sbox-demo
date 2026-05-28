// Created by Crowbar 0.74

$modelname "attachment_vm_vertgrip02_LOD0.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_vertgrip02_LOD0.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -0.015 -0.77 -4.276 1.962 0.77 0.453

$definebone "tag_folding_grip" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_vertgrip02_lod0_anims\reference.smd"
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
