// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_thermal_west_01.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_thermal_west_01.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_thermal_west_01_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.288 -0.893 -0.246 3.402 0.893 2.208

$definebone "tag_thermal" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_thermal" -1.082 0 0.926 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_thermal" -1.082 0 0.926 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_thermal_west_01_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\optics_rifle\attachment.qc"
//	}
}
