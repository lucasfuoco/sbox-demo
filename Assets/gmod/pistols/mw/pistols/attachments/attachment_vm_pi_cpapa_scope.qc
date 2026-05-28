// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_pi_cpapa_scope.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_pi_cpapa_scope.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_pi_cpapa_scope_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials "viper\MW\weapons\357\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.691 -0.839 -0.506 7.218 0.869 1.554

$definebone "tag_scope" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_scope" -0.42 0 0.732 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_cpapa_scope_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\pistols\357\attachment_optic.qc"
//	}
}
