// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_decho_muzzlebrake.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_decho_muzzlebrake.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\deagle\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.248 -0.672 -1.123 1.41 0.678 0.537

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_silencer" 1.378997 0 0.075 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_decho_muzzlebrake_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\deagle\attachment_barrel.qc"
//	}
}
