

--global variables

--reduce typing
EOM_GLOBAL_EMPIRE_FACTION = "wh_main_emp_empire"
--helper for listeners
EOM_GLOBAL_EMPIRE_REGIONS = {
    ["wh_main_ostland_castle_von_rauken"] = 1,
    ["wh_main_ostland_norden"] = 1,
    ["wh_main_ostland_wolfenburg"] = 2,
    ["wh_main_reikland_altdorf"] = 2,
    ["wh_main_reikland_eilhart"] = 1,
    ["wh_main_reikland_grunburg"] = 1,
    ["wh_main_reikland_helmgart"] = 1,
    ["wh_main_stirland_the_moot"] = 1,
    ["wh_main_stirland_wurtbad"] = 2,
    ["wh_main_talabecland_kemperbad"] = 1,
    ["wh_main_wissenland_nuln"] = 2,
    ["wh_main_wissenland_pfeildorf"] = 1,
    ["wh_main_wissenland_wissenburg"] = 1,
    ["wh_main_hochland_brass_keep"] = 1,
    ["wh_main_hochland_hergig"] = 2,
    ["wh_main_middenland_carroburg"] = 1,
    ["wh_main_middenland_middenheim"] = 2,
    ["wh_main_middenland_weismund"] = 1,
    ["wh_main_nordland_dietershafen"] = 2,
    ["wh_main_nordland_salzenmund"] = 1,
    ["wh_main_talabecland_talabheim"] = 2,
    ["wh_main_averland_averheim"] = 2,
    ["wh_main_averland_grenzstadt"] = 1,
    ["wh_main_ostermark_bechafen"] = 2,
    ["wh_main_ostermark_essen"] = 1,
    ["wh_main_the_wasteland_gorssel"] = 1,
    ["wh_main_the_wasteland_marienburg"] = 2
}--:map<EMPIRE_REGION, number>


require("eom/eom_startpos")

local eom_plot = require("eom/eom_plot")
local eom_action = require("eom/eom_action")
local eom_elector = require("eom/eom_elector")
local eom_model = {} --# assume eom_model: EOM_MODEL




--v function() --> EOM_MODEL
function eom_model.init()
    local self = {}
    setmetatable(
        self, {
            __index = eom_model,
            __tostring = function() return "EOM_MODEL.3.0_BETA" end
        }
    ) --# assume self: EOM_MODEL

    self._electors = {} --:map<ELECTOR_NAME, EOM_ELECTOR>
    self._events = {} --:map<string, EOM_ACTION>
    self._plot = {} --:map<string, EOM_PLOT>

    self._coredata = {} --:map<string, EOM_CORE_DATA>
    self._view = nil --:EOM_VIEW
    return self
end

--core data
--v function(self: EOM_MODEL) --> map<string, EOM_CORE_DATA>
function eom_model.coredata(self)
    return self._coredata
end

--v function(self: EOM_MODEL, key: string) --> EOM_CORE_DATA
function eom_model.get_core_data_with_key(self, key)
    if self._coredata[key] == nil then
        return false
    end
    return self._coredata[key]
end

--v function(self: EOM_MODEL, key: string, new_value: EOM_CORE_DATA)
function eom_model.set_core_data(self, key, new_value)
    self._coredata[key] = new_value
    EOMLOG("Set core data at key ["..key.."] to ["..tostring(new_value).."] ")
end

--v function(self: EOM_MODEL, key: string)
function eom_model.remove_core_data(self, key)
    self._coredata[key] = nil
    EOMLOG("Erased core data at key ["..key.."] ")
end


--electors
--v function(self: EOM_MODEL) --> map<ELECTOR_NAME, EOM_ELECTOR>
function eom_model.electors(self)
    return self._electors
end

--v function(self: EOM_MODEL) --> vector<EOM_ELECTOR>
function eom_model.elector_list(self)
    local elector_list = {} --:vector<EOM_ELECTOR>
    for k, v in pairs(self:electors()) do
        table.insert(elector_list, v)
    end
    return elector_list
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.grant_casus_belli(self, name)
    cm:apply_effect_bundle("eom_"..name.."_casus_belli", EOM_GLOBAL_EMPIRE_FACTION, 8)
end



