cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end



local function empire_plot_and_events_check_human()
    eom:log("Entered", "eom_model.event_and_plot_check(self)")

    if cm:get_saved_value("ci_trigger_mid_game_event_on_turn_start") == true then
        eom:log("aborting for the chaos invasion")
        return
    end
    if cm:get_saved_value("ci_trigger_late_game_event_on_turn_start") == true then
        eom:log("aborting for the chaos invasion")
        return
    end


    --capitulation
    --unncessary for AI, they capitulate on event
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



local function empire_plot_and_events_check_ai()


    --ai events
    local next_event = eom:get_core_data_with_key("next_event_turn") --# assume next_event: number
    if cm:model():turn_number() >= next_event and (not eom:get_core_data_with_key("block_events_for_plot") == true) then
        eom:log("Core event and plot check function checking political events")
        for key, event in pairs(eom:events()) do
            eom:log("Checking Event: ["..key.."] ")
            if eom:get_core_data_with_key(key.."_occured") ~= true then
                if event:allowed() then
                    eom:log("Event ["..key.."] is allowed!")
                    eom:set_core_data(key.."_occured", true)
                    event:act_ai()
                    eom:set_core_data("next_event_turn", cm:model():turn_number() + 5) 
                    --return
                    --returning unncessary for the AI.
                end
            else
                eom:log("event ["..key.."] already occured ")
            end
        end
    else
        eom:log("No event this turn")
    end

    --full loyalty events.
    if not eom:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        eom:log("Checking for fully loyal electors")
        for name, elector in pairs(eom:electors()) do
            if elector:loyalty() > 99 and elector:status() == "normal" then
                elector:set_fully_loyal(eom) --function automatically checks humanity.
            end
        end
    end

    --ai restore opportunity.
    eom:log("Core event and plot check function checking ai restoration opportunities")
        for name, elector in pairs(eom:electors()) do
            if not elector:is_cult() then
                if cm:get_region(elector:capital()):owning_faction():name() == EOM_GLOBAL_EMPIRE_FACTION and cm:get_faction(name):is_dead() then
                    if elector:status() == "normal" or elector:status() == "open_rebellion" then
                        if cm:random_number(10) < 3 then
                            eom:elector_fallen(name)
                        else
                            if eom:get_elector(name):status() == "open_rebellion" then
                                eom:elector_rebellion_end(name)
                                eom:get_elector(name):respawn_at_capital()
                                local home_regions = eom:get_elector(name):home_regions()
                                for i = 1, #home_regions do
                                    local current_region = home_regions[i]
                                    if cm:get_region(current_region):owning_faction():subculture() == "wh_main_emp_sc_empire" then
                                        cm:callback(function()
                                            cm:transfer_region_to_faction(current_region, name)
                                        end, i/10)
                                    end
                                end
                            else
                                eom:get_elector(name):respawn_at_capital()
                                eom:get_elector(name):change_loyalty(20)
                                local home_regions = eom:get_elector(name):home_regions()
                                for i = 1, #home_regions do
                                    local current_region = home_regions[i]
                                    if cm:get_region(current_region):owning_faction():subculture() == "wh_main_emp_sc_empire" then
                                        cm:callback(function()
                                            cm:transfer_region_to_faction(current_region, name)
                                        end, i/10)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        --revival events
        eom:log("Core event and plot check function checking revivification events")
        for name, elector in pairs(eom:electors()) do
            if eom:get_elector_faction(name):is_dead() and elector:turns_dead() > 4 and elector:can_revive() and (not elector:is_cult()) then
                if cm:get_region(elector:capital()):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                    elector:trigger_coup(true)
                    return
                else
                    elector:trigger_expedition(true) 
                    return
                end
            end
        end




        --elector fallen events
        eom:log("Core event and plot check function checking elector fallen events.")
        for name, elector in pairs(eom:electors()) do
            if elector:turns_dead() > 20 and elector:can_revive() == false and (not elector:is_cult()) then
                eom:elector_fallen(name, false)
            end
        end


end



core:add_listener(
    "EOMTurnStart",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == eom:empire()
    end,
    function(context)
        eom:set_log_turn(cm:model():turn_number())
        if cm:get_faction(eom:empire()):is_human() then
            empire_plot_and_events_check_human()
        else
            empire_plot_and_events_check_ai()
        end
    end,
    true);




events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom:set_log_turn(cm:model():turn_number()) end;  