cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end

function reikland_rebellion_add()
    local reikland_rebellion = eom:new_story_chain("reikland_rebellion")
    reikland_rebellion:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        return cm:get_faction("wh_main_emp_empire_separatists"):is_dead()
    end)
    
    
    
    reikland_rebellion:add_stage_callback(1, function(model--:EOM_MODEL
    )
        model:change_all_loyalties(5)
        cm:trigger_incident(model:empire(), "eom_reikland_rebellion_1", true)
        model:get_story_chain("reikland_rebellion"):finish()
        model:set_core_data("block_events_for_plot", false)
    end)
end

local function marienburg_add_remove_bundle_listener()
    core:remove_listener("MarienburgRebellionBundles")
    core:add_listener(
    "MarienburgRebellionBundles",
    "GarrisonOccupiedEvent",
    function(context)
        return context:garrison_residence():region():name() == "wh_main_the_wasteland_marienburg" and context:character():faction() == "wh_main_emp_marienburg"
    end,
    function(context)
        cm:remove_effect_bundle_from_region("eom_marienburg_rebellion_1_region", "wh_main_the_wasteland_marienburg")
    end,
    false)

end


function marienburg_rebellion_add()

    local marienburg_rebellion = eom:new_story_chain("marienburg_rebellion")
    marienburg_rebellion:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        local plot_turn = model:get_core_data_with_key("marienburg_plot_turn") --# assume plot_turn: number
        local plot_progress = (plot_turn <= cm:model():turn_number())
        local plot_available =  (not model:get_core_data_with_key("block_events_for_plot") == true)
        local mburg_dead = cm:get_faction("wh_main_emp_marienburg"):is_dead()
        local mburg_owned = cm:get_region("wh_main_the_wasteland_marienburg"):owning_faction():name() == model:empire()
        local mburg_attacked = (model:get_core_data_with_key("friend_of_marienburg") == false)

        if mburg_attacked and plot_progress then
            if not (mburg_dead and mburg_owned) then
                model:set_core_data("marienburg_plot_turn", cm:model():turn_number() + 15)
            end
        end 
        return plot_progress and plot_available and mburg_dead and mburg_owned and mburg_attacked
    end)


    marienburg_rebellion:add_stage_callback(1, function(model--:EOM_MODEL
    )
        cm:trigger_incident(model:empire(), "eom_marienburg_rebellion_1", true)
        cm:create_force("wh_main_emp_marienburg", model:get_elector("wh_main_emp_marienburg"):get_army_list(), "wh_main_couronne_et_languille_couronne", 358, 509, true, true, function(cqi) end)
        cm:create_force("wh_main_emp_marienburg", model:get_elector("wh_main_emp_marienburg"):get_army_list(), "wh_main_couronne_et_languille_couronne", 440, 545, true, true, function(cqi) end)
        cm:apply_effect_bundle_to_region("eom_marienburg_rebellion_1_region", "wh_main_the_wasteland_marienburg", 8)
        
        cm:callback(function()
            cm:force_declare_war("wh_main_emp_marienburg", "wh_main_emp_empire", false, false)
            cm:treasury_mod("wh_main_emp_marienburg", 10000)
        end, 0.1)


    end)


    marienburg_rebellion:add_stage_trigger(2, function(model--:EOM_MODEL
    )
        local mburg_dead = cm:get_faction("wh_main_emp_marienburg"):is_dead()
        marienburg_add_remove_bundle_listener()
        local mburg_owned = cm:get_region("wh_main_the_wasteland_marienburg"):owning_faction():name() == "wh_main_emp_marienburg"
        return mburg_dead or mburg_owned
    end)

    marienburg_rebellion:add_stage_callback(2, function(model--:EOM_MODEL
    )
        cm:trigger_dilemma(model:empire(), "eom_marienburg_rebellion_2", true)
        core:add_listener(
            "eom_marienburg_invaded_1",
            "DilemmaChoiceMadeEvent",
            function(context)
               return context:dilemma() ==  "eom_marienburg_rebellion_2"
            end,
            function(context)
                if context:choice() == 0 then 
                    cm:force_make_peace("wh_main_emp_marienburg", "wh_main_emp_empire")
                    model:get_elector("wh_main_emp_marienburg"):set_status("normal")
                    model:get_elector("wh_main_emp_marienburg"):set_loyalty(65)
                    model:get_elector("wh_main_emp_marienburg"):set_can_revive(true)
                    cm:apply_effect_bundle("eom_wh_main_emp_marienburg_taxation_3", eom:empire(), 0)
                    cm:remove_effect_bundle_from_region("eom_marienburg_rebellion_1_region", "wh_main_the_wasteland_marienburg")
                    eom:get_elector("wh_main_emp_marienburg"):respawn_at_capital()
                    if cm:get_region("wh_main_the_wasteland_gorssel"):owning_faction():name() == eom:empire() then
                        eom:log("Empire owns gorsel!")
                        cm:callback(function() cm:transfer_region_to_faction("wh_main_the_wasteland_gorssel", "wh_main_emp_marienburg") end, 0.5)
                    else
                        eom:log("empire does not own gorsel!")
                    end
                else
                    cm:force_declare_war("wh_main_brt_bretonnia", "wh_main_emp_empire", false, false)
                    cm:treasury_mod("wh_main_brt_bretonnia", 5000)
                    if cm:get_faction("wh_main_emp_marienburg"):is_dead() then
                        cm:create_force("wh_main_emp_marienburg", model:get_elector("wh_main_emp_marienburg"):get_army_list(), "wh_main_couronne_et_languille_couronne", 405, 478, true, true, function(cqi) end)
                    end
                end
            end,
            false)


        model:get_story_chain("marienburg_rebellion"):finish()

    end)



