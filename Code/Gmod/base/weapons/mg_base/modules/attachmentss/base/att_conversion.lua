require("mw_utils")

ATTACHMENT.Base = "att_base"
ATTACHMENT.Name = "Default"
ATTACHMENT.Category = "Conversions"

--[[
you likely noticed this is just a glorified attachment, so everything that works for other types works
here as well (bodygroups, model, etc etc)
structure of a typical conversion goes like this:

--
with conversions you completely ditch the original gun's customization slot,
which means you gotta provide a default attachment too (the first one)

ATTACHMENT.Conversion = {
    [2] = {"att_example1", "att_example2"},
    [4] = {"att_example3", "att_example4"},
    [5] = {} <- will remove slot 5
}

! note how i skipped some slots (they are the same ones you use in injectors): if you wish to not replace a slot,
you simply omit it !
--

--
with replacements you handpick some attachments that change with your conversion

ATTACHMENT.Replacements = {
    ["att_original_from_swep1"] = "att_your_new_attachment1",
    ["att_original_from_swep2"] = "att_your_new_attachment2"
}
--

in injectors, you don't need to specify a slot: base will check if you're trying to add a conversion to the gun.
don't worry about it, just let it manage it for you
this also means you don't have to inject the attachments you use above manually!! they will still show up
if the conversion is trying to load an attachment the player hasn't downloaded it will not get added

later down the line i plan on adding their own ui to conversions, for now we can live with them just being
an attachment button...

lastly, please remember the philosophy of our customization. are you sure your set needs to be a conversion?
if you're able to, consider making it part of the gun instead; don't take customization away from the player. 
this sytem can easily throw everything out of the window if you're not careful.
enjoy~!
]]

local function getSlotAndIndex(cust, originalClass)
    for slot, atts in pairs(cust) do
        for index, attClass in pairs(atts) do
            if (attClass == originalClass) then
                return slot, index
            end
        end
    end

    return -1000, -1000
end

local function stripUnknownAttachments(atts)
    for i = #atts, 1, -1 do
        if (MW_ATTS[atts[i]] == nil) then
            table.remove(atts, i)
        end
    end
end

local BaseClass = GetAttachmentBaseClass(ATTACHMENT.Base)
function ATTACHMENT:Stats(weapon)
    BaseClass.Stats(self, weapon)

    if (self.Conversion != nil) then
        for slot, atts in pairs(self.Conversion) do
            if (slot <= SLOT_CONVERSIONS) then
                continue
            end

            if (table.IsEmpty(atts)) then
                weapon.Customization[slot] = nil
                continue
            end

            local strippedAtts = table.Copy(atts)
            stripUnknownAttachments(strippedAtts)

            weapon.Customization[slot] = strippedAtts
        end
    end

    if (self.Replacements != nil) then
        for originalClass, newClass in pairs(self.Replacements) do
            local rSlot, rIndex = getSlotAndIndex(weapon.Customization, originalClass)

            if (rSlot > SLOT_CONVERSIONS && rIndex > SLOT_CONVERSIONS && MW_ATTS[newClass] != nil) then
                weapon.Customization[rSlot][rIndex] = newClass
            end
        end
    end
end