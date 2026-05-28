// Created by Crowbar 0.74

$modelname "viper/mw/attachments/shotgun/attachment_vm_muzzlemelee_shgn01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_muzzlemelee_shgn01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.401 -0.582 -0.461 1.889 0.582 0.461

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_silencer" 0.849 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_muzzlemelee_shgn01_anims\reference.smd"
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
