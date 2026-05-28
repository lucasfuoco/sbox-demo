AddCSLuaFile()
require("mw_input")

if (SERVER) then
	return
end

hook.Add("AddToolMenuCategories", "Mw_CustomCategory", function()
	spawnmenu.AddToolCategory("Options", "mw_options", "MW Options")
end)

local function getRig()
	local currentRig = GetConVar("mgbase_rig"):GetString()

	if (MW_RIGS[currentRig] != nil) then
		return currentRig
	end

	return "chands"
end

local function getGloves()
	local currentGloves = GetConVar("mgbase_gloves"):GetString()

	if (MW_GLOVES[currentGloves] != nil) then
		return currentGloves
	end

	return ""
end

local function addGloveSkinControls(panel)
	if (IsValid(panel.gloveSkinBox)) then
		panel.gloveSkinBox:Remove()
	end

	if (IsValid(panel.gloveSkinLabel)) then
		panel.gloveSkinLabel:Remove()
	end

	if (MW_GLOVES[getGloves()] == nil) then
		return
	end

	panel.gloveSkinBox, panel.gloveSkinLabel = panel:ComboBox("Gloves Skin", "mgbase_gloves_skin")

	--populate the combobox
	for i, skin in pairs(MW_GLOVES[getGloves()].Skins) do
		panel.gloveSkinBox:AddChoice(skin, i - 1, GetConVar("mgbase_gloves_skin"):GetInt() == i - 1)
	end
end

local function addGloveControls(panel)
	if (IsValid(panel.gloveModelBox)) then
		panel.gloveModelBox:Remove()
	end

	if (IsValid(panel.gloveModelLabel)) then
		panel.gloveModelLabel:Remove()
	end

	if (IsValid(panel.gloveSkinBox)) then
		panel.gloveSkinBox:Remove()
	end

	if (IsValid(panel.gloveSkinLabel)) then
		panel.gloveSkinLabel:Remove()
	end

	if (getRig() == "chands") then
		return
	end

	--MODEL
	panel.gloveModelBox, panel.gloveModelLabel = panel:ComboBox("Gloves", "mgbase_gloves")

	local oldSelect = panel.gloveModelBox.OnSelect
	panel.gloveModelBox.OnSelect = function(cb, index, value, data)
		oldSelect(cb, index, value, data)
		RunConsoleCommand("mgbase_gloves_skin", "0")

		timer.Simple(0, function()
			addGloveSkinControls(panel)
		end)
	end

	--populate the combobox
	for cls, glove in pairs(MW_GLOVES) do
		panel.gloveModelBox:AddChoice(glove.Name, cls, getGloves() == cls)
	end

	--SKIN
	addGloveSkinControls(panel)
end

local function addRigSkinControls(panel)
	if (IsValid(panel.rigSkinBox)) then
		panel.rigSkinBox:Remove()
	end

	if (IsValid(panel.rigSkinLabel)) then
		panel.rigSkinLabel:Remove()
	end

	if (getRig() == "chands") then
		return
	end

	panel.rigSkinBox, panel.rigSkinLabel = panel:ComboBox("Rig Skin", "mgbase_rig_skin")

	--populate the combobox
	for i, skin in pairs(MW_RIGS[getRig()].Skins) do
		panel.rigSkinBox:AddChoice(skin, i - 1, GetConVar("mgbase_rig_skin"):GetInt() == i - 1)
	end
end

local function addRigControls(panel)
	--RIG MODEL BOX
	if (IsValid(panel.rigModelBox)) then
		panel.rigModelBox:Remove()
	end

	if (IsValid(panel.rigModelLabel)) then
		panel.rigMrigModelLabelodelBox:Remove()
	end

	panel.rigModelBox, panel.rigModelLabel = panel:ComboBox("Rig", "mgbase_rig")
	panel.rigModelBox:AddChoice("C_Hands", "chands", getRig() == "chands")
	
	--populate the combobox
	for cls, rig in pairs(MW_RIGS) do
		panel.rigModelBox:AddChoice(rig.Name, cls, getRig() == cls)
	end

	local oldSelect = panel.rigModelBox.OnSelect
	panel.rigModelBox.OnSelect = function(cb, index, value, data)
		oldSelect(cb, index, value, data)
		RunConsoleCommand("mgbase_rig_skin", "0")

		timer.Simple(0, function()
			addRigSkinControls(panel)
			addGloveControls(panel)
		end)
	end
	----
	
	--RIG SKIN BOX
	addRigSkinControls(panel)

	--GLOVES
	addGloveControls(panel)
