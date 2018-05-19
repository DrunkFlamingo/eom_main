-- EOMLOG("eom model required", "file.eom_model")
--[[
local eom_elector = require("eom/eom_elector")
local eom_cult = require("eom/eom_cult")
local eom_civil_war = require("eom/eom_civil_war")
local eom_action = require("eom/eom_action")
local eom_trait = require("eom/eom_trait")
]]

--ui 



local eom_model = {} --# assume eom_model: EOM_MODEL


--model assembly


--v function() --> EOM_MODEL
function eom_model.new()
    EOMLOG("Starting Model Creation", "function.eom_model.new()")
    local self = {};
    setmetatable(self, {
        __index = eom_model
    })
    --# assume self: EOM_MODEL

    self.electors = {}--:map<string, EOM_ELECTOR>
    self.cults = {}--:map<string, EOM_CULT>
    self.civil_wars = {}--:vector<EOM_CIVIL_WAR>
    self.elector_actions = {} --:vector<EOM_ACTION>
    self.cult_actions = {} --:vector<EOM_ACTION>
    self.core_data = {} --:map<string, string | number | boolean>
    self.active_traits = {} --:map<string, EOM_TRAIT>
    self.ui_view = nil --: EOM_VIEW
    self.ui_controller = nil --: EOM_CONTROLLER

    EOMLOG("******CREATED THE MODEL*****", "function.eom_model.new()")
    return self
end;

--object population

--v function(self: EOM_MODEL) --> map<string, WHATEVER>
function eom_model.save(self)
    EOMLOG("SAVING THE MODEL", "eom_model.save(self)")
    local st = {}
    st.electors = {}
    for key, value in pairs(self.electors) do
        local s = self.electors[key]:save()
        table.insert(st.electors, s)
    end
    st.cults = {}
    for key, value in pairs(self.cults) do
        local s = self.cults[key]:save()
        table.insert(st.cults, s)
    end
    st.core_data = self.core_data

    return st
end


--v function(self: EOM_MODEL, key: string, elector: EOM_ELECTOR)
function eom_model.add_elector(self, key, elector)
    EOMLOG("Added elector with key ["..key.."]", "eom_model.add_elector(self, key,elector)")
    local electors = self.electors;
    electors[key] = elector;
end;

--v function(self: EOM_MODEL, key: string, cult: EOM_CULT)
function eom_model.add_cult(self, key, cult)
    EOMLOG("Added cult with key ["..key.."]", "eom_model.add_cult(self, key, elector)")
    local cults = self.cults
    cults[key] = cult
end;

--v function(self: EOM_MODEL, civil_war: EOM_CIVIL_WAR)
function eom_model.add_civil_war(self, civil_war)
    EOMLOG("Added a new civil war to the model", "eom_model.add_civil_war(self, civil_war)")
    table.insert(self.civil_wars, civil_war)
    civil_war.eom = self
end

--v function(self: EOM_MODEL, key: string, data: string | number | boolean)
function eom_model.add_core_data(self, key, data)
    EOMLOG("added core data with key ["..key.."] and value ["..tostring(data).."]", "eom_model.add_core_data(self, key_data)")
    local core_data = self.core_data
    core_data[key] = data
end

--v function(self: EOM_MODEL, action: EOM_ACTION)
function eom_model.add_elector_action(self, action)
    EOMLOG("added an action to the elector actions", "eom_model.add_elector_action(self, action)")
    table.insert(self.elector_actions, action)
    action:register_to_model(self)
end

--v function(self: EOM_MODEL, action: EOM_ACTION)
function eom_model.add_cult_action(self, action)
    EOMLOG("added an action to the cult actions", "eom_model.add_cult_action(self, action)")
    table.insert(self.cult_actions, action)
    action:register_to_model(self)
end

--v function(self: EOM_MODEL, trait: EOM_TRAIT)
function eom_model.add_trait(self, trait)
    trait:activate(self)
    self.active_traits[trait:get_name()] = trait
end

--v function(self: EOM_MODEL, name: string)
function eom_model.disactivate_trait_with_name(self, name)
    local trait = self.active_traits[name]
    trait:deactivate()
    self.active_traits[name] = nil
end


--if choices are not present or used pass a blank function.
--v function(self: EOM_MODEL, dilemma: string, choice1: function(), choice2: function(), choice3: function(), choice4: function())
function eom_model.add_dilemma_to_model(self, dilemma, choice1, choice2, choice3, choice4)
    EOMLOG("Adding a scripted dilemma choice responce to the model", "eom_model.add_dilemma_to_model(self, dilemma, always, choice1, choice2, choice3, choice4")
    core:add_listener(
        "eom"..dilemma,
        "DilemmaChoiceMadeEvent",
        function(context)
            return context:dilemma() == dilemma
        end,
        function(context)
            EOMLOG("Dilemma choice made ["..tostring(context:choice()).."] for dilemma ["..tostring(context:dilemma()).."]", "listener.eom_model.add_dilemma_to_model")
            if context:choice() == 0 then
                choice1()
            elseif context:choice() == 1 then
                choice2()
            elseif context:choice() == 2 then
                choice3()
            elseif context:choice() == 3 then
                choice4()
            end
        end,
        false);
end;


--retval--

--v function(self: EOM_MODEL, key: string) --> number | string | boolean
function eom_model.get_core_data(self, key)
    EOMLOG("retrieved core data piece at ["..key.."]", "eom_model.get_core_data(self, key)")
    return self.core_data[key]
end

--v function(self: EOM_MODEL, key: string) --> EOM_ELECTOR
function eom_model.get_elector(self, key)
    EOMLOG("retrieved elector object ["..key.."]", "eom_model.get_elector(self, key)")
    return self.electors[key]
