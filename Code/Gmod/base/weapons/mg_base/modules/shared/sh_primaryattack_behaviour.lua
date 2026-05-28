AddCSLuaFile()

function SWEP:CanRechamber()
    if !self:GetAnimation("Rechamber") then
        return false
    end
    
    if self:HasFlag("Rechambered") then
        return false
    end

    if self:GetOwner():GetInfoNum("mgbase_manualrechamber", 0) > 0 && self:GetOwner():KeyDown(IN_ATTACK) then
        return false
    end

    return true
end

function SWEP:IsEmpty()
    return (self:GetMaxClip1() < 0 && self:Ammo1() <= 0) || (self:GetMaxClip1() > 0 && self:Clip1() <= 0)
end

function SWEP:GetRecoilDecreaseEveryShotMultiplier()
    local globalMul = 1
    local tbl = self:HasFlag("UsingUnderbarrel") && self.Secondary.Recoil || self.Recoil

    if (tbl.DecreaseEveryShot != nil) then
        globalMul = 1 - (self:GetSprayRounds() * tbl.DecreaseEveryShot)
        globalMul = math.max(globalMul, tbl.MinDecreaseEveryShot || 0)
    end

    return globalMul
end

function SWEP:GetRecoilMultiplier()
    return self:HasFlag("BipodDeployed") && 0.1 || 1
end

function SWEP:CalculateRecoil()
    local tbl = self:HasFlag("UsingUnderbarrel") && self.Secondary.Recoil || self.Recoil

    math.randomseed(tbl.Seed + self:GetSprayRounds())

    local sprayRoundsCap = 30
    if self:GetMaxClip1() >= 0 then
        sprayRoundsCap = math.min(self:GetMaxClip1() * 0.33, 30)
    end

    local verticalRecoil = math.min(self:GetSprayRounds(), sprayRoundsCap) * (tbl.VerticalKick || 0.1) + math.Rand(tbl.Vertical[1], tbl.Vertical[2])
    local horizontalRecoil = math.Rand(tbl.Horizontal[1], tbl.Horizontal[2])
    local angles = Angle(-verticalRecoil, horizontalRecoil, horizontalRecoil * -0.3)
    
    return angles * (Lerp(self:GetAimDelta(), 1, tbl.AdsMultiplier || 1) * self:GetRecoilDecreaseEveryShotMultiplier() * self:GetRecoilMultiplier()) * GetConVar("mgbase_sv_recoil"):GetFloat()
end

function SWEP:MetersToHU(meters)
    return (meters * 100) / 2.54
end

SWEP.FireSurfaces = {
    MAT_ANTLION, MAT_BLOODYFLESH, MAT_EGGSHELL, MAT_FLESH, MAT_ALIENFLESH, MAT_PLASTIC, MAT_FOLIAGE, MAT_SLOSH, MAT_GRASS, MAT_WOOD, MAT_DIRT
}

function SWEP:MakeLight(pos, color, brightness, dieTime)
    if (SERVER && game.SinglePlayer()) then
        local args = "Vector("..pos.x..", "..pos.y..", "..pos.z.."), Color("..color.r..", "..color.g..", "..color.b.."), "..brightness..", "..dieTime
        self:GetOwner():SendLua("local e = Entity("..self:EntIndex()..") if (IsValid(e)) then e:MakeLight("..args..") end")
    end

    if (CLIENT) then
        local dlight = DynamicLight(-1)
        if (dlight) then
            dlight.pos = pos
            dlight.r = color.r
            dlight.g = color.g
            dlight.b = color.b
            dlight.brightness = brightness
            dlight.Decay = 1000
            dlight.Size = 256
            dlight.DieTime = dieTime
        end
    end
end

