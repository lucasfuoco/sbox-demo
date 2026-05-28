// Created by Crowbar 0.74

$modelname "attachment_vm_silencerpstl03.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_silencerpstl03.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment_silenced" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.017 -0.678 -0.67 5.394 0.722 0.67

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment_silenced" "tag_silencer" 5.378 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_silencerpstl03_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\muzzles\attachment.qc"
//	}
}
