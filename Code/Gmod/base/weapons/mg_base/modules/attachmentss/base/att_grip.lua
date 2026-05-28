ATTACHMENT.Base = "att_base"
ATTACHMENT.Name = "Default"
ATTACHMENT.Category = "Grips"

function ATTACHMENT:ChangeRecoil(var, mul)
    return var < 0 && var / mul || var * mul
end