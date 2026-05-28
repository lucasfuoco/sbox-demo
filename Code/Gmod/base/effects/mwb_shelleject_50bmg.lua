AddCSLuaFile()

EFFECT.Model = Model("models/viper/mw/shells/vfx_rifle_shell_lod0.mdl")
EFFECT.Scale = 2
EFFECT.Force = 100
EFFECT.Offset = Vector()
EFFECT.Sounds = {
    Default = Sound("MW_Casings.50bmg.cement"),
    Water = Sound("MW_Casings.50bmg.water"), 
    [MAT_DIRT] = Sound("MW_Casings.50bmg.dirt"),
    [MAT_GLASS] = Sound("MW_Casings.50bmg.glass"),
    [MAT_TILE] = Sound("MW_Casings.50bmg.glass"),
    [MAT_GRASS] = Sound("MW_Casings.50bmg.grass"),
    [MAT_FOLIAGE] = Sound("MW_Casings.50bmg.grass"),
    [MAT_SLOSH] = Sound("MW_Casings.50bmg.mud"),
    [MAT_FLESH] = Sound("MW_Casings.50bmg.mud"),
    [MAT_BLOODYFLESH] = Sound("MW_Casings.50bmg.mud"),
    [MAT_ALIENFLESH] = Sound("MW_Casings.50bmg.mud"),
    [MAT_EGGSHELL] = Sound("MW_Casings.50bmg.mud"),
    [MAT_METAL] = Sound("MW_Casings.50bmg.metal"),
    [MAT_COMPUTER] = Sound("MW_Casings.50bmg.metal"),
    [MAT_GRATE] = Sound("MW_Casings.50bmg.metal"),
    [MAT_SAND] = Sound("MW_Casings.50bmg.sand"),
    [MAT_SNOW] = Sound("MW_Casings.50bmg.sand"),
    [MAT_VENT] = Sound("MW_Casings.50bmg.metal"),
    [MAT_WOOD] = Sound("MW_Casings.50bmg.wood_hollow")
}

include("mwb_shelleject.lua") 