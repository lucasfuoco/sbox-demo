// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_mike9_scope_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_pi_mike9_scope_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m9\"
$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -2.98 -0.642 0 0 0.642 2.005

$definebone "tag_scope" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike9_scope_hide_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\m9\attachment_sight_hide.qc"
//	}
}
