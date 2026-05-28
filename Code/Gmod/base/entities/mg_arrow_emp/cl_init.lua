include("shared.lua")

killicon.Add("mg_arrow_emp", "VGUI/entities/mg_crossbow", Color(255, 0, 0, 255))

hook.Add("HUDShouldDraw", "MW19_HUDShouldDraw_EMP", function(name)
    if (IsValid(GetViewEntity())) then
        if (CurTime() < GetViewEntity():GetNWFloat("MW19_EMPEffect", CurTime())) then
            return name != "CHudAmmo" && name != "CHudBattery" && name != "CHudHealth" && name != "CHudSecondaryAmmo"
        end
    end
end)