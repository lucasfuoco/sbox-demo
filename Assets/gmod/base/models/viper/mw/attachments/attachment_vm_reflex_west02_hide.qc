// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_reflex_west02_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_reflex_west02_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.036 -0.44 0 0 0.44 1.705

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_west02_hide_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\optics_rifle\attachment_hide.qc"
//	}
}