end



local function add_marienburg_retaken_listener()
    core:remove_listener("MarienburgRetakenPlot")
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
    end,
    false)

end


function marienburg_invasion_add()

    local marienburg_invasion = eom:new_story_chain("marienburg_invasion")
    --stage 1: triggers when louen is alive, it is the correct turn, and you picked leaving marienburg independent
    marienburg_invasion:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        local plot_turn = model:get_core_data_with_key("marienburg_plot_turn") --# assume plot_turn: number
        local plot_progress = (plot_turn <= cm:model():turn_number())
        local plot_available =  (not model:get_core_data_with_key("block_events_for_plot") == true)
        local friend_of_mburg = (model:get_core_data_with_key("friend_of_marienburg") == true)
        local louen = cm:get_faction("wh_main_brt_bretonnia"):faction_leader():has_military_force()
        local mburg_owned = cm:get_region("wh_main_the_wasteland_marienburg"):owning_faction():name() == "wh_main_emp_marienburg"
        return plot_available and plot_progress and friend_of_mburg and louen and mburg_owned
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
        add_marienburg_retaken_listener()
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
        end,
        false)
    cm:force_make_peace("wh_main_emp_empire", "wh_main_brt_bretonnia")
    cm:force_make_peace("wh_main_emp_marienburg", "wh_main_brt_bretonnia")
    end)

end
--v function() --> boolean
local function vampires_contained()
    local region_list = cm:get_faction("wh_main_vmp_vampire_counts"):region_list()
    for i = 0, region_list:num_items() - 1 do
        if region_list:item_at(i):province_name() ~= "wh_main_eastern_sylvania" and region_list:item_at(i):province_name() ~= "wh_main_western_sylvania" then
            return true
        end
    end
    return false
end

