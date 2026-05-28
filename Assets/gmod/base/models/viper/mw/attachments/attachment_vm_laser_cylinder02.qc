// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_laser_cylinder02.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_laser_cylinder02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "laser" "tag_laser" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.585 -0.626 -0.556 1.888 0.425 0.502

$definebone "tag_laser_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_laser" "tag_laser_attach" 1.699 0.238 0.013 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_laser_cylinder02_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\lasers\laser.qc"
//	}
}
