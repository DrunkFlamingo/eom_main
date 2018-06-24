

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
}--:map<string, number>

EOM_GLOBAL_REGION_TO_ELECTOR = {
    ["wh_main_ostland_castle_von_rauken"] = "wh_main_emp_ostland",
    ["wh_main_ostland_norden"] = "wh_main_emp_ostland",
    ["wh_main_ostland_wolfenburg"] = "wh_main_emp_ostland",
    ["wh_main_stirland_the_moot"] = "wh_main_emp_stirland",
    ["wh_main_stirland_wurtbad"] = "wh_main_emp_stirland",
    ["wh_main_talabecland_kemperbad"] = "wh_main_emp_talabecland",
    ["wh_main_wissenland_nuln"] = "wh_main_emp_wissenland",
    ["wh_main_wissenland_pfeildorf"] = "wh_main_emp_wissenland",
    ["wh_main_wissenland_wissenburg"] = "wh_main_emp_wissenland",
    ["wh_main_hochland_brass_keep"] = "wh_main_emp_hochland",
    ["wh_main_hochland_hergig"] = "wh_main_emp_hochland",
    ["wh_main_middenland_carroburg"] = "wh_main_emp_middenland",
    ["wh_main_middenland_middenheim"] = "wh_main_emp_middenland",
    ["wh_main_middenland_weismund"] = "wh_main_emp_middenland",
    ["wh_main_nordland_dietershafen"] = "wh_main_emp_nordland",
    ["wh_main_nordland_salzenmund"] = "wh_main_emp_nordland",
    ["wh_main_talabecland_talabheim"] = "wh_main_emp_talabecland",
    ["wh_main_averland_averheim"] = "wh_main_emp_averland",
    ["wh_main_averland_grenzstadt"] = "wh_main_emp_averland",
    ["wh_main_ostermark_bechafen"] = "wh_main_emp_ostermark",
    ["wh_main_ostermark_essen"] = "wh_main_emp_ostermark",
    ["wh_main_the_wasteland_gorssel"] = "wh_main_emp_marienburg",
    ["wh_main_the_wasteland_marienburg"] = "wh_main_emp_marienburg"
}--:map<string, ELECTOR_NAME>


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
--v function(self: EOM_MODEL) --> string
function eom_model.empire(self)
    return "wh_main_emp_empire"
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

--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> boolean
function eom_model.has_elector(self, name)
    return not not self._electors[name]
end

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
    local living = (not self:get_elector_faction(name):is_dead()) 
    if self:get_elector(name):is_cult() then
        living = true 
        capital_owned = true
    end
    local first_dilemma_triggered =  cm:get_saved_value("eom_action_eom_dilemma_nordland_2_occured") or false
    EOMLOG("is Elector Valid returning ["..tostring(elector_active and capital_owned and living and first_dilemma_triggered).."] ")
    return elector_active and capital_owned and living and first_dilemma_triggered
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> boolean
function eom_model.is_elector_valid_for_taxes(self, name)
    local elector_active = (self:get_elector(name):status() == "normal")
    local capital_owned = (cm:get_region(self:get_elector(name):capital()):owning_faction():name() == name)
    local living = (not self:get_elector_faction(name):is_dead()) 
    return elector_active and capital_owned and living
end


--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> boolean
function eom_model.is_elector_rebelling(self, name)
    return self:get_elector(name):status() == "normal" or self:get_elector(name):status() == "fully_loyal"
end


--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_all_loyalties(self, quantity)
    EOMLOG("called for an all loyalties change of ["..tostring(quantity).."]")
    for key, elector in pairs(self:electors()) do
        elector:change_loyalty(quantity)
    end
end

--v function(self: EOM_MODEL, exception: vector<ELECTOR_NAME>, quantity: number)
function eom_model.change_loyalty_for_all_except(self, exception, quantity)    
    local reverse_quantity = -(quantity)
    self:change_all_loyalties(quantity)
    for i = 1, #exception do
        self:get_elector(exception[i]):change_loyalty(reverse_quantity)
    end
