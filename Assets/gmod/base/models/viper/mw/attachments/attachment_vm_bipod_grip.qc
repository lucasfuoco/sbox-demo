// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_bipod_grip.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_bipod_grip.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -0.132 -3.376 -8.215 2.141 3.376 0.35

$definebone "tag_folding_grip" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_bipod_grip_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\grips\attachment.qc"
//	}
}
