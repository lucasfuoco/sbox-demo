// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_cpapa_scope_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_pi_cpapa_scope_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\357\"
$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.452 -0.446 0 0 0.446 1.177

$definebone "tag_scope" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_scope" -0.42 0 0.732 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_cpapa_scope_hide_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\357\attachment_sight_hide.qc"
//	}
}