local function drawHitDebug(self, tr, damage, dist, effectiveRange, dropoffStart)
    RunConsoleCommand("clear_debug_overlays")

    timer.Simple(0, function()
        local original = weapons.Get(self:GetClass())
        local ang = tr.HitNormal:Angle()
        debugoverlay.EntityTextAtPosition(tr.HitPos, 0, "°", 5, Color(0, 255, 0, 255))

        --check if we have any atts that change range
        if (self.Bullet.EffectiveRange != original.Bullet.EffectiveRange
            || self.Bullet.DropOffStartRange != original.Bullet.DropOffStartRange
            || self.Bullet.Damage[1] != original.Bullet.Damage[1]
            || self.Bullet.Damage[2] != original.Bullet.Damage[2]) then
            debugoverlay.ScreenText(0.55, 0.51, "You have attachments that modify range values!", 5, Color(255, 100, 50, 255))
        end

        debugoverlay.ScreenText(0.55, 0.52, math.Round(dist - dropoffStart).." / "..math.Round(effectiveRange).." units ("..self.Bullet.EffectiveRange.."m)", 5, Color(0, 200, 50, 255))
        debugoverlay.ScreenText(0.55, 0.53, math.floor(damage).." damage (raw)", 5, Color(255, 200, 0, 255))
    end)
end

