// Created by Crowbar 0.74

$modelname "viper/mw/attachments/shotgun/attachment_vm_sh_romeo870_choke.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_sh_romeo870_choke.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\romeo870\"
$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.764 -0.376 -0.377 0.29 0.376 0.376

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment" "tag_silencer" 0.289999 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_sh_romeo870_choke_anims\reference.smd"
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