--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> EOM_ELECTOR
function eom_model.get_elector(self, name)
    return self._electors[name]
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> CA_FACTION
function eom_model.get_elector_faction(self, name)
    return cm:get_faction(self:get_elector(name):name())
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> boolean
function eom_model.is_elector_valid(self, name)
    local elector_active = (self:get_elector(name):status() == "normal")
    local capital_owned = (cm:get_region(self:get_elector(name):capital()):owning_faction():name() == name)
    local living = not self:get_elector_faction(name):is_dead()
    local first_dilemma_triggered =  cm:get_saved_value("eom_action_eom_dilemma_nordland_2_occured") or false
    return elector_active and capital_owned and living and first_dilemma_triggered
end

--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_all_loyalties(self, quantity)
    EOMLOG("called for an all loyalties change of ["..tostring(quantity).."]")
    for key, elector in pairs(self:electors()) do
        elector:change_loyalty(quantity)
    end
end


--v function(self: EOM_MODEL, info: ELECTOR_INFO)
function eom_model.add_elector(self, info)
    EOMLOG("entered", "eom_model.add_elector(self, info)")
    local elector = eom_elector.new(info)
    self._electors[elector:name()] = elector
    EOMLOG("Added elector ["..elector:name().."] to the model!")
end

--events 
--v function(self: EOM_MODEL, event: EOM_EVENT)
function eom_model.add_event(self, event)
    if cm:get_saved_value("eom_action_"..event.key.."_occured") == true then
        EOMLOG("Event ["..event.key.."] already occured this save, not adding it back to the model!")
        return
    end
    local choicetable = event.choices
    local key = event.key
    local conditional = event.conditional
    local action = eom_action.new(key, conditional, choicetable, self)
    self._events[key] = action
end

--v function(self: EOM_MODEL, key: string) --> EOM_ACTION
function eom_model.get_event_by_key(self, key)
    return self._events[key]
end

--v function(self: EOM_MODEL) --> map<string, EOM_ACTION>
function eom_model.events(self)
    return self._events
end

--plot events

--v function(self: EOM_MODEL, name: string) --> EOM_PLOT
function eom_model.new_story_chain(self, name)
    local event = eom_plot.new(name, self)
    self._plot[name] = event
    return event
end

--v function(self: EOM_MODEL) --> map<string, EOM_PLOT>
function eom_model.get_story(self)
    return self._plot
end

--v function(self: EOM_MODEL, name: string) --> EOM_PLOT
function eom_model.get_story_chain(self, name)
    return self._plot[name]
end


--radiant revival
--v function (self: EOM_MODEL)
function eom_model.check_dead(self)
    for name, elector in pairs(self:electors()) do
        if self:get_elector_faction(name):is_dead() then
            elector:dead_for_turn()
        end
    end
end



---EBS

--v function(self: EOM_MODEL)
function eom_model.event_and_plot_check(self)
    --plot check
    for key, story in pairs(self:get_story()) do
       if story:check_advancement() == true then
            story:advance()
            return
       end
    end
    --player restore opportunity.

    

    --events
    local next_event = self:get_core_data_with_key("next_event_turn") --# assume next_event: number
    if cm:model():turn_number() >= next_event and (not self:get_core_data_with_key("block_events_for_plot") == true) then
        for key, event in pairs(self:events()) do
            if event:allowed() then
                event:act()
                return
            end
        end
    end

    --revival events.

    --elector falls

    
end



--v function(self: EOM_MODEL)
function eom_model.elector_diplomacy(self)
    local suffix_list = {"_critical", "_good", "_indifferent", "_low", "_loyal", "_very_good", "_very_low"} --:vector<string>
    EOMLOG("entered", "function eom_model.elector_diplomacy(self)");
    local loyalty_level = "_loyal"
    for key, current_elector in pairs(self:electors()) do
        local current_loyalty = current_elector:loyalty()
        if current_loyalty > 80 then
            loyalty_level = "_loyal"
        elseif current_loyalty > 65 then
            loyalty_level = "_very_good"
        elseif current_loyalty > 50 then
            loyalty_level = "_good"
        elseif current_loyalty > 40 then
            loyalty_level = "_indifferent"
        elseif current_loyalty > 30 then
            loyalty_level = "_low"
        elseif current_loyalty > 15 then
            loyalty_level = "_very_low"
        else
            loyalty_level = "_critical"
        end

        if not cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION):has_effect_bundle("eom_"..current_elector:name()..loyalty_level) then
            EOMLOG("The bundle does not currently match!")
            for i = 1, #suffix_list do
                if cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION):has_effect_bundle("eom_"..current_elector:name()..suffix_list[i]) then
                    cm:remove_effect_bundle("eom_"..current_elector:name()..suffix_list[i], EOM_GLOBAL_EMPIRE_FACTION)
                    break
                end
            end
            EOMLOG("Set the diplomacy effect bundle to [eom_"..current_elector:name()..loyalty_level.."] for elector ["..current_elector:name().."]")
            cm:apply_effect_bundle("eom_"..current_elector:name()..loyalty_level, EOM_GLOBAL_EMPIRE_FACTION, 0)
        end
    end