function SWEP:BulletCallbackInternal(tbl, attacker, tr, dmgInfo)
    tbl = tbl || self.Bullet
    local dist = tr.HitPos:Distance(self:GetOwner():GetShootPos())
    local effectiveRange = self:MetersToHU(tbl.EffectiveRange)
    local dropoffStart = tbl.DropOffStartRange && self:MetersToHU(tbl.DropOffStartRange) || 0

    local damage
    if !self.Explosive then --regular hitscan damage
        damage = Lerp(math.Clamp((dist - dropoffStart) / effectiveRange, 0, 1), tbl.Damage[1], tbl.Damage[2])
        damage = math.max(damage / tbl.NumBullets, 1) 
    else --launcher damage
        damage = tbl.Damage[1] / self.Explosive.ImpactBlastRatio
    end

    local pen = tbl.Penetration

    if (SERVER && GetConVar("mgbase_debug_range"):GetInt() > 0) then
        drawHitDebug(self, tr, damage, dist, effectiveRange, dropoffStart)
    end

    local bCanPenetrate = (GetConVar("mgbase_sv_full_penetration"):GetBool() || (self:GetMaxClip1() <= 10 || self:Clip1() % 2 == 0))
        && tbl.NumBullets <= 1 
        && (self.Projectile == nil || self.Projectile.Penetrate) 

    if (bCanPenetrate) then
        if (self:GetPenetrationCount() < pen.MaxCount) then
            local mul = pen.DamageMultiplier
            local c = pen.MaxCount - self:GetPenetrationCount()

            while (c > 0) do
                mul = mul * pen.DamageMultiplier
                c = c - 1
            end

            damage = damage * mul
        end
    end

    if (tr.Entity:IsPlayer()) then
        damage = damage * GetConVar("mgbase_sv_pvpdamage"):GetFloat()
    elseif (tr.Entity:IsNPC() || tr.Entity:IsNextBot()) then
        damage = damage * GetConVar("mgbase_sv_pvedamage"):GetFloat()
    end

    local hsDmg = (tbl.HeadshotMultiplier || 1) * 2
    local leDmg = (tbl.LimbMultiplier || 1) * 0.75

    local bGenericButHead = tr.Entity:EyePos() != tr.Entity:GetPos() && tr.HitGroup == HITGROUP_GENERIC && tr.HitPos.z > tr.Entity:EyePos().z
    if bGenericButHead then
        damage = damage * hsDmg
    elseif tr.HitGroup == HITGROUP_HEAD then
        dmgInfo:SetDamageCustom(1)
        damage = (damage * 0.5) * hsDmg
    elseif tr.HitGroup == HITGROUP_LEFTARM || tr.HitGroup == HITGROUP_RIGHTARM then
        damage = damage * 4
    elseif tr.HitGroup == HITGROUP_LEFTLEG || tr.HitGroup == HITGROUP_RIGHTLEG then
        damage = (damage * 4) * leDmg
    else
        damage = damage * (tbl.TorsoMultiplier || 1)
    end

    dmgInfo:SetDamage(damage)
    
    if (tr.Entity == self.lastHitEntity && (tr.Entity:IsPlayer() || tr.Entity:IsNPC() || tr.Entity:IsNextBot())) then --if we are penetrating something again (bad coz we apply double damage this way)
        dmgInfo:SetDamage(0)
    end

    if (bCanPenetrate) then
        self.lastHitEntity = tr.Entity
    end

    if (self.Projectile == nil) then
        dmgInfo:SetDamageType(DMG_BULLET)
    end

    dmgInfo:SetDamageForce(tr.Normal * (tbl.Damage[2] * tbl.PhysicsMultiplier * 200) / tbl.NumBullets)

    local bInWater = bit.band(util.PointContents(tr.HitPos), CONTENTS_WATER) == CONTENTS_WATER

    if (!bInWater) then
        for _, att in pairs(self:GetAllAttachmentsInUse()) do
            if (att.OnImpact != nil) then
                att:OnImpact(self, dmgInfo, tr)
            end
        end
    end

    local bCanRicochet = !tr.bFromRicochet && !bWater && (tr.Entity:IsWorld() || tr.Entity:Health() <= 0) && !tr.Entity:IsNPC() && !tr.Entity:IsPlayer() && !tr.Entity:IsNextBot()
    math.randomseed(self:Clip1() + self:Ammo1())

    if (tbl.Ricochet && bCanRicochet && math.random(1, math.Clamp(self:GetMaxClip1() / 10, 2, 4)) == 1) then
        local finalDir = tr.HitNormal + VectorRand()

        if (IsFirstTimePredicted()) then
            for _, e in pairs(ents.FindInSphere(tr.HitPos, 1024)) do
                if (e == self:GetOwner()) then
                    continue
                end
                
                if (!e:IsNPC() && !e:IsPlayer() && !e:IsNextBot()) then
                    continue
                end

                if (e:Health() <= 0) then
                    continue
                end

                local dir = (e:WorldSpaceCenter() - tr.HitPos):GetNormalized()
                local dot = tr.HitNormal:Dot(dir)

                if (dot < 0.5) then
                    continue
                end

                if (!e:IsLineOfSightClear(tr.HitPos)) then
                    continue
                end

                local bCanTarget = (e:IsNPC() || e:IsNextBot()) 
                    || (e:IsPlayer() && (GetConVar("sbox_playershurtplayers"):GetInt() > 0  || e:Team() != self:GetOwner():Team()))

                if (bCanTarget) then
                    finalDir = dir + (VectorRand() * 0.01)
                    break
                end
            end
        end

        if (SERVER) then
            sound.Play("^viper/shared/blt_ricco_0"..math.random(1, 6)..".wav", tr.HitPos, 85, math.random(95, 105), 1)
        end --i was forced, suppresshostevents does nothing like always

        --fire forward
        self:GetOwner():FireBullets({
            Attacker = self:GetOwner(),
            Src = tr.HitPos,
            Dir = finalDir,
            Num = 1,
            Tracer = 0,
            Callback = function(attacker, tr, dmgInfo)
                tr.bFromRicochet = true
                
                if (IsFirstTimePredicted()) then
                    local ed = EffectData()
                    ed:SetScale(5000) --speed
                    ed:SetStart(tr.StartPos)
                    ed:SetOrigin(tr.HitPos)
                    ed:SetNormal(finalDir)
                    ed:SetEntity(self)
                    util.Effect("Tracer", ed)

                    ed = EffectData()
                    ed:SetOrigin(tr.StartPos)
                    ed:SetMagnitude(1)
                    ed:SetScale(1)
                    ed:SetNormal(tr.HitNormal)
                    ed:SetRadius(2)
                    util.Effect("Sparks", ed)

                    --[[if (CLIENT) then
                        local dlight = DynamicLight(self:EntIndex())
                        if (dlight) then
                            dlight.pos = tr.StartPos
                            dlight.r = 255
                            dlight.g = 75
                            dlight.b = 0
                            dlight.brightness = 5
                            dlight.Decay = 500
                            dlight.Size = 8
                            dlight.DieTime = CurTime()
                        end
                    end]]
                end
                
                self:BulletCallback(attacker, tr, dmgInfo)
            end
        })

        return --stop penetration
    end

    if (damage <= 1.9 || tr.HitTexture == "**displacement**" || bInWater || tr.bFromRicochet) then
        return
    end
    
    if (bCanPenetrate && self:GetPenetrationCount() > 0) then
        if (tr.HitNoDraw || tr.HitSky) then
            return
        end

        local output = {}
        local dir = tr.Normal
        local start = tr.HitPos

        if (IsFirstTimePredicted()) then
            --debugoverlay.Axis(tr.HitPos, tr.HitNormal:Angle(), 5, 5, true)
            
            util.TraceLine({
                start = tr.HitPos + tr.Normal,
                endpos = tr.HitPos + tr.Normal * pen.Thickness,
                mask = MASK_SHOT,
                filter = {tr.Entity},
                ignoreworld = !IsValid(tr.Entity),
                output = output
            })

            util.TraceLine({
                start = output.HitPos,
                endpos = tr.HitPos,
                mask = MASK_SHOT,
                output = output
            })

            --debugoverlay.Line(tr.HitPos, output.HitPos, 5, Color(255, 0, 0, 255), true)
        end
        
        if (output != nil && !output.StartSolid && !output.HitNoDraw && !output.HitSky) then
            self:SetPenetrationCount(self:GetPenetrationCount() - 1)

            --fire back to the wall to make hole
            self:GetOwner():FireBullets({
                Attacker = self:GetOwner(),
                Src = output.StartPos,
                Dir = -tr.Normal,
                Num = 1,
                Tracer = 0,
                Damage = 0
            })

            --fire forward
            self:GetOwner():FireBullets({
                Attacker = self:GetOwner(),
                Src = output.HitPos,
                Dir = tr.Normal,
                Num = 1,
                Tracer = 0,
                Callback = function(attacker, tr, dmgInfo)
                    self:BulletCallback(attacker, tr, dmgInfo)
                end
            })
        end
    end
