// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_angledgrip04.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_angledgrip04.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$cbox 0 0 0 0 0 0

$bbox -2.851 -0.631 -1.349 0.075 0.631 0.252

$definebone "tag_grip_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_angledgrip04_anims\reference.smd"
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
