// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_reflex_west05.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_reflex_west05.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox 0 -1.123 -0.334 3.255 0.856 1.988

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_hybrid" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_hybrid" 2.508134 0 1.292 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_reflex_west05_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\sights_rifle\attachment.qc"
//	}
}
