AddCSLuaFile()

PrecacheParticleSystem("mwb_muzzle_pl_0")
PrecacheParticleSystem("mwb_suppressor_0")
PrecacheParticleSystem("mwb_shell_eject")
PrecacheParticleSystem("AC_muzzle_pistol_smoke_barrel")
include("animations.lua") 
include("customization.lua")
    
if CLIENT then
    killicon.Add( "mg_glock", "VGUI/entities/mg_glock", Color(255, 0, 0, 255))
    SWEP.WepSelectIcon = surface.GetTextureID("VGUI/spawnicons/icon_cac_weapon_pi_golf21")
end
  
SWEP.Base = "mg_base"

SWEP.PrintName = "X16" 
SWEP.Category = "Modern Warfare"
SWEP.SubCategory = "Pistols"
SWEP.Spawnable = true 
SWEP.VModel = Model("models/viper/mw/weapons/v_glock.mdl")
SWEP.WorldModel = Model("models/viper/mw/weapons/w_glock.mdl")
SWEP.Trigger = {
    PressedSound = Sound("weap_golf21_fire_first"),
    ReleasedSound = Sound("weap_golf21_fire_disconnector"),
    Time = 0
}
SWEP.Slot = 1
SWEP.HoldType = "Pistol"

SWEP.ParticleEffects = {
    ["MuzzleFlash"] = "mwb_muzzle_pl_0",
    ["MuzzleFlash_Suppressed"] = "mwb_suppressor_0",
    ["Ejection"] = "mwb_shell_eject", 
}


SWEP.Primary.Sound = Sound("weap_golf21_fire_plr")
SWEP.Primary.Ammo = "Pistol" 
SWEP.Primary.ClipSize = 13
SWEP.Primary.Automatic = false
SWEP.Primary.BurstRounds = 1
SWEP.Primary.BurstDelay = 0
SWEP.Primary.RPM = 309 
SWEP.CanChamberRound = true

SWEP.Reverb = {
    RoomScale = 50000, --(cubic hu)
    --how big should an area be before it is categorized as 'outside'?

    Sounds = {
        Outside = {
            Layer = Sound("Atmo_Pistol.Outside"),
            Reflection = Sound("Reflection_Pistol.Outside")
        },

        Inside = { 
            Layer = Sound("Atmo_Pistol.Inside"),
            Reflection = Sound("Reflection_Pistol.Inside")
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
    ShotTemperatureIncrease = 20,
    TemperatureThreshold = 100, --temperature that triggers smoke
    TemperatureCooldown = 40 --degrees per second
}

SWEP.Cone = {
    Hip = 0.3, --accuracy while hip
    TacStance = false, --accuracy in tac-stance
    Ads = 0, --accuracy while aiming
    Increase = 0.1, --increase cone size by this amount every time we shoot
    TacStanceMultiplier = 0.7, --multiply the increase value by this while in tac-stance
    AdsMultiplier = 0, --multiply the increase value by this amount while aiming
    Max = 1.3, --the cone size will not go beyond this size
}

SWEP.Recoil = {
    Vertical = {0.1, 0.4}, --random value between the 2
    Horizontal = {-0.05, 0.1}, --random value between the 2
    Shake = 2, --camera shake
    AdsMultiplier = 0.5, --multiply the values by this amount while aiming
    Seed = 610312 --give this a random number until you like the current recoil pattern
}

SWEP.Bullet = {
    Damage = {31, 14}, --first value is damage at 0 meters from impact, second value is damage at furthest point in effective range
    EffectiveRange = 22, --in meters, damage scales within this distance
    DropOffStartRange = 7,
    Range = 100, --in meters, after this distance the bullet stops existing
    Tracer = false, --show tracer
    NumBullets = 1, --the amount of bullets to fire
    PhysicsMultiplier = 1, --damage is multiplied by this amount when pushing objects
    HeadshotMultiplier = 1, --this gets multiplied by 2
    Penetration = {
        DamageMultiplier = 0.6, --how much damaged is multipled by when leaving a surface.
        MaxCount = 3, --how many times the bullet can penetrate.
        Thickness = 6, --in hu, how thick an obstacle has to be to stop the bullet.
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
    Angles = Angle(0, 0, 180),
    Pos = Vector(12, -1.5, -3)
}

SWEP.ViewModelOffsets = {
    Aim = {
        Angles = Angle(0, 0, 0),
        Pos = Vector(0.15, 0, 0)
    },
    TacStance = {
        Angles = Angle(-0.3, 0.05, -45),
        Pos = Vector(-2.25, 0, -1.75)
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
            [0] = {Pos = Vector(2, -3, 0), Angles = Angle(-30, -60, 0)},
            [1] = {Pos = Vector(-4, 0, 0), Angles = Angle(0, 30, 0)}
        }
    }
}

SWEP.Shell = "mwb_shelleject_45"