end

local function addBinder(panel, text, convar)
	local container = vgui.Create("DPanel", panel)
	container:SetTall(30)
	container:DockPadding(10, 2, 10, 2)

	function container:Paint(w, h)
		surface.SetDrawColor(250, 250, 250, 255)
		self:DrawFilledRect()
	end

	local inputs = mw_input.GetUnpackedInputs(LocalPlayer(), convar)

	local label = vgui.Create("DLabel", container)
	label:SetText(text)
	label:SetTextColor(Color(0, 0, 0, 255))
	label:Dock(LEFT)

	local binderLeft = vgui.Create("DBinder", container)
	binderLeft:Dock(RIGHT)
	binderLeft:SetWide(100)
	binderLeft:SetValue(inputs[1] || 0)
	
	local binderRight = vgui.Create("DBinder", container)
	binderRight:Dock(RIGHT)
	binderRight:SetWide(100)
	binderRight:SetValue(inputs[2] || 0)

	function binderLeft:OnChange(iNum)
		mw_input.PackInputs(convar, binderLeft:GetValue(), binderRight:GetValue())
	end

	function binderRight:OnChange(iNum)
		mw_input.PackInputs(convar, binderLeft:GetValue(), binderRight:GetValue())
	end

	panel:AddItem(container)
end

