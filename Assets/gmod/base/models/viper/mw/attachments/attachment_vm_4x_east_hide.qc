// Created by Crowbar 0.74

$modelname "attachment_vm_4x_east_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_4x_east_hide_new.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -1.733 -0.444 0 0 0.672 1.57

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_4x_east_hide_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\optics\attachment_hide.qc"
//	}
}
