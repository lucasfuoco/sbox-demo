// Created by Crowbar 0.74

$modelname "viper/mw/attachments/attachment_vm_hybrid_east02_hide.mdl"

$bodygroup "hide"
{
	studio "attachment_vm_hybrid_east02_hide.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"
$cdmaterials ""

$cbox 0 0 0 0 0 0

$bbox -1.358 -0.369 0 0 0.369 1.474

$definebone "tag_hybrid" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_magnifier" "tag_hybrid" -0.001 -0.189 0.239 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "j_magnifier" -1.357 0.189 0.866 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_hybrid_east02_hide_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\optics_rifle\attachment_hide.qc"
//	}
}