end

function SWEP:BulletCallback(attacker, tr, dmgInfo)
    local tbl = self:HasFlag("UsingUnderbarrel") && self.Secondary.Bullet || self.Bullet
    self:BulletCallbackInternal(tbl, attacker, tr, dmgInfo)
end

function SWEP:Bullets(hitpos)
    local tbl = self:HasFlag("UsingUnderbarrel") && self.Secondary.Bullet || self.Bullet

    self.lastHitEntity = NULL
    self:SetPenetrationCount(tbl.Penetration != nil && tbl.Penetration.MaxCount || 0)

    local spread = Vector(self:GetCone(), self:GetCone()) * 0.1
    local dir = (self:GetOwner():EyeAngles() + self:GetOwner():GetViewPunchAngles() + self:GetBreathingSwayAngle()):Forward()

    if (hitpos != nil && isvector(hitpos)) then
        dir = (hitpos - self:GetOwner():EyePos()):GetNormalized()
        spread = Vector()
    end
    
    local bCanAssist = self:GetAimDelta() > 0.5 && self:GetOwner():GetInfoNum("mgbase_aimassist", 1) > 0 && GetConVar("mgbase_sv_aimassist"):GetInt() > 0
    bCanAssist = tbl.NumBullets > 1 || bCanAssist
    
    self:GetOwner():FireBullets({
        Attacker = self:GetOwner(),
        Src = self:GetOwner():EyePos(),
        Dir = dir,
        Spread = spread,
        Num = tbl.NumBullets,
        Damage = tbl.Damage[1], --for some fucking bullet mod or something idk
        HullSize = bCanAssist && 1 || 0,
        --Force = (tbl.Damage[1] * tbl.PhysicsMultiplier) * 0.01,
        Distance = self:MetersToHU(tbl.Range) * GetConVar("mgbase_sv_range"):GetFloat(),
        Tracer = tbl.Tracer && 1 || 0,
        Callback = function(attacker, tr, dmgInfo)
            self:BulletCallback(attacker, tr, dmgInfo, bFromServer)

            if (IsFirstTimePredicted() || game.SinglePlayer()) then
                self:FireTracer(tr.HitPos)
            end
        end
    })