hook.Add("PopulateToolMenu", "MW19_MenuSettings", function()
	spawnmenu.AddToolMenuOption("Options", "mw_options", "mw_vmodel", MWBLTL.Get("SpawnMenu_VM_Title"), "", "", function(panel)
		panel:ClearControls()
		
		panel:NumSlider(MWBLTL.Get("SpawnMenu_VM_Text1"), "mgbase_fx_vmfov", 0.5, 1.5, 2)
		panel:NumSlider(MWBLTL.Get("SpawnMenu_VM_Text2"), "mgbase_fx_vmfov_ads", 0.5, 1.5, 2)
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_VM_Help1"))

		panel:NumSlider(MWBLTL.Get("SpawnMenu_VM_Text3"), "mgbase_fx_vmposx", -5, 5, 1)
		panel:NumSlider(MWBLTL.Get("SpawnMenu_VM_Text4"), "mgbase_fx_vmposy", -5, 5, 1)
		panel:NumSlider(MWBLTL.Get("SpawnMenu_VM_Text5"), "mgbase_fx_vmposz", -5, 5, 1)

		local divider = vgui.Create("DPanel", panel)
		divider:SetTall(4)
		panel:AddItem(divider)

		panel:Help(MWBLTL.Get("SpawnMenu_VM_Help2"))
		addRigControls(panel)
	end)
	
	spawnmenu.AddToolMenuOption("Options", "mw_options", "mw_hud", MWBLTL.Get("SpawnMenu_HUD_Title"), "", "", function(panel)
		panel:ClearControls()
		
		panel:Help(MWBLTL.Get("SpawnMenu_HUD_Help0"))
		
		local DermaColorCombo = vgui.Create("DColorCombo", panel)
		DermaColorCombo:SetColor(string.ToColor(GetConVar("mgbase_hud_xhaircolor"):GetString()))
		function DermaColorCombo:OnValueChanged(col)
			RunConsoleCommand("mgbase_hud_xhaircolor", string.FromColor(col))
		end
		
		panel:AddItem(DermaColorCombo)

		local divider = vgui.Create("DPanel", panel)
		divider:SetTall(4)
		panel:AddItem(divider)

		local method = math.Clamp(GetConVar("mgbase_hud_xhair"):GetInt(), 0, 2)
		local combo = panel:ComboBox(MWBLTL.Get("SpawnMenu_HUD_Text1"), "mgbase_hud_xhair")
		combo:SetWide(200)
		combo:SetSortItems(false)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_HUD_Text5"), 0, method == 0)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_HUD_Text6"), 1, method == 1)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_HUD_Text7"), 2, method == 2)
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_HUD_Text2"), "mgbase_hud_xhairdot")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_HUD_Help2"))
		
		divider = vgui.Create("DPanel", panel)
		divider:SetTall(4)
		panel:AddItem(divider)
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_HUD_Text3"), "mgbase_hud_firemode")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_HUD_Help3"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_HUD_Text4"), "mgbase_hud_controls")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_HUD_Help4"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Effs_Text1"), "mgbase_fx_debris")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Effs_Help1"))

		panel:CheckBox(MWBLTL.Get("SpawnMenu_Effs_Text2"), "mgbase_fx_blur")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Effs_Help2"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Effs_Text3"), "mgbase_fx_laser_weaponcolor")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Effs_Help3"))
	end)
	
	spawnmenu.AddToolMenuOption("Options", "mw_options", "mw_controls", MWBLTL.Get("SpawnMenu_Cont_Title"), "", "", function(panel)
		panel:ClearControls()
		
		panel:NumSlider(MWBLTL.Get("SpawnMenu_Cont_Text11"), "mgbase_sensitivity_ads", 0.01, 2, 2)
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Cont_Help7"))

		panel:NumSlider(MWBLTL.Get("SpawnMenu_Cont_Text12"), "mgbase_sensitivity_tacstance", 0.01, 2, 2)
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Cont_Help8"))
		
		local method = math.Clamp(GetConVar("mgbase_tacsprint"):GetInt(), 0, 2)
		local combo = panel:ComboBox(MWBLTL.Get("SpawnMenu_Cont_Text13"), "mgbase_tacsprint")
		combo:SetWide(200)
		combo:SetSortItems(false)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_Cont_Text14"), 0, method == 0)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_Cont_Text15"), 1, method == 1)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_Cont_Text16"), 2, method == 2)
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Cont_Text1"), "mgbase_toggleaim")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Cont_Help1"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Cont_Text2"), "mgbase_autoreload")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Cont_Help2"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Cont_Text3"), "mgbase_manualrechamber")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Cont_Help3"))

		panel:CheckBox(MWBLTL.Get("SpawnMenu_Cont_Text4"), "mgbase_aimassist")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Cont_Help6"))

		panel:CheckBox("Remember Underbarrels", "mgbase_underbarrelswitch")
		panel:ControlHelp("Keep underbarrels active when switching weapons.")

		local divider = vgui.Create("DPanel", panel)
		divider:SetTall(4)
		panel:AddItem(divider)

		local method = math.Clamp(GetConVar("mgbase_presetspawnmethod"):GetInt(), 0, 3)
		local combo = panel:ComboBox(MWBLTL.Get("SpawnMenu_Cont_Text5"), "mgbase_presetspawnmethod")
		combo:SetWide(200)
		combo:SetSortItems(false)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_Cont_Text6"), 0, method == 0)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_Cont_Text7"), 1, method == 1)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_Cont_Text8"), 2, method == 2)
		combo:AddChoice(MWBLTL.Get("SpawnMenu_Cont_Text9"), 3, method == 3)
		
		divider = vgui.Create("DPanel", panel)
		divider:SetTall(4)
		panel:AddItem(divider)

		panel:Help("Bind the same button twice to enable double tap.")
		panel:Help("Press MOUSE2 to unbind.")

		addBinder(panel, "Inspect", "inspect")
		addBinder(panel, "Customize", "customize")
		addBinder(panel, "Firemode", "firemode")
		addBinder(panel, "Switch Sights", "switchsights")
		addBinder(panel, "Tac Stance", "tacstance")
		addBinder(panel, "Melee", "melee")
		addBinder(panel, "Underbarrels", "underbarrel")
		addBinder(panel, "Low Carry", "safety")
		addBinder(panel, "Holster", "holster")
		panel:ControlHelp("⬆ Press again while inspecting to stop animation.")

		panel:NumSlider("Double Tap Delay", "mgbase_binds_doubletap_delay", 0.1, 1, 1)
	end)
	
	spawnmenu.AddToolMenuOption("Options", "mw_options", "mw_debug", MWBLTL.Get("SpawnMenu_Debug_Title"), "", "", function(panel)
		panel:ClearControls()
		
		if !LocalPlayer():IsAdmin() then
			panel:ControlHelp("Server admins can access these settings.")
			return
		end

		panel:CheckBox(MWBLTL.Get("SpawnMenu_Debug_Text1"), "mgbase_debug_freeview")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Debug_Help1"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Debug_Text4"), "mgbase_debug_crosshair")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Debug_Help3"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Debug_Text6"), "mgbase_debug_reverb")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Debug_Help5"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Debug_Text7"), "mgbase_debug_range")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Debug_Help6"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Debug_Text8"), "mgbase_debug_projectiles")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Debug_Help7"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Debug_Text9"), "mgbase_debug_vmrender")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Debug_Help8"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_Debug_Text10"), "mgbase_debug_wmrender")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Debug_Help9"))

		panel:CheckBox(MWBLTL.Get("SpawnMenu_Debug_Text11"), "mgbase_debug_mag")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_Debug_Help10"))
	end)
	
	spawnmenu.AddToolMenuOption("Options", "mw_options", "mw_svcontrols", MWBLTL.Get("SpawnMenu_SC_Title"), "", "", function(panel)
		panel:ClearControls()
		
		if !LocalPlayer():IsAdmin() then
			panel:ControlHelp("Server admins can access these settings.")
			return
		end

		panel:NumSlider(MWBLTL.Get("SpawnMenu_SC_Text1"), "mgbase_sv_pvpdamage", 0, 5, 1)
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help1"))
		
		panel:NumSlider(MWBLTL.Get("SpawnMenu_SC_Text2"), "mgbase_sv_pvedamage", 0, 5, 1)
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help2"))
		
		panel:NumSlider(MWBLTL.Get("SpawnMenu_SC_Text3"), "mgbase_sv_recoil", 0, 5, 1)
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help3"))
		
		panel:NumSlider(MWBLTL.Get("SpawnMenu_SC_Text4"), "mgbase_sv_accuracy", 0.1, 5, 1)
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help4"))

		panel:NumSlider(MWBLTL.Get("SpawnMenu_SC_Text5"), "mgbase_sv_range", 0, 5, 1)
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help5"))

		panel:CheckBox(MWBLTL.Get("SpawnMenu_SC_Text14"), "mgbase_sv_tacstance")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help14"))

		panel:CheckBox(MWBLTL.Get("SpawnMenu_SC_Text6"), "mgbase_sv_aimassist")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help6"))

		panel:CheckBox(MWBLTL.Get("SpawnMenu_SC_Text7"), "mgbase_sv_breathing")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help7"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_SC_Text8"), "mgbase_sv_customization")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help8"))

		panel:CheckBox(MWBLTL.Get("SpawnMenu_SC_Text11"), "mgbase_sv_firstdraws")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help11"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_SC_Text12"), "mgbase_sv_sprintreloads")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help12"))

		panel:CheckBox(MWBLTL.Get("SpawnMenu_SC_Text13"), "mgbase_sv_sprintvmanip")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help13"))
		
		panel:CheckBox(MWBLTL.Get("SpawnMenu_SC_Text9"), "mgbase_sv_full_penetration")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help9"))

		panel:TextEntry(MWBLTL.Get("SpawnMenu_SC_Text10"), "mgbase_sv_customization_limit")
		panel:ControlHelp(MWBLTL.Get("SpawnMenu_SC_Help10"))
	end)
