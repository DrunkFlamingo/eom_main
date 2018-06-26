cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end


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
}

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
}

local function empire_plot_and_events_check()
    eom:log("Entered", "eom_model.event_and_plot_check(self)")
    --capitulation
    eom:log("Checking for Electors willing to capitulate")
    for name, elector in pairs(eom:electors()) do
        if elector:will_capitulate() and (not elector:is_cult()) then
            eom:offer_capitulation(name)
            elector:set_should_capitulate(false)
            return
        end
    end
    --full loyalty
    if not eom:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        eom:log("Checking for fully loyal electors")
        for name, elector in pairs(eom:electors()) do
            if elector:loyalty() > 99 and elector:status() == "normal" then
                elector:set_fully_loyal(eom)
            end
        end
    end
    --plot check
    eom:log("Core event and plot check function checking story events")
    for key, story in pairs(eom:get_story()) do
       if story:check_advancement() == true then
            story:advance()
            return
       end
    end
    --open rebellions
    if not eom:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        eom:log("Core event and plot check function checking open rebellion opportunities")
        for name, elector in pairs(eom:electors()) do
            if (elector:loyalty() == 0) and elector:status() == "normal" then
                
                eom:log("Elector ["..name.."] can rebel!")
                eom:elector_rebellion_start(name)
            end
        end
    end


    --player restore opportunity.
    eom:log("Core event and plot check function checking player restoration opportunities")
    for name, elector in pairs(eom:electors()) do
        if not elector:is_cult() then
            if cm:get_region(elector:capital()):owning_faction():name() == EOM_GLOBAL_EMPIRE_FACTION and cm:get_faction(name):is_dead() then
                if elector:status() == "normal" or elector:status() == "open_rebellion" then
                    eom:trigger_restoration_dilemma(name)
                end
            end
        end
    end

    --events
    local next_event = eom:get_core_data_with_key("next_event_turn") --# assume next_event: number
    if cm:model():turn_number() >= next_event and (not eom:get_core_data_with_key("block_events_for_plot") == true) then
        eom:log("Core event and plot check function checking political events")
        for key, event in pairs(eom:events()) do
            eom:log("Checking Event: ["..key.."] ")
            if eom:get_core_data_with_key(key.."_occured") ~= true then
                if event:allowed() then
                    eom:log("Event ["..key.."] is allowed!")
                    eom:set_core_data(key.."_occured", true)
                    event:act()
                    eom:set_core_data("next_event_turn", cm:model():turn_number() + 5) 
                    return
              
                end
            else
                eom:log("event ["..key.."] already occured ")
            end
        end
    else
        eom:log("No event this turn")
    end

    --revival events.
    eom:log("Core event and plot check function checking revivification events")
    for name, elector in pairs(eom:electors()) do
        if eom:get_elector_faction(name):is_dead() and elector:turns_dead() > 4 and elector:can_revive() and (not elector:is_cult()) then
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
    eom:log("Core event and plot check function checking elector fallen events.")
    for name, elector in pairs(eom:electors()) do
        if elector:turns_dead() > 20 and elector:can_revive() == false and (not elector:is_cult()) then
            eom:elector_fallen(name, true)
        end
    end
end



core:add_listener(
    "EOMTurnStart",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == "wh_main_emp_empire"
    end,
    function(context)
        eom:set_log_turn(cm:model():turn_number())
        empire_plot_and_events_check()
        eom:elector_diplomacy()
        eom:elector_personalities()
        eom:elector_taxation()
    end,
    true);


--event triggers;


core:add_listener(
    "EOMBattlesCompleted",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character() --:CA_CHAR
        return character:faction():name() == eom:empire() 
    end,
    function(context)
        local character = context:character() --:CA_CHAR
        local enemies = cm:pending_battle_cache_get_enemies_of_char(character)
        for i = 1, #enemies do
            local enemy = enemies[i]
            local enemy_sub = enemy:faction():subculture()
            if character:won_battle() then 
                eom:log("Triggering event VictoryAgainstSubcultureKey_"..enemy_sub, "EOMBattlesCompleted")
                core:trigger_event("VictoryAgainstSubcultureKey_"..enemy_sub)
            else
                core:trigger_event("DefeatAgainstSubcultureKey_"..enemy_sub)
                eom:log("Triggering event DeafeatAgainstSubcultureKey_"..enemy_sub, "EOMBattlesCompleted")
            end
        end
    end, 
    true)

core:add_listener(
    "EOMSettlementSacked",
    "CharacterSackedSettlement", 
    function(context)
        local gar_res = context:garrison_residence() --:CA_GARRISON_RESIDENCE
        local region =  gar_res:region():name()
        return (not not EOM_GLOBAL_REGION_TO_ELECTOR[region]) and context:character():faction():subculture() == "wh_main_sc_emp_empire"
    end,
    function(context)
        local elector = EOM_GLOBAL_REGION_TO_ELECTOR[context:garrison_residence():region():name()]
        if cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION):at_war_with(cm:get_faction(elector)) and eom:get_elector(elector):status() == "normal" or eom:get_elector(elector):status() == "open_rebellion" then
            if eom:is_elector_valid(context:character():faction():name()) and eom:get_elector(elector):capital() == context:garrison_residence():region():name() then
                eom:get_elector(elector):set_should_capitulate(true)
            end
        end
    end,
    true);
core:add_listener(
    "EOMSettlementOccupied",
    "GarrisonOccupiedEvent", 
    function(context)
        local gar_res = context:garrison_residence() --:CA_GARRISON_RESIDENCE
        local region =  gar_res:region():name()
        return not not EOM_GLOBAL_REGION_TO_ELECTOR[region] and context:character():faction():subculture() == "wh_main_sc_emp_empire"
    end,
    function(context)
        local elector = EOM_GLOBAL_REGION_TO_ELECTOR[context:garrison_residence():region():name()]
        if cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION):at_war_with(cm:get_faction(elector)) and eom:get_elector(elector):status() == "normal" or eom:get_elector(elector):status() == "open_rebellion" then
            if eom:is_elector_valid(context:character():faction():name()) and eom:get_elector(elector):capital() == context:garrison_residence():region():name() then
                eom:get_elector(elector):set_should_capitulate(true)
            end
        end
    end,
    true);



core:add_listener(
    "EOMUnjustWar",
    "NegativeDiplomaticEvent",
    function(context)
        return context:is_war() and context:proposer():name() == eom:empire() and eom:has_elector(context:recipient():name())
    end,
    function(context)
        eom:check_unjust_war(context:recipient():name())
    end,
    false)