end


--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_sigmarite_loyalties(self, quantity)
    EOMLOG("called for a change in sigmarite loyalties of ["..tostring(quantity).."]")
    self:get_elector("wh_main_emp_wissenland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_stirland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_ostland"):change_loyalty(quantity)
end

--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_ulrican_loyalites(self, quantity)
    EOMLOG("called for a change in ulrican loyalties of ["..tostring(quantity).."]")
    self:get_elector("wh_main_emp_middenland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_hochland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_nordland"):change_loyalty(quantity)
end

--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_atheist_loyalties(self, quantity)
    EOMLOG("called for a change in sigmarite loyalties of ["..tostring(quantity).."]")
    self:get_elector("wh_main_emp_averland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_ostermark"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_marienburg"):change_loyalty(quantity)
end




--v function(self: EOM_MODEL, info: ELECTOR_INFO)
function eom_model.add_elector(self, info)
    EOMLOG("entered", "eom_model.add_elector(self, info)")
    local elector = eom_elector.new(info)
    self._electors[elector:name()] = elector
    EOMLOG("Added elector ["..elector:name().."] to the model!")
end



    




--events 
--@name: add_event
--@description: creates a new event from a table template.
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

--rebellion
--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.elector_rebellion_end(self, name)
    self:get_elector(name):set_status("normal")
    self:get_elector(name):change_loyalty(20)
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.elector_rebellion_start(self, name)
    if name == "wh_main_vmp_schwartzhafen" then
        EOMLOG("Vlad can't rebel!")
        return 
    end


    EOMLOG("triggering rebellion for ["..name.."] ")
    local elector = self:get_elector(name)
    elector:set_status("open_rebellion")
    cm:trigger_incident(EOM_GLOBAL_EMPIRE_FACTION, "eom_"..name.."_open_rebellion", true)
    if elector:is_cult() then
        local x, y = elector:expedition_coordinates()
        cm:create_force(name, elector:get_army_list(), elector:expedition_region(), x, y, true, true)
        core:add_listener(
            "rebellion_ender"..name,
            "FactionTurnStart",
            function(context)
                return cm:get_faction(name):is_dead()
            end,
            function(context)
                self:elector_rebellion_end(name)
            end,
            false)
    end
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

--v function(self: EOM_MODEL, name:ELECTOR_NAME, show_message_event: boolean?)
function eom_model.elector_fallen(self, name, show_message_event)
    local elector = self:get_elector(name)
    self:change_all_loyalties(-10)
    --NOTE: trigger elector fallen event.
    elector:set_status("fallen")
    elector:set_visible(false)
    if show_message_event then
        cm:show_message_event(
            self:empire(),
            "event_feed_strings_text_elector_fallen_title",
            "event_feed_strings_text_elector_fallen_subtitle",
            "event_feed_strings_text_elector_"..name.."_fallen_detail",
            true,
            591
        )
    end
end

    
--v function (self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.trigger_restoration_dilemma(self, name)
    local elector = self:get_elector(name)
    cm:trigger_dilemma(EOM_GLOBAL_EMPIRE_FACTION, "eom_"..name.."_restoration", true)
    core:add_listener(
        "restoration_"..name,
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 1 then
                self:elector_fallen(name)
            elseif context:choice() == 0 then
                if self:get_elector(name):status() == "open_rebellion" then
                    self:elector_rebellion_end(name)
                    self:get_elector(name):respawn_at_capital()
                else
                    self:get_elector(name):respawn_at_capital()
                    self:get_elector(name):change_loyalty(20)
                end
            end
        end,
        false)
end

--war systems
--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.grant_casus_belli(self, name)
    cm:apply_effect_bundle("eom_"..name.."_casus_belli", EOM_GLOBAL_EMPIRE_FACTION, 8)
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.check_unjust_war(self, name)
    if cm:get_faction(self:empire()):has_effect_bundle("eom_"..name.."_casus_belli") then
        EOMLOG("Casus Belli possessed, doing nothing!")
    else
        EOMLOG("Checking unjust war!")
        local last_unjust = self:get_core_data_with_key("last_unjust_war") --# assume last_unjust:number
        if last_unjust == nil then self:set_core_data("last_unjust_war", cm:model():turn_number()) end
        if last_unjust ~= cm:model():turn_number() then
            EOMLOG("triggering unjust war")
            self:change_all_loyalties(-10)
            self:set_core_data("last_unjust_war", cm:model():turn_number())
            cm:show_message_event(
                self:empire(),
                "event_feed_strings_text_unjust_war_title",
                "event_feed_strings_text_unjust_war_subtitle",
                "event_feed_strings_text_unjust_war_detail",
                true,
                591)
        else
            EOMLOG("Unjust war already triggered this turn!")
        end
    end
end



--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.offer_capitulation(self, name)
    EOMLOG("Offering capitulation for ["..name.."] ")
    --needs filling
    cm:trigger_dilemma(EOM_GLOBAL_EMPIRE_FACTION, "eom_"..name.."_capitulation", true)
    core:add_listener(
        "capitulation_"..name,
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 0 then
                cm:force_make_peace(name, EOM_GLOBAL_EMPIRE_FACTION)
                self:elector_rebellion_end(name)
                if cm:get_region(self:get_elector(name):capital()):owning_faction() == EOM_GLOBAL_EMPIRE_FACTION then
                    cm:transfer_region_to_faction(self:get_elector(name):capital(), name)
                end
            else
                self:change_all_loyalties(-5)
            end
        end,
        false
    )
end

---EBS

--@name: event_and_plot_check
--@description: causes all events on a prioritized basis.
--v function(self: EOM_MODEL)
function eom_model.event_and_plot_check(self)

    --capitulation
    EOMLOG("Checking for Electors willing to capitulate")
    for name, elector in pairs(self:electors()) do
        if elector:is_cult() and elector:status() == "open_rebellion" and cm:get_faction(name):is_dead() then
            self:elector_rebellion_end(name)
        end
        if elector:will_capitulate() and (not elector:is_cult()) then
            self:offer_capitulation(name)
            elector:set_should_capitulate(false)
            return
        end
    end
    --full loyalty
    if not self:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        EOMLOG("Checking for fully loyal electors")
        for name, elector in pairs(self:electors()) do
            if elector:loyalty() > 99 and elector:status() == "normal" then
                elector:set_fully_loyal(self)
            end
        end
    end
    --plot check
    EOMLOG("Core event and plot check function checking story events")
    for key, story in pairs(self:get_story()) do
       if story:check_advancement() == true then
            story:advance()
            return
       end
    end
    --open rebellions
    if not self:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        EOMLOG("Core event and plot check function checking open rebellion opportunities")
        for name, elector in pairs(self:electors()) do
            if (elector:loyalty() == 0) and elector:status() == "normal" then
                
                EOMLOG("Elector ["..name.."] can rebel!")
                self:elector_rebellion_start(name)
            end
        end
    end


    --player restore opportunity.
    EOMLOG("Core event and plot check function checking player restoration opportunities")
    for name, elector in pairs(self:electors()) do
        if not elector:is_cult() then
            if cm:get_region(elector:capital()):owning_faction():name() == EOM_GLOBAL_EMPIRE_FACTION and cm:get_faction(name):is_dead() then
                if elector:status() == "normal" or elector:status() == "open_rebellion" then
                    self:trigger_restoration_dilemma(name)
                end
            end
        end
    end

    --events
    EOMLOG("Core event and plot check function checking political events")
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
    EOMLOG("Core event and plot check function checking revivification events")
    for name, elector in pairs(self:electors()) do
        if self:get_elector_faction(name):is_dead() and elector:turns_dead() > 4 and elector:can_revive() and (not elector:is_cult()) then
        if cm:get_region(elector:capital()):owning_faction():subculture() == "wh_main_sc_emp_empire" then
            elector:trigger_coup()
            return
        else
            elector:trigger_expedition() 
            return
        end
        end
    end
    --elector falls
    EOMLOG("Core event and plot check function checking elector fallen events.")
    for name, elector in pairs(self:electors()) do
        if elector:turns_dead() > 20 and elector:can_revive() == false and (not elector:is_cult()) then
            self:elector_fallen(name, true)
        end
    end
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

--v function(self: EOM_MODEL)
function eom_model.elector_personalities(self)
    for name, elector in pairs(self:electors()) do
        if elector:status() == "normal" then
            cm:force_change_cai_faction_personality(name, "eom_normal_elector")
        elseif elector:status() == "civil_war_enemy" or elector:status() == "open_rebellion" then
            cm:force_change_cai_faction_personality(name, "eom_disloyal_elector")
        elseif elector:status() == "civil_war_emperor" then
            cm:force_change_cai_faction_personality(name, "eom_pretender")
        end
    end
end

--v function (name:ELECTOR_NAME)
local function remove_taxation_bundles(name)
    
    local empire = cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION)
    for i = 1, 4 do 
        if empire:has_effect_bundle("eom_"..name.."_taxation_"..i) then
            cm:remove_effect_bundle(tostring("eom_"..name.."_taxation_"..i), EOM_GLOBAL_EMPIRE_FACTION)
        end
    end
    EOMLOG("Removing all tax bundles for ["..name.."] ")
end


--v function(self: EOM_MODEL)
function eom_model.elector_taxation(self)
    local empire = cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION)
    for name, elector in pairs(self:electors()) do
        if (not elector:is_cult()) and self:is_elector_valid_for_taxes(name) then
            if elector:loyalty() <= 25 then
                if not empire:has_effect_bundle("eom_"..name.."_taxation_1") then
                    remove_taxation_bundles(name)
                    cm:apply_effect_bundle("eom_"..name.."_taxation_1", EOM_GLOBAL_EMPIRE_FACTION, 0)
                    EOMLOG("Assigning tax level 1 to ["..name.."] ")
                end
            elseif elector:loyalty() > 25 and elector:loyalty() <= 50 then
                if not empire:has_effect_bundle("eom_"..name.."_taxation_2") then
                    remove_taxation_bundles(name)
                    cm:apply_effect_bundle("eom_"..name.."_taxation_2", EOM_GLOBAL_EMPIRE_FACTION, 0)
                    EOMLOG("Assigning tax level 2 to ["..name.."] ")
                end
            elseif elector:loyalty() > 50 and elector:loyalty() <= 75 then
                if not empire:has_effect_bundle("eom_"..name.."_taxation_3") then
                    remove_taxation_bundles(name)
                    cm:apply_effect_bundle("eom_"..name.."_taxation_3", EOM_GLOBAL_EMPIRE_FACTION, 0)
                    EOMLOG("Assigning tax level 3 to ["..name.."] ")
                end
            else
                if not empire:has_effect_bundle("eom_"..name.."_taxation_4") then
                    remove_taxation_bundles(name)
                    cm:apply_effect_bundle("eom_"..name.."_taxation_4", EOM_GLOBAL_EMPIRE_FACTION, 0)
                    EOMLOG("Assigning tax level 4 to ["..name.."] ")
                end
            end
        elseif (not self:is_elector_valid_for_taxes(name)) then
            remove_taxation_bundles(name)
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
        EOMLOG("saved Elector ["..k.."] with loyalty ["..tostring(v:loyalty()).."], status ["..v:status().."], UI visibility: ["..tostring(v:is_hidden()).."] and capitulation flag ["..tostring(v:will_capitulate()).."] ")
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
            --randomize which plot events happen when
        else
            eom:load(savetable)
        end
    end
)

