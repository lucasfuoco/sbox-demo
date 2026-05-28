// Created by Crowbar 0.74

$modelname "weapon_vm_scope_vz_lens_hide.mdl"

$bodygroup "hide"
{
	studio "weapon_vm_scope_vz_lens_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -3.181 -0.55 0 0 0.552 1.799

$definebone "tag_scope" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"weapon_vm_scope_vz_lens_hide_anims\reference.smd"
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
