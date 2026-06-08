// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_mike9_scope.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_pi_mike9_scope.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_pi_mike9_scope_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials "viper\MW\weapons\m9\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -3.204 -1.07 -0.289 6.083 1.199 2.423

$definebone "tag_scope" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_scope" -2.98 0 1.363 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike9_scope_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\m9\attachment_optic.qc"
//	}
}
