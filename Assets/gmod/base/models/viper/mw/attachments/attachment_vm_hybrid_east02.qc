// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_hybrid_east02.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_hybrid_east02.smd"
}
$bodygroup "lens"
{
	blank
	studio "attachment_vm_hybrid_east02_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials ""

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0
$attachment "reticle2" "tag_reticle_attach2" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.463 -0.651 -0.298 4.72 0.838 1.812

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_magnifier" "tag_hybrid" -0.001 -0.189 0.239 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "j_magnifier" -1.357 0.189 0.866 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_ads2" "tag_hybrid" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_glass_hip2" "tag_hybrid" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach2" "tag_hybrid" 1.27 0 1.105 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_hybrid_east02_anims\reference.smd"
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
