AddCSLuaFile()

if (SERVER) then
    return
end

require("mw_utils")

local openSound = "mw/user_interface/main_iw8/iw8_wheel_popup.wav"
local detachSound = "mw/user_interface/main_iw8/iw8_mainmenu_deny_v1.wav"
local attachSound = "mw/user_interface/main_iw8/iw8_general_purchase_confirm_v1.wav"
local selectAttachmentSound = "mw/user_interface/mp/iw8_radar_drone_marker2.wav"
local closeAttachmentsSound = "mw/user_interface/mp/iw8_outofbounds_popup.wav"
local closeSound = "mw/user_interface/mp/iw8_scoreboard_popup_extra.wav"
local scrollSound = "mw/user_interface/ui_text_beep1.wav"
local hoverSounds = {
    "mw/user_interface/main_iw8/iw8_general_updownmovement1_v1.wav",
    "mw/user_interface/main_iw8/iw8_general_updownmovement2_v1.wav",
    "mw/user_interface/main_iw8/iw8_general_updownmovement3_v1.wav",
    "mw/user_interface/main_iw8/iw8_general_updownmovement4_v1.wav",
    "mw/user_interface/main_iw8/iw8_general_updownmovement5_v1.wav",
    "mw/user_interface/main_iw8/iw8_general_updownmovement6_v1.wav"
}
local hoverAttachmentSounds = {
    "mw/user_interface/main_iw8/iw8_mpmenu_tabsmove1_v1.wav",
    "mw/user_interface/main_iw8/iw8_mpmenu_tabsmove2_v1.wav",
    "mw/user_interface/main_iw8/iw8_mpmenu_tabsmove3_v1.wav",
    "mw/user_interface/main_iw8/iw8_mpmenu_tabsmove4_v1.wav",
    "mw/user_interface/main_iw8/iw8_mpmenu_tabsmove5_v1.wav",
    "mw/user_interface/main_iw8/iw8_mpmenu_tabsmove6_v1.wav"
}
local selectCategorySound = "mw/user_interface/main_iw8/iw8_leavelobby_alert_v1.wav"
local presetSound = "mw/user_interface/aar/ui_aar_progress_circle_stop.wav"
local savePresetSound = "mw/user_interface/aar/ui_aar_operator_complete_reveal.wav"
local removePresetSound = "mw/user_interface/mp/iw8_restock_lethals_v1.wav"
local resetSound = "mw/user_interface/mp/iw8_restock_lethals_v1.wav"
local randomSound = "mw/user_interface/mp/mp_ui_splash_notify_01.wav"
local favoriteSound = "mw/user_interface/ui_motiontracker_pong1.wav"
local unfavoriteSound = "mw/user_interface/ui_motiontracker_pong2.wav"
local blurMaterial = Material("mg/blur")
local buttonGlowMaterial = Material("mg/buttonglow")
local removeButtonGlowMaterial = Material("mg/removeattachmentbutton")
local customizeMenuOpenMaterial = Material("mg/customizemenuopen")
local removeAttachmentMaterial = Material("mg/removeattachment")
local removePresetMaterial = Material("mg/removenew")
local closeAttachmentsMaterial = Material("mg/closeattachments")
local rightClickMaterial = Material("mg/rightclick")
local cursorGlowMaterial = Material("mg/cursorglow")
local presetsMaterial = Material("mg/presets")
local defaultPresetMaterial = Material("mg/defaultpreset")
local addPresetMaterial = Material("mg/addpreset")
local resetMaterial = Material("mg/clear")
local randomMaterial = Material("mg/random")
local favoriteMaterial = Material("mg/favorite")
local bookmarkMaterial = Material("mg/bookmark")

local whiteColor = Color(255, 255, 255, 200)
local greyColor = Color(255, 255, 255, 150)
local blackColor = Color(0, 0, 0, 150)
local shadowColor = Color(0, 0, 0, 20)
local backgroundErrorColor = Color(50, 0, 0, 150)
local errorColor = Color(150, 0, 0, 255)
local greenColor = Color(140, 198, 109, 255)
local redColor = Color(169, 63, 44, 255)
local yellowColor = Color(254, 170, 74, 150)
local blueColor = Color(121, 217, 255, 150)
local textColor1 = Color(89, 121, 133, 255)
local textColor2 = Color(52, 91, 120, 255)

local MWBLTLXCoordinate = {
    xOffset = {
        ["de"] = 290,
        ["en"] = 280,
        ["es-ES"] = 400,
        ["fr"] = 420,
        ["pt-BR"] = 340,
        ["ru"] = 340,
        ["th"] = 350,
        ["zh-CN"] = 240,
        ["zh-TW"] = 240
    },
    xLeftOffset = {
        ["de"] = 50,
        ["en"] = 0,
        ["es-ES"] = 125,
        ["fr"] = 150,
        ["pt-BR"] = 100,
        ["ru"] = 75,
        ["th"] = 125,
        ["zh-CN"] = 0,
        ["zh-TW"] = 0
    }
}

function getLanguageCoord(coordType)
    local lang = GetConVar("gmod_language"):GetString()
	return MWBLTLXCoordinate[coordType][lang] || MWBLTLXCoordinate[coordType]["en"]
end

--opening the menu if no mgbase_customize bind (context menu)

local function closeCustomizationMenu()
    if (!IsValid(MW_CUSTOMIZEMENU)) then
        return
    end

    gui.EnableScreenClicker(false)
    surface.PlaySound(closeSound)
    
    if (IsValid(MW_CUSTOMIZEMENU)) then
        MW_CUSTOMIZEMENU:Remove()
    end
end

local function validWeapon(weapon)
    return IsValid(weapon) && weapon:GetOwner() == LocalPlayer() && weapon:HasFlag("Customizing")
end

--removing panel if already there (reload code)
if IsValid(MW_CUSTOMIZEMENU) then
    MW_CUSTOMIZEMENU:Remove()
end

MW_CUSTOMIZEMENU = nil

local function makeCloseButton(panel, panelToClose)
    local closeButton = vgui.Create("DButton", panel)
    closeButton:Dock(RIGHT)
    closeButton:SetSize(40, 40)
    closeButton:SetText("")
    
    local closeButtonDownColor = Color(100, 100, 100, 200)
    function closeButton:Paint(w, h)
        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)
        self:DrawOutlinedRect()
        
        surface.SetMaterial(closeAttachmentsMaterial)
        
        local color = self:IsDown() && closeButtonDownColor || whiteColor
        surface.SetDrawColor(color.r, color.g, color.b, color.a)
        surface.DrawTexturedRect(5, 5, w - 10, h - 10)
    end
    
    function closeButton:DoClick()
        surface.PlaySound(closeAttachmentsSound)
        panelToClose:Remove()
    end
    
    return closeButton
end

local function createRightButtonControl(panel, name)
    if IsValid(panel.controls) then return end

    local xOffset = -25
    local ml, mt, mr, mb = panel:GetDockMargin()
    local posx, posy = panel:LocalToScreen(panel:GetX(), panel:GetY())
    posy = posy - mt
    posx = posx - 150

    panel.controls = vgui.Create("DPanel")
    panel.controls:SetPos(posx, posy)
    panel.controls:SetSize(150, panel:GetTall())
    panel.controls:NoClipping(true)
    panel.controls:SetMouseInputEnabled(false)
    panel.controls.parent = panel

    function panel.controls:Think()
        if !IsValid(self.parent) then
            self:Remove()
        end
        xOffset = math.Approach(xOffset, 0, 250 * RealFrameTime())
    end

    function panel.controls:Paint(w, h)
        surface.SetDrawColor(0, 0, 0, 150)
        surface.SetMaterial(buttonGlowMaterial)
        surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, h * 0.9, w, 90)

        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)
        surface.SetMaterial(rightClickMaterial)
        surface.DrawTexturedRect(w - 32 + xOffset, h * 0.5 - 15, 20, 30)
        
        draw.SimpleText(name, "mgbase_control", w - 42 + xOffset, h * 0.5, whiteColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
end

local function removeButtonControls(panel)
    if IsValid(panel.controls) then
        panel.controls:Remove()
    end
end

local function makeScrollBar(panel, dock)
    local scroll = vgui.Create("DScrollPanel", panel)
    scroll:Dock(FILL)
    
    local sbar = scroll:GetVBar()
    sbar:Dock(dock)
    sbar.LastScrollValue = sbar:GetOffset()
    function sbar:Paint(w, h)
    end
    function sbar:Think()
        if (self:GetOffset() != self.LastScrollValue && math.abs(self:GetOffset() - self.LastScrollValue) > 10) then
            surface.PlaySound(scrollSound)
            self.LastScrollValue = self:GetOffset()
        end
    end
    function sbar.btnUp:Paint(w, h)
        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)
        surface.DrawRect(w * 0.5 - 2, 0, 4, h)
    end
    function sbar.btnDown:Paint(w, h)
        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)
        surface.DrawRect(w * 0.5 - 2, 0, 4, h)
    end
    function sbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)
        surface.DrawRect(w * 0.5 - 1, 10, 2, h - 20)
    end
    
    return scroll
end

local function makePopupMenu()
    local background = vgui.Create("DButton", MW_CUSTOMIZEMENU)
    background:SetPos(0, 0)
    background:SetSize(ScrW(), ScrH())
    background:SetText("")
    background:Center()
    background:SetCursor("arrow")
    
    function background:Think()
        if (LocalPlayer():KeyDown(IN_USE)) then
            self:Remove()
        end
    end
    
    function background:Paint(width, height)
        Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
        
        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, 3)
        surface.SetMaterial(cursorGlowMaterial)
        surface.DrawTexturedRect(gui.MouseX() - 175, gui.MouseY() - 175, 350, 350)
    end
    
    function background:DoClick()
        surface.PlaySound(closeAttachmentsSound)
        self:Remove()
    end
    
    return background
