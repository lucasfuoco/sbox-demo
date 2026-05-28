// Created by Crowbar 0.74

$modelname "attachment_vm_silencerpstl.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_silencerpstl.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment_silenced" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox 0 -0.568 -0.568 6.152 0.568 0.568

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment_silenced" "tag_silencer" 6.151988 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_silencerpstl_anims\reference.smd"
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
