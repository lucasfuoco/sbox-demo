// Created by Crowbar 0.74

$modelname "attachment_vm_flashhider_psl01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_flashhider_psl01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.004 -0.355 -0.473 1.148 0.355 0.352

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_flashhider_psl01_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\muzzles\attachment.qc"
//	}
}
