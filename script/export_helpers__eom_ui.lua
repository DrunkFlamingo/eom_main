
cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end

if not Util then
    script_error("UIMF IS MISSING")
end

out("EOM UI IS ACTIVE")

-- ui view

local eom_view = {} --# assume eom_view: EOM_VIEW

--controller functions
--# assume EOM_VIEW.docker_button_pressed: method()
--# assume EOM_VIEW.close_politics: method()



--v function() --> EOM_VIEW
function eom_view.new()
    local self = {}
    setmetatable(self, {
        __index = eom_view
    })
    --# assume self: EOM_VIEW
    self.game_model = nil --:EOM_MODEL
    self.button = nil --:BUTTON
    self.button_name = "WEC_CUSTOM_FEATURE"
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




--v function(self: EOM_VIEW)
function eom_view.set_button_parent(self)
    local component = find_uicomponent(core:get_ui_root(), "button_group_management")
    if not not component then
        EOMLOG("UI: Set the button parent")
        self.button_parent = component
    else
        EOMLOG("ERROR?: Failed to set the button component!")
    end
end

--# assume EOM_CONTROLLER.docker_button_pressed: method()
--v function(self: EOM_VIEW) --> BUTTON
function eom_view.get_button(self)

    if self.button_parent == nil then
        EOMLOG("ERROR: get button called but the button parent is not set!")
        return nil
    end

    local existingButton = Util.getComponentWithName(self.button_name)
    if not not existingButton then
        --# assume existingButton: BUTTON
        self.button = existingButton
        return self.button
    else
        local PoliticsButton = Button.new(self.button_name, self.button_parent, "CIRCULAR", "ui/skins/default/icon_capture_point.png")
        PoliticsButton:RegisterForClick(function(context) self:docker_button_pressed() end);
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

    EOMLOG("Getting the politics frame!")
    local existingFrame = Util.getComponentWithName(self.frame_name)
    if not not existingFrame then
        --# assume existingFrame: FRAME
        existingFrame:SetVisible(true)
        self.frame = existingFrame
        return existingFrame
    else
        PoliticsFrame = Frame.new(self.frame_name)
        PoliticsFrame:Scale(1.70)
        Util.centreComponentOnScreen(PoliticsFrame)
        self.frame = PoliticsFrame
        PoliticsFrame:SetTitle("Imperial Politics")
        local parchment = PoliticsFrame:GetContentPanel()
       -- parchment:SetImage("ui/skins/default/politics_panel.png")
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

--v function(self: EOM_VIEW)
function eom_view.frame_buttons(self)
    if self.frame == nil then
        EOMLOG("ERROR: frame buttons called but the button parent is not set!")
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
    CloseButton:RegisterForClick(function(context) self:close_politics() end)
    end

end


