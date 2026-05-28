// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_thermal_east_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_thermal_east_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -1.081 -0.53 0 0 0.533 1.478

$definebone "tag_thermal" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_thermal_east_hide_anims\reference.smd"
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