--v function() --> boolean
local function empire_controls_sylvania()
    local sylvania = {
            "wh_main_western_sylvania_fort_oberstyre",
            "wh_main_eastern_sylvania_castle_drakenhof",
            "wh_main_eastern_sylvania_eschen",
            "wh_main_western_sylvania_schwartzhafen",
            "wh_main_eastern_sylvania_waldenhof",
            "wh_main_western_sylvania_castle_templehof"
    } --:vector<string>
    local emp_count = 0
    for i = 1, #sylvania do
        if not cm:get_region(sylvania[i]):owning_faction():subculture() == "wh_main_sc_vmp_vampire_counts" then
            emp_count = emp_count + 1
        end
    end
    if emp_count >= 3 then return true else return false end
end




function vampire_wars_add()

local vampire_wars = eom:new_story_chain("vampire_wars")
vampire_wars:add_stage_trigger(1, function(model --:EOM_MODEL
)
    local plot_turn = model:get_core_data_with_key("vampire_war_turn") --# assume plot_turn: number
    return cm:model():turn_number() >= plot_turn
end)

vampire_wars:add_stage_callback(1, function(model --:EOM_MODEL
)   
    cm:trigger_incident(model:empire(), "eom_vampire_war_1", true)
    model:set_core_data("vampire_war_turn", cm:model():turn_number() + 10)
    cm:treasury_mod("wh_main_vmp_vampire_counts", 10000)
    cm:force_diplomacy("faction:wh_main_vmp_vampire_counts", "all", "war", true, true, true)
    cm:force_declare_war("wh_main_vmp_vampire_counts", "wh_main_emp_averland", false, false)
    cm:force_declare_war("wh_main_vmp_vampire_counts", "wh_main_emp_ostermark", false, false)
    cm:force_declare_war("wh_main_vmp_vampire_counts", "wh_main_emp_stirland", false, false)
    cm:force_declare_war("wh_main_vmp_vampire_counts", "wh_main_emp_empire", false, false)
    model:get_elector("wh_main_emp_cult_of_sigmar"):respawn_at_capital(true)
    cm:callback( function()
        cm:treasury_mod("wh_main_emp_cult_of_sigmar", 5000)
        cm:force_declare_war("wh_main_vmp_vampire_counts", "wh_main_emp_cult_of_sigmar", false, false)
    end, 0.5)
    cm:create_force("wh_main_vmp_vampire_counts", model:get_elector("wh_main_vmp_schwartzhafen"):get_army_list(), "wh_main_eastern_sylvania_waldenhof", 687, 460, true, true)
    cm:create_force("wh_main_vmp_vampire_counts", model:get_elector("wh_main_vmp_schwartzhafen"):get_army_list(), "wh_main_eastern_sylvania_castle_drakenhof", model:get_elector("wh_main_vmp_schwartzhafen"):capital_spawn_x(), model:get_elector("wh_main_vmp_schwartzhafen"):capital_spawn_y(), true, true)

end)
vampire_wars:add_stage_trigger(2, function(model --:EOM_MODEL
)
    local plot_turn = model:get_core_data_with_key("vampire_war_turn") --# assume plot_turn: number
    if empire_controls_sylvania() then
        model:get_story_chain("vampire_wars"):finish()
        return false
    end

    return (cm:model():turn_number() >= plot_turn) and vampires_contained()
end)