--v function(self: EOM_VIEW)
function eom_view.populate_frame(self)

    local existingView = Util.getComponentWithName(self.list_name_electors)
    if not existingView then
        local frameContainer = Container.new(FlowLayout.VERTICAL)
        local fX, fY = self.frame:Bounds()
        local cultTitleContainer = Container.new(FlowLayout.HORIZONTAL)
        
        local cultsTitle = Image.new(self.list_name_electors.."_title", self.frame, "ui/custom/cults_banner.png")
        cultsTitle:Resize(fX*(1/3), fX*(1/3)/3.34)
        local ctX, ctY = cultsTitle:Bounds()
        cultTitleContainer:AddGap(fX/2 - ctX)
        cultTitleContainer:AddComponent(cultsTitle)
        frameContainer:AddComponent(cultTitleContainer)
        -- local firstDivider = Image.new(self.list_name_electors.."divider", self.frame, "ui/skins/default/candidate_divider.png")
        -- firstDivider:Resize(fX*(2/3), 3)
        --  frameContainer:AddComponent(firstDivider)
        local cultContainer = Container.new(FlowLayout.HORIZONTAL)
        cultContainer:AddGap(fX/2 - 352)

        for k, v in pairs(self.game_model:electors()) do
            if v:is_cult() and (not v:is_hidden()) then
                local currentContainer = Container.new(FlowLayout.VERTICAL)
                local cultButton = Button.new(k.."cult_button", self.frame, "SQUARE", v:image())
                cultButton:Scale(1.75)
                local dy_loyalty = Text.new(k.."_dy_loyalty", self.frame, "TITLE", "[[col:dark_g]]"..tostring(v:loyalty()).."[[/col]]")
                local bX, bY = cultButton:Bounds()
                local tX, tY = dy_loyalty:Bounds()
                dy_loyalty:Resize(bX, tY)
                currentContainer:AddComponent(cultButton)
                currentContainer:AddComponent(dy_loyalty)
                cultContainer:AddGap(5)
                cultContainer:AddComponent(currentContainer)
            end
        end
        frameContainer:AddComponent(cultContainer)
        -- local SecondDivider = Image.new(self.list_name_electors.."divider2", self.frame, "ui/skins/default/candidate_divider.png")
        --SecondDivider:Resize(fX*(2/3), 3)
        --frameContainer:AddComponent(SecondDivider)
        local electorTitleContainer = Container.new(FlowLayout.HORIZONTAL)
        electorTitleContainer:AddGap(fX/2 - ctX)
        local electorTitle = Image.new(self.list_name_electors.."_title2", self.frame, "ui/custom/electorcounts_banner.png")
        electorTitle:Resize(fX*(1/3), fX*(1/3)/3.67)
        electorTitleContainer:AddComponent(electorTitle)
        frameContainer:AddComponent(electorTitleContainer)
        local electorListView = ListView.new(self.list_name_electors, self.frame, "HORIZONTAL")
        electorListView:Resize(fX*(2/3), fY/4)
        local electorContainer = Container.new(FlowLayout.HORIZONTAL)
        electorContainer:AddGap(10)
        electorListView:AddComponent(electorContainer)
        for k, v in pairs(self.game_model:electors()) do
            if (not v:is_hidden()) and (not v:is_cult()) then
                local currentContainer = Container.new(FlowLayout.VERTICAL)
                local electorButton = Button.new(k.."elector_button", self.frame, "SQUARE", v:image())
                electorButton:Scale(1.75)
                local dy_loyalty = Text.new(k.."_dy_loyalty", self.frame, "TITLE", "[[col:dark_g]]"..tostring(v:loyalty()).."[[/col]]")
                if v:status() == "seceded" then 
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
        local fcX, fcY = frameContainer:Position()
        frameContainer:MoveTo(fcX, fcY - 15)

    else
        for k, v in pairs(self.game_model:electors()) do
            if not v:is_hidden() then
                local dy_loyalty = Util.getComponentWithName(k.."_dy_loyalty")
                --# assume dy_loyalty: TEXT
                dy_loyalty:SetText("[[col:dark_g]]"..tostring(v:loyalty()).."[[/col]]")
                if v:status() == "seceded" then 
                    dy_loyalty:SetText("[[col:red]]Seceded[[/col]]")
                end
            else
                local dy_loyalty = Util.getComponentWithName(k.."_dy_loyalty") --# assume dy_loyalty: CA_UIC
                local electorButton = Util.getComponentWithName(k.."elector_button")--# assume electorButton: CA_UIC
                if dy_loyalty and electorButton then
                    dy_loyalty:SetVisible(false)
                    electorButton:SetVisible(false)
                end
            end
        end
        EOMLOG("UI: Updated Loyalties")
    end
    EOMLOG("UI: Populate frame completed with no errors")
end
    

--controller methods (assumed)


--v function(self: EOM_VIEW)
function eom_view.close_politics(self)
    EOMLOG("UI: Close button pressed on politics panel")
    self:hide_frame()
    local layout = find_uicomponent(core:get_ui_root(), "layout")
    if not not layout then
        layout:SetVisible(true)
        EOMLOG("Showing the layout!")
    else
        EOMLOG("Could not find the layout?!?")
    end
    local settlement = find_uicomponent(core:get_ui_root(), "settlement_panel")
    if not not settlement then
     settlement:SetVisible(true)
    end
    local character = find_uicomponent(core:get_ui_root(), "units_panel")
    if not not character then
        character:SetVisible(true)
    end
end


--v function(self: EOM_VIEW)
function eom_view.docker_button_pressed(self)
    EOMLOG("Docker Button Pressed")
    self:get_frame()
    self:frame_buttons()
    local ok, err = pcall( function() self:populate_frame() end)
    if not ok then
        --# assume err: string
        EOMLOG(err)
    end
    local layout = find_uicomponent(core:get_ui_root(), "layout")
    if not not layout then
        layout:SetVisible(false)
    end
    local settlement = find_uicomponent(core:get_ui_root(), "settlement_panel")
    if not not settlement then
        EOMLOG("Setting Settlements Panel Invisible")
     settlement:SetVisible(false)
    end
    local character = find_uicomponent(core:get_ui_root(), "units_panel")
    if not not character then
        EOMLOG("Setting Character Panel Invisible")
        character:SetVisible(false)
    end
end

--link the model to the view and vice versa
core:add_ui_created_callback(function()
    eom:add_view(eom_view.new())
    eom:view():add_model(eom)
    eom:view():set_button_parent()
    local button = eom:view():get_button()
    button:SetVisible(true)
end);







core:add_listener(
    "UI_FACTION_TURN_START",
    "FactionTurnStart",
    true,
    function(context)
        if context:faction():name() == eom:empire() and context:faction():is_human() then
            local button = eom:view():get_button()
            button:SetVisible(true)
        elseif context:faction():is_human() then
            local button = eom:view():get_button()
            button:SetVisible(false)
        end
    end,
    true)