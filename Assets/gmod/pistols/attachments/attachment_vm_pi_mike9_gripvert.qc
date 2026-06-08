// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike9_gripvert.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike9_gripvert.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m9\"

$cbox 0 0 0 0 0 0

$bbox -1.614 -0.77 -3.243 0.441 0.857 0.399

$definebone "tag_folding_grip" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike9_gripvert_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\m9\attachment_grip.qc"
//	}
}
