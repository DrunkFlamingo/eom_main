cm = get_cm() events = get_events() eom = _G.eom


--[[ testing functions

core:add_listener(
    "EOM_TEST_BATTLES",
    "VictoryAgainstSubcultureKey_wh_main_sc_emp_empire",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(8)
        eom:get_elector("wh_main_emp_stirland"):change_loyalty(4)
    end,
    true);



--]]



function eom_starting_settings()
    if cm:is_new_game() then
        out("EOM STARTING CHANGES RUNNING")
        local karl = "wh_main_emp_empire"
        local elector_diplo_list = {
            "faction:wh_main_emp_averland",
            "faction:wh_main_emp_hochland",
            "faction:wh_main_emp_ostermark",
            "faction:wh_main_emp_stirland",
            "faction:wh_main_emp_middenland",
            "faction:wh_main_emp_nordland",
            "faction:wh_main_emp_ostland",
            "faction:wh_main_emp_wissenland",
            "faction:wh_main_emp_talabecland"
        }--: vector<string>
        local external_list = {
            "faction:wh_main_ksl_kislev",
            "faction:wh_main_teb_border_princes"
        }--:vector< string>

        for i = 1, #elector_diplo_list do
            for j = 1, #elector_diplo_list do
                cm:force_diplomacy(elector_diplo_list[i], elector_diplo_list[j], "defensive alliance", false, false, false);
                cm:force_diplomacy(elector_diplo_list[i], elector_diplo_list[j], "peace", true, true, false);
                cm:force_diplomacy(elector_diplo_list[i], elector_diplo_list[j], "war", false, false, false);
                cm:force_diplomacy(elector_diplo_list[i], elector_diplo_list[j], "form confederation", false, false, false);
                cm:force_diplomacy(elector_diplo_list[i], elector_diplo_list[j], "military alliance", false, false, false);
            end
        end

            --second, disable the elector counts from declaring war on Karl Franz
        
        for i = 1, #elector_diplo_list do
            cm:force_diplomacy(elector_diplo_list[i], "faction:"..karl, "war", false, false, false);
        end

            --next, disable the ability for elector counts to declare war on external factions.
        for i = 1, #elector_diplo_list do
            for j = 1, #external_list do
                cm:force_diplomacy(elector_diplo_list[i], external_list[j], "war", false, false, false);
            end
        end
        
            ---now, allow the emperor to declare war on anyone.
        for i = 1, #elector_diplo_list do
            cm:force_diplomacy("faction:"..karl, elector_diplo_list[i], "war", true, true, false);
            cm:force_diplomacy("faction:"..karl, elector_diplo_list[i], "military alliance", false, false, false);
            cm:force_diplomacy("faction:"..karl, elector_diplo_list[i], "defensive alliance", false, false, false);
            cm:force_diplomacy("faction:"..karl, elector_diplo_list[i], "form confederation", false, false, false);
            cm:force_diplomacy("faction:"..karl, elector_diplo_list[i], "vassal", false, false, false);
        end;
        out("EOM STARTING CHANGES FINISHED")
    end
end




events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_starting_settings() end;








core:add_listener(
    "EOMTurnStart",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == EOM_GLOBAL_EMPIRE_FACTION
    end,
    function(context)
        eom:event_and_plot_check()
        eom:elector_diplomacy()
    end,
    true);


--civil wars.
local eom_story_reikland_rebellion = eom:new_story_chain("eom_story_reikland_rebellion")
eom_story_reikland_rebellion:add_stage_trigger( 1, function(model --: EOM_MODEL
)
    return true

end)

eom_story_reikland_rebellion:add_stage_callback(2, function(model --:EOM_MODEL
)
    model:set_core_data("block_events_for_plot", true)
    model:set_core_data("plot_event_active", true)
end)


eom_story_reikland_rebellion:add_stage_trigger( 2, function(model --:EOM_MODEL
)
    return cm:get_faction("wh_main_emp_empire_rebels"):is_dead()

end)

eom_story_reikland_rebellion:add_stage_callback(2, function(model --:EOM_MODEL
)
    model:change_all_loyalties(5)
    --trigger event 
    model:get_story_chain("eom_story_reikland_rebellion"):finish()
    model:set_core_data("block_events_for_plot", false)
    model:set_core_data("plot_event_active", false)
end)