end)

local function createSpawnIcon(w, propPanel)
	return spawnmenu.CreateContentIcon(w.ScriptedEntityType or "weapon", propPanel, {
		nicename = w.PrintName or w.ClassName,
		spawnname = w.ClassName,
		material = w.IconOverride or "entities/" .. w.ClassName .. ".png",
		admin = w.AdminOnly
	})
end

--sub categories
hook.Add("PopulateWeapons", "AddWeaponContentMW19", function(pnlContent, tree, node)
	timer.Simple(0, function()
		local weaponsList = list.Get("Weapon")
		local mgbaseWeapons = {}
		
		--look into every weapon and see if they're from mgbase
		for _, weapon in pairs(weaponsList) do
			if (weapons.IsBasedOn(weapon.ClassName, "mg_base") || weapon.ClassName == "mw_infil_flare") then
				if (mgbaseWeapons[weapon.Category] == nil) then
					mgbaseWeapons[weapon.Category] = {}
				end

				--keep them for later if so
				table.insert(mgbaseWeapons[weapon.Category], weapon)
			end
		end

		--loop through all weapon categories
		for _, categoryNode in pairs(tree:Root():GetChildNodes()) do
			--if the text matches the categories we saved before we replace DoPopulate
			if (mgbaseWeapons[categoryNode:GetText()] != nil) then
				local manifest = {
					["Other"] = {} --default header
				}

				--order them by subcategory
				for _, weapon in pairs(mgbaseWeapons[categoryNode:GetText()]) do
					--get weapon from storeds
					local actualWeapon = weapons.Get(weapon.ClassName)
					
					if (actualWeapon.SubCategory == nil) then
						table.insert(manifest["Other"], weapon)
					else
						if (manifest[actualWeapon.SubCategory] == nil) then
							manifest[actualWeapon.SubCategory] = {}
						end
						table.insert(manifest[actualWeapon.SubCategory], weapon)
					end
				end

				categoryNode.DoPopulate = function(self)
					-- If we've already populated it - forget it.
					if (self.PropPanel) then return end

					-- Create the container panel
					self.PropPanel = vgui.Create("ContentContainer", pnlContent)
					self.PropPanel:SetVisible(false)
					self.PropPanel:SetTriggerSpawnlistChange(false)

					for categoryName, weps in SortedPairs(manifest) do
						if (#weps <= 0) then
							continue
						end

						--create header
						local label = vgui.Create("ContentHeader", container)
						label:SetText(categoryName)

						self.PropPanel:Add(label)

						--this is copy from gmod
						for _, ent in SortedPairsByMemberValue(weps, "PrintName") do
							local icon = createSpawnIcon(ent, self.PropPanel)
							local oldPaint = icon.Paint
							local we = weapons.Get(ent.ClassName)
							local bPossibleBlueprint = we.Base != "mg_base"

							if (bPossibleBlueprint) then
								icon.DoClick = function()
									RunConsoleCommand("gm_giveswep", ent.ClassName)
									surface.PlaySound(we.BlueprintSound || "mw/user_interface/aar/ui_aar_operator_complete_reveal.wav")
								end
							end

							icon.Paint = function(self, aWide, aTall)
								if (bPossibleBlueprint) then
									blueprintIconPaint(self, aWide, aTall)
								end
								oldPaint(self, aWide, aTall)
							end

							local oldMenuExtra = icon.OpenMenuExtra
							icon.OpenMenuExtra = function(icon, menu)
								oldMenuExtra(icon, menu)
								local weaponsBasedOnMe = {}

								--blueprints
								for _, w in pairs(weaponsList) do
									if (weapons.IsBasedOn(w.ClassName, ent.ClassName)) then
										weaponsBasedOnMe[#weaponsBasedOnMe + 1] = w
									end
								end

								if (#weaponsBasedOnMe > 0) then
									menu:AddSpacer()

									local grid = vgui.Create("DGrid")
									grid:SetCols(math.min(#weaponsBasedOnMe, 3))
									grid:SetColWide(icon:GetWide())
									grid:SetRowHeight(icon:GetTall())

									for _, w in pairs(weaponsBasedOnMe) do
										local we = weapons.Get(w.ClassName)
										local subIcon = createSpawnIcon(w, menu)
										local oldPaint = subIcon.Paint
										subIcon.Paint = function(self, aWide, aTall)
											blueprintIconPaint(self, aWide, aTall)
											oldPaint(self, aWide, aTall)
										end

										subIcon.DoClick = function()
											RunConsoleCommand("gm_giveswep", w.ClassName)
											surface.PlaySound(we.BlueprintSound || "mw/user_interface/aar/ui_aar_operator_complete_reveal.wav")
										end

										subIcon.DoRightClick = function() end

										grid:AddItem(subIcon)
									end

									menu:AddPanel(grid)
								end
							end
						end
					end
				end
			end
		end
	end) --timer simple
end)

local specialMat = Material("gui/ps_hover.png")
local glowMat = Material("particles/fire_glow")
function blueprintIconPaint(self, aWide, aTall)
	if (self.nextGlowSpawn == nil || CurTime() > self.nextGlowSpawn) then
		if (self.glows == nil) then
			self.glows = {}
		end

		table.insert(self.glows, {delta = 1, speed = math.random(30, 60), size = math.random(12, 24), x = math.random(6, aWide - 6), y = aWide - 16})
		self.nextGlowSpawn = CurTime() + math.random(0.3, 0.5)
	end

	surface.SetMaterial(glowMat)
	for i, glow in pairs(self.glows) do
		glow.delta = glow.delta - FrameTime()
		glow.y = glow.y - (glow.speed * FrameTime())
		surface.SetDrawColor(255, 255, 255, math.sin(math.pi * glow.delta) * 255)
		surface.DrawTexturedRectRotated(glow.x, glow.y, glow.size, glow.size, CurTime() + glow.size + glow.speed)

		if (glow.delta <= 0) then
			table.remove(self.glows, i)
		end
	end

	--surface.SetDrawColor(255, 255, 255, 255)
	--surface.SetMaterial(specialMat)
	--self:DrawTexturedRect()
end