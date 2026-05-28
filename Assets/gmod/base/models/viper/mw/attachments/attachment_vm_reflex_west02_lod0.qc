// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_reflex_west02_lod0.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_west02.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_reflex_west02_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.482 -0.615 -0.32 2.102 1.003 1.524

$definebone "tag_reflex" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_reflex" -0.015 0 0.869 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_west02_lod0_anims\reference.smd"
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
