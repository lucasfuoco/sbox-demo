// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_thermal_east.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_thermal_east.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_thermal_east_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0
$attachment "reticle2" "tag_reticle_attach2" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.536 -1.748 -0.225 4.019 1.072 1.955

$definebone "tag_thermal" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_thermal" -0.941 0 0.943 0 0 0 0 0 0 0 0 0
$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach2" "tag_hybrid" 1.339 -1.748 0.451 0 0 44.998386 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_thermal_east_anims\reference.smd"
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