--upstream events
core:add_listener(
    "EOMVampiresDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_vmp_vampire_counts",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(8)
        eom:get_elector("wh_main_emp_stirland"):change_loyalty(4)
    end,
    true);

core:add_listener(
    "EOMVampiresDefeatedYou",
    "DefeatAgainstSubcultureKey_wh_main_sc_vmp_vampire_counts",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(-5)
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_stirland"):change_loyalty(-5)
    end,
    true);
    


core:add_listener(
    "EOMBeastmenDefeated",
    "VictoryAgainstSubcultureKey_wh_dlc03_sc_bst_beastmen",
    true,
    function(context)
        eom:get_elector("wh_main_emp_hochland"):change_loyalty(12)
        eom:get_elector("wh_main_emp_middenland"):change_loyalty(8)
    end,
    true);

core:add_listener(
    "EOMBeastmenDefeatedYou",
    "DefeatAgainstSubcultureKey_wh_dlc03_sc_bst_beastmen",
    true,
    function(context)
        eom:get_elector("wh_main_emp_hochland"):change_loyalty(-15)
        eom:get_elector("wh_main_emp_middenland"):change_loyalty(-10)
    end,
    true)
    



core:add_listener(
    "EOMNorscaDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_nor_norsca",
    true,
    function(context)
        eom:get_elector("wh_main_emp_ostland"):change_loyalty(8)
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(4)
        eom:get_elector("wh_main_emp_nordland"):change_loyalty(8)
        eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(4)
    end,
    true)

