local eom_view = {} --# assume eom_view: EOM_VIEW
local eom_controller = require("eom/eom_controller")
--v function() --> EOM_VIEW
function eom_view.new()
    local self = {}
    setmetatable(self, {
        __index = eom_view
    })
    --# assume self: EOM_VIEW
    self.game_model = nil --:EOM_MODEL
    self.ui_controller = nil --:EOM_CONTROLLER
    self.button = nil --:BUTTON
    self.button_name = "PoliticsButton"
    self.button_parent = nil --:CA_UIC
    self.panel = nil --:FRAME

    return self

end

--v function(self: EOM_VIEW, model: EOM_MODEL)
function eom_view.add_model(self, model)
    self.game_model = model
end


--v function(self: EOM_VIEW, controller: EOM_CONTROLLER)
function eom_view.add_controller(self, controller)
    self.ui_controller = controller
end


--v function(self: EOM_VIEW)
function eom_view.set_button_parent(self)
    local component = find_uicomponent(core:get_ui_root(), "button_group_management")
    if not not component then
        EOMLOG("Set the button parent", "eom_view.set_button_parent(self)")
        self.button_parent = component
    else
        EOMLOG("ERROR?: Failed to set the button component!", "eom_view.set_button_parent(self)")
    end
end


--v function(self: EOM_VIEW) --> BUTTON
function eom_view.get_button(self)

    if self.button_parent == nil then
        EOMLOG("ERROR: get button called but the button parent is not set!", "eom_view.get_button(self)")
        return nil
    end

    local existingButton = Util.getComponentWithName(self.button_name)
    if not not existingButton then
        --# assume existingButton: BUTTON
        self.button = existingButton
        return self.button
    else
        local PoliticsButton = Button.new(self.button_name, self.button_parent, "CIRCULAR", "ui/skins/default/icon_capture_point.png")
        PoliticsButton:RegisterForClick(function(context) self.ui_controller:docker_button_pressed() end);
        return PoliticsButton
    end

end

--you can find the button and set it visible using the component command but this provides a shorthand method

--v function(self: EOM_VIEW, visible: boolean)
function eom_view.set_button_visible(self, visible)
    self.get_button(self)
    self.button:SetVisible(visible)
end





return {
    new = eom_view.new
}