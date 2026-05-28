// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_reflex_02.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_02.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -0.461 -0.849 -0.367 3.244 1.214 1.842

$definebone "tag_holo" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_holo" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_holo" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_holo" 2.267 0 1.317 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_02_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\sights\attachment.qc"
//	}
}
