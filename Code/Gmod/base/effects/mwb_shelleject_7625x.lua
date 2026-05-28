AddCSLuaFile()

EFFECT.Model = Model("models/viper/mw/shells/vfx_rifle_shell_lod0.mdl")
EFFECT.Scale = 0.75
EFFECT.Force = 100
EFFECT.Offset = Vector()
EFFECT.Sounds = {
    Default = Sound("MW_Casings.308.cement"),
    Water = Sound("MW_Casings.308.water"),
    [MAT_DIRT] = Sound("MW_Casings.308.dirt"),
    [MAT_GLASS] = Sound("MW_Casings.308.glass"),
    [MAT_TILE] = Sound("MW_Casings.308.glass"),
    [MAT_GRASS] = Sound("MW_Casings.308.grass"),
    [MAT_FOLIAGE] = Sound("MW_Casings.308.grass"),
    [MAT_SLOSH] = Sound("MW_Casings.308.mud"),
    [MAT_FLESH] = Sound("MW_Casings.308.mud"),
    [MAT_BLOODYFLESH] = Sound("MW_Casings.308.mud"),
    [MAT_ALIENFLESH] = Sound("MW_Casings.308.mud"),
    [MAT_EGGSHELL] = Sound("MW_Casings.308.mud"),
    [MAT_METAL] = Sound("MW_Casings.308.metal"),
    [MAT_COMPUTER] = Sound("MW_Casings.308.metal"),
    [MAT_GRATE] = Sound("MW_Casings.308.metal"),
    [MAT_SAND] = Sound("MW_Casings.308.sand"),
    [MAT_SNOW] = Sound("MW_Casings.308.sand"),
    [MAT_VENT] = Sound("MW_Casings.308.metal"),
    [MAT_WOOD] = Sound("MW_Casings.308.wood_hollow")
}

include("mwb_shelleject.lua")  