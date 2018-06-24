cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
    return
end


cm:kill_all_armies_for_faction(cm:get_faction("wh_main_emp_talabecland"))
cm:transfer_region_to_faction("wh_main_talabecland_talabheim", eom:empire())
cm:transfer_region_to_faction("wh_main_talabecland_kemperbad", eom:empire())


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