// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_silencer_east02.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_silencer_east02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment_silenced" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox 0 -0.929 -0.929 9.296 0.929 1.093

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment_silenced" "tag_silencer" 9.075 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_silencer_east02_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\muzzles\attachment.qc"
//	}
}
