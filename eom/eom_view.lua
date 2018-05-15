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

--# assume EOM_MODEL.get_elector_list: method() --> map<string, EOM_ELECTOR>
--# assume EOM_MODEL.get_cult_list: method() --> map<string, EOM_CULT>
--v function(self: EOM_VIEW)
function eom_view.populate_frame(self)
    EOMLOG("Populating the Frame", "eom_view.populate_frame(self)")
    local existingListView = Util.getComponentWithName(self.list_name_electors)
    if not existingListView then
        local ListViewContainer = Container.new(FlowLayout.VERTICAL);
        local eList = ListView.new(self.list_name_electors, self.frame, "VERTICAL")
        eList:Scale(1.5)
        local firstDivider = Image.new(self.list_name_electors.."divider", self.frame, "ui/skins/default/candidate_divider.png")
        local listX, listY = eList:Bounds()
        firstDivider:Resize(listX, 5)
        local GapContainer = Container.new(FlowLayout.HORIZONTAL)
        GapContainer:AddComponent(firstDivider)
        eList:AddComponent(GapContainer)


        --CULTS LIST
        local CultContainer = Container.new(FlowLayout.HORIZONTAL)
        for k, v in pairs (self.game_model:get_cult_list()) do
            --no hidden condition, cults are never hidden
            local MainCContainer = Container.new(FlowLayout.HORIZONTAL)
            MainCContainer:AddGap(10)
            local flagImage = Image.new(k.."_image", self.frame, v:get_image())
            flagImage:Scale(2)
            MainCContainer:AddComponent(flagImage)
            local panelSecond = Container.new(FlowLayout.VERTICAL)
            --panel one, loyalty.
            local SubContainerA = Container.new(FlowLayout.HORIZONTAL)
            local loyaltyText = Text.new(k.."_loyalty_text", self.frame, "TITLE", "Loyalty: ")
            local dy_loyalty = Text.new(k.."_dy_loyalty", self.frame, "TITLE", "[[col:green]]"..tostring(v:get_loyalty()).."[[/col]]")
            local tX, tY = dy_loyalty:Bounds()
            loyaltyText:Resize(tX/2, tY)
            dy_loyalty:Resize(tX/4, tY)
            SubContainerA:AddComponent(loyaltyText)
            SubContainerA:AddComponent(dy_loyalty)
            panelSecond:AddComponent(SubContainerA)
        end


        --ELECTORS LIST
        for k, v in pairs(self.game_model:get_elector_list()) do
            if not v:is_hidden() then
                local MainEContainer = Container.new(FlowLayout.HORIZONTAL)
                MainEContainer:AddGap(10)
                local flagImage = Image.new(k.."_image", self.frame, v:get_image())
                flagImage:Scale(2)
                MainEContainer:AddComponent(flagImage)
                --panel one, status and name
                local SubContainerA = Container.new(FlowLayout.VERTICAL)
                local NameText = Text.new(k.."_name", self.frame, "TITLE", v:get_ui_name())
                SubContainerA:AddComponent(NameText)
                local StatusText = Text.new(k.."_status", self.frame, "TITLE", v:get_tooltip())
                SubContainerA:AddComponent(StatusText)
                MainEContainer:AddComponent(SubContainerA)
                --panel two, loyalty and power
                local SubContainerB = Container.new(FlowLayout.VERTICAL)
                --loyalty
                local loyaltyContainer = Container.new(FlowLayout.HORIZONTAL)
                local loyaltyText = Text.new(k.."_loyalty_text", self.frame, "TITLE", "Loyalty: ")
                local dy_loyalty = Text.new(k.."_dy_loyalty", self.frame, "TITLE", "[[col:green]]"..tostring(v:get_loyalty()).."[[/col]]")
                if v:get_loyalty() < 33 then
                    dy_loyalty:SetText("[[col:red]]"..tostring(v:get_loyalty()).."[[/col]]")
                end
                local tX, tY = dy_loyalty:Bounds()
                loyaltyText:Resize(tX/2, tY)
                dy_loyalty:Resize(tX/4, tY)
                loyaltyContainer:AddComponent(loyaltyText)
                loyaltyContainer:AddComponent(dy_loyalty)
                SubContainerB:AddComponent(loyaltyContainer)
                --power
                local PowerContainer = Container.new(FlowLayout.HORIZONTAL)
                local PowerText = Text.new(k.."_power_text", self.frame, "TITLE", "Power: ")
                local dy_power = Text.new(k.."_dy_power", self.frame, "TITLE", "[[col:red]]"..tostring(v:get_base_power()).."[[/col]]")
                local tX, tY = dy_power:Bounds()
                dy_power:Resize(tX/3, tY)
                PowerContainer:AddComponent(PowerText)
                PowerContainer:AddComponent(dy_power)
                SubContainerB:AddComponent(PowerContainer)
                MainEContainer:AddComponent(SubContainerB)
                --
                eList:AddComponent(MainEContainer)
                local firstDivider = Image.new(k.."divider", self.frame, "ui/skins/default/candidate_divider.png")
                firstDivider:Resize(listX, 5)
                local GapContainer = Container.new(FlowLayout.HORIZONTAL)
                GapContainer:AddComponent(firstDivider)
                eList:AddComponent(GapContainer)
            end
        end
        ListViewContainer:AddComponent(eList)

        Util.centreComponentOnComponent(ListViewContainer, self.frame:GetContentPanel())
    end

end

return {
    new = eom_view.new
}