end

--v function(self: EOM_MODEL, key: string) --> EOM_CULT
function eom_model.get_cult(self, key)
    EOMLOG("retrieved cult object ["..key.."]", "eom_model.get_cult(self_key)")
    return self.cults[key]
end

--v function(self: EOM_MODEL) --> map<string, EOM_ELECTOR>
function eom_model.get_elector_list(self)
    return self.electors
end

--v function(self: EOM_MODEL) --> map<string, EOM_CULT>
function eom_model.get_cult_list(self)
    return self.cults
end


--UI SYSTEMS
local eom_controller = require("eom/eom_controller")
local eom_view = require("eom/eom_view")

--v function(self: EOM_MODEL)
function eom_model.create_ui(self)
    local controller = eom_controller.new()
    local view = eom_view.new()
    controller:add_model(self)
    controller:add_view(view)
    view:add_model(self)
    view:add_controller(controller)
    self.ui_view = view
    self.ui_controller = controller
end

--v function(self: EOM_MODEL) --> EOM_VIEW
function eom_model.view(self)
    return self.ui_view
end

--v function(self: EOM_MODEL) --> EOM_CONTROLLER
function eom_model.controller(self)
    return self.ui_controller
end

--core functions


--v function(self: EOM_MODEL)
function eom_model.decide_on_actions(self)
    EOMLOG("Checking to see who should act", "eom_model.decide_on_actions(self)")
    --cults first
    local timer = self:get_core_data("cult_meeting_timer")
    --# assume timer: number
    if timer <= 0 then
        EOMLOG("The cults are deciding on political action", "eom_model.decide_on_actions(self)")
        _any_true = false --:boolean
        local valid_acts = {} --:vector<EOM_ACTION>
        for i = 1, #self.cult_actions do
            if self.cult_actions[i]:check() == true then
                table.insert(valid_acts, self.cult_actions[i])
                _any_true = true;
                EOMLOG("The cults have found a political action!", "eom_model.decide_on_actions(self)")
            end
        end
        if not _any_true == false then
            EOMLOG("The cults are randomly picking a valid action", "eom_model.decide_on_actions(self)")
            local i = cm:random_number(#valid_acts)
            valid_acts[i]:act()
            self:add_core_data("cult_meeting_timer", 24)
            --need to skip the electors this time, since the cults are acting.
            self:add_core_data("elector_meeting_timer", 6)
        end

    else
        EOMLOG("The cult does not meet this turn.", "eom_model.decide_on_actions(self)")
        local new_timer = timer - 1;
        self:add_core_data("cult_meeting_timer", new_timer)
    end



      --electors.
    local timer = self:get_core_data("elector_meeting_timer")
    --# assume timer: number
    if timer <= 0 then
        EOMLOG("The Electors are deciding on an action.", "eom_model.decide_on_actions(self)")
        _any_true = false 
        local valid_acts = {} --:vector<EOM_ACTION>
        for i = 1, #self.elector_actions do
            if self.elector_actions[i]:check() == true then
                table.insert(valid_acts, self.elector_actions[i])
                _any_true = true;
                EOMLOG("The Electors have found a political action!", "eom_model.decide_on_actions(self)")
            end
        end
        if _any_true == false then
            local i = cm:random_number(#valid_acts)
            valid_acts[i]:act()
            self:add_core_data("elector_meeting_timer", 6)
            EOMLOG("The Electors are randomly selecting a valid action!", "eom_model.decide_on_actions(self)")
        end

    else
        EOMLOG("The Electors do not meet this turn.", "eom_model.decide_on_actions(self)")
        local new_timer = timer - 1;
        self:add_core_data("elector_meeting_timer", new_timer)
    end



end

--v function(self: EOM_MODEL)
function eom_model.refresh(self)
    EOMLOG("Refreshing all elector data", "eom_model.refresh(self)")
    for k, v in pairs(self.electors) do
        v:refresh()
    end
end

--v function(self: EOM_MODEL)
function eom_model.consequences(self)
    EOMLOG("Checking Consequences for electors", "eom_model.consequences(self)")
    for k, v in pairs(self.electors) do
        if v:get_status() == "normal" then
            local loyalty = v:get_loyalty()
            if loyalty > 99 then
                v:set_status("loyal")
                cm:force_change_cai_faction_personality(v:get_faction_name(), "df_"..v:get_faction_name().."_loyal");
                EOMLOG(" ["..v:get_faction_name().."] was fully loyal, changing their status and personality","eom_model.consequences(self)")
                --all other consequences can be done by other actions.
            end
            if v:get_status() == "normal" then
                v:set_personality()
                v:remove_diplomatic_bundles()
                v:apply_diplomatic_bundles()
            end
        end
    end
end

--v function(self: EOM_MODEL)
function eom_model.plot(self)
    EOMLOG("Checking the plot elements", "eom_model.plot(self)")
    --these are gonna be messy, but we will leave them for now.

end

--v function(self: EOM_MODEL)
function eom_model.civil_war_check(self)
    EOMLOG("Checking for civil war potential", "eom_model.civil_war_check(self)")
end





--v function(self: EOM_MODEL)
function eom_model.activate(self)
    core:add_listener(
        "eom_model_core_turnstart",
        "FactionTurnStart",
        function(context)
            return context:faction():name() == "wh_main_emp_empire"
        end,
        function(context)
            self:refresh()
            self:plot()
            self:civil_war_check()
            self:consequences()
            self:decide_on_actions()
        end,
        true)
end




return {
    new = eom_model.new
}