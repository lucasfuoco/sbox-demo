// Created by Crowbar 0.74

$modelname "attachment_vm_thermal_east_tall.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_thermal_east_tall.smd"
}
$bodygroup "lens"
{
	studio "attachment_vm_thermal_east_tall_lens_hide.smd"
	studio "attachment_vm_thermal_east_tall_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -1.435 -1.063 -0.224 4.12 1.072 2.382

$definebone "tag_thermal" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_thermal" -0.971 0 1.37 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_thermal" -0.971 0 1.37 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_thermal" -0.971 0 1.37 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_thermal_east_tall_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\#shared\optics_rifle\attachment.qc"
//	}
}