end










--saving
--v function(self: EOM_MODEL) --> EOM_MODEL_SAVETABLE
function eom_model.save(self)
    EOMLOG("entered", "eom_model.save(self)")
    local savetable = {} 
    --electors
    savetable._electors = {}--:map<string, ELECTOR_INFO>
    for k, v in pairs(self:electors()) do
        local info = v:save()
        savetable._electors[k] = info
        EOMLOG("saved Elector ["..k.."]")
    end
    --core data
    savetable._coredata = self:coredata()
    EOMLOG("Core data saved!")

    for k, v in pairs(self:get_story()) do
        v:save()
    end

    return savetable
end

--loading
--v function(self: EOM_MODEL, savetable: EOM_MODEL_SAVETABLE)
function eom_model.load(self, savetable)
    EOMLOG("entered", "eom_model.load(self, savetable)")

    --electors
    for k, v in pairs(savetable._electors) do
        self:add_elector(v)
        EOMLOG("Loaded Elector ["..k.."]")
    end
    --coredata
    self._coredata = savetable._coredata
    EOMLOG("Loaded core data!")
end

--ui
--v function(self: EOM_MODEL, view: EOM_VIEW)
function eom_model.add_view(self, view)
    EOMLOG("initializing the view", "eom_model.add_view(self, view)")
    self._view = view
end

--v function(self: EOM_MODEL) --> EOM_VIEW
function eom_model.view(self)
    return self._view
end



-- ui view
local eom_view = require("eom/eom_view")



--CORE
eom = eom_model.init()
_G.eom = eom
--link the model to the view and vice versa
core:add_ui_created_callback(function()
    eom:add_view(eom_view.new())
    eom:view():add_model(eom)
    eom:view():set_button_parent()
    local button = eom:view():get_button()
    button:SetVisible(true)
end);

cm:add_saving_game_callback(
    function(context)
        local eom = _G.eom
        local save_table = eom:save()
        cm:save_named_value("eom_core", save_table, context)
    end
)

cm:add_loading_game_callback(
    function(context)
        local eom = _G.eom
        local savetable = cm:load_named_value("eom_core", {}, context)
        if cm:is_new_game() then
            local electors_to_load = return_elector_starts()
            for i = 1, #electors_to_load do
                local elector_to_load = electors_to_load[i]()
                eom:add_elector(elector_to_load)
            end
            local core_data_to_load = return_starting_core_data()
            for key, data in pairs(core_data_to_load) do
                eom:set_core_data(key, data)
            end
        else
            eom:load(savetable)
        end
    end
)



















--event triggers;


core:add_listener(
    "EOMBattlesCompleted",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character() --:CA_CHAR
        return character:faction():name() == EOM_GLOBAL_EMPIRE_FACTION 
    end,
    function(context)
        local character = context:character() --:CA_CHAR
        local enemies = cm:pending_battle_cache_get_enemies_of_char(character)
        for i = 1, #enemies do
            local enemy = enemies[i]
            local enemy_sub = enemy:faction():subculture()
            if character:won_battle() then 
                EOMLOG("Triggering event VictoryAgainstSubcultureKey_"..enemy_sub, "EOMBattlesCompleted")
                core:trigger_event("VictoryAgainstSubcultureKey_"..enemy_sub)
            else
                core:trigger_event("DefeatAgainstSubcultureKey_"..enemy_sub)
                EOMLOG("Triggering event DeafeatAgainstSubcultureKey_"..enemy_sub, "EOMBattlesCompleted")
            end
        end
    end, 
    true)


