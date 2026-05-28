// Created by Crowbar 0.74

$modelname "attachment_vm_thermal_hybrid_tall.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_thermal_hybrid_tall.smd"
}
$bodygroup "lens"
{
	studio "attachment_vm_thermal_hybrid_tall_lens_hide.smd"
	studio "attachment_vm_thermal_hybrid_tall_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0
$attachment "reticle2" "tag_reticle_attach2" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.162 -2.355 -0.28 4.394 1.072 2.386

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_hybrid" -0.698 0 1.374 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach2" "tag_hybrid" 1.874 -1.748 0.567 0 0 44.998444 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_hybrid" -0.698 0 1.374 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_hybrid" -0.698 0 1.374 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_thermal_hybrid_tall_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\#shared\hybrid\attachment.qc"
//	}
}
