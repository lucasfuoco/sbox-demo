AddCSLuaFile()

require("mw_math")
require("mw_utils")
require("mw_input")

if (SERVER) then
    return
end

local shotgunXhairTickMaterial = Material("mg/shotgunxhairtick")
local normalXhairTickMaterial = Material("mg/normalxhairtick")
local crosshairDotMaterial = Material("mg/crosshairdot")
local blurMaterial = Material("mg/cursorglow")
local mwbWhite = Color(255, 255, 255, 200)
local mwbRed = Color(230, 0, 30, 255)
local mwbGrey = Color(127, 127, 127, 150)
local mwbWhiteish = Color(200, 200, 200, 150)
local mwbGreyRed = Color(100, 20, 20, 200)

local function drawBinding(x, y, bind)
	local key = string.upper(input.LookupBinding(bind) || MWBLTL.Get("HUD_Key_NotBound")..bind)
	local scale = ScrH() / 1080
	local size = 26 * scale

	surface.SetFont("mgbase_command")
	local w = math.max(surface.GetTextSize(key) + 10 * scale, size)

	draw.RoundedBox(4, x - (w * 0.5 - 1), y - (size * 0.5 * scale - 1), w, size * scale, Color(0, 0, 0, 150))
	draw.SimpleText(key, "mgbase_command", x, y, mwbWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	return w * 0.5 + (5 * scale)
end

local function drawBaseBinding(x, y, bind)
	local bindStr =  mw_input.GetBindKeyString(bind)
	local key = string.upper(bindStr != nil && bindStr || MWBLTL.Get("HUD_Key_NotBound") .. bind)
	local scale = ScrH() / 1080
	local size = 26 * scale

	surface.SetFont("mgbase_command")
	local w = math.max(surface.GetTextSize(key) + 10 * scale, size)

	draw.RoundedBox(4, x - (w * 0.5 - 1), y - (size * 0.5 * scale - 1), w, size * scale, Color(0, 0, 0, 150))
	draw.SimpleText(key, "mgbase_command", x, y, mwbWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	return w * 0.5 + (5 * scale)
end

function SWEP:DrawHUD()
	if self:GetOwner():InVehicle() then
		return
	end

	if (GetConVar("mgbase_hud_xhair"):GetBool() || GetConVar("mgbase_hud_xhairdot")) && !self:HasFlag("Customizing") then
		self:Crosshair()
	end

	if GetConVar("mgbase_debug_crosshair"):GetBool() then
		surface.SetDrawColor(0, 255, 0, 127)
		surface.DrawLine(ScrW() * 0.5 - 50, ScrH() * 0.5, ScrW() * 0.5 + 50, ScrH() * 0.5)
		surface.DrawLine(ScrW() * 0.5, ScrH() * 0.5 - 50, ScrW() * 0.5, ScrH() * 0.5 + 50)

		if self:GetSight() then
			local att = self:GetSight().m_Model:GetAttachment(mw_utils.LookupAttachmentCached(self:GetSight().m_Model, self:GetSight().Reticle.Attachment))
			pos = att.Pos:ToScreen()
			surface.SetDrawColor(0, 150, 255, 255)
			surface.DrawLine(pos.x - 25, pos.y, pos.x + 25, pos.y)
			surface.DrawLine(pos.x, pos.y - 25, pos.x, pos.y + 25)

			if self:GetSight().ReticleHybrid then
				att = self:GetSight().m_Model:GetAttachment(mw_utils.LookupAttachmentCached(self:GetSight().m_Model, self:GetSight().ReticleHybrid.Attachment))
				pos = att.Pos:ToScreen()
				surface.SetDrawColor(0, 150, 255, 255)
				surface.DrawLine(pos.x - 25, pos.y, pos.x + 25, pos.y)
				surface.DrawLine(pos.x, pos.y - 25, pos.x, pos.y + 25)
			end
		end

		local att = self:GetViewModel():GetAttachment(mw_utils.LookupAttachmentCached(self:GetViewModel(), self.ViewModelOffsets.Aim.AlignAttachment || "align"))
		if att then
			-- sight position
			local pos = att.Pos:ToScreen()
			surface.SetDrawColor(255, 0, 0, 127)
			surface.DrawLine(pos.x - 50, pos.y, pos.x + 50, pos.y)
			surface.DrawLine(pos.x, pos.y - 50, pos.x, pos.y + 50)

			-- sight angle
			local pos = (att.Pos + att.Ang:Forward() * 1000):ToScreen()
			local diffX, diffY = (pos.x - (ScrW() * 0.5)), (pos.y - (ScrH() * 0.5))
			local centerX, centerY = ScrW() * 0.5, ScrH() * 0.5
			surface.SetDrawColor(255, 0, 255, 255)
			surface.DrawLine(centerX, centerY, centerX + (diffX * 10), centerY + (diffY * 10))

			draw.SimpleText(MWBLTL.Get("HUD_Debug_Text3")..math.Round(diffX, 2)..", "..math.Round(diffY, 2), "mgbase_command", ScrW() * 0.2, ScrH() * 0.3 - 60, Color(200, 0, 50, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(MWBLTL.Get("HUD_Debug_Text1"), "DermaDefault", ScrW() * 0.2, ScrH() * 0.3 - 45, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(MWBLTL.Get("HUD_Debug_Text2"), "DermaDefault", ScrW() * 0.2, ScrH() * 0.3 - 30, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(MWBLTL.Get("HUD_Debug_Text4"), "DermaDefault", ScrW() * 0.2, ScrH() * 0.3 - 15, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end
		
		-- extra debug
		draw.SimpleText(MWBLTL.Get("HUD_Debug_Text5")..math.floor(self.m_swayLerp*100), "mgbase_command", ScrW() * 0.2, ScrH() * 0.3 + 10, Color(0, 0, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	end

	if GetConVar("mgbase_hud_firemode"):GetBool() && !self:HasFlag("Customizing") then
		self:DrawFiremode()
	end

	self:DrawTrackingHUD()
	self:DrawCommands()
end

local lastFiremodeIndex = 0
local transitionAnimation = 0
local bWasLowered = false
local bWasUnderbarrel = false

function SWEP:DrawFiremode()
	if (self:HasFlag("Holstering")) then
		return
	end
	
	-- current firemode (outline commented out)
	local x,y = ScrW() * 0.5, ScrH() * 0.8
	local scale = ScrH() / 1080

	transitionAnimation = math.min(transitionAnimation + 10 * RealFrameTime(), 1)
	local transitionPos = (24 * (1 - transitionAnimation) * scale)

	if (self:HasFlag("UsingUnderbarrel") && self:GetUnderbarrel() != nil) then
		if (!bWasUnderbarrel) then
			transitionAnimation = 0
		end
		
		if GetConVar("mgbase_hud_controls"):GetBool() then
			drawBaseBinding(x, y - 30, "underbarrel")
		end
		draw.SimpleTextOutlined(string.upper(self:GetUnderbarrel().Name), "mgbase_firemode", x, y + transitionPos, mwbWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
	elseif (!self:HasFlag("Lowered")) then
		local index = self:GetFiremode()

		if (lastFiremodeIndex != index) then
			transitionAnimation = 0
		end

		local name = string.upper(self.Firemodes[index].Name)
		draw.SimpleTextOutlined(name, "mgbase_firemode", x, y + transitionPos, mwbWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))

		-- next firemode
		if (self.Firemodes[index + 1]) then
			index = index + 1
		else
			index = 1
		end

		if GetConVar("mgbase_hud_controls"):GetBool() and (#self.Firemodes > 1) then
			drawBaseBinding(x, y - 30, "firemode")
		end
		
		if (self:GetFiremode() != index) then
			name = string.upper(self.Firemodes[index].Name)
			draw.SimpleText(name, "mgbase_firemode_alt", x, y + (24 * transitionAnimation * scale), mwbGrey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	else
		if (!bWasLowered) then
			transitionAnimation = 0
		end
		
		if GetConVar("mgbase_hud_controls"):GetBool() then
			drawBaseBinding(x, y - 30, "safety")
		end
		draw.SimpleTextOutlined("LOWERED", "mgbase_firemode", x, y + transitionPos, mwbWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
	end

	lastFiremodeIndex = self:GetFiremode()
	bWasUnderbarrel = self:HasFlag("UsingUnderbarrel")
	bWasLowered = self:HasFlag("Lowered")
end

local bipodIcon = Material("bipodicon")
local bipodDelta = 0

function SWEP:DrawBipod()
	if (!self:HasFlag("BipodDeployed")) then
		bipodDelta = 0
		return
	end

	bipodDelta = math.min(bipodDelta + RealFrameTime() * 5, 1)

	surface.SetAlphaMultiplier(bipodDelta)

	local mat = self:GetBipod().Icon
	surface.SetMaterial(bipodIcon)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(ScrW() * 0.5 - 15, ScrH() * 0.5 + 88 + (bipodDelta * 12), 32, 30)

	surface.SetAlphaMultiplier(1)
end

function SWEP:DrawCommands()
	local scale = ScrH() / 1080
	local x,y = ScrW() * 0.7, ScrH() * 0.5

	if !GetConVar("mgbase_hud_controls"):GetBool() then return end

	surface.SetAlphaMultiplier(self:GetAimDelta())
	if self:GetHybrid() then
		x = Lerp(self:GetAimDelta(), ScrW() * 0.75, ScrW() * 0.7)
		--y = Lerp(self:GetAimDelta(), ScrH() * 0.8, ScrH() * 0.5)

		local w = drawBaseBinding(x, y, "switchsights")
		draw.SimpleTextOutlined(": SWITCH SIGHTS", "mgbase_commandSecondary", x + w, y, mwbWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
	end

	x,y = ScrW() * 0.5, ScrH() * 0.7

	if (self:GetSight() != nil && self:GetSight().Optic != nil && self:GetAimModeDelta() <= self.m_hybridSwitchThreshold && !self:GetOwner():KeyDown(IN_SPEED) && GetConVar("mgbase_sv_breathing"):GetInt() > 0) then
		local w = drawBinding(x, y, "+speed")
		draw.SimpleTextOutlined(MWBLTL.Get("HUD_Commands_Text2"), "mgbase_commandSecondary", x, y + (30 * scale), mwbWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
	end

	surface.SetAlphaMultiplier(1)
	
	if self:GetFlashlightAttachment() != nil && !self:HasFlag("Customizing") then
		surface.SetFont("mgbase_commandSecondary")
		local tw = surface.GetTextSize(MWBLTL.Get("HUD_Commands_Text3")) * 0.5
		x,y = ScrW() * 0.5 - tw - 7, ScrH() * 0.9 - 150

		--if (self:CanChangeAimMode()) then
		local w = drawBinding(x, y + 100, "impulse 100")
		draw.SimpleTextOutlined(MWBLTL.Get("HUD_Commands_Text3"), "mgbase_commandSecondary", x + w, y + 100, mwbWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
		--end
	end
end

function SWEP:CanDrawCrosshair()
	return !self:HasFlag("Reloading")
		&& !self:HasFlag("Sprinting")
		&& !self:HasFlag("Holstering")
		&& !self:HasFlag("Drawing")
		&& !self:HasFlag("Lowered")
		&& !self:HasFlag("Inspecting")
		&& !self:HasFlag("Meleeing")
		&& GetConVar("mgbase_hud_xhair"):GetBool()
end

function SWEP:HUDShouldDraw(name)
	if (self:HasFlag("Customizing")) then
		return false
	end

	if (self:GetAimDelta() > 0 && name == "CHUDQuickInfo") then
		return false
	end

	if (self:HasFlag("Inspecting")) then
		return false
	end

	return true
end

function SWEP:DrawCrosshairSticks(x, y, cone)
	local aimDelta = self:GetTacStanceDelta() > 0 and self:GetTacStanceDelta() or (1 - self:GetAimDelta())

	surface.SetAlphaMultiplier(aimDelta)

	local crosshairAlpha = 200

	local color = string.ToColor(GetConVar("mgbase_hud_xhaircolor"):GetString())
	local scale = math.ceil(ScreenScale(2)) -- leadup to appropriate scaling for crosshairs
	local size = math.max(scale - bit.band(scale, 1), 4)
	surface.SetDrawColor(color.r, color.g, color.b, 255)

	--dot
	if GetConVar("mgbase_hud_xhairdot"):GetBool() then
		surface.SetMaterial(crosshairDotMaterial)
		surface.DrawTexturedRect(x - size * 0.5, y - size * 0.5, size, size)
	end

	if self:CanDrawCrosshair() then
		local dist = x - cone -- must be done here for accurate cone representation
		local drawRect = surface.DrawTexturedRectRotated
		local sizeW = size * 5
		local sizeH = size * 5

		surface.SetMaterial(normalXhairTickMaterial)

		if (self.Bullet.NumBullets > 1) then
			surface.SetMaterial(shotgunXhairTickMaterial)
		elseif self.Primary.BurstRounds > 1 then
			drawRect(x - dist, y, sizeW, size, 90)
			drawRect(x + dist, y, sizeW, size, 270)
			drawRect(x, y - dist, sizeH, size, 0)
			drawRect(x, y + dist, sizeH, size, 180)
			dist = dist-3
		end

		--right stick
		drawRect(x - dist, y, sizeW, sizeH, 90)

		--left stick
		drawRect(x + dist, y, sizeW, sizeH, 270)

		--down stick
		drawRect(x, y - dist, sizeH, sizeW, 0)

		--up stick
		if self.Primary.Automatic || self.Primary.BurstRounds > 1 || self.Bullet.NumBullets > 1 then
			drawRect(x, y + dist, sizeH, sizeW, 180)
		end
	end

	surface.SetAlphaMultiplier(1)
	surface.SetDrawColor(255, 255, 255, 255)
end

local ubTransitionAnimation = 0

function SWEP:DrawUnderbarrelCrosshair(x, y)
	local pulseDelta = math.abs(math.sin(RealTime() * 5))

	if (self:HasFlag("Holstering")) then
		ubTransitionAnimation = math.max(ubTransitionAnimation - 10 * RealFrameTime(), 0)
	else
		ubTransitionAnimation = math.min(ubTransitionAnimation + 10 * RealFrameTime(), 1)
	end

	local ubTransitionPos = 20 * (1 - ubTransitionAnimation)

	surface.SetAlphaMultiplier(ubTransitionAnimation)

	if (self:Clip2() <= 0) then
		surface.SetDrawColor(mwbRed.r, mwbRed.g, mwbRed.b, 50)
		surface.SetMaterial(blurMaterial)

		local size = 30 +  (pulseDelta * 10)
		surface.DrawTexturedRect(x - (size * 0.625), y + 90 - (size * 0.2) + 2 + ubTransitionPos, size * 1.25, size * 0.4)

		draw.SimpleTextOutlined(self:Clip2(), "mgbase_firemode", x, y + 90 + ubTransitionPos, mwbRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(175, 25, 15, Lerp(pulseDelta, 20, 50)))
	else
		draw.SimpleTextOutlined(self:Clip2(), "mgbase_firemode", x, y + 90 + ubTransitionPos, mwbWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
	end

	draw.SimpleTextOutlined(self:Ammo2(), "mgbase_firemode_alt", x, y + 115 + ubTransitionPos, self:Ammo2() <= 0 && mwbGreyRed || mwbWhiteish, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))

	surface.SetAlphaMultiplier(1)
	
	surface.SetAlphaMultiplier(mw_math.btn(self:CanDrawCrosshair()))

	local color = string.ToColor(GetConVar("mgbase_hud_xhaircolor"):GetString())
	surface.SetDrawColor(color.r, color.g, color.b, 200)
	surface.SetMaterial(self.Secondary.Crosshair)
	surface.DrawTexturedRect(x - 64, y - 64, 128, 128)

	surface.SetAlphaMultiplier(1)
end

function SWEP:Crosshair()
	local x, y = ScrW() * 0.5, ScrH() * 0.5
	local vec = EyePos() + (self:GetOwner():EyeAngles() + self:GetOwner():GetViewPunchAngles()):Forward()
	local cone = math.floor((vec + ( self:GetCone() * 0.1 * (self:GetOwner():EyeAngles() + self:GetOwner():GetViewPunchAngles()):Right() ) ):ToScreen().x)
	local pos = vec:ToScreen()

	if (Vector(x, 0, y):DistToSqr(Vector(pos.x, 0, pos.y)) > 2.25) and GetConVar("mgbase_hud_xhair"):GetFloat() == 1 then
		x,y = math.floor(pos.x), math.floor(pos.y)
	end

	if self:HasFlag("UsingUnderbarrel") && self.Secondary.Crosshair != nil && GetConVar("mgbase_hud_xhair"):GetBool() then
		self:DrawUnderbarrelCrosshair(x, y)
	else
		self:DrawCrosshairSticks(x, y, cone)
		ubTransitionAnimation = 0
	end

	self:DrawBipod(x, y)
end

local TrackingIndicator = Material("VGUI/target_tracked.png")
function SWEP:DrawTrackingHUD() 

	if !self.TrackingInfo then return end

	if self:GetTrackedEntity():IsValid() then 
		local dir = self:GetTrackedEntity():WorldSpaceCenter() - self:GetOwner():WorldSpaceCenter()
		dir = dir:Angle()
		local screen = self:GetTrackedEntity():WorldSpaceCenter():ToScreen()
		surface.SetDrawColor(255,0,0,math.Remap(self:CalcAngleDifference(self:GetOwner():EyeAngles(),dir), 0, 3.5, 255, 0))
		surface.DrawLine(0, screen.y,ScrW(),screen.y)
		surface.DrawLine(screen.x, 0,screen.x,ScrH())
	elseif self:GetPingedEntity():IsValid() then
		local dir = self:GetPingedEntity():WorldSpaceCenter() - self:GetOwner():WorldSpaceCenter()
		dir = dir:Angle()
		local screen = self:GetPingedEntity():WorldSpaceCenter():ToScreen()
		surface.SetMaterial(TrackingIndicator)
		surface.SetDrawColor(255,0,0,math.Remap(self:CalcAngleDifference(self:GetOwner():EyeAngles(),dir), 0, 3.5, 255, 0))
		surface.DrawTexturedRect(screen.x - 30, screen.y - 30, 60, 60) 
	end
end
--FONTS

local function CreateFonts()
	local scale = ScrH() / 1080

	surface.CreateFont("mgbase_firemode", {
		font = "BioSansW05-Light",
		size = 30 * scale,
		weight = 0
	})

	surface.CreateFont("mgbase_statName", {
		font = "BioSansW05-Light",
		size = 24,
		weight = 0
	})

	surface.CreateFont("mgbase_stat", {
		font = "BioSansW05-Light",
		size = 22,
		weight = 0
	})

	surface.CreateFont("mgbase_control", {
		font = "BioSansW05-Light",
		size = 22,
		weight = 0
	})

	surface.CreateFont("mgbase_statPositive", {
		font = "BioSansW05-Light",
		size = 22,
		weight = 0,
		blursize = 2
	})

	surface.CreateFont("mgbase_firemode_alt", {
		font = "BioSansW05-Light",
		size = 24 * scale,
		weight = 0
	})

	surface.CreateFont("mgbase_attSlot", {
		font = "Conduit ITC",
		size = 24 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_attSlotMenu", {
		font = "Conduit ITC",
		size = 24,
		weight = 500
	})

	surface.CreateFont("mgbase_attSlotAttachmentInUse", {
		font = "BioSansW05-Light",
		size = 24,
		weight = 0
	})

	surface.CreateFont("mgbase_attSlotAttachmentInUse_IsCosmetic", {
		font = "Conduit ITC",
		size = 20,
		weight = 500
	})

	surface.CreateFont("mgbase_attSlotAttachmentInUse:hover", {
		font = "BioSansW05-Light",
		size = 24,
		weight = 0,
		blursize = 1
	})

	surface.CreateFont("mgbase_attSlotMenu:hover", {
		font = "Conduit ITC",
		size = 24,
		weight = 500,
		blursize  = 2
	})

	surface.CreateFont("mgbase_utilityButton", {
		font = "BioSansW05-Light",
		size = 32,
		weight = 0
	})

	surface.CreateFont("mgbase_utilityButton:hover", {
		font = "BioSansW05-Light",
		size = 32,
		weight = 0,
		blursize = 1
	})

	surface.CreateFont("mgbase_attSlotMenu", {
		font = "Conduit ITC",
		size = 24,
		weight = 500
	})

	surface.CreateFont("mgbase_attName", {
		font = "Conduit ITC",
		size = 24 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_attTitle", {
		font = "BioSansW05-Light",
		size = 60 * scale,
		weight = 0
	})

	surface.CreateFont("mgbase_attTitle_blur", {
		font = "BioSansW05-Light",
		size = 60 * scale,
		weight = 0,
		blursize = 3
	})

	surface.CreateFont("mgbase_attWeaponName", {
		font = "Conduit ITC",
		size = 36 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_command", {
		font = "BioSansW05-Light",
		size = 26 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_commandSecondary", {
		font = "BioSansW05-Light",
		size = 22 * scale,
		weight = 500
	})

	surface.CreateFont("mgbase_presetSpawnMethod", {
		font = "BioSansW05-Light",
		size = 24,
		weight = 0
	})

	surface.CreateFont("mgbase_presetSpawnMethod_child", {
		font = "BioSansW05-Light",
		size = 20,
		weight = 0
	})
end
hook.Add("OnScreenSizeChanged", "MW_UpdateFonts", CreateFonts)
CreateFonts()