vampire_wars:add_stage_callback(2, function(model --:EOM_MODEL
)
    model:set_core_data("block_events_for_plot", true)
    cm:trigger_incident(model:empire(), "eom_vampire_war_2", true)
    vlad_x = 687
    vlad_y = 460
    isabella_x = 677
    isabella_y = 460
    vlad_list = "wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_1,wh_main_vmp_inf_grave_guard_1,wh_main_vmp_cav_black_knights_3,wh_main_vmp_cav_black_knights_3,wh_main_vmp_mon_terrorgheist,wh_main_vmp_veh_black_coach,wh_main_vmp_mon_varghulf,wh_main_vmp_inf_skeleton_warriors_1,wh_main_vmp_inf_skeleton_warriors_1,wh_dlc04_vmp_veh_mortis_engine_0";
    isabella_list = "wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_cha_vampire_0,wh_main_vmp_cha_vampire_0,wh_main_vmp_inf_crypt_ghouls,wh_main_vmp_inf_crypt_ghouls,wh_main_vmp_mon_vargheists,wh_main_vmp_mon_vargheists,wh_main_vmp_mon_terrorgheist,wh_main_vmp_mon_fell_bats,wh_main_vmp_mon_fell_bats,wh_main_vmp_mon_fell_bats,wh_main_vmp_mon_crypt_horrors";
    model:set_core_data("vampire_war_turn", cm:model():turn_number() + 2)
    cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            "wh_main_vmp_schwartzhafen",
            vlad_list,
            "wh_main_eastern_sylvania_waldenhof",
            vlad_x,
            vlad_y,
            "general",
            "dlc04_vmp_vlad_con_carstein",
            "names_name_2147345130",		-- Vlad
            "",
            "names_name_2147343895",		-- Von Carstein
            "",
            true,
            function(cqi)
            end
        );

    cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            "wh_main_vmp_schwartzhafen",
            isabella_list,
            "wh_main_eastern_sylvania_waldenhof",
            isabella_x,
            isabella_y,
            "general",
            "pro02_vmp_isabella_von_carstein",
            "names_name_2147345124",		-- Isabella
            "",
            "names_name_2147343895",		-- Von Carstein
            "",
            false,
            function(cqi)
            end
        );

    cm:callback(function()
        cm:make_diplomacy_available("wh_main_vmp_schwartzhafen", "wh_main_emp_empire")
        cm:treasury_mod("wh_main_vmp_schwartzhafen", 20000);
        cm:force_declare_war("wh_main_vmp_vampire_counts", "wh_main_vmp_schwartzhafen", false, false);
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_waldenhof", "wh_main_vmp_schwartzhafen");
        cm:force_diplomacy("faction:wh_main_vmp_schwartzhafen", "faction:wh_main_vmp_vampire_counts", "peace", false, false, false);
        cm:force_diplomacy("faction:wh_main_vmp_schwartzhafen", "subculture:wh_main_sc_emp_empire", "war", false, false, true);
        cm:force_diplomacy("faction:wh_main_vmp_vampire_counts", "faction:wh_main_vmp_schwartzhafen", "peace", false, false, false);
        end, 0.5);

end)

vampire_wars:add_stage_trigger(3, function(model --:EOM_MODEL
)
    local plot_turn = model:get_core_data_with_key("vampire_war_turn") --# assume plot_turn: number
    return cm:model():turn_number() >= plot_turn
end)
vampire_wars:add_stage_callback(3, function(model
)
    cm:trigger_dilemma(model:empire(), "eom_vampire_war_3", true)
    core:add_listener(
        "eom_vampire_war_3",
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 0 then
                cm:force_alliance("wh_main_emp_empire", "wh_main_vmp_schwartzhafen", true)
                model:set_core_data("allied_vlad", true)
                model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-10)
            elseif context:choice() == 1 then
                model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
                model:set_core_data("allied_vlad", false)
                cm:force_diplomacy("faction:wh_main_vmp_schwartzhafen", "subculture:wh_main_sc_emp_empire", "war", true, true, true);
            end
        end,
        false)
end)