end

function SWEP:GetTracerOrigin() 
    --[[local vm = self:GetViewModel()
    local att = vm:GetAttachment(vm:LookupAttachment("muzzle"))
    
    if (att == nil) then
        return self:GetPos()
    end
    
    return att.Pos - Vector(0, 0, 10)]]

    if (CLIENT && self:IsCarriedByLocalPlayer()) then
       local attEnt, attId = self:GetViewModel():FindAttachment("muzzle")

       return attEnt:GetAttachment(attId).Pos
    end

    return self:GetPos()
end
 
function SWEP:GetConeDecreaseEveryShotMultiplier()
    local recoilGlobalMul = 1

    if self.Cone.DecreaseEveryShot then
        recoilGlobalMul = 1 - (self:GetSprayRounds() * self.Cone.DecreaseEveryShot)
        recoilGlobalMul = math.max(recoilGlobalMul, self.Cone.MinDecreaseEveryShot || 0)
    end

    return recoilGlobalMul
end

function SWEP:GetConeMax()
    local max = (self:HasFlag("UsingUnderbarrel") && self.Secondary.Cone != nil) && self.Secondary.Cone.Max || self.Cone.Max
    local cone = (max * self:GetConeDecreaseEveryShotMultiplier()) / GetConVar("mgbase_sv_accuracy"):GetFloat() 

    if self:HasFlag("BipodDeployed") then
        cone = cone * 0.25
    end

    return cone
end

function SWEP:GetConeMin()
    local min = (self:HasFlag("UsingUnderbarrel") && self.Secondary.Cone != nil) && self.Secondary.Cone.Hip || self.Cone.Hip
    local tacMultiplier = Lerp(self:GetTacStanceDelta(), self.Cone.Ads, self.Cone.TacStance || 1)
    local cone = (Lerp(self:GetAimDelta(), min, tacMultiplier) * self:GetConeDecreaseEveryShotMultiplier()) / GetConVar("mgbase_sv_accuracy"):GetFloat()

    if self:HasFlag("BipodDeployed") then
        cone = cone * 0.25
    end
    
    return cone
end

function SWEP:ShakeCamera()
    local tbl = self.Recoil

    if self:HasFlag("UsingUnderbarrel") then
        tbl = self.Secondary.Recoil
    end

    self.Camera.Shake = tbl.Shake
end

function SWEP:GetVMRecoil(name)
    return self.Recoil.ViewModel != nil && (self.Recoil.ViewModel[name] || 1) || 1
end

