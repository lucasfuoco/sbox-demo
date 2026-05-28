// Created by Crowbar 0.74

$modelname "attachment_vm_scope_vz.mdl"

$bodygroup "optic"
{
	studio "attachment_vm_scope_vz.smd"
}
$bodygroup "lens"
{
	studio "attachment_vm_scope_vz_lens_hide.smd"
	studio "attachment_vm_scope_vz_lens.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\attachments\"

$attachment "reticle" "tag_reticle_attach" 0 0 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -3.534 -1.393 -0.272 6.266 1.357 2.555

$definebone "tag_scope" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_scope_lens_cover" "tag_scope" -3.422 -0.771 1.701 0 0 60.078119 0 0 0 0 0 0
$definebone "tag_reticle_attach" "tag_scope" -3.191 0.001 1.248 0 0 0 0 0 0 0 0 0
$definebone "tag_lense_hide" "tag_scope" -3.191 0.001 1.248 0 0 0 0 0 0 0 0 0
$definebone "tag_lense" "tag_scope" -3.191 0.001 1.248 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_scope_vz_anims\reference.smd"
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
