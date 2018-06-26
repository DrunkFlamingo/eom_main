cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end



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
        return faction:name() == eom:empire()
    end,
    function(context)
        eom:set_log_turn(cm:model():turn_number())
        if cm:get_faction(eom:empire()):is_human() then
            empire_plot_and_events_check()
        end
    end,
    true);




