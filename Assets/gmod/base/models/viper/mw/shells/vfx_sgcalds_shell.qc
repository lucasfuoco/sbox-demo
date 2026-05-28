// Created by Crowbar 0.74

$modelname "viper/mw/shells/vfx_sgcalds_shell.mdl"

$bodygroup "optic"
{
	studio "shotgunshell_green.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 0 0

$mostlyopaque

$cdmaterials "viper\MW\shells\shotgun\"

$cbox 0 0 0 0 0 0

$bbox -2.999 -0.457 0 0 0.457 1.265

$definebone "tag_mag_attach" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "j_mag2" "tag_mag_attach" -1.615 0 0.184 0 0 0 0 0 0 0 0 0


$sequence "reference" {
	"vfx_sgcalds_shell_anims\reference.smd"
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
//		"value" "c:\github\source files mw\source-files-mw\attachments\#shared\shells\shell.qc"
//	}
}
