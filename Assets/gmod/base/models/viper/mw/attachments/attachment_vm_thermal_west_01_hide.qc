// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_thermal_west_01_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_thermal_west_01_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -1.099 -0.562 0 0 0.562 1.488

$definebone "tag_thermal" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_thermal" -1.082 0 0.926 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_thermal_west_01_hide_anims\reference.smd"
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