vampire_wars:add_stage_trigger(4, function(model--: EOM_MODEL
)
    return cm:get_faction("wh_main_vmp_vampire_counts"):is_dead()
end)
vampire_wars:add_stage_callback(4, function(model
)
model:set_core_data("block_events_for_plot", false)
if cm:get_faction("wh_main_vmp_schwartzhafen"):is_dead() then
    model:get_story_chain("vampire_wars"):finish()
    --sylvania dilemma now
    cm:trigger_dilemma(model:empire(), "eom_empire_war_5", true)
    core:add_listener(
        "eom_vampire_war_5",
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 0 then
                if model:get_elector("wh_main_emp_stirland"):status() == "loyal" then
                    local sylvania_regions = {
                        "wh_main_western_sylvania_fort_oberstyre",
                        "wh_main_eastern_sylvania_castle_drakenhof",
                        "wh_main_eastern_sylvania_eschen",
                        "wh_main_western_sylvania_schwartzhafen",
                        "wh_main_eastern_sylvania_waldenhof",
                        "wh_main_western_sylvania_castle_templehof"
                    }--:vector<string>
                    for i = 1, #sylvania_regions do
                        if cm:get_region(sylvania_regions[i]):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                            cm:callback(function()
                            cm:transfer_region_to_faction(sylvania_regions[i], model:empire())
                            end, i/10);
                        end
                    end
                    return
                end
                model:get_elector("wh_main_emp_stirland"):change_loyalty(15)
                local sylvania_regions = {
                    "wh_main_western_sylvania_fort_oberstyre",
                    "wh_main_eastern_sylvania_castle_drakenhof",
                    "wh_main_eastern_sylvania_eschen",
                    "wh_main_western_sylvania_schwartzhafen",
                    "wh_main_eastern_sylvania_waldenhof",
                    "wh_main_western_sylvania_castle_templehof"
                }--:vector<string>
                for i = 1, #sylvania_regions do
                    if cm:get_region(sylvania_regions[i]):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                        cm:callback(function()
                        cm:transfer_region_to_faction(sylvania_regions[i], "wh_main_emp_stirland")
                        end, i/10);
                    end
                end
            else
                model:get_elector("wh_main_emp_sylvania"):set_hidden(false)
                model:get_elector("wh_main_emp_sylvania"):set_loyalty(50)
                model:get_elector("wh_main_emp_sylvania"):set_status("normal")
                local sylvania_regions = {
                    "wh_main_western_sylvania_fort_oberstyre",
                    "wh_main_eastern_sylvania_castle_drakenhof",
                    "wh_main_eastern_sylvania_eschen",
                    "wh_main_western_sylvania_schwartzhafen",
                    "wh_main_eastern_sylvania_waldenhof",
                    "wh_main_western_sylvania_castle_templehof"
                }--:vector<string>
                for i = 1, #sylvania_regions do
                    if cm:get_region(sylvania_regions[i]):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                        cm:callback(function()
                        cm:transfer_region_to_faction(sylvania_regions[i], "wh_main_emp_sylvania")
                        end, i/10);
                    end
                end
    
            end
        end,
        false)


    return
end
if model:get_core_data_with_key("allied_vlad") == true then
    cm:trigger_dilemma(model:empire(), "eom_vampire_war_4", true)
    core:add_listener(
        "eom_vampire_war_4",
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 0 then
                model:change_sigmarite_loyalties(-10)
                model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-10)
                model:get_elector("wh_main_emp_averland"):change_loyalty(-10)
                cm:force_diplomacy("faction:wh_main_vmp_schwartzhafen", "subculture:wh_main_sc_emp_empire", "war", false, false, true);
                model:get_elector("wh_main_vmp_schwartzhafen"):set_loyalty(45)
                model:get_elector("wh_main_vmp_schwartzhafen"):set_hidden(false)
                model:get_elector("wh_main_vmp_schwartzhafen"):set_status("normal")
                local sylvania_regions = {
                    "wh_main_western_sylvania_fort_oberstyre",
                    "wh_main_eastern_sylvania_castle_drakenhof",
                    "wh_main_eastern_sylvania_eschen",
                    "wh_main_western_sylvania_schwartzhafen",
                    "wh_main_eastern_sylvania_waldenhof",
                    "wh_main_western_sylvania_castle_templehof"
                }--:vector<string>
                for i = 1, #sylvania_regions do
                    if cm:get_region(sylvania_regions[i]):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                        cm:callback(function()
                        cm:transfer_region_to_faction(sylvania_regions[i], "wh_main_vmp_schwartzhafen")
                        end, i/10);
                    end
                end
                model:get_story_chain("vampire_wars"):finish()
            else
                model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
                model:change_sigmarite_loyalties(10)
                cm:force_diplomacy("faction:wh_main_vmp_schwartzhafen", "subculture:wh_main_sc_emp_empire", "war", true, true, true);
            end
        end,
        false);
