// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike9_compensator.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike9_compensator.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.915 -0.439 -1.233 2.302 0.439 0.33

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_silencer" 2.3 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike9_compensator_anims\reference.smd"
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
