ENT.Base = "mg_arrow"
ENT.Type = "anim"

ENT.KnockbackRadius = 320
ENT.KnockbackForce = 300

sound.Add({
    name = "MW19_Crossbow.Knockback",
    channel = CHAN_BODY,
    volume = 1, 
    level = 100,
    pitch = {95, 105},
    sound = {"@viper/shared/smoke_expl_body_01.ogg"}
}) 