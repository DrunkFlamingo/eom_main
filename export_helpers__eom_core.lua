cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
    return
end
core:add_listener(
    "EOMTurnStart",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == "wh_main_emp_empire"
    end,
    function(context)
        eom:event_and_plot_check()
        eom:elector_diplomacy()
        eom:elector_personalities()
    end,
    true);


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