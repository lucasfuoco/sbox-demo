// Created by Crowbar 0.74

$modelname "attachment_vm_pi_mike_pistolgrip03.mdl"

$bodygroup "grip"
{
	studio "attachment_vm_pi_mike_pistolgrip03.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\weapons\makarov\"

$cbox 0 0 0 0 0 0

$bbox -1.161 -0.841 -1.914 1.211 0.841 2.174

$definebone "tag_pistolgrip_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"attachment_vm_pi_mike_pistolgrip03_anims\reference.smd"
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
//		"value" "c:\users\wilson\desktop\things\decompiled shit\mw decompiled stuff\attachments\makarov\attachment_slide.qc"
//	}
}
