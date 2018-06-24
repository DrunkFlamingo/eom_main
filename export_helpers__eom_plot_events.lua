cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
    return
end

function reikland_rebellion_add()
    local reikland_rebellion = eom:new_story_chain("reikland_rebellion")
    reikland_rebellion:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        return true 
    end)
    reikland_rebellion:add_stage_trigger(2, function(model--:EOM_MODEL
    )
        return cm:get_faction("wh_main_emp_empire_separatists"):is_dead()
    end)
    
    
    
    reikland_rebellion:add_stage_callback(2, function(model--:EOM_MODEL
    )
        model:change_all_loyalties(5)
        cm:trigger_incident(model:empire(), "eom_reikland_rebellion_1", true)
        model:get_story_chain("reikland_rebellion"):finish()
        model:set_core_data("block_events_for_plot", false)
    end)
end

local function add_marienburg_retaken_listener()

    core:add_listener(
    "MarienburgRetakenPlot",
    "GarrisonOccupiedEvent",
    function(context)
        return context:garrison_residence():region():name() == "wh_main_the_wasteland_marienburg" and context:character():faction() == eom:empire()
    end,
    function(context)
        if cm:get_faction("wh_main_emp_marienburg"):is_dead() then
            eom:get_elector("wh_main_emp_marienburg"):respawn_at_capital()
        end
        cm:callback( function()
            cm:transfer_region_to_faction("wh_main_the_wasteland_marienburg", "wh_main_emp_marienburg")
        end, 0.5)
    end,
    false)

end


function marienburg_invasion_add()

    local marienburg_invasion = eom:new_story_chain("marienburg_invasion")
    --stage 1: triggers when louen is alive, it is the correct turn, and you picked leaving marienburg independent
    marienburg_invasion:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        local plot_turn = model:get_core_data_with_key("marienburg_plot_turn") --# assume plot_turn: number
        return plot_turn <= cm:model():turn_number() and model:get_core_data_with_key("friend_of_marienburg") == true and cm:get_faction("wh_main_brt_bretonnia"):faction_leader():has_military_force() and (not model:get_core_data_with_key("block_events_for_plot") == true)
    end)
    --spawn army for louen, trigger dilemma to aid marienburg
    marienburg_invasion:add_stage_callback(1, function(model--:EOM_MODEL
    )
    cm:trigger_dilemma(model:empire(), "eom_marienburg_invaded_1", true)
    core:add_listener(
        "eom_marienburg_invaded_1",
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 0 then
                cm:force_declare_war("wh_main_brt_bretonnia", "wh_main_emp_empire", true, true)
                model:set_core_data("block_events_for_plot", true)
                model:set_core_data("marienburg_plot_turn", (cm:model():turn_number() + 7))
                add_marienburg_retaken_listener()
            else
                model:get_story_chain("eom_marienburg_invaded_1"):finish()
            end
        end,
        false)
    cm:force_declare_war("wh_main_brt_bretonnia", "wh_main_emp_marienburg", false, false)
    cm:treasury_mod("wh_main_brt_bretonnia", 10000)
    local louen = cm:get_faction("wh_main_brt_bretonnia"):faction_leader()
    cm:remove_all_units_from_general(louen)
    local louen_army = {
    "wh_dlc07_brt_inf_men_at_arms_2", "wh_dlc07_brt_inf_men_at_arms_2","wh_dlc07_brt_inf_men_at_arms_2","wh_dlc07_brt_inf_men_at_arms_2","wh_dlc07_brt_inf_men_at_arms_2","wh_dlc07_brt_inf_men_at_arms_2","wh_dlc07_brt_inf_men_at_arms_2",
    "wh_dlc07_brt_inf_peasant_bowmen_1", "wh_dlc07_brt_inf_peasant_bowmen_1", "wh_dlc07_brt_inf_grail_reliquae_0", "wh_dlc07_brt_inf_spearmen_at_arms_1", "wh_dlc07_brt_inf_spearmen_at_arms_1",
    "wh_dlc07_brt_art_blessed_field_trebuchet_0", "wh_main_brt_cav_grail_knights", "wh_main_brt_cav_grail_knights", "wh_main_brt_cav_grail_knights", "wh_main_brt_cav_grail_knights", "wh_main_brt_cav_grail_knights"} --:vector<string>
    for i = 1, #louen_army do
        cm:callback(function()
            cm:grant_unit_to_character(cm:char_lookup_str(louen:cqi()), louen_army[i])
        end, (i/10))
    end
    cm:teleport_to(cm:char_lookup_str(louen:cqi()), 393, 486, true)
    end)
    --stage 2: triggers when louen is wounded
    marienburg_invasion:add_stage_trigger(2, function(model--:EOM_MODEL
    )
        local plot_turn = model:get_core_data_with_key("marienburg_plot_turn") --# assume plot_turn: number
        return cm:get_faction("wh_main_brt_bretonnia"):faction_leader():is_wounded() and plot_turn <= cm:model():turn_number()
    end)

    marienburg_invasion:add_stage_callback(2, function(model --:EOM_MODEL
    )
   
    core:remove_listener("MarienburgRetakenPlot")
    cm:trigger_dilemma(model:empire(), "eom_marienburg_invaded_2", true)
    core:add_listener(
        "eom_marienburg_invaded_2",
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 0 then
                model:get_elector("wh_main_emp_marienburg"):set_status("normal")
                model:get_elector("wh_main_emp_marienburg"):set_loyalty(45)
                model:get_elector("wh_main_emp_marienburg"):set_can_revive(true)
            end
            model:get_story_chain("eom_marienburg_invaded_1"):finish()
            model:set_core_data("block_events_for_plot", false)
        end,
        false)
    end)

end




function eom_plot_events()
    reikland_rebellion_add()
    marienburg_invasion_add()

end



events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_plot_events() end;