AddCSLuaFile()

local fragVolume = 1

local function generateSoundTable(name, count)
    local tbl = {}

    for c = 1, count do
        local finalName = string.Replace(name, "#", c)
        table.insert(tbl, finalName)
    end

    return tbl
end

sound.Add({
    name =          "MW_Physics.Frag.Concrete",
    channel =       CHAN_ITEM, 
    volume =        fragVolume,
    level =   90,
    sound = generateSoundTable("viper/shared/frag_physics/bounce/phy_frag_bounce_concrete_hard_0#_ext.wav", 8)
})

sound.Add({
    name =          "MW_Physics.Frag.Dirt",
    channel =       CHAN_ITEM, 
    volume =        fragVolume,
    level =   90,
    sound = generateSoundTable("viper/shared/frag_physics/bounce/phy_frag_bounce_dirt_hard_0#_ext.wav", 9)
})

sound.Add({
    name =          "MW_Physics.Frag.Grass",
    channel =       CHAN_ITEM, 
    volume =        fragVolume,
    level =   90,
    sound = generateSoundTable("viper/shared/frag_physics/bounce/phy_frag_bounce_grass_hard_0#_ext.wav", 6)
})

sound.Add({
    name =          "MW_Physics.Frag.Gravel",
    channel =       CHAN_ITEM, 
    volume =        fragVolume,
    level =   90,
    sound = generateSoundTable("viper/shared/frag_physics/bounce/phy_frag_bounce_gravel_hard_0#_ext.wav", 6)
})

sound.Add({
    name =          "MW_Physics.Frag.Metal",
    channel =       CHAN_ITEM, 
    volume =        fragVolume,
    level =   90,
    sound = generateSoundTable("viper/shared/frag_physics/bounce/phy_frag_bounce_metal_hard_0#_ext.wav", 9)
})

sound.Add({
    name =          "MW_Physics.Frag.MetalGrate",
    channel =       CHAN_ITEM, 
    volume =        fragVolume,
    level =   90,
    sound = generateSoundTable("viper/shared/frag_physics/bounce/phy_frag_bounce_metalgrate_hard_0#_ext.wav", 9)
})

sound.Add({
    name =          "MW_Physics.Frag.Mud",
    channel =       CHAN_ITEM, 
    volume =        fragVolume,
    level =   90,
    sound = generateSoundTable("viper/shared/frag_physics/bounce/phy_frag_bounce_mud_hard_0#_ext.wav", 9)
})

sound.Add({
    name =          "MW_Physics.Frag.Wood",
    channel =       CHAN_ITEM, 
    volume =        fragVolume,
    level =   90, 
    sound = generateSoundTable("viper/shared/frag_physics/bounce/phy_frag_bounce_wood_hard_0#_ext.wav", 9)
})

local debrisVolume = 1

sound.Add({
    name =          "MW_Physics.Frag.Debris.Wood",
    channel =       CHAN_BODY, 
    volume =        debrisVolume,
    level =   80,
    sound = {"viper/shared/frag_physics/debris/expl_debris_wood_03.ogg", "viper/shared/frag_physics/debris/expl_debris_wood_04.ogg", "viper/shared/frag_physics/debris/expl_debris_wood_05.ogg"}
})

sound.Add({
    name =          "MW_Physics.Frag.Debris.Concrete",
    channel =       CHAN_BODY, 
    volume =        debrisVolume,
    level =   80,
    sound = {"viper/shared/frag_physics/debris/expl_debris_concrete_01.ogg", "viper/shared/frag_physics/debris/expl_debris_concrete_02.ogg", "viper/shared/frag_physics/debris/expl_debris_concrete_05.ogg"}
})

sound.Add({
    name =          "MW_Physics.Frag.Debris.Metal",
    channel =       CHAN_BODY, 
    volume =        debrisVolume,
    level =   80,
    sound = {"viper/shared/frag_physics/debris/expl_debris_mtl_01.ogg", "viper/shared/frag_physics/debris/expl_debris_mtl_02.ogg", "viper/shared/frag_physics/debris/expl_debris_mtl_03.ogg"}
})

sound.Add({
    name =          "MW_Physics.Frag.Debris.Sand",
    channel =       CHAN_BODY, 
    volume =        debrisVolume,
    level =   80,
    sound = {"viper/shared/frag_physics/debris/expl_debris_sand_01.ogg", "viper/shared/frag_physics/debris/expl_debris_sand_02.ogg", "viper/shared/frag_physics/debris/expl_debris_sand_03.ogg"}
})

sound.Add({
    name =          "MW_Physics.Frag.Debris.Dirt",
    channel =       CHAN_BODY, 
    volume =        debrisVolume,
    level =   80,
    sound = {"viper/shared/frag_physics/debris/expl_debris_dirt_01.ogg", "viper/shared/frag_physics/debris/expl_debris_dirt_02.ogg", "viper/shared/frag_physics/debris/expl_debris_dirt_03.ogg"}
})

sound.Add({
    name =          "MW_Physics.Frag.Debris.Glass",
    channel =       CHAN_BODY, 
    volume =        debrisVolume,
    level =   80,
    sound = "viper/shared/frag_physics/debris/expl_debris_glass_01.ogg"
})