function SWEP:ShakeViewModel()
    local vm = self:GetViewModel()

    local recoilPos = Vector(0, 2, -0.5)
    local recoilAng = Angle(0, 0, -1)

    if self.ViewModelOffsets.Recoil != nil then
        recoilPos = Vector(self.ViewModelOffsets.Recoil.Pos)
        recoilAng = Angle(self.ViewModelOffsets.Recoil.Angles)
    end

    if self.ViewModelOffsets.AimRecoil != nil then
        recoilPos = LerpVector(self:GetAimDelta(), recoilPos, Vector(self.ViewModelOffsets.AimRecoil.Pos))
        recoilAng = LerpAngle(self:GetAimDelta(), recoilAng, Angle(self.ViewModelOffsets.AimRecoil.Angles))
    end

    local delta = 1 - self:GetAimDelta()
    recoilPos:Mul(01)
    recoilAng.p = recoilAng.p * (delta)
    recoilAng.y = recoilAng.y * (delta)

    local cone = math.Clamp(self:GetCone(), 0.85, 1.2)
    cone = cone * 0.5
    cone = Lerp(delta, 0.5, cone)

    delta = Lerp(delta, 0.3, 1)

    local vpAngles = self:GetOwner():GetViewPunchAngles()
    local aimingMult = Lerp(self:GetAimDelta(), 1, self:GetVMRecoil("AdsMultiplier"))
    vpAngles.p = (vpAngles.p * Lerp(self:GetAimDelta(), 0, 0.1)) + math.Rand(-cone, cone)
    vpAngles.y = vpAngles.y * Lerp(self:GetAimDelta(), 0.1, 0.5) + Lerp(self:GetAimDelta(), math.Rand(-cone, cone), 0)

    local ang = Angle()
    ang.pitch = (vpAngles.pitch * self:GetVMRecoil("VerticalMultiplier") * aimingMult) + (recoilAng.pitch * delta)
    ang.yaw = (-vpAngles.yaw * self:GetVMRecoil("HorizontalMultiplier") * aimingMult) + (recoilAng.yaw * delta)
    ang.roll = (math.Rand(-1, 1) * self:GetVMRecoil("HorizontalMultiplier") * aimingMult) + Lerp(delta, recoilAng.roll, recoilAng.roll * 0.5)

    local pos = Vector() 
    pos.y = Lerp(delta, recoilPos.y * 0.5, recoilPos.y)
    pos.x = (ang.yaw * 1.5 + (ang.roll * -0.5) + recoilPos.x) * delta
    pos.z = (ang.pitch * 1.5 + (ang.roll * 0.5) + recoilPos.z) * delta

    if self:HasFlag("BipodDeployed") then
        pos.x = 0
        pos.z = 0
        ang.pitch = 0
        ang.yaw = 0
        ang.roll = 0
    end

    vm:SetRecoilTargets(pos, ang)
    vm.m_RecoilRoll = math.Clamp(math.Rand(-1, 1) * 100000, -1, 1) * (self.Recoil.Shake * 3)
end

function SWEP:Projectiles()
    if (CLIENT) then
        return
    end

    local tbl = tbl || self.Projectile

    if (self:HasFlag("UsingUnderbarrel")) then
        tbl = self.Secondary.Projectile
    end

    self:SetPenetrationCount(self.Bullet.Penetration != nil && self.Bullet.Penetration.MaxCount || 0)

    local proj = ents.Create(tbl.Class)

    local angles = self:GetOwner():EyeAngles() + self:GetOwner():GetViewPunchAngles()

    local src = LerpVector(self:GetAimDelta(), self:GetOwner():EyePos() + angles:Up() * -3 + angles:Right() * 3, self:GetOwner():EyePos())
    local dir = self:GetOwner():GetEyeTraceNoCursor().HitPos - src 
    
    local spreadRight = math.Rand(-self:GetCone(), self:GetCone()) * 5
    local spreadUp = math.Rand(-self:GetCone(), self:GetCone()) * 5
    angles:RotateAroundAxis(angles:Right(), spreadRight)
    angles:RotateAroundAxis(angles:Up(), spreadUp)

    proj.Weapon = self
    proj.Projectile = table.Copy(tbl)

    proj:SetPos(src)
    proj:SetAngles(angles)
    proj:SetOwner(self:GetOwner())
    proj:Spawn()
    
    if (tbl.Velocity != nil) then
        proj:SetVelocity(angles:Forward() * tbl.Velocity)
    end
end

local function doTracer(wep, hitpos)
    if (!wep.Bullet) then
        return
    end
    
    local traceEffect = wep.Bullet.TracerName || "mgbase_tracer"
    util.ParticleTracerEx(traceEffect, wep:GetTracerOrigin(), hitpos, false, wep:EntIndex(), -1)
end

function SWEP:FireTracer(pos) 
    if (self.Projectile != nil) then 
        return 
    end

    if (CLIENT) then
        doTracer(self, pos)
    else
        net.Start("mgbase_fire_tracer", false)
            net.WriteEntity(self)
            net.WriteVector(pos)
        if (game.SinglePlayer()) then
            net.Send(self:GetOwner())
        else
            net.SendOmit(self:GetOwner())
        end
    end
end

net.Receive("mgbase_fire_tracer", function() 
    local wep = net.ReadEntity()
    local hitpos = net.ReadVector()
    doTracer(wep, hitpos)
end)