core:add_listener(
    "EOMNorscaDefeatedYou",
    "VictoryAgainstSubcultureKey_wh_main_sc_nor_norsca",
    true,
    function(context)
        eom:get_elector("wh_main_emp_ostland"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(-5)
        eom:get_elector("wh_main_emp_nordland"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-5)
    end,
    true)

core:add_listener(
    "EOMBretonniaDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_brt_bretonnia",
    true,
    function(context)
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(8)
    end,
    true)

core:add_listener(
    "EOMKislevDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_ksl_kislev",
    true,
    function(context)
        eom:get_elector("wh_main_emp_ostland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(-4)
    end,
    true)

core:add_listener(
    "EOMGreenSkinsDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_grn_greenskins",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(8)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(8)
    end,
    true)

core:add_listener(
    "EOMGreenSkinsDefeatedYou",
    "VictoryAgainstSubcultureKey_wh_main_sc_grn_greenskins",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(-5)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(-10)
    end,
    true)
core:add_listener(
    "EOMGreenSkinsDefeated2",
    "VictoryAgainstSubcultureKey_wh_main_sc_grn_savage_orcs",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(8)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(8)
    end,
    true)

core:add_listener(
    "EOMGreenSkinsDefeatedYou2",
    "VictoryAgainstSubcultureKey_wh_main_sc_grn_savage_orcs",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(-5)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(-10)
    end,
    true)

core:add_listener(
    "EOMChaosDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_chs_chaos",
    true,
    function(context)
        eom:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(8)
        eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(8)
        eom:get_elector("wh_main_emp_talabecland"):change_loyalty(8)
    end,
    true)

core:add_listener(
    "EOMChaosDefeatedYou",
    "VictoryAgainstSubcultureKey_wh_main_sc_chs_chaos",
    true,
    function(context)
        eom:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_talabecland"):change_loyalty(-10)
    end,
    true)

--EVENTS


local eom_main_events_table = {
    {
        key = "eom_dilemma_nordland_2",
        conditional = function(model --:EOM_MODEL
        )
            return true
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_nordland"):change_loyalty(-15)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(5)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_nordland"):change_loyalty(15)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-10)
        end
        }

    },
    {
        key = "eom_dilemma_averland_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_averland") and cm:get_region("wh_main_stirland_the_moot"):owning_faction():name() == "wh_main_emp_stirland" and model:is_elector_valid("wh_main_emp_stirland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_averland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_stirland"):change_loyalty(15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_averland"):change_loyalty(15)
            model:get_elector("wh_main_emp_stirland"):change_loyalty(-10)
            cm:force_declare_war("wh_main_emp_averland", "wh_main_emp_stirland", false, false)
        end
        }
    },
    {
        key = "eom_dilemma_hochland_1",
        conditional = function(model --:EOM_MODEL
        )
            return model:is_elector_valid("wh_main_emp_hochland") and model:is_elector_valid("wh_main_emp_nordland") and model:is_elector_valid("wh_main_emp_ostland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_ostland"):change_loyalty(-10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_nordland"):change_loyalty(-10)
            model:set_core_data("hochland_ostland_allied", true)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(15)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-10)
            model:get_elector("wh_main_emp_nordland"):change_loyalty(-10)
        
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(10)
            model:get_elector("wh_main_emp_ostland"):change_loyalty(10)
            model:set_core_data("hochland_ostland_allied", true)
        end
        }
    },
    {
        key = "eom_dilemma_ostermark_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_ostermark") and not model:get_core_data_with_key("vampire_wars_concluded")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-10)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(10)
            cm:force_declare_war("wh_main_emp_kislev", "wh_main_emp_ostermark", true, true)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-15)
        end
        }
    },
    {
        key = "eom_dilemma_stirland_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_stirland") and model:is_elector_valid("wh_main_emp_talabecland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_stirland"):change_loyalty(-15)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_stirland"):change_loyalty(10)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-15)
        end
        }
    },
    {
        key = "eom_dilemma_middenland_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_middenland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_middenland"):change_loyalty(10)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(5)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_middenland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(5)
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(5)
            model:get_elector("wh_main_emp_averland"):change_loyalty(5)
            model:get_elector("wh_main_emp_stirland"):change_loyalty(5)
            model:get_elector("wh_main_emp_ostland"):change_loyalty(5)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(5)
        end
        }
    },
    {
        key = "eom_dilemma_nordland_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_hochland") and model:is_elector_valid("wh_main_emp_nordland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_nordland"):change_loyalty(-25)
            model:get_elector("wh_main_emp_hochland"):change_loyalty(15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_nordland"):change_loyalty(-15)
            model:get_elector("wh_main_emp_hochland"):change_loyalty(15)
            cm:force_declare_war("wh_main_emp_nordland", "wh_main_emp_hochland", false, false)
            cm:force_declare_war("wh_main_emp_nordland", "wh_main_emp_empire", false, false)
            if model:get_core_data_with_key("hochland_ostland_allied") then
                cm:force_declare_war("wh_main_emp_ostland", "wh_main_emp_nordland", false, false)
            end
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_nordland"):change_loyalty(10)
            model:get_elector("wh_main_emp_hochland"):change_loyalty(-25)
            cm:force_declare_war("wh_main_emp_nordland", "wh_main_emp_hochland", false, false)
            if model:get_core_data_with_key("hochland_ostland_allied") then
                cm:force_declare_war("wh_main_emp_ostland", "wh_main_emp_nordland", false, false)
            end
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(-10)
            cm:force_declare_war("wh_main_emp_nordland", "wh_main_emp_hochland", false, false)
            if model:get_core_data_with_key("hochland_ostland_allied") then
                cm:force_declare_war("wh_main_emp_ostland", "wh_main_emp_nordland", false, false)
            end
        end
        }
    },
    {
        key = "eom_dilemma_ostland_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_ostland") and not cm:get_faction("wh_main_ksl_kislev"):is_dead()
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostland"):change_loyalty(10)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-10)
            cm:force_declare_war("wh_main_emp_ostland", "wh_main_ksl_kislev", false, false)
            cm:force_declare_war("wh_main_emp_empire", "wh_main_ksl_kislev", false, false)
        end
        }
    }
}--:vector<EOM_EVENT>
    
for i = 1, #eom_main_events_table do 
    local current_event = eom_main_events_table[i];
    if not cm:get_saved_value("eom_action_"..current_event.key.."_occured") == true then
        eom:add_event(current_event)
    end
end


--[[
Templates for events
    {
        key = "key",
        conditional = function(model --:EOM_MODEL
        )

            return 
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
        
        end,
            [2] = function(model --:EOM_MODEL
            ) 
        
        end,
            [3] = function(model --: EOM_MODEL
            ) 
        
        end,
            [4] = function(model --: EOM_MODEL
            ) 
        
        end
        }
    }






]]