// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike9_pstlgrplght.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike9_pstlgrplght.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\m9\"

$cbox 0 0 0 0 0 0

$bbox -1.471 -0.869 -2.178 1.438 0.953 2.261

$definebone "tag_pistolgrip_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike9_pstlgrplght_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\m9\attachment_pgrip.qc"
//	}
}
