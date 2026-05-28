// Created by Crowbar 0.74

$modelname "attachment_vm_4x_west02_tall_lens_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_4x_west02_tall_lens_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -1.31 -0.604 0 0 0.595 2.045

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_4x_west02_tall_lens_hide_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\optics_rifle\decompiled\attachment_hide.qc"
//	}
}
