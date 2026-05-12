AddCSLuaFile()

PrecacheParticleSystem("mwb_muzzle_pl_6")
PrecacheParticleSystem("mwb_suppressor_0")
PrecacheParticleSystem("AC_muzzle_pistol_ejection")
PrecacheParticleSystem("AC_muzzle_pistol_smoke_barrel")
include("animations.lua")
include("customization.lua")

if CLIENT then
    killicon.Add( "mg_deagle", "VGUI/entities/mg_deagle", Color(255, 0, 0, 255))
    SWEP.WepSelectIcon = surface.GetTextureID("VGUI/spawnicons/icon_cac_weapon_pi_decho")
end

SWEP.Base = "mg_base"

SWEP.PrintName = ".50 GS"
SWEP.Category = "Modern Warfare"
SWEP.SubCategory = "Pistols"
SWEP.Spawnable = true
SWEP.VModel = Model("models/viper/mw/weapons/v_deagle.mdl")
SWEP.WorldModel = Model("models/viper/mw/weapons/w_deagle.mdl")
SWEP.Trigger = {
    PressedSound = Sound("weap_decho_fire_first"),
    ReleasedSound = Sound("weap_mike1911_fire_disconnector"),
    Time = 0
}
SWEP.Slot = 1
SWEP.HoldType = "Pistol"

SWEP.Primary.Sound = Sound("weap_decho_fire_plr")
SWEP.Primary.Ammo = "357"
SWEP.Primary.ClipSize = 7 
SWEP.Primary.Automatic = false
SWEP.Primary.BurstRounds = 1
SWEP.Primary.BurstDelay = 0
SWEP.Primary.RPM = 189
SWEP.CanChamberRound = true

SWEP.ParticleEffects = {
    ["MuzzleFlash"] = "mwb_muzzle_pl_6",
    ["MuzzleFlash_Suppressed"] = "mwb_suppressor_0",
    ["Ejection"] = "mwb_shell_eject",
}

SWEP.Reverb = {
    RoomScale = 50000, --(cubic hu)
    --how big should an area be before it is categorized as 'outside'?
 
    Sounds = {
        Outside = {
            Layer = Sound("Atmo_Pistol_Mag.Outside"),
            Reflection = Sound("Reflection_Pistol.Outside")
        }, 

        Inside = { 
            Layer = Sound("Atmo_Shotgun.Inside"),
            Reflection = Sound("Reflection_Shotgun.Inside")
        }
    }
}

SWEP.Firemodes = {
    [1] = {
        Name = "Semi Auto",
        OnSet = function()
            return nil
        end
    }
}

SWEP.BarrelSmoke = {
    Particle = "AC_muzzle_pistol_smoke_barrel",
    Attachment = "muzzle",
    ShotTemperatureIncrease = 100,
    TemperatureThreshold = 100, --temperature that triggers smoke
    TemperatureCooldown = 100 --degrees per second
}

SWEP.Cone = {
    Hip = 0.3, --accuracy while hip
    Ads = 0, --accuracy while aiming
    Increase = 0.1, --increase cone size by this amount every time we shoot
    AdsMultiplier = 0, --multiply the increase value by this amount while aiming
    Max = 1.3, --the cone size will not go beyond this size
}

SWEP.Recoil = {
    Vertical = {1.5, 3.5}, --random value between the 2
    Horizontal = {-0.5, 1}, --random value between the 2
    Shake = 3.5, --camera shake
    AdsMultiplier = 0.75, --multiply the values by this amount while aiming
    Seed = 4445523 --give this a random number until you like the current recoil pattern
}

SWEP.Bullet = {
    Damage = {59, 28}, --first value is damage at 0 meters from impact, second value is damage at furthest point in effective range
    EffectiveRange = 30, --in meters, damage scales within this distance
    DropOffStartRange = 10, --in meters, damage scales within this distance
    Range = 100, --in meters, after this distance the bullet stops existing
    Tracer = false, --show tracer
    NumBullets = 1, --the amount of bullets to fire
    PhysicsMultiplier = 1.5, --damage is multiplied by this amount when pushing objects
    HeadshotMultiplier = 1, --this gets multiplied by 2
    Penetration = {
        DamageMultiplier = 0.875, --how much damaged is multipled by when leaving a surface.
        MaxCount = 6, --how many times the bullet can penetrate.
        Thickness = 16, --in hu, how thick an obstacle has to be to stop the bullet.
    }
}

SWEP.Zoom = {
    IdleSway = 0.2,
    FovMultiplier = 0.95,
    ViewModelFovMultiplier = 1,
    Blur = {
        EyeFocusDistance = 15
    }
}

SWEP.WorldModelOffsets = {
    Bone = "tag_pistol_offset",
    Angles = Angle(0, 90, -90),
    Pos = Vector(3, -3, -1.75)
}

SWEP.ViewModelOffsets = {
    Aim = {
        Angles = Angle(0, 0, 0), 
        Pos = Vector(0.15, 0, 0)
    },  
    Idle = {  
        Angles = Angle(0, 0, 0), 
        Pos = Vector(0, 0, 0) 
    },   
    Inspection = {
        Bone = "tag_pistol_offset",
        X = {
            [0] = {Pos = Vector(0, 2, -2), Angles = Angle(30, 0, -30)},
            [1] = {Pos = Vector(0, 0, 0), Angles = Angle(0, 0, 0)}
        },
        Y = {
            [0] = {Pos = Vector(2, 0, 0), Angles = Angle(-30, -30, 0)},
            [1] = {Pos = Vector(-4, 0, 0), Angles = Angle(0, 30, 0)}
        }
    }
}    
   
SWEP.Shell = "mwb_shelleject_45"