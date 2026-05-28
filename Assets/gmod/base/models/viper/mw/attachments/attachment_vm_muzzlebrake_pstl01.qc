// Created by Crowbar 0.74

$modelname "attachment_vm_muzzlebrake_pstl01.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_muzzlebrake_pstl01.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.001 -0.424 -0.423 1.038 0.423 0.423

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_silencer" 1.022 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_muzzlebrake_pstl01_anims\reference.smd"
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
