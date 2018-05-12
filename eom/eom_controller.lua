local eom_controller = {} --# assume eom_controller: EOM_CONTROLLER

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
    EOMLOG("Docker Button Pressed", "eom_controller.docker_button_pressed()")
end





return {
    new = eom_controller.new
}