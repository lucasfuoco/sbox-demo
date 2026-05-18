using Sandbox;
using Sandbox.Attributes;

namespace Sandbox.Components.ViewModelArmsProfileComponents;

/// <summary>
/// Eastern arms/glove options ported from GMod reference data (see Code/Lua/weapons/mg_base/modules/rigs/).
/// Not executed at runtime — each option needs a matching slot_{category}_{id} child on the arms prefab.
/// </summary>
[Title( "Eastern Arms Profile" ), Group( "Viewmodel" )]
public class EasternViewModelArmsProfileComponent : ViewModelArmsProfileComponent
{
	protected override ViewModelArmsProfile CreateProfile()
	{
		return new ViewModelArmsProfile
		{
			Slots =
			{
				Slot( "sleeve", "gorka_1",
					Opt( "gorka_1" ),
					Opt( "gorka_2" ),
					Opt( "gorka_3" ),
					Opt( "gorka_4" ),
					Opt( "gorka_5" ),
					Opt( "gorka_6" ),
					Opt( "gorka_7" ),
					Opt( "gorka_8" ),
					Opt( "gorka_9" ),
					Opt( "vm_bale_sleeves" ) ),
				Slot( "glove", "mechanix_black",
					Opt( "none" ),
					Opt( "mechanix_black" ),
					Opt( "mechanix_alice" ),
					Opt( "mechanix_coma_a" ),
					Opt( "mechanix_coma_e" ),
					Opt( "mechanix_cayote" ),
					Opt( "mechanix_white" ),
					Opt( "mechanix_green" ),
					Opt( "mechanix_grey" ),
					Opt( "mechanix_grinch" ),
					Opt( "mechanix_grinch_green" ),
					Opt( "mechanix_minotaur" ),
					Opt( "mechanix_otter" ),
					Opt( "mechanix_tan" ),
					Opt( "compacted_crowfoot_a" ),
					Opt( "compacted_crowfoot_b" ),
					Opt( "compacted_crowfoot_c" ),
					Opt( "compacted_ghost" ),
					Opt( "compacted_murphy_a" ),
					Opt( "compacted_murphy_b" ),
					Opt( "compacted_murphy_c" ),
					Opt( "compacted_syd_a" ),
					Opt( "compacted_syd_b" ),
					Opt( "compacted_zedra_a" ),
					Opt( "nomex_dday_a" ),
					Opt( "nomex_dday_b" ),
					Opt( "nomex_dday_c" ),
					Opt( "nomex_dday_d" ),
					Opt( "nomex_desert" ),
					Opt( "nomex_golem_a" ),
					Opt( "nomex_golem_b" ),
					Opt( "nomex_green_camo" ),
					Opt( "nomex_light_green" ),
					Opt( "knuckled_default" ),
					Opt( "knuckled_alex_a" ),
					Opt( "knuckled_alex_b" ),
					Opt( "knuckled_clan" ),
					Opt( "knuckled_zane" ),
					Opt( "knuckled_ghost_a" ),
					Opt( "knuckled_ghost_b" ),
					Opt( "knuckled_ghost_c" ),
					Opt( "technician_yegor" ),
					Opt( "technician_lynch" ),
					Opt( "fireteam_eastern" ),
					Opt( "fireteam_eastern_a" ),
					Opt( "fireteam_eastern_dmr" ) )
			}
		};
	}
}
