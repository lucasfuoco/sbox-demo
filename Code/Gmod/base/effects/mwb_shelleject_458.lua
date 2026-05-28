AddCSLuaFile()

EFFECT.Model = Model("models/viper/mw/shells/vfx_9x39_shell.mdl")
EFFECT.Scale = 0.4
EFFECT.Force = 100
EFFECT.Offset = Vector()
EFFECT.Sounds = {
    Default = Sound("MW_Casings.338.cement"),
    Water = Sound("MW_Casings.338.water"),
    [MAT_DIRT] = Sound("MW_Casings.338.dirt"),
    [MAT_GLASS] = Sound("MW_Casings.338.glass"),
    [MAT_TILE] = Sound("MW_Casings.338.glass"),
    [MAT_GRASS] = Sound("MW_Casings.338.grass"),
    [MAT_FOLIAGE] = Sound("MW_Casings.338.grass"),
    [MAT_SLOSH] = Sound("MW_Casings.338.mud"),
    [MAT_FLESH] = Sound("MW_Casings.338.mud"),
    [MAT_BLOODYFLESH] = Sound("MW_Casings.338.mud"),
    [MAT_ALIENFLESH] = Sound("MW_Casings.338.mud"),
    [MAT_EGGSHELL] = Sound("MW_Casings.338.mud"),
    [MAT_METAL] = Sound("MW_Casings.338.metal"),
    [MAT_COMPUTER] = Sound("MW_Casings.338.metal"),
    [MAT_GRATE] = Sound("MW_Casings.338.metal"),
    [MAT_SAND] = Sound("MW_Casings.338.sand"),
    [MAT_SNOW] = Sound("MW_Casings.338.sand"),
    [MAT_VENT] = Sound("MW_Casings.338.metal"),
    [MAT_WOOD] = Sound("MW_Casings.338.wood_hollow")
}

include("mwb_shelleject.lua") 