else
    cm:force_declare_war("wh_main_vmp_schwartzhafen", "wh_main_emp_averland", true, true)
    cm:treasury_mod("wh_main_vmp_schwartzhafen", 10000)
end



end)


vampire_wars:add_stage_trigger(5, function(model--: EOM_MODEL
)
    return cm:get_faction("wh_main_vmp_schwartzhafen"):is_dead()
end)
vampire_wars:add_stage_callback(5, function(model
)
    model:get_story_chain("vampire_wars"):finish()
    --sylvania dilemma now
    cm:trigger_dilemma(model:empire(), "eom_vampire_war_5", true)
    core:add_listener(
        "eom_vampire_war_5",
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 0 then
                if model:get_elector("wh_main_emp_stirland"):status() == "loyal" then --if sylvania is loyal give their shit straight to the empire.
                    local sylvania_regions = {
                        "wh_main_western_sylvania_fort_oberstyre",
                        "wh_main_eastern_sylvania_castle_drakenhof",
                        "wh_main_eastern_sylvania_eschen",
                        "wh_main_western_sylvania_schwartzhafen",
                        "wh_main_eastern_sylvania_waldenhof",
                        "wh_main_western_sylvania_castle_templehof"
                    }--:vector<string>
                    for i = 1, #sylvania_regions do
                        if cm:get_region(sylvania_regions[i]):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                            cm:callback(function()
                            cm:transfer_region_to_faction(sylvania_regions[i], model:empire())
                            end, i/10);
                        end
                    end
                    return
                end
                model:get_elector("wh_main_emp_stirland"):change_loyalty(15)
                local sylvania_regions = {
                    "wh_main_western_sylvania_fort_oberstyre",
                    "wh_main_eastern_sylvania_castle_drakenhof",
                    "wh_main_eastern_sylvania_eschen",
                    "wh_main_western_sylvania_schwartzhafen",
                    "wh_main_eastern_sylvania_waldenhof",
                    "wh_main_western_sylvania_castle_templehof"
                }--:vector<string>
                for i = 1, #sylvania_regions do
                    if cm:get_region(sylvania_regions[i]):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                        cm:callback(function()
                        cm:transfer_region_to_faction(sylvania_regions[i], "wh_main_emp_stirland")
                        end, i/10);
                    end
                end
            else --choice 2
                model:get_elector("wh_main_emp_sylvania"):set_hidden(false)
                model:get_elector("wh_main_emp_sylvania"):set_loyalty(50)
                model:get_elector("wh_main_emp_sylvania"):set_status("normal")
                local sylvania_regions = {
                    "wh_main_western_sylvania_fort_oberstyre",
                    "wh_main_eastern_sylvania_castle_drakenhof",
                    "wh_main_eastern_sylvania_eschen",
                    "wh_main_western_sylvania_schwartzhafen",
                    "wh_main_eastern_sylvania_waldenhof",
                    "wh_main_western_sylvania_castle_templehof"
                }--:vector<string>
                for i = 1, #sylvania_regions do
                    if cm:get_region(sylvania_regions[i]):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                        cm:callback(function()
                        cm:transfer_region_to_faction(sylvania_regions[i], "wh_main_emp_sylvania")
                        end, i/10);
                    end
                end
    
            end
        end,
        false)
end)


end



function eom_plot_events()
    if cm:get_faction(eom:empire()):is_human() then
        eom:log("Adding plot events!")
        reikland_rebellion_add()
        marienburg_rebellion_add()
        marienburg_invasion_add()
        vampire_wars_add()
        if cm:random_number(10) > 4 then
            eom:set_core_data("vampire_war_turn", 55)
            eom:set_core_data("marienburg_plot_turn", 30)
        end
    end
end



events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_plot_events() end;