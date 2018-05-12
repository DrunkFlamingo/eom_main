--[[
eom_button = {} --# assume eom_button: EOM_BUTTON


--v function() --> EOM_BUTTON
function eom_button.new()
    EOMLOG("Creating the politics panel open button", "eom_button.new()")
    local self = {}
    setmetatable(self, {
        __index = eom_button
    })
    --# assume self: EOM_BUTTON
    local existingButton = Util.getComponentWithName("PoliticsButton")
    if not existingButton then
        local Docker = find_uicomponent(core:get_ui_root(), "button_group_management")
        self.button = Button.new("PoliticsButton", Docker, "ui/skins/default/icon_end_turn.png")
        self.button:Resize(72, 72)
    --failsafe
    elseif not not existingButton then
        --# assume existingButton: BUTTON
        self.button = existingButton
        self.button:SetVisible(true)
    end
    return self

end


return {
    new = eom_button.new
}

]]