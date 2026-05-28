// Created by Crowbar 0.74

$modelname "viper/mw/attachments/oscar12/attachment_vm_sh_oscar12_silencer03.mdl"

$bodygroup "slide"
{
	studio "attachment_vm_sh_oscar12_silencer03.smd"
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

$bbox -0.241 -0.777 -1.811 10.416 0.777 0.719

$definebone "tag_silencer" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_flash_attachment_silenced" "tag_silencer" 10.403 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_sh_oscar12_silencer03_anims\reference.smd"
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