end

local function createUtilityButton(parent, icon, text)
    local button = vgui.Create("DButton", parent)
    button:SetText("")
    button.HoverDelta = 0
    button.ClickDelta = 0
    button.bWasHovered = false
    function button:Paint(width, height)
        if (self:IsHovered()) then
            self.HoverDelta = math.Approach(self.HoverDelta, 1, math.min(10 * RealFrameTime(), 0.1))
            
            if (!self.bWasHovered) then
                surface.PlaySound(hoverAttachmentSounds[math.random(1, #hoverAttachmentSounds)])
            end
            
            self.bWasHovered = true
        else
            self.HoverDelta = math.Approach(self.HoverDelta, 0, math.min(10 * RealFrameTime(), 0.1))
            self.bWasHovered = false
        end
        
        if (self:IsDown()) then
            self.ClickDelta = math.Approach(self.ClickDelta, 1, math.min(10 * RealFrameTime(), 0.1))
        else
            self.ClickDelta = math.Approach(self.ClickDelta, 0, math.min(10 * RealFrameTime(), 0.1))
        end
        
        local currentColor = blackColor
        
        --background
        surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a)
        self:DrawFilledRect()
        
        currentColor = whiteColor
        
        --click hold
        surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * 0.15 * self.ClickDelta)
        self:DrawFilledRect()
        
        --border hover
        surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, Lerp(self.HoverDelta, 45, 255))
        self:DrawOutlinedRect()
        
        --glow hover
        surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * Lerp(self.ClickDelta, 0.1, 0))
        surface.SetMaterial(cursorGlowMaterial)
        local x, y = self:ScreenToLocal(gui.MouseX(), gui.MouseY())
        surface.DrawTexturedRect(x - 70, y - 70, 140, 140)
        
        --icon
        if (icon != nil) then
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, Lerp(self.HoverDelta, 150, 255))
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(10, 10, width - 20, height - 20)
        end
        
        if (text != nil && text != "") then
            local hoverColor = Color(currentColor.r, currentColor.g, currentColor.b, currentColor.a * self.HoverDelta)
            draw.SimpleText(text, "mgbase_utilityButton:hover", width * 0.5, height * 0.5, hoverColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(text, "mgbase_utilityButton", width * 0.5, height * 0.5, currentColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, shadowColor)
        end
    end
    
    return button
end

local function closePresetInfo(panel)
    if (!IsValid(panel.hover)) then
        return
    end
    
    panel.hover:Remove()
end

local function openPresetInfo(panel, preset)
    if (preset == nil || preset.Attachments == nil) then
        return
    end
    
    local atts = {}

    for _, attClass in pairs(preset.Attachments) do
        if (MW_ATTS[attClass] != nil) then
            table.insert(atts, attClass)
        end
    end

    if !IsValid(panel.hover) then
        panel.hover = vgui.Create("DPanel")
        panel.hover.parent = panel
        local x, y = panel:LocalToScreen(panel:GetPos())
        panel.hover:SetPos(ScrW(), ScrH())
        panel.hover:SetSize(400, 50 * (#atts + 1))
        panel.hover:SetMouseInputEnabled(false)
        panel.hover:NoClipping(true)

        function panel.hover:Think()
            if (!IsValid(self.parent)) then
                self:Remove()
                return
            end
            
            self:SetPos(math.Clamp(gui.MouseX() + 30, 0, ScrW() - self:GetWide()), math.Clamp(gui.MouseY() + 30, 0, ScrH() - self:GetTall()))
        end

        function panel.hover:Paint(w, h)
        end

        function panel.hover:PaintOver(w, h)
            surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)
            
            --corner lines
            surface.DrawLine(-5, -5, -5, 5)
            surface.DrawLine(-5, -5, 5, -5)
        end
        
        local attsGrid = vgui.Create("DGrid", panel.hover)
        attsGrid:SetPos(0, 0)
        attsGrid:SetCols(1)
        attsGrid:SetColWide(panel.hover:GetWide())
        attsGrid:SetRowHeight(50)
        attsGrid:Dock(FILL)
        
        for i, attachmentClass in pairs(atts) do
            local attPanel = vgui.Create("DPanel")
            attPanel:SetSize(attsGrid:GetColWide(), attsGrid:GetRowHeight())

            function attPanel:Paint(w, h)
                surface.SetDrawColor(blackColor.r, blackColor.g, blackColor.b, blackColor.a)
                surface.DrawRect(5, 5, 40, 40)

                --glow hover
                surface.SetDrawColor(blackColor.r, blackColor.g, blackColor.b, blackColor.a)
                surface.SetMaterial(buttonGlowMaterial)
                surface.DrawTexturedRectRotated(150, 25, 40, 200, 270)

                local attachment = MW_ATTS[attachmentClass]
                local attColor = attachment.UIColor || whiteColor

                surface.SetDrawColor(attColor.r, attColor.g, attColor.b, 255)
                surface.SetMaterial(attachment.Icon)
                surface.DrawTexturedRect(8, h * 0.5 - 17, 35, 35)
                
                draw.SimpleText(attachment.Name, "mgbase_stat", 60, h * 0.5, attColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                local c = Color(attColor.r, attColor.g, attColor.b, attColor.a * 0.5)
                draw.SimpleText(attachment.Name, "mgbase_statPositive", 60, h * 0.5, c, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            
            attsGrid:AddItem(attPanel)
        end
    end
end

local function createPresetPanel(preset, wepclass)
    --panel to hold button
    local presetPanel = vgui.Create("DPanel")
    function presetPanel:Paint(w, h)
    end
    
    local but = vgui.Create("DButton", presetPanel)
    but:SetText("")
    but:Dock(FILL)
    but:DockMargin(0, 5, 0, 5)
    but.HoverDelta = 0
    but.ClickDelta = 0
    but.bWasHovered = false
    but.FavoriteDelta = 0
    but.bWasFavorite = preset != nil && mw_utils.IsAssetFavorite(wepclass, preset.ClassName) || false
    
    function but:IsAllowed()
        return true
    end

    function but:Paint(width, height)
        if self:IsHovered() then
            self.HoverDelta = math.Approach(self.HoverDelta, 1, math.min(10 * RealFrameTime(), 0.1))
            
            if !self.bWasHovered then
                surface.PlaySound(hoverAttachmentSounds[math.random(1, #hoverAttachmentSounds)])
            end
            
            self.bWasHovered = true
        else
            self.HoverDelta = math.Approach(self.HoverDelta, 0, math.min(10 * RealFrameTime(), 0.1))
            self.bWasHovered = false
        end
        
        if self:IsDown() then
            self.ClickDelta = math.Approach(self.ClickDelta, 1, math.min(10 * RealFrameTime(), 0.1))
        else
            self.ClickDelta = math.Approach(self.ClickDelta, 0, math.min(10 * RealFrameTime(), 0.1))
        end

        self.FavoriteDelta = math.Approach(self.FavoriteDelta, 0, math.min(3 * RealFrameTime(), 0.3))
        
        local bAllowed = self:IsAllowed()
        local currentColor = bAllowed && blackColor || backgroundErrorColor
        
        --background
        surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a)
        self:DrawFilledRect()
        
        currentColor = bAllowed && whiteColor || errorColor
        
        --click hold
        surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * 0.15 * self.ClickDelta)
        self:DrawFilledRect()
        
        --border hover
        surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * math.max(self.HoverDelta, 0.15))
        self:DrawOutlinedRect()
        
        --glow hover
        surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * 0.1 * (self.HoverDelta - self.ClickDelta))
        surface.SetMaterial(buttonGlowMaterial)
        surface.DrawTexturedRect(0, height * 0.5, width, height * 0.5)
        
        --preset name
            
        if self.FavoriteDelta > 0 then
            surface.SetDrawColor(yellowColor.r, yellowColor.g, yellowColor.b, yellowColor.a * self.FavoriteDelta)
            self:DrawFilledRect()
        end

        if preset == nil then return end

        local hoverColor = Color(currentColor.r, currentColor.g, currentColor.b, currentColor.a * self.HoverDelta)
        draw.SimpleText(preset.Name, "mgbase_attSlotAttachmentInUse:hover", width * 0.5 - 2, height * 0.5, hoverColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(preset.Name, "mgbase_attSlotAttachmentInUse", width * 0.5 - 2, height * 0.5, currentColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, shadowColor)

        if !preset._bUserGenerated then
            surface.SetDrawColor(255, 255, 255, Lerp(self.HoverDelta, 5, 50))
            surface.SetMaterial(defaultPresetMaterial)
            surface.DrawTexturedRect(width * 0.5 - 25, height * 0.5 - 20, 50, 40)
        end

        local bFav = mw_utils.IsAssetFavorite(wepclass, preset.ClassName)

        if bFav != self.bWasFavorite then
            self.FavoriteDelta = bFav && 1 || 0
            self.bWasFavorite = bFav
        end

        if bFav then
            surface.SetDrawColor(yellowColor.r, yellowColor.g, yellowColor.b, yellowColor.a)
            surface.SetMaterial(favoriteMaterial)
            surface.DrawTexturedRect(-1, -1, 16, 16)
        end
    end

    function but:PaintOver(width, height)
    end

    function but:Think()
        if self:IsHovered() then
            openPresetInfo(self, preset)
            if preset != nil then
                createRightButtonControl(self, MWBLTL.Get("CuzMenu_Nom_Text1"))
            end
        else
            closePresetInfo(self)
            removeButtonControls(self)
        end
    end

    return presetPanel, but
end

local function openPresetsMenu(weapon)
    local background = makePopupMenu()
    local presets = mw_utils.GetPresetsForSWEP(weapon:GetClass())

    table.sort(presets, function(a, b)
        local aFav = mw_utils.IsAssetFavorite(weapon:GetClass(), a.ClassName)
        local bFav = mw_utils.IsAssetFavorite(weapon:GetClass(), b.ClassName)

        if (!aFav && bFav) then
            return false
        elseif (aFav && !bFav) then
            return true
        elseif ((aFav && bFav) || (!aFav && !bFav)) then
            if (!a._bUserGenerated && b._bUserGenerated) then
                return true
            elseif (a._bUserGenerated && !b._bUserGenerated) then
                return false
            elseif ((a._bUserGenerated && b._bUserGenerated) || (!a._bUserGenerated && !b._bUserGenerated)) then
                return a.Name < b.Name
            end
        end
    end)
    
    local menu = vgui.Create("DPanel", background)
    menu:SetSize(400, ScrH() * 0.6)
    menu:Center() 
    
    local x,y = menu:GetPos()
    menu:SetPos(x, ScrH())
    menu:MoveTo(x, y, 0.1, 0, -1)
    
    function menu:Paint(width, height)
    end
    
    local headerPanel = vgui.Create("DPanel", menu)
    headerPanel:SetText("")
    headerPanel:Dock(TOP)
    headerPanel:SetSize(0, 40)
    headerPanel:DockMargin(20, 0, 20, 10)
    function headerPanel:Paint(w, h)
        draw.SimpleText(MWBLTL.Get("CuzMenu_Nom_Text2"), "mgbase_attSlotMenu", 0, h * 0.5, whiteColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end 
    
    makeCloseButton(headerPanel, background)
    
    --ADD PRESET
    local addPresetPanel, addBut = createPresetPanel(nil, nil)
    addPresetPanel:SetParent(menu)
    addPresetPanel:SetSize(0, 80)
    addPresetPanel:SetPos(20, 40)
    addPresetPanel:DockMargin(20, 0, 20, 0)
    addPresetPanel:Dock(TOP)
    
    function addBut:IsAllowed()
        if (!validWeapon(weapon)) then
            return
        end
        
        for _, att in pairs(weapon:GetAllAttachmentsInUse()) do
            if (att.Index > 1) then
                return true
            end
        end
        
        return false
    end
    
    local presetInputRequirement = vgui.Create("EditablePanel", addBut)
    presetInputRequirement:Dock(FILL)
    presetInputRequirement:SetVisible(false)
    function presetInputRequirement:Paint()
    end
    
    function presetInputRequirement:Think()
        local x, y = addBut:LocalToScreen(addBut:GetX(), addBut:GetY())
        self:SetPos(x, y - 5) --stupid fucking workaround because of SILENCE
    end
    
    local presetInput = vgui.Create("DTextEntry", presetInputRequirement)
    presetInput:Dock(FILL)
    presetInput:DockMargin(10, 0, 10, 0)
    presetInput:SetTabbingDisabled(true)
    presetInput:SetPaintBackground(false)
    presetInput:SetMultiline(false)
    presetInput:SetFont("mgbase_attSlotAttachmentInUse")
    presetInput:SetCursorColor(Color(255, 255, 255, 255))
    presetInput:SetPlaceholderText(MWBLTL.Get("CuzMenu_Nom_Text3"))
    presetInput:SetEditable(true)
    presetInput:SetTextColor(whiteColor)
    
    function presetInput:AllowInput(char)
        return #self:GetText() >= 32
    end
    
    function presetInput:OnLoseFocus()
        self:GetParent():SetVisible(false)
        self:SetText("")
    end
    
    function presetInput:OnEnter()
        local atts = {}
        
        for slot, att in pairs(weapon:GetAllAttachmentsInUse()) do
            if (att.Index > 1) then
                atts[#atts + 1] = att.ClassName
            end
        end
        
        mw_utils.SavePreset(weapon:GetClass(), self:GetText(), atts)
        surface.PlaySound(savePresetSound)
        background:Remove()
        openPresetsMenu(weapon)
    end

    local oldPaint = addBut.Paint
    function addBut:Paint(width, height)
        oldPaint(self, width, height)
        
        local bAllowed = self:IsAllowed()
        local currentColor = bAllowed && whiteColor || errorColor
        
        --icon
        if (!presetInputRequirement:IsVisible()) then
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, Lerp(self.HoverDelta, 150, 255))
            surface.SetMaterial(addPresetMaterial)
            surface.DrawTexturedRect(width * 0.5 - 20, 15, 40, 40)
        end
    end
    
    function addBut:DoClick()
        if (!self:IsAllowed()) then
            surface.PlaySound(presetSound)
            return
        end
        
        presetInputRequirement:SetVisible(true)
        presetInputRequirement:MakePopup()
        presetInput:RequestFocus()
    end
    
    --DIVIDER BETWEEN ADD PRESET AND PRESETS
    local divider = vgui.Create("DPanel", menu)
    divider:SetSize(0, 1)
    divider:Dock(TOP)
    divider:DockMargin(20, 5, 20, 5)
    function divider:Paint(w, h)
        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b)
        self:DrawFilledRect()
    end
    
    local scroll = makeScrollBar(menu, RIGHT)
    
    local presetsGrid = vgui.Create("DGrid", scroll)
    presetsGrid:SetPos(0, 0)
    presetsGrid:SetCols(1)
    presetsGrid:SetColWide(menu:GetWide())
    presetsGrid:SetRowHeight(80)
    presetsGrid:Dock(FILL)
    presetsGrid:DockMargin(20, 0, 0, 0)
     
    for _, preset in pairs(presets) do
        local presetPanel, but = createPresetPanel(preset, weapon:GetClass())
        presetPanel:SetSize(presetsGrid:GetColWide() * 0.9, presetsGrid:GetRowHeight())

        function but:DoRightClick()
            if (!mw_utils.IsAssetFavorite(weapon:GetClass(), preset.ClassName)) then
                mw_utils.FavoriteAsset(weapon:GetClass(), preset.ClassName)
                surface.PlaySound(favoriteSound)
            else
                mw_utils.UnfavoriteAsset(weapon:GetClass(), preset.ClassName)
                surface.PlaySound(unfavoriteSound)
            end
        end
            
        function but:DoClick()
            if (!self:IsAllowed()) then
                surface.PlaySound(selectAttachmentSound)
                return
            end
            
            mw_utils.LoadPreset(weapon, preset)
            
            surface.PlaySound(presetSound)

            if (preset.UISound != nil) then
                surface.PlaySound(preset.UISound)
            end
            
            background:Remove()
        end

        if (preset._bUserGenerated) then
            local removeButton = vgui.Create("DButton", but)
            removeButton:SetSize(24, 24)
            removeButton:SetPos(330, 5)
            removeButton:SetText("")
            removeButton.HoverDelta = 0
            removeButton.ClickDelta = 0
            removeButton.bWasHovered = false

            function removeButton:DoClick()
                mw_utils.RemovePreset(preset.ClassName)
                background:Remove()
                surface.PlaySound(removePresetSound)
                openPresetsMenu(weapon)
            end

            function removeButton:Paint(w, h)
                if (self:IsHovered()) then
                    self.HoverDelta = math.Approach(self.HoverDelta, 1, math.min(10 * RealFrameTime(), 0.1))
                    
                    if (!self.bWasHovered) then
                        surface.PlaySound(hoverAttachmentSounds[math.random(1, #hoverAttachmentSounds)])
                    end
                    
                    self.bWasHovered = true
                else
                    self.HoverDelta = math.Approach(self.HoverDelta, 0, math.min(10 * RealFrameTime(), 0.1))
                    self.bWasHovered = false
                end
                
                if (self:IsDown()) then
                    self.ClickDelta = math.Approach(self.ClickDelta, 1, math.min(10 * RealFrameTime(), 0.1))
                else
                    self.ClickDelta = math.Approach(self.ClickDelta, 0, math.min(10 * RealFrameTime(), 0.1))
                end

                surface.SetMaterial(removePresetMaterial)
                surface.SetDrawColor(redColor.r, redColor.g, redColor.b, Lerp(self.HoverDelta * 0.25 + self.ClickDelta * 0.75, redColor.a * 0.1, redColor.a))
                self:DrawTexturedRect()
            end
        end
        
        presetsGrid:AddItem(presetPanel)
    end

    --SPAWN METHOD
    local presetSpawnPanel = vgui.Create("DPanel", menu)
    presetSpawnPanel:Dock(BOTTOM)
    presetSpawnPanel:SetSize(0, 50)
    presetSpawnPanel:DockMargin(0, 10, 0, 0)
    function presetSpawnPanel:Paint(w, h)
    end

    local options = {[0] = MWBLTL.Get("CuzMenu_Method_Text1"), [1] = MWBLTL.Get("CuzMenu_Method_Text2"), [2] = MWBLTL.Get("CuzMenu_Method_Text3"), [3] = MWBLTL.Get("CuzMenu_Method_Text4")}
    local method = math.Clamp(GetConVar("mgbase_presetspawnmethod"):GetInt(), 0, 3)

    local presetSpawnLabel = vgui.Create("DLabel", presetSpawnPanel)
    presetSpawnLabel:Dock(LEFT)
    presetSpawnLabel:DockMargin(20, 5, 0, 5)
    presetSpawnLabel:SetFont("mgbase_presetSpawnMethod")
    presetSpawnLabel:SetTextColor(whiteColor)
    presetSpawnLabel:SetText(MWBLTL.Get("CuzMenu_Nom_Text4"))
    presetSpawnLabel:SizeToContents()

    local presetSpawnCombo = vgui.Create("DComboBox", presetSpawnPanel)
    presetSpawnCombo:SetSize(200, 10)
    presetSpawnCombo:SetValue(options[method])
    presetSpawnCombo:SetFont("mgbase_presetSpawnMethod")
    presetSpawnCombo:SetTextColor(whiteColor)
    presetSpawnCombo:Dock(RIGHT)
    presetSpawnCombo:DockMargin(0, 5, 20, 5)
    for i, op in pairs(options) do
        presetSpawnCombo:AddChoice(op)
    end

    function presetSpawnCombo:OnSelect(index, value)
        GetConVar("mgbase_presetspawnmethod"):SetInt(index - 1)
    end

    function presetSpawnCombo:Paint(w, h)
        surface.SetDrawColor(blackColor.r, blackColor.g, blackColor.b, blackColor.a)
        self:DrawFilledRect()

        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a * 0.25)
        self:DrawOutlinedRect()
    end

    function presetSpawnCombo:OnMenuOpened(menu)
        function menu:Paint(w, h)
            surface.SetDrawColor(blackColor.r, blackColor.g, blackColor.b, blackColor.a)
            self:DrawFilledRect()
        end

        for i = 1, #options + 1, 1 do
            local child = menu:GetChild(i)
            child:SetFont("mgbase_presetSpawnMethod_child")
            child:SetTextColor(whiteColor)
            child.HoverDelta = 0
            function child:Paint(w, h)
                if (self:IsHovered()) then
                    self.HoverDelta = math.Approach(self.HoverDelta, 1, 8 * FrameTime())
                else
                    self.HoverDelta = math.Approach(self.HoverDelta, 0, 8 * FrameTime())
                end

                surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, self.HoverDelta * 15)
                self:DrawFilledRect()
            end
        end
    end
end

local function openStatsInfo(panel, attachment, weapon)
    if attachment.Breadcrumbs == nil then --from attachments selection list
        weapon:MakeBreadcrumbsForAttachment(attachment)
    end
    
    local count = table.Count(attachment.Breadcrumbs)
    
    if attachment.Breadcrumbs == nil || count <= 0 then return end

    if !IsValid(panel.hover) then
        panel.hover = vgui.Create("DPanel")
        panel.hover.parent = panel
        local x, y = panel:LocalToScreen(panel:GetPos())
        panel.hover:SetPos(ScrW(), ScrH())
        panel.hover:SetSize(400, 50 * math.max(count, 1))
        panel.hover:SetMouseInputEnabled(false)
        panel.hover:NoClipping(true)
        function panel.hover:Think()
            if !IsValid(self.parent) then
                self:Remove()
                return
            end
            
            self:SetPos(math.Clamp(gui.MouseX() + 30, 0, ScrW() - self:GetWide()), math.Clamp(gui.MouseY() + 30, 0, ScrH() - self:GetTall()))
        end
        function panel.hover:Paint(w, h)
            if count <= 0 then return end
            
            surface.SetMaterial(blurMaterial)
            surface.SetDrawColor(255, 255, 255, 255)
            
            for i = 1, 10, 1 do
                render.UpdateScreenEffectTexture()
                self:DrawTexturedRect()
            end
            
            surface.SetDrawColor(blackColor.r, blackColor.g, blackColor.b, blackColor.a)
            self:DrawFilledRect()
            
            --white fade
            surface.SetMaterial(buttonGlowMaterial)
            surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a * 0.02)
            surface.DrawTexturedRect(0, h * 0.5, w, h * 0.5)
        end
        function panel.hover:PaintOver(w, h)
            surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)

            --long line on the right
            surface.DrawLine(w + 5, 15, w + 5, h - 15)
            
            --corner lines
            surface.DrawLine(-5, -5, -5, 5)
            surface.DrawLine(-5, -5, 5, -5)
        end

        local statsGrid = vgui.Create("DGrid", panel.hover)
        statsGrid:SetPos(0, 0)
        statsGrid:SetCols(1)
        statsGrid:SetColWide(panel.hover:GetWide())
        statsGrid:SetRowHeight(50) 
        statsGrid:Dock(FILL)
        
        for i, crumb in pairs(attachment.Breadcrumbs) do
            local statPanel = vgui.Create("DPanel")
            statPanel:SetSize(statsGrid:GetColWide(), statsGrid:GetRowHeight())
            function statPanel:Paint(w, h)
                if (!validWeapon(weapon)) then
                    return
                end
                
                local statInfo = weapon.StatInfo[crumb.statInfo]
                draw.SimpleText(statInfo.Name, "mgbase_statName", 10, h * 0.5, whiteColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                
                local bPositive = weapon:GetStatPositive(crumb.Original, crumb.Current, crumb.statInfo)
                local statText = math.Round(crumb.Current - crumb.Original, 1)
                if (statInfo.ShowPercentage) then
                    statText = math.Round((crumb.Current - crumb.Original) / crumb.Original * 100, 1).."%"
                end
                
                statText = (bPositive && "⮝ " || "⮟ ")..statText
                local statColor = bPositive and greenColor or redColor
                draw.SimpleText(statText, "mgbase_stat", w - 10, h * 0.5, statColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                
                local c = Color(statColor.r, statColor.g, statColor.b, statColor.a * 0.5)
                draw.SimpleText(statText, "mgbase_statPositive", w - 10, h * 0.5, c, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
            
            statsGrid:AddItem(statPanel)
        end

        if attachment.CustomText then

            local panelWidth = statsGrid:GetColWide()
            local text = attachment.CustomText
            local splitText = string.Split(text, " ")

            local textPanel = vgui.Create("DPanel")
            textPanel:SetSize(statsGrid:GetColWide(), statsGrid:GetRowHeight())
            textPanel.WrappedText = {}

            local curString = ""
            local prevString = ""
            local count = 1

            for k, v in pairs(splitText) do 

                curString = curString..v.." "
                local w, h = surface.GetTextSize(curString)
                local w2, h2 = surface.GetTextSize(v)

                if w > panelWidth - 10 then 
                    textPanel.WrappedText[count] = prevString
                    curString = v.." "
                    count = count + 1
                    panel.hover:SetTall(panel.hover:GetTall() + 50)
                end 
                prevString = curString

            end
            textPanel.WrappedText[count] = curString

            function textPanel:Paint(w, h)

                if !self.WrappedText then return end

                for k, v in pairs(self.WrappedText) do
                    local old = DisableClipping( true )
                    draw.SimpleText(v, "mgbase_statName", 10 , (h * 0.5) + ((k - 1) * 50), attachment.CustomTextColor || whiteColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    DisableClipping( old )
                end
                        
                local bPositive = true
            end

            panel.hover:SetTall(panel.hover:GetTall() + 50)
            statsGrid:AddItem(textPanel)
        end

    end
end

local function closeStatsInfo(panel)
    if (!IsValid(panel.hover)) then
        return
    end
    
    panel.hover:Remove()
end

local categoryScrollBarValue = {}

local function openCategoryList(categoryName, weapon, buttonFrom)
    local background = makePopupMenu()
    local atts = {}
    
    for slot, attachmentClasses in pairs(weapon.Customization) do
        for i, attachmentClass in pairs(attachmentClasses) do
            if MW_ATTS[attachmentClass] == nil then continue end
            
            local att = table.Copy(weapon:GetStoredAttachment(attachmentClass))
            if att.Category == categoryName && i > 1 && MW_ATTS[attachmentClass] != nil && weapon:GetAttachmentInUseForSlot(slot).ClassName != attachmentClass then
                atts[#atts + 1] = att
            end
        end
    end
    
    if #atts <= 0 then
        background:Remove()
        return
    end
    
    if categoryScrollBarValue[categoryName] == nil then
        categoryScrollBarValue[categoryName] = 0
    end

    local menu = vgui.Create("DPanel", background)
    menu:SetSize(400, ScrH() * 0.6)
    menu:Center()
    
    local x,y = menu:GetPos()
    menu:SetPos(x, ScrH())
    menu:MoveTo(x, y, 0.1, 0, -1)
    
    function menu:Paint(width, height)
    end
    
    local headerPanel = vgui.Create("DPanel", menu)
    headerPanel:SetText("")
    headerPanel:Dock(TOP)
    headerPanel:SetSize(0, 40)
    headerPanel:DockMargin(20, 0, 20, 10)
    function headerPanel:Paint(w, h)
        local text = string.upper(categoryName)
        local ltl = MWBLTL.Get("Atts_Category_"..string.gsub(categoryName, " ", "_"))
        draw.SimpleText(ltl or text, "mgbase_attSlotMenu", 0, h * 0.5, whiteColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end 
    
    makeCloseButton(headerPanel, background)

    local scroll = makeScrollBar(menu, RIGHT)
    local vbar = scroll:GetVBar()
    
    vbar:AnimateTo(categoryScrollBarValue[categoryName], 0.25, 0, -1)

    function vbar:OnRemove()
        categoryScrollBarValue[categoryName] = self:GetScroll()
    end

    local attachmentsGrid = vgui.Create("DGrid", scroll)
    attachmentsGrid:SetPos(0, 0)
    attachmentsGrid:SetCols(1)
    attachmentsGrid:SetColWide(menu:GetWide() * 0.9)
    attachmentsGrid:SetRowHeight(80)
    attachmentsGrid:Dock(FILL)
    attachmentsGrid:DockMargin(20, 0, 0, 0)
    
    table.sort(atts, function(a, b)
        local aFav = mw_utils.IsAssetFavorite(weapon:GetClass(), a.ClassName)
        local bFav = mw_utils.IsAssetFavorite(weapon:GetClass(), b.ClassName)

        if (!aFav && bFav) then
            return false
        elseif (aFav && !bFav) then
            return true
        elseif ((aFav && bFav) || (!aFav && !bFav)) then
            return a.Name < b.Name
        end
    end)

    for _, attachment in pairs(atts) do
        --panel to hold button
        local attachmentPanel = vgui.Create("DPanel")
        attachmentPanel:SetSize(attachmentsGrid:GetColWide(), attachmentsGrid:GetRowHeight())
        function attachmentPanel:Paint(w, h)
        end
        
        local but = vgui.Create("DButton", attachmentPanel)
        but:SetText("")
        but:Dock(FILL)
        but:DockMargin(0, 5, 0, 5)
        but.HoverDelta = 0
        but.ClickDelta = 0
        but.bWasHovered = false
        but.IsAllowed = true
        but.FavoriteDelta = 0
        
        function but:Think()
            if !validWeapon(weapon) then return end
            
            self.IsAllowed = weapon:IsAttachmentAllowed(attachment)

            if self:IsHovered() then
                openStatsInfo(self, attachment, weapon)
                createRightButtonControl(self, MWBLTL.Get("CuzMenu_Nom_Text1"))
            else
                closeStatsInfo(self)
                removeButtonControls(self)
            end
        end
        
        function but:Paint(width, height)
            if self:IsHovered() then
                self.HoverDelta = math.Approach(self.HoverDelta, 1, math.min(10 * RealFrameTime(), 0.1))
                
                if !self.bWasHovered then
                    surface.PlaySound(hoverAttachmentSounds[math.random(1, #hoverAttachmentSounds)])
                end
                self.bWasHovered = true
            else
                self.HoverDelta = math.Approach(self.HoverDelta, 0, math.min(10 * RealFrameTime(), 0.1))
                self.bWasHovered = false
            end
            
            if self:IsDown() then
                self.ClickDelta = math.Approach(self.ClickDelta, 1, math.min(10 * RealFrameTime(), 0.1))
            else
                self.ClickDelta = math.Approach(self.ClickDelta, 0, math.min(10 * RealFrameTime(), 0.1))
            end
            
            local currentColor = self.IsAllowed && blackColor || backgroundErrorColor
            
            --background
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a)
            self:DrawFilledRect()
            
            currentColor = self.IsAllowed && (attachment.UIColor || whiteColor) || errorColor
            
            --click hold
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * 0.15 * self.ClickDelta)
            self:DrawFilledRect()
            
            --border hover
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * math.max(self.HoverDelta, 0.15))
            self:DrawOutlinedRect()
            
            --glow hover
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * 0.1 * (self.HoverDelta - self.ClickDelta))
            surface.SetMaterial(buttonGlowMaterial)
            surface.DrawTexturedRect(0, height * 0.5, width, height * 0.5)

            --favorite bg
            self.FavoriteDelta = math.Approach(self.FavoriteDelta, 0, math.min(3 * RealFrameTime(), 0.3))

            if self.FavoriteDelta > 0 then
                surface.SetDrawColor(yellowColor.r, yellowColor.g, yellowColor.b, yellowColor.a * self.FavoriteDelta)
                self:DrawFilledRect()
            end

            if mw_utils.IsAssetFavorite(weapon:GetClass(), attachment.ClassName) then
                surface.SetDrawColor(yellowColor.r, yellowColor.g, yellowColor.b, yellowColor.a)
                surface.SetMaterial(favoriteMaterial)
                surface.DrawTexturedRect(-1, -1, 16, 16)
            end
            
            --att icon
            surface.SetMaterial(attachment.Icon)
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, 255)
            surface.DrawTexturedRect(15, 11, 50, 50) --???
            
            --att name
            local bDeveloper = GetConVar("developer"):GetInt() > 0
            local blocker = weapon:GetBlockerAttachment(attachment)
            local bCanShowExtra = attachment.CosmeticChange || blocker != nil || bDeveloper
            local hoverColor = Color(currentColor.r, currentColor.g, currentColor.b, currentColor.a * self.HoverDelta)
            local yOffset = bCanShowExtra && self.HoverDelta * 10 || 0

            local name = bDeveloper && attachment.ClassName || attachment.Name
            draw.SimpleText(name, "mgbase_attSlotAttachmentInUse:hover", 75, height * 0.5 - yOffset, hoverColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(name, "mgbase_attSlotAttachmentInUse", 75, height * 0.5 - yOffset, currentColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, shadowColor)
            
            if bCanShowExtra then
                if bDeveloper then
                    draw.SimpleText(attachment.Base, "mgbase_attSlotAttachmentInUse_IsCosmetic", 75, height * 0.5 + yOffset, hoverColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                elseif blocker != nil then
                    draw.SimpleText(MWBLTL.Get("CuzMenu_Nom_Text5")..blocker.Name, "mgbase_attSlotAttachmentInUse_IsCosmetic", 75, height * 0.5 + yOffset, hoverColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(MWBLTL.Get("CuzMenu_Nom_Text6"), "mgbase_attSlotAttachmentInUse_IsCosmetic", 75, height * 0.5 + yOffset, hoverColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            end
        end
        
        function but:PaintOver(width, height)
        end
        
        function but:DoClick()
            if !self.IsAllowed then
                surface.PlaySound(selectAttachmentSound)
                return
            end
            
            local slotInUse = 1
            local indexInUse = 1
            
            for slot, atts in pairs(weapon.Customization) do
                for i, att in pairs(atts) do
                    if att == attachment.ClassName then
                        slotInUse = slot
                        indexInUse = i
                        break
                    end
                end
            end
            
            if attachment.ClassName == weapon:GetAttachmentInUseForSlot(slotInUse).ClassName then
                surface.PlaySound(detachSound)
            else
                surface.PlaySound(attachSound)
            end
            
            surface.PlaySound(selectAttachmentSound)
            mw_utils.SendAttachmentToServer(weapon, slotInUse, indexInUse)

            background:Remove()
        end

        function but:DoRightClick()
            if !mw_utils.IsAssetFavorite(weapon:GetClass(), attachment.ClassName) then
                mw_utils.FavoriteAsset(weapon:GetClass(), attachment.ClassName)
                surface.PlaySound(favoriteSound)
                self.FavoriteDelta = 1
            else
                mw_utils.UnfavoriteAsset(weapon:GetClass(), attachment.ClassName)
                surface.PlaySound(unfavoriteSound)
            end
        end
        
        attachmentsGrid:AddItem(attachmentPanel)
    end
end

local lastScroll = 0

local function openCustomizationMenu(weapon)
    if (IsValid(MW_CUSTOMIZEMENU)) then return end

    surface.PlaySound(openSound)
    gui.EnableScreenClicker(true)
    
    MW_CUSTOMIZEMENU = vgui.Create("DFrame") 
    MW_CUSTOMIZEMENU:SetPos(0, 0)
    MW_CUSTOMIZEMENU:SetSize(ScrW(), ScrH())
    MW_CUSTOMIZEMENU:ShowCloseButton(false) 
    MW_CUSTOMIZEMENU:SetDraggable(false)
    MW_CUSTOMIZEMENU:Center()
    MW_CUSTOMIZEMENU:SetTitle("")
    MW_CUSTOMIZEMENU.AlphaDelta = 0

    function MW_CUSTOMIZEMENU:Paint(width, height)
        if !validWeapon(weapon) then return end
        
        weapon:DrawStats(self)

        if !LocalPlayer():KeyDown(IN_USE) then
            self.AlphaDelta = Lerp(math.min(10 * RealFrameTime(), 1), self.AlphaDelta, 1)
        else
            self.AlphaDelta = Lerp(math.min(10 * RealFrameTime(), 1), self.AlphaDelta, 0)
        end

        --title
        local titleColor = Color(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a * self.AlphaDelta)
        local animHeight = 20 -- MWBLTL.Get("CuzMenu_Title_Text")
        draw.SimpleTextOutlined(weapon.PrintName, "mgbase_attTitle_blur", ScrW() * 0.5, ScrH() * 0.1 - animHeight + (1 - self.AlphaDelta) * animHeight, titleColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, Color(0, 0, 0, self.AlphaDelta * 20))
        draw.SimpleTextOutlined(weapon.PrintName, "mgbase_attTitle", ScrW() * 0.5, ScrH() * 0.1 - animHeight + (1 - self.AlphaDelta) * animHeight, titleColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, Color(0, 0, 0, self.AlphaDelta * 20))
        
        surface.SetDrawColor(255, 255, 255, self.AlphaDelta * 255)
        surface.DrawLine(ScrW() * 0.2 - self.AlphaDelta * 200, ScrH() * 0.1, ScrW() * 0.8 + self.AlphaDelta * 200, ScrH() * 0.1)
    end
    
    function MW_CUSTOMIZEMENU:Think()
        if !validWeapon(weapon) then
            closeCustomizationMenu()
            self:Remove() --why do i need this
        end
    end
    
    local categories = {}
    
    for slot, atts in pairs(weapon.Customization) do
        for ind, attClass in pairs(atts) do
            if (ind <= 1) then
                continue
            end

            if (MW_ATTS[attClass] == nil) then
                continue
            end
            
            local att = weapon:GetStoredAttachment(attClass)
            local category = att.Category

            if (category == nil) then
                continue
            end
            
            categories[category] = (categories[category] || 0) + (weapon:IsAttachmentAllowed(att) && 1 || 0)
        end
    end
    
    if table.IsEmpty(categories) then return end

    local x, y = -ScrW()*0.3, ScrH() * 0.175
    leftSidePanel = vgui.Create("DPanel", MW_CUSTOMIZEMENU)
    leftSidePanel:SetSize(610, ScrH())

    function leftSidePanel:Paint() end

    function leftSidePanel:Think()
        if !LocalPlayer():KeyDown(IN_USE) then
            x = math.Approach(x, ScrW()*0.05, 4000 * RealFrameTime())
        else
            x = math.Approach(x, -ScrW()*0.3, 4000 * RealFrameTime())
        end
        self:SetPos(x, y)
    end
    
    --holder for categories with scroll bar
    local categoriesMenu = vgui.Create("DScrollPanel", leftSidePanel)
    categoriesMenu:SetPos(0, 0)
    categoriesMenu:SetSize(leftSidePanel:GetWide(), leftSidePanel:GetTall() * 0.7)
    
    local sbar = categoriesMenu:GetVBar()
    sbar:Dock(LEFT)
    sbar.LastScrollValue = sbar:GetOffset()
    sbar:AnimateTo(lastScroll, 0.25, 0, -1)

    function sbar:Paint(w, h) end

    function sbar:Think()
        if (self:GetOffset() != self.LastScrollValue && math.abs(self:GetOffset() - self.LastScrollValue) > 10) then
            surface.PlaySound(scrollSound)
            self.LastScrollValue = self:GetOffset()
        end
    end

    function sbar.btnUp:Paint(w, h)
        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)
        surface.DrawRect(w * 0.5 - 2, 0, 4, h)
    end

    function sbar.btnDown:Paint(w, h) end

    function sbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(whiteColor.r, whiteColor.g, whiteColor.b, whiteColor.a)
        surface.DrawRect(w * 0.5 - 1, 10, 2, h - 20)
    end

    function sbar:OnRemove()
        lastScroll = self:GetScroll()
    end

    --grid for categories
    local categoriesGrid = vgui.Create("DGrid", categoriesMenu)
    categoriesGrid:SetPos(0, 0)
    categoriesGrid:SetCols(1)
    categoriesGrid:SetColWide(categoriesMenu:GetWide())
    categoriesGrid:SetRowHeight(80)
    categoriesGrid:Dock(FILL)
    categoriesGrid:DockMargin(20, 0, 0, 0)
    
    for categoryName, count in SortedPairs(categories) do
        --panel to hold buitton + attachment in use panel
        local categoryPanel = vgui.Create("DPanel")
        categoryPanel:SetSize(categoriesGrid:GetColWide(), categoriesGrid:GetRowHeight())
        function categoryPanel:Paint(w, h) end
        
        --button to select category
        local but = vgui.Create("DButton", categoryPanel)
        but:SetText("")
        but:SetSize(200, categoriesGrid:GetRowHeight())
        but:Dock(LEFT)
        but:DockMargin(0, 5, 0, 5)

        but.HoverDelta = 0
        but.AttachmentDelta = 0
        but.ClickDelta = 0
        but.bWasHovered = false
        but.AvailableAttachments = count
        
        function but:Think()
            if !validWeapon(weapon) then return end
            
            self.AvailableAttachments = 0
            for slot, atts in pairs(weapon.Customization) do
                for ind, attClass in pairs(atts) do
                    if (ind <= 1) then
                        continue
                    end

                    if (MW_ATTS[attClass] == nil) then
                        continue
                    end
                    
                    local att = weapon:GetStoredAttachment(attClass)
                    
                    if (att.Category != categoryName || att.ClassName == weapon:GetAttachmentInUseForSlot(slot).ClassName) then
                        continue
                    end
                    
                    self.AvailableAttachments = self.AvailableAttachments + (weapon:IsAttachmentAllowed(att) && 1 || 0)
                end
            end
        end
        
        function but:Paint(width, height)
            if self:IsHovered() then
                self.HoverDelta = math.Approach(self.HoverDelta, 1, math.min(10 * RealFrameTime(), 0.1))
                
                if (!self.bWasHovered) then
                    surface.PlaySound(hoverSounds[math.random(1, #hoverSounds)])
                end
                self.bWasHovered = true
            else
                self.HoverDelta = math.Approach(self.HoverDelta, 0, math.min(10 * RealFrameTime(), 0.1))
                self.bWasHovered = false
            end
            
            if !self.inUsePanel:IsHovered() then
                self.inUsePanel.HoverDelta = self.HoverDelta
            end
            
            if self:IsDown() && !input.IsMouseDown(MOUSE_RIGHT) then
                self.ClickDelta = math.Approach(self.ClickDelta, 1, math.min(10 * RealFrameTime(), 0.1))
            else
                self.ClickDelta = math.Approach(self.ClickDelta, 0, math.min(10 * RealFrameTime(), 0.1))
            end
            
            local currentColor = self.AvailableAttachments <= 0 && backgroundErrorColor || blackColor
            
            --background
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a)
            self:DrawFilledRect()
            
            currentColor = self.AvailableAttachments <= 0 && errorColor || whiteColor
            
            --click hold 
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * 0.15 * self.ClickDelta)
            self:DrawFilledRect()
            
            --border hover
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * math.max(self.HoverDelta, 0.15))
            self:DrawOutlinedRect()
            
            --glow hover
            surface.SetDrawColor(currentColor.r, currentColor.g, currentColor.b, currentColor.a * 0.1 * (self.HoverDelta - self.ClickDelta))
            surface.SetMaterial(buttonGlowMaterial)
            surface.DrawTexturedRect(0, height * 0.5, width, height * 0.5)
            
            --category
            local text = categoryName
            local ltl = MWBLTL.Get("Atts_Category_"..string.gsub(categoryName, " ", "_"))
            draw.SimpleText(string.upper(ltl or text), "mgbase_attSlotMenu", width * 0.5, height * 0.5, currentColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            
            local hoverColor = Color(currentColor.r, currentColor.g, currentColor.b, currentColor.a * self.HoverDelta)
            draw.SimpleText(string.upper(ltl or text), "mgbase_attSlotMenu:hover", width * 0.5, height * 0.5, hoverColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        
        --panel to show what attachment we have in use (empty if default)
        local removeAttachmentButton = vgui.Create("DButton", categoryPanel)
        removeAttachmentButton:SetSize(ScrW(), categoriesGrid:GetRowHeight())
        removeAttachmentButton:SetText("")
        removeAttachmentButton:Dock(LEFT)
        removeAttachmentButton:DockMargin(0, 9, 0, 9)
        removeAttachmentButton.HoverDelta = 0
        removeAttachmentButton.HoverDelta2 = 0 --alternative so att button doesn't higlight other elements
        removeAttachmentButton.RClickDelta = 0
        removeAttachmentButton.ClickDelta = 0
        removeAttachmentButton.FavoriteDelta = 0
        removeAttachmentButton.AttachmentDelta = 0
        removeAttachmentButton.LastAttachmentIndex = 1
        removeAttachmentButton.bShow = true--this is for latency (hide before actual customization update)
        
        --link to button so we have consistent hover delta anim
        but.inUsePanel = removeAttachmentButton
        
        function removeAttachmentButton:DoRightClick()
            local attachmentInUse = nil
            
            for slot, att in pairs(weapon:GetAllAttachmentsInUse()) do
                if (att.Category == categoryName) then
                    attachmentInUse = att
                    break
                end
            end
            
            if (attachmentInUse == nil) then
                return
            end

            if (!mw_utils.IsAssetFavorite(weapon:GetClass(), attachmentInUse.ClassName)) then
                mw_utils.FavoriteAsset(weapon:GetClass(), attachmentInUse.ClassName)
                surface.PlaySound(favoriteSound)
                self.FavoriteDelta = 1
            else
                mw_utils.UnfavoriteAsset(weapon:GetClass(), attachmentInUse.ClassName)
                surface.PlaySound(unfavoriteSound)
            end
        end
        
        function removeAttachmentButton:Think()
            if !validWeapon(weapon) then
                return
            end
            
            self:SetEnabled(false)
            self:SetCursor("none")
            
            --attachment in use next to button
            local attachmentInUse = nil
            
            for slot, att in pairs(weapon:GetAllAttachmentsInUse()) do
                if att.Category == categoryName then
                    attachmentInUse = att
                    break
                end
            end
            
            if !attachmentInUse then return end
            
            if attachmentInUse.Index > 1 && self.bShow then
                self:SetEnabled(true)
                self:SetCursor("hand")
            end
            
            if self.LastAttachmentIndex != attachmentInUse.Index then
                self.RClickDelta = 0
                self.ClickDelta = 0
                self.AttachmentDelta = 0
                self.HoverDelta = 0
                self.HoverDelta2 = 0
                self.LastAttachmentIndex = attachmentInUse.Index
                self.bShow = true
            end

            if self:IsHovered() then
                openStatsInfo(self, attachmentInUse, weapon)
            else
                closeStatsInfo(self)
            end
        end
        
        function removeAttachmentButton:Paint(width, height)
            if !validWeapon(weapon) then return end

            if !self.bShow then
                closeStatsInfo(self)
                return
            end
            
            local attachmentInUse = nil
            for slot, att in pairs(weapon:GetAllAttachmentsInUse()) do
                if (att.Category == categoryName && att.Index > 1) then
                    attachmentInUse = att
                    break
                end
            end
            
            if !attachmentInUse then
                closeStatsInfo(self)
                return
            end
            
            if self:IsHovered() then
                self.HoverDelta = math.Approach(self.HoverDelta, 1, math.min(10 * RealFrameTime(), 0.1))
                self.HoverDelta2 = math.Approach(self.HoverDelta2, 1, math.min(10 * RealFrameTime(), 0.1))
                
                if !self.bWasHovered then
                    surface.PlaySound(hoverAttachmentSounds[math.random(1, #hoverAttachmentSounds)])
                end
                
                self.bWasHovered = true
            else
                self.HoverDelta = math.Approach(self.HoverDelta, 0, math.min(10 * RealFrameTime(), 0.1))
                self.HoverDelta2 = math.Approach(self.HoverDelta2, 0, math.min(10 * RealFrameTime(), 0.1))
                self.bWasHovered = false
            end

            if self:IsDown() then
                if input.IsMouseDown(MOUSE_RIGHT) then
                    self.RClickDelta = math.Approach(self.RClickDelta, 1, math.min(10 * RealFrameTime(), 0.1))
                else
                    self.ClickDelta = math.Approach(self.ClickDelta, 1, math.min(10 * RealFrameTime(), 0.1))
                end
            else
                self.RClickDelta = math.Approach(self.RClickDelta, 0, math.min(10 * RealFrameTime(), 0.1))
                self.ClickDelta = math.Approach(self.ClickDelta, 0, math.min(10 * RealFrameTime(), 0.1))
            end
            
            self.AttachmentDelta = math.Approach(self.AttachmentDelta, 1, math.min(10 * RealFrameTime(), 0.1))
            
            local rightOffset = (1 - self.AttachmentDelta) * 20
            
            --background stylish black blur
            surface.SetMaterial(removeButtonGlowMaterial)
            local color = LerpVector(self.ClickDelta, Vector(0, 0, 0), Vector(100, 0, 0))
            color = LerpVector(self.RClickDelta, color, Vector(100, 100, 100))
            local alpha = Lerp(self.ClickDelta, Lerp(self.HoverDelta, 150, 200), 200)
            surface.SetDrawColor(color.x, color.y, color.z, alpha)
            surface.DrawTexturedRect(0, 0, 150 * 0.9, height)
            
            rightOffset = rightOffset + 10
            
            --fav
            self.FavoriteDelta = math.Approach(self.FavoriteDelta, 0, math.min(3 * RealFrameTime(), 0.3))
            
            if self.FavoriteDelta > 0 then
                surface.SetDrawColor(yellowColor.r, yellowColor.g, yellowColor.b, yellowColor.a * self.FavoriteDelta)
                surface.SetMaterial(removeButtonGlowMaterial)
                surface.DrawTexturedRect(0, 0, 150 * 0.9, height)
            end

            --att icon
            surface.SetDrawColor(255, 255, 255, Lerp(self.HoverDelta - self.ClickDelta, 100, 255))
            surface.SetMaterial(attachmentInUse.Icon)
            surface.DrawTexturedRect(rightOffset, height * 0.5 - 20, 40, 40)
            
            surface.SetDrawColor(200, 0, 0, (self.HoverDelta2 * 0.5 + self.ClickDelta - self.FavoriteDelta) * 255)
            surface.SetMaterial(removeAttachmentMaterial)
            surface.DrawTexturedRect(rightOffset + 6, height * 0.5 - 16, 28, 32)
            
            rightOffset = rightOffset + 50
            
            --att name
            local colorForAttachment = attachmentInUse.UIColor || whiteColor
            draw.SimpleText(attachmentInUse.Name, "mgbase_attSlotAttachmentInUse:hover", rightOffset, height * 0.5, Color(colorForAttachment.r, colorForAttachment.g, colorForAttachment.b, colorForAttachment.a * self.HoverDelta), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(attachmentInUse.Name, "mgbase_attSlotAttachmentInUse", rightOffset, height * 0.5, colorForAttachment, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, shadowColor)
            
            if mw_utils.IsAssetFavorite(weapon:GetClass(), attachmentInUse.ClassName) then
                surface.SetDrawColor(yellowColor.r, yellowColor.g, yellowColor.b, yellowColor.a)
                surface.SetMaterial(favoriteMaterial)
                surface.DrawTexturedRect(0, 0, 16, 16)
            end

            surface.SetAlphaMultiplier(1)
        end
        
        function removeAttachmentButton:DoClick()
            local attachmentInUse = nil
            
            for slot, att in pairs(weapon:GetAllAttachmentsInUse()) do
                if att.Category == categoryName && att.Index > 1 then
                    attachmentInUse = att
                    break
                end
            end
            
            if !attachmentInUse then return end
            
            surface.PlaySound(detachSound)
            surface.PlaySound(selectAttachmentSound)
            
            mw_utils.SendAttachmentToServer(weapon, attachmentInUse.Slot, attachmentInUse.Index)
            
            self.bShow = false
        end
        
        function but:DoClick()
            if self.AvailableAttachments > 0 then
                surface.PlaySound(selectCategorySound)
                openCategoryList(categoryName, weapon, removeAttachmentButton)
                self.inUsePanel.LastAttachmentIndex = 1
            else
                surface.PlaySound(closeAttachmentsSound)
            end
        end
        
        categoriesGrid:AddItem(categoryPanel)
    end
    
    local x, y = 0, ScrH() * 0.9 + 450
    local bottomPanel = vgui.Create("DPanel", MW_CUSTOMIZEMENU)
    bottomPanel:SetSize(ScrW(), ScrH() * 0.2)

    function bottomPanel:Paint() end

    function bottomPanel:Think()
        if !LocalPlayer():KeyDown(IN_USE) then
            y = math.Approach(y, ScrH() * 0.9 - 50, 4000 * RealFrameTime())
        else
            y = math.Approach(y, ScrH() * 0.9 + 450, 4000 * RealFrameTime())
        end
        
        self:SetPos(x, y)
    end
    
    --PRESETS BUTTON
    local presetsButton = createUtilityButton(bottomPanel, presetsMaterial, nil)
    presetsButton:SetSize(66, 66)
    presetsButton:SetPos(ScrW() * 0.5 - 100 - 33, 4)

    function presetsButton:DoClick()
        surface.PlaySound(selectCategorySound)
        openPresetsMenu(weapon)
    end

    --RESET BUTTON
    local resetButton = createUtilityButton(bottomPanel, resetMaterial, nil)
    resetButton:SetSize(66, 66)
    resetButton:SetPos(ScrW() * 0.5 - 33, 4)

    function resetButton:DoClick()
        surface.PlaySound(resetSound)

        for slot, att in pairs(weapon:GetAllAttachmentsInUse()) do
            if (att.Index > 1) then --just sending what we need
                mw_utils.SendAttachmentToServer(weapon, slot, 1)
            end
        end
    end

    --RANDOM BUTTON
    local randomButton = createUtilityButton(bottomPanel, randomMaterial, nil)
    randomButton:SetSize(66, 66)
    randomButton:SetPos(ScrW() * 0.5 + 100 - 33, 4)

    function randomButton:DoClick()
        surface.PlaySound(randomSound)

        for slot, atts in pairs(weapon.Customization) do
            mw_utils.SendAttachmentToServer(weapon, slot, math.random(#atts))
        end
    end
end

function SWEP:CustomizationMenu()
    if self:HasFlag("Customizing") then
        openCustomizationMenu(self)
    else
        closeCustomizationMenu(self)
    end
end

function SWEP:GetStatPositive(originalStat, currentStat, statInfoIndex)
    local statInfo = self.StatInfo[statInfoIndex]
    
    if statInfo && originalStat != currentStat then
        if statInfo.ProIfMore == false then
			return math.abs(currentStat) < math.abs(originalStat)
        else
			return math.abs(currentStat) > math.abs(originalStat)
		end
    end
    
    return
end

local maxStats = 10

function SWEP:DrawStat(statInfoIndex, append, index, originalStat, currentStat, statMult)
    local scale = ScrH() / 1080
    local scaleX = ScrW() / 1920
    local spacing = (index * 30) - (maxStats * 0.5 * 30) * scale
    local x,y = ScrW() * 0.05, ScrH() * 0.3
    local xOffset = x + getLanguageCoord("xOffset") * scale
    local xLeftOffset = 0
	
	if ScrH() > 875 then
		x,y = ScrW() * 0.79, ScrH() * 0.3
        xOffset = x + 280 * scaleX
        xLeftOffset = getLanguageCoord("xLeftOffset")
    end
        
    surface.SetDrawColor(blackColor.r, blackColor.g, blackColor.b, blackColor.a)
    surface.DrawRect(x - 23 - xLeftOffset * scale, y + spacing + 16, 310 * scale + xLeftOffset, 2)

    local info = self.StatInfo[statInfoIndex].Name
    local ltl = MWBLTL.Get("StatInfo_"..statInfoIndex) or "???"

    local bPositive
    if originalStat then
        bPositive = self:GetStatPositive(originalStat, currentStat, statInfoIndex)
    end
    local statColor = bPositive && greenColor || bPositive == false && redColor || whiteColor

    if isnumber(currentStat) then
        currentStat = math.Round(currentStat * (statMult || 1), 2)
    end
    
    draw.SimpleTextOutlined(ltl..":" or info..":", "mgbase_firemode", x - 20 - xLeftOffset * scale, y + spacing, whiteColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
    draw.SimpleTextOutlined(tostring(currentStat)..append, "mgbase_firemode", xOffset, y + spacing, statColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
    --local c = Color(statColor.r, statColor.g, statColor.b, statColor.a * 0.5)
    --draw.SimpleTextOutlined(tostring(currentStat)..append, "mgbase_statPositive", xOffset, y + spacing, c, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
    
    return y + spacing
end

local function lengthCalculate(curAnim)
    if curAnim then
        return curAnim.Length / (curAnim.Fps / 30)
    end

    return nil
end

local function getOriginalStat(original, table)
    for i, v in pairs(table) do
        if !original[v] then return nil end
        original = original[v]
    end

    return original
end

local function StatPageAdvanced(panel, self)
	local scale = ScrH() / 1080
    local spacing = 30 * scale
    local x,y = ScrW() * 0.79, ScrH() * 0.3
	local linespace = spacing*1.75

    local original = weapons.Get(self:GetClass()) --inheritance gotta copy
    local xLeftOffset = getLanguageCoord("xLeftOffset")
    local xOffset = x + 150 - (xLeftOffset/2) * scale
    local statBeforeLineY = y - (maxStats * 17.5) * scale + 20

    if LocalPlayer():KeyDown(IN_USE) then
        surface.SetMaterial(blurMaterial)
        surface.SetDrawColor(255,255,255,255)
        for i = 1, 10, 1 do
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x - 30 * scale, statBeforeLineY - 20, 325 * scale, 32*c)
        end
    end

    c = 1

    surface.SetDrawColor(255, 255, 255, 255)
	
	-- DAMAGE

	draw.SimpleTextOutlined(MWBLTL.Get("CuzMenu_Nom_Text11"), "mgbase_firemode", xOffset, statBeforeLineY, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))

    if self.Bullet.Damage then
        statBeforeLineY = self:DrawStat("Damage", "", c, original.Bullet.Damage[1] * (original.Bullet.HeadshotMultiplier || 1), self.Bullet.Damage[1] * (self.Bullet.HeadshotMultiplier || 1))
        c = c + 1

        statBeforeLineY = self:DrawStat("HeadshotDamage", "", c, original.Bullet.HeadshotMultiplier || 1, self.Bullet.HeadshotMultiplier || 1, self.Bullet.Damage[1] * 2)
        c = c + 1
    end

    if self.Bullet.DropOffStartRange then
        statBeforeLineY = self:DrawStat("EffectiveRange", MWBLTL.Get("CuzMenu_Nom_Text9"), c, original.Bullet.DropOffStartRange, self.Bullet.DropOffStartRange)
        c = c + 1
    end

    if self.Bullet.EffectiveRange then
        statBeforeLineY = self:DrawStat("Range", MWBLTL.Get("CuzMenu_Nom_Text9"), c, original.Bullet.EffectiveRange, self.Bullet.EffectiveRange)
        c = c + 1
    end

    if self.Primary.RPM then
        statBeforeLineY = self:DrawStat("RPM", "", c, original.Primary.RPM, self.Primary.RPM)
        c = c + 1
    end

    if self.Bullet.Penetration then
        statBeforeLineY = self:DrawStat("PenetrationThickness", "", c, getOriginalStat(original.Bullet, {"Penetration", "Thickness"}), self.Bullet.Penetration.Thickness)
        c = c + 1
    end

    if self.Projectile then
		statBeforeLineY = self:DrawStat("ProjectileSpeed", "", c, getOriginalStat(original, {"Projectile", "Speed"}), self.Projectile.Speed)
        c = c + 1
    end
	
	-- ACCURACY

    draw.SimpleTextOutlined(MWBLTL.Get("CuzMenu_Nom_Text12"), "mgbase_firemode", xOffset, statBeforeLineY + linespace, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
    c = c + 2

    if self.Cone.Hip then
        statBeforeLineY = self:DrawStat("Accuracy", "", c, original.Cone.Hip, self.Cone.Hip, 100)
        c = c + 1
    end
    
    if self.Cone.Ads then
        statBeforeLineY = self:DrawStat("AimAccuracy", "", c, original.Cone.Ads, self.Cone.Ads, 100)
        c = c + 1
    end

    if self.Cone.TacStance then
        statBeforeLineY = self:DrawStat("TacAccuracy", "", c, original.Cone.TacStance, self.Cone.TacStance, 100)
        c = c + 1
    end

    if self.Cone.Increase then
        statBeforeLineY = self:DrawStat("ConeIncrease", "", c, original.Cone.Increase, self.Cone.Increase, 100)
        c = c + 1
    end

    if self.Zoom.IdleSway then
        statBeforeLineY = self:DrawStat("IdleSway", "", c, original.Zoom.IdleSway, self.Zoom.IdleSway, 100)
        c = c + 1
    end

	-- CONTROL
    draw.SimpleTextOutlined(MWBLTL.Get("CuzMenu_Nom_Text13"), "mgbase_firemode", xOffset, statBeforeLineY + linespace, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
    c = c + 2

    if self.Recoil.Vertical then
        statBeforeLineY = self:DrawStat("VerticalRecoil", "", c, original.Recoil.Vertical[2], self.Recoil.Vertical[2], 10)
        c = c + 1
    end

    if self.Recoil.Horizontal then
        statBeforeLineY = self:DrawStat("HorizontalRecoil", "", c, original.Recoil.Horizontal[2], self.Recoil.Horizontal[2], 10)
        c = c + 1
    end

    if self.Recoil.AdsMultiplier then
        statBeforeLineY = self:DrawStat("ADSRecoil", "%", c, original.Recoil.AdsMultiplier, self.Recoil.AdsMultiplier, 100)
        c = c + 1
    end
	
	-- HANDLING
	draw.SimpleTextOutlined(MWBLTL.Get("CuzMenu_Nom_Text14"), "mgbase_firemode", xOffset, statBeforeLineY + linespace, whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 20))
    c = c + 2
	
    local reloadAnimIndex
    local oldAnim
    local curAnim
    if self:GetAnimation("Reload_Loop") then
        reloadAnimIndex = self:ChooseReloadLoopAnim()
        oldAnim = lengthCalculate(original.Animations.Reload_Loop)
        curAnim = self:GetAnimation(reloadAnimIndex)
    elseif self:GetAnimation("Reload") then
        reloadAnimIndex = self:ChooseReloadAnim()
        oldAnim = lengthCalculate(original.Animations.Reload)
        curAnim = self:GetAnimation(reloadAnimIndex)
    end

    if curAnim then
        self:DrawStat("ReloadLength", MWBLTL.Get("CuzMenu_Nom_Text10"), c, oldAnim, self:GetAnimLength(reloadAnimIndex))
        c = c + 1
    end
    
    if self:GetAnimation("Ads_In") then
        self:DrawStat("AimLength", MWBLTL.Get("CuzMenu_Nom_Text10"), c, lengthCalculate(original.Animations.Ads_In), self:GetAnimLength("Ads_In"))
        c = c + 1
    end

    if self:GetAnimation("Sprint_Out") then
        self:DrawStat("SprintLength", MWBLTL.Get("CuzMenu_Nom_Text10"), c, lengthCalculate(original.Animations.Sprint_Out), self:GetAnimLength("Sprint_Out"))
        c = c + 1
    end

    if self:GetAnimation("Draw") then
        self:DrawStat("DrawLength", MWBLTL.Get("CuzMenu_Nom_Text10"), c, lengthCalculate(original.Animations.Draw), self:GetAnimLength("Draw"))
        c = c + 1
    end

    surface.SetAlphaMultiplier(1)
end

local function StatPageSimple(panel, self)
	if !self:GetOwner():KeyDown(IN_USE) then
        return
    end
    local scale = ScrH() / 1080
    local spacing = 30 * scale
    local x,y = ScrW() * 0.05, ScrH() * 0.325

    local original = weapons.Get(self:GetClass()) --inheritance gotta copy
    local c = 1
    
    if self.Bullet.Damage then
        self:DrawStat("DamageClose", "", c, original.Bullet.Damage[1], self.Bullet.Damage[1])
        c = c + 1
    end

    if self.Bullet.DropOffStartRange then
        statBeforeLineY = self:DrawStat("EffectiveRange", MWBLTL.Get("CuzMenu_Nom_Text9"), c, original.Bullet.DropOffStartRange, self.Bullet.DropOffStartRange)
        c = c + 1
    end

    if self.Bullet.EffectiveRange then
        statBeforeLineY = self:DrawStat("Range", MWBLTL.Get("CuzMenu_Nom_Text9"), c, original.Bullet.EffectiveRange, self.Bullet.EffectiveRange)
        c = c + 1
    end

    if self.Primary.RPM then
        statBeforeLineY = self:DrawStat("RPM", "", c, original.Primary.RPM, self.Primary.RPM)
        c = c + 1
    end
	
    c = c + 1

    if self.Cone.Hip then
        statBeforeLineY = self:DrawStat("Accuracy", "", c, original.Cone.Hip, self.Cone.Hip, 100)
        c = c + 1
    end
    
    if self.Cone.Ads then
        statBeforeLineY = self:DrawStat("AimAccuracy", "", c, original.Cone.Ads, self.Cone.Ads, 100)
        c = c + 1
    end
	
	if self.Recoil.Vertical then
        statBeforeLineY = self:DrawStat("VerticalRecoil", "", c, original.Recoil.Vertical[2], self.Recoil.Vertical[2])
        c = c + 1
    end

    if self.Recoil.Horizontal then
        statBeforeLineY = self:DrawStat("HorizontalRecoil", "", c, original.Recoil.Horizontal[2], self.Recoil.Horizontal[2])
        c = c + 1
    end
	
    c = c + 1
	
    local reloadAnimIndex
    local oldAnim
    local curAnim
    if self:GetAnimation("Reload_Loop") then
        reloadAnimIndex = self:ChooseReloadLoopAnim()
        oldAnim = lengthCalculate(original.Animations.Reload_Loop)
        curAnim = self:GetAnimation(reloadAnimIndex)
    elseif self:GetAnimation("Reload") then
        reloadAnimIndex = self:ChooseReloadAnim()
        oldAnim = lengthCalculate(original.Animations.Reload)
        curAnim = self:GetAnimation(reloadAnimIndex)
    end

    if curAnim then
        self:DrawStat("ReloadLength", MWBLTL.Get("CuzMenu_Nom_Text10"), c, oldAnim, self:GetAnimLength(reloadAnimIndex))
        c = c + 1
    end
    
    if self:GetAnimation("Ads_In") then
        self:DrawStat("AimLength", MWBLTL.Get("CuzMenu_Nom_Text10"), c, lengthCalculate(original.Animations.Ads_In), self:GetAnimLength("Ads_In"))
        c = c + 1
    end

    if self:GetAnimation("Sprint_Out") then
        self:DrawStat("SprintLength", MWBLTL.Get("CuzMenu_Nom_Text10"), c, lengthCalculate(original.Animations.Sprint_Out), self:GetAnimLength("Sprint_Out"))
        c = c + 1
    end

    if self:GetAnimation("Draw") then
        self:DrawStat("DrawLength", MWBLTL.Get("CuzMenu_Nom_Text10"), c, lengthCalculate(original.Animations.Draw), self:GetAnimLength("Draw"))
        c = c + 1
    end

    surface.SetAlphaMultiplier(1)
end

function SWEP:DrawStats(panel)
    if ScrH() > 875 then
		StatPageAdvanced(panel, self)
	else
		StatPageSimple(panel, self)
	end
end