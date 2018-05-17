local eom_view = {} --# assume eom_view: EOM_VIEW


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
    self.frame = nil --:FRAME
    self.frame_name = "PoliticsFrame"
    self.list_electors = nil --:LIST_VIEW
    self.list_name_electors = "ElectorsListView"

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

--# assume EOM_CONTROLLER.docker_button_pressed: method()
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
        PoliticsButton:Resize(69, 69)
        return PoliticsButton
    end  

end

--you can find the button and set it visible using the component command but this provides a shorthand method

--v function(self: EOM_VIEW, visible: boolean)
function eom_view.set_button_visible(self, visible)
    self.get_button(self)
    self.button:SetVisible(visible)
end


--FRAME


--v function(self: EOM_VIEW) --> FRAME
function eom_view.get_frame(self)

    EOMLOG("Getting the politics frame!", "eom_view.get_frame(self)")
    local existingFrame = Util.getComponentWithName(self.frame_name)
    if not not existingFrame then
        --# assume existingFrame: FRAME
        existingFrame:SetVisible(true)
        self.frame = existingFrame
        return existingFrame
    else
        PoliticsFrame = Frame.new(self.frame_name)
        PoliticsFrame:Scale(1.5)
        Util.centreComponentOnScreen(PoliticsFrame)
        self.frame = PoliticsFrame
        PoliticsFrame:SetTitle("Imperial Politics")
        local parchment = PoliticsFrame:GetContentPanel()
        parchment:SetImage("ui/skins/default/politics_panel.png")
        local parchmentX, parchmentY = parchment:Bounds()
       -- local background = Image.new("PoliticsBackground", parchment, "ui/skins/default/panel_leather_frame_red.png")
       -- background:Resize(parchmentX, parchmentY)
        return PoliticsFrame
    end
end

--v function(self: EOM_VIEW)
function eom_view.hide_frame(self)
    self.frame:SetVisible(false)
end

--# assume EOM_CONTROLLER.close_politics: method()
--v function(self: EOM_VIEW)
function eom_view.frame_buttons(self)
    if self.frame == nil then
        EOMLOG("ERROR: frame buttons called but the button parent is not set!", "eom_view.frame_buttons(self)")
        return
    end
    local existingCloseButton = Util.getComponentWithName(self.frame_name.."close")
    if not not existingCloseButton then
        --# assume existingCloseButton: BUTTON
        existingCloseButton:SetVisible(true)
    else
    local CloseButton = Button.new(self.frame_name.."close", self.frame, "CIRCULAR", "ui/skins/default/icon_check.png");
    local frameWidth, frameHeight = self.frame:Bounds()
    local buttonWidth, buttonHeight = CloseButton:Bounds()
    CloseButton:PositionRelativeTo(self.frame, (frameWidth/2) - (buttonWidth/2), frameHeight - (buttonHeight*2) )
    CloseButton:RegisterForClick(function(context) self.ui_controller:close_politics() end)
    end

end


--v function(self: EOM_VIEW)
function eom_view.populate_frame(self)

    local existingView = Util.getComponentWithName(self.list_name_electors)
    if not existingView then
        local frameContainer = Container.new(FlowLayout.VERTICAL)
        local fX, fY = self.frame:Bounds()
        
        --title bar cults goes here.
        local firstDivider = Image.new(self.list_name_electors.."divider", self.frame, "ui/skins/default/candidate_divider.png")
        firstDivider:Resize(fX*(2/3), 5)
        frameContainer:AddComponent(firstDivider)
        local cultContainer = Container.new(FlowLayout.HORIZONTAL)
        cultContainer:AddGap(fX/4 - 10)
        for k, v in pairs(self.game_model:get_cult_list()) do
            local currentContainer = Container.new(FlowLayout.VERTICAL)
            local cultButton = Button.new(k.."cult_button", self.frame, "SQUARE", v:get_image())
            cultButton:Scale(2)
            local dy_loyalty = Text.new(k.."_dy_loyalty", self.frame, "TITLE", "[[col:green]]"..tostring(v:get_loyalty()).."[[/col]]")
            local bX, bY = cultButton:Bounds()
            local tX, tY = dy_loyalty:Bounds()
            dy_loyalty:Resize(bX, tY)
            currentContainer:AddComponent(cultButton)
            currentContainer:AddComponent(dy_loyalty)
            cultContainer:AddGap(5)
            cultContainer:AddComponent(currentContainer)
        end
        frameContainer:AddComponent(cultContainer)
        local SecondDivider = Image.new(self.list_name_electors.."divider2", self.frame, "ui/skins/default/candidate_divider.png")
        SecondDivider:Resize(fX*(2/3), 5)
        frameContainer:AddComponent(SecondDivider)
        frameContainer:AddGap(10)

        --title bar electors goes here.
       --frameContainer:AddGap(5)
        local electorListView = ListView.new(self.list_name_electors, self.frame, "HORIZONTAL")
        electorListView:Resize(fX*(2/3), fY/4)
        local electorContainer = Container.new(FlowLayout.HORIZONTAL)
        electorContainer:AddGap(10)
        electorListView:AddComponent(electorContainer)
        for k, v in pairs(self.game_model:get_elector_list()) do
            if not v:is_hidden() then
                local currentContainer = Container.new(FlowLayout.VERTICAL)
                local electorButton = Button.new(k.."elector_button", self.frame, "SQUARE", v:get_image())
                electorButton:Scale(2)
                local dy_loyalty = Text.new(k.."_dy_loyalty", self.frame, "TITLE", "[[col:green]]"..tostring(v:get_loyalty()).."[[/col]]")
                if v:get_status() == "seceded" then 
                    dy_loyalty:SetText("[[col:red]]Seceded[[/col]]")
                end
                local bX, bY = electorButton:Bounds()
                local tX, tY = dy_loyalty:Bounds()
                dy_loyalty:Resize(bX, tY)
                currentContainer:AddComponent(electorButton)
                currentContainer:AddComponent(dy_loyalty)

                

                electorListView:AddComponent(currentContainer)
            end
        end
        frameContainer:AddComponent(electorListView)
        Util.centreComponentOnComponent(frameContainer, self.frame)

    else
        for k, v in pairs(self.game_model:get_cult_list()) do
            local dy_loyalty = Util.getComponentWithName(k.."_dy_loyalty")
            --# assume dy_loyalty: TEXT
            dy_loyalty:SetText("[[col:green]]"..tostring(v:get_loyalty()).."[[/col]]")
        end
        for k, v in pairs(self.game_model:get_elector_list()) do
            local dy_loyalty = Util.getComponentWithName(k.."_dy_loyalty")
            --# assume dy_loyalty: TEXT
            dy_loyalty:SetText("[[col:green]]"..tostring(v:get_loyalty()).."[[/col]]")
            if v:get_status() == "seceded" then 
                dy_loyalty:SetText("[[col:red]]Seceded[[/col]]")
            end
        end
    end
end

return {
    new = eom_view.new
}