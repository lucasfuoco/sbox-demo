// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_lm_slima_acog.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_lm_slima_acog.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_lm_slima_acog_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -2.735 -1.281 -0.307 4.476 0.972 2.19

$definebone "tag_acog_2" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_acog_2" -2.567999 0 1.365 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_acog_2" -2.567999 0 1.365 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_lm_slima_acog_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\optics\attachment.qc"
//	}
}
