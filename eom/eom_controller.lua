local eom_controller = {} --# assume eom_controller: EOM_CONTROLLER
local eom_view = require("eom/eom_view")

--v function() --> EOM_CONTROLLER
function eom_controller.new()
    local self = {}
    setmetatable( self, {
        __index = eom_controller
    })
    --# assume self: EOM_CONTROLLER

    self.game_model = nil --:EOM_MODEL
    self.ui_view = nil  --:EOM_VIEW

    return self
end

--v function(self: EOM_CONTROLLER, model: EOM_MODEL)
function eom_controller.add_model(self, model)
    self.game_model = model
end


--v function(self: EOM_CONTROLLER, view: EOM_VIEW)
function eom_controller.add_view(self, view)
    self.ui_view = view
end



---UI FUNCTIONS

--v function(self: EOM_CONTROLLER)
function eom_controller.docker_button_pressed(self)
    EOMLOG("Docker Button Pressed", "eom_controller.docker_button_pressed(self)")
    self.ui_view:get_frame()
    self.ui_view:frame_buttons()
    self.ui_view:populate_frame()
    local layout = find_uicomponent(core:get_ui_root(), "layout")
    layout:SetVisible(false)
    local settlement = find_uicomponent(core:get_ui_root(), "settlement_panel")
    if settlement then
     settlement:SetVisible(false)
    end
    local character = find_uicomponent(core:get_ui_root(), "units_panel")
    if character then
        character:SetVisible(false)
    end
end

--v function(self: EOM_CONTROLLER)
function eom_controller.close_politics(self)
    EOMLOG("Close button pressed on politics panel", "eom_controller.close_politics(self)")
    self.ui_view:hide_frame()
    local layout = find_uicomponent(core:get_ui_root(), "layout")
    layout:SetVisible(true)
    local settlement = find_uicomponent(core:get_ui_root(), "settlement_panel")
    if settlement then
     settlement:SetVisible(true)
    end
    local character = find_uicomponent(core:get_ui_root(), "units_panel")
    if character then
        character:SetVisible(true)
    end
end



return {
    new = eom_controller.new
}