// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_lm_slima_acog_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_lm_slima_acog_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -2.633 -0.513 0 0 0.513 1.878

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_acog_2" -2.567999 0 1.365 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_lm_slima_acog_hide_anims\reference.smd"
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
