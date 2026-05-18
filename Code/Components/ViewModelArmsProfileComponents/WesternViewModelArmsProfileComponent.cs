namespace Sandbox.Components.ViewModelArmsProfileComponents;

/// <summary>
/// Western arms/glove options (vm_western_arms material groups + western glove meshes).
/// </summary>
[Title( "Western Arms Profile" ), Group( "Viewmodel" )]
public class WesternViewModelArmsProfileComponent : ViewModelArmsProfileComponent
{
	protected override ViewModelArmsProfile CreateProfile()
	{
		var profile = new ViewModelArmsProfile
		{
			Slots =
			{
				Slot( "sleeve", "sleeve_1", BuildSleeveOptions() ),
				Slot( "glove", "knuckled_wyatt_a", BuildGloveOptions() )
			}
		};

		return profile;
	}

	static ViewModelArmsOptionDefinition[] BuildSleeveOptions()
	{
		var options = new ViewModelArmsOptionDefinition[26];
		for ( var i = 0; i < 26; i++ )
			options[i] = Opt( $"sleeve_{i + 1}" );

		return options;
	}

	static ViewModelArmsOptionDefinition[] BuildGloveOptions()
	{
		return
		[
			Opt( "none" ),
			Opt( "knuckled_wyatt_a" ),
			Opt( "knuckled_wyatt_b" ),
			Opt( "knuckled_wyatt_c" ),
			Opt( "knuckled_wyatt_d" ),
			Opt( "knuckled_alex_a" ),
			Opt( "knuckled_alex_b" ),
			Opt( "knuckled_rodion_a" ),
			Opt( "knuckled_rodion_b" ),
			Opt( "knuckled_kreuger_a" ),
			Opt( "knuckled_kreuger_b" ),
			Opt( "knuckled_kreuger_c" ),
			Opt( "knuckled_ghost_a" ),
			Opt( "knuckled_ghost_b" ),
			Opt( "knuckled_ghost_c" ),
			Opt( "knuckled_clan" ),
			Opt( "knuckled_bale" ),
			Opt( "knuckled_milsim" ),
			Opt( "nomex_dday_a" ),
			Opt( "nomex_dday_b" ),
			Opt( "nomex_dday_c" ),
			Opt( "nomex_dday_d" ),
			Opt( "nomex_desert" ),
			Opt( "nomex_golem_a" ),
			Opt( "nomex_golem_b" ),
			Opt( "nomex_green_camo" ),
			Opt( "nomex_light_green" ),
			Opt( "mechanix_black" ),
			Opt( "mechanix_white" ),
			Opt( "mechanix_tan" ),
			Opt( "mechanix_cayote" ),
			Opt( "mechanix_grey" ),
			Opt( "mechanix_green" ),
			Opt( "mechanix_camo_a" ),
			Opt( "mechanix_camo_e" ),
			Opt( "mechanix_grinch" ),
			Opt( "mechanix_grinch_green" ),
			Opt( "mechanix_minotaur" ),
			Opt( "mechanix_otter" ),
			Opt( "mechanix_disguise" ),
			Opt( "fireteam_price" )
		];
	}
}
