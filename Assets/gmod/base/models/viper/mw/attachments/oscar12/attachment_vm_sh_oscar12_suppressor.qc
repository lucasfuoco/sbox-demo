// Created by Crowbar 0.74

$modelname "viper/mw/attachments/oscar12/attachment_vm_sh_oscar12_suppressor.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_sh_oscar12_suppressor.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\oscar12\"
$cdmaterials "viper\MW\attachments\"

$attachment "muzzle" "tag_flash_attachment_silenced" 0 0 0 rotate 0 0 0
$attachment "silencer" "tag_silencer" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.212 -1.054 -0.933 12.294 1.054 2.24

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment_silenced" "tag_silencer" 12.046 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_sh_oscar12_suppressor_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\shotguns\oscar12\attachment_barrel.qc"
//	}
}
