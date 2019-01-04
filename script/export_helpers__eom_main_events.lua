cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end

local function eom_empire_main_events()

local eom_main_events_table = {
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
    },
    {
        key = "eom_dilemma_wissenland_1",
        conditional = function(model --:EOM_MODEL
        )
            return model:is_elector_valid("wh_main_emp_wissenland") and (not cm:get_faction("wh_main_brt_parravon"):is_dead()) and cm:get_faction(eom:empire()):treasury() > 2500
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            cm:force_declare_war("wh_main_brt_parravon", "wh_main_emp_wissenland", false, false)
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(-5)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(10)
            --NOTE: Treasury Mod Payload
        
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            cm:force_declare_war("wh_main_brt_parravon", "wh_main_emp_wissenland", false, false)
            cm:force_declare_war("wh_main_brt_carcassonne", "wh_main_emp_wissenland", false, false)
            cm:force_declare_war("wh_main_brt_parravon", "wh_main_emp_empire", false, false)
            cm:force_declare_war("wh_main_brt_carcassonne", "wh_main_emp_empire", false, false)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(-15)
        end
        }
    },
    {
        key = "eom_dilemma_talabecland_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_talabecland") and model:is_elector_valid("wh_main_emp_ostermark") and model:is_elector_valid("wh_main_emp_middenland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(25)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(10)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-15)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-5)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-5)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(5)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(5)
        end
        }
    },
    {
        key = "eom_dilemma_cult_of_ulric_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_cult_of_ulric") and model:is_elector_valid("wh_main_emp_cult_of_sigmar") and model:is_elector_valid("wh_main_emp_talabecland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-25)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(25)
            model:change_ulrican_loyalites(15)
            model:change_sigmarite_loyalties(-15)
            model:change_atheist_loyalties(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-15)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(25)
            model:change_ulrican_loyalites(15)
            model:change_sigmarite_loyalties(-10)
            model:change_atheist_loyalties(-10)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-10)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-15)
            model:change_ulrican_loyalites(-10)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(30)

        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-10)
            model:change_ulrican_loyalites(-5)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
        end
        }
    },
    {
        key = "eom_dilemma_cult_of_sigmar_1",
        conditional = function(model --:EOM_MODEL
        )
            return model:is_elector_valid("wh_main_emp_cult_of_sigmar") and model:is_elector_valid("wh_main_emp_wissenland") and model:is_elector_valid("wh_main_emp_middenland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(15)
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(-10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-25) 
            model:change_loyalty_for_all_except({"wh_main_emp_cult_of_sigmar", "wh_main_emp_cult_of_ulric"}, 10)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(5)
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(5)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(5)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-15)
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(5)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(5)
        end
        }
    },
    {
        key = "eom_dilemma_marienburg_1",
        conditional = function(model --:EOM_MODEL
        )
            return (not cm:get_faction("wh2_main_hef_eataine")) and model:is_elector_valid("wh_main_emp_marienburg") and cm:get_faction("wh_main_emp_empire"):treasury() > 5000
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_marienburg"):change_loyalty(-15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_marienburg"):change_loyalty(10)
        end
        }
    },
    {
        key = "eom_dilemma_sylvania_1",
        conditional = function(model --:EOM_MODEL
        )
            return model:is_elector_valid("wh_main_emp_sylvania") and cm:get_faction("wh_main_emp_empire"):treasury() > 6000
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_sylvania"):change_loyalty(-10)
           cm:apply_effect_bundle_to_region("eom_dilemma_sylvania_1_corruption", "wh_main_eastern_sylvania_castle_drakenhof", 10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_sylvania"):change_loyalty(20)
        end
        }
    },
    {
        key = "eom_dilemma_schwartzhafen_1",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_vmp_schwartzhafen")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(15)
            model:change_sigmarite_loyalties(10)
            model:get_elector("wh_main_vmp_schwartzhafen"):change_loyalty(-20)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:set_core_data("vlad_civil_war", true)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-20)
            model:change_sigmarite_loyalties(-10)
            model:get_elector("wh_main_emp_averland"):change_loyalty(-10)
            model:get_elector("wh_main_vmp_schwartzhafen"):change_loyalty(20)
        end
        }
    },
    {
        key = "eom_dilemma_averland_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_averland") and model:is_elector_valid("wh_main_emp_wissenland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(10)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(20)
            model:change_atheist_loyalties(-10)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_averland"):change_loyalty(10)
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(-10)
            cm:force_declare_war("wh_main_emp_averland", "wh_main_emp_wissenland", false, false)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            if cm:random_number(10) > 7 then
                cm:force_declare_war("wh_main_emp_averland", "wh_main_emp_empire", false, false)
                model:get_elector("wh_main_emp_averland"):change_loyalty(-20)
                --@ sam, might need a new dummy effect. Called it "risk_of_escalation" or something so it can be reused in future random chance events.
                --@ localise as "[[col:yellow]]The Emperor Risks Escalating the Situation [[/col]]"
            end
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(10)
        end
        }
    },
    {
        key = "eom_dilemma_hochland_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_hochland") and model:is_elector_valid("wh_main_emp_cult_of_sigmar")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(10)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
        end
        }
    },
    {
        key = "eom_dilemma_ostermark_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_ostermark") and model:is_elector_valid("wh_main_emp_cult_of_sigmar")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-15)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(15)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-15)
        end
        }
    },
    {
        key = "eom_dilemma_stirland_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_stirland") and model:is_elector_valid("wh_main_emp_averland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_stirland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_averland"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_stirland"):change_loyalty(15)
            model:get_elector("wh_main_emp_averland"):change_loyalty(-15)
        end
        }
    },
    {
        key = "eom_dilemma_middenland_2",
        conditional = function(model --:EOM_MODEL
        )
            return model:is_elector_valid("wh_main_emp_cult_of_sigmar") and model:is_elector_valid("wh_main_emp_middenland") and model:is_elector_valid("wh_main_emp_cult_of_ulric")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-15)
            model:change_sigmarite_loyalties(-10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-20)
            model:change_ulrican_loyalites(-10)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(15)
            model:change_sigmarite_loyalties(10)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_middenland"):change_loyalty(-10)
            cm:force_declare_war("wh_main_emp_middenland", "wh_main_emp_empire", false, false)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(15)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(15)

        end
        }
    },
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
            cm:force_change_cai_faction_personality("wh_main_emp_marienburg", "eom_marienburg_appeased")
            model:set_core_data("friend_of_marienburg", true)
            model:get_elector("wh_main_emp_marienburg"):set_loyalty(80)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_nordland"):change_loyalty(15)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-10)
            cm:force_change_cai_faction_personality("wh_main_emp_marienburg", "eom_marienburg_angry")
            cm:force_diplomacy("faction:wh_main_emp_empire", "faction:wh_main_emp_marienburg", "trade", false, false, true)
            model:set_core_data("friend_of_marienburg", false)
            model:get_elector("wh_main_emp_marienburg"):set_loyalty(5)
        end
        }

    },
    {
        key = "eom_dilemma_ostland_2",
        conditional = function(model --:EOM_MODEL
        )  
            return model:is_elector_valid("wh_main_emp_ostland") and model:is_elector_valid("wh_main_emp_hochland") and (not model:get_core_data_with_key("hochland_ostland_allied") == true)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostland"):change_loyalty(10)
            model:get_elector("wh_main_emp_hochland"):change_loyalty(-15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostland"):change_loyalty(10)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostland"):change_loyalty(10)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-10)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(10)
            model:get_elector("wh_main_emp_ostland"):change_loyalty(-15)
        end
        }
    },
    {
        key = "eom_dilemma_wissenland_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_wissenland") and model:is_elector_valid("wh_main_emp_cult_of_ulric") and (cm:get_faction("wh_main_emp_empire"):treasury() > 5000)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(-15)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-15)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(15)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-15)
            model:change_ulrican_loyalites(-10)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(10)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(10)
            --NOTE: Add treasury cost payload
        end
        }
    },
    {
        key = "eom_dilemma_talabecland_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_talabecland") and model:is_elector_valid("wh_main_emp_hochland") and model:is_elector_valid("wh_main_emp_ostermark")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(5)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-15)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(10)
            model:get_elector("wh_main_emp_hochland"):change_loyalty(10)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(15)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-10)
            model:get_elector("wh_main_emp_hochland"):change_loyalty(-10)
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-25)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(15)
            model:get_elector("wh_main_emp_hochland"):change_loyalty(15)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(10)
        end
        }
    },
    {
        key = "eom_dilemma_cult_of_ulric_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_cult_of_sigmar") and model:is_elector_valid("wh_main_emp_cult_of_ulric") and model:is_elector_valid("wh_main_emp_talabecland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_averland"):change_loyalty(10)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-5)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-5)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-10)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(5)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(10)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:set_core_data("eom_conclave_cancelled", false)
            --@ sam: risk of escalation
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-15)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-10)
        end
        }
    },
    {
        key = "eom_dilemma_cult_of_sigmar_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_cult_of_sigmar") and model:is_elector_valid("wh_main_emp_talabecland")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-15)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(10)
        end
        }
    },
    {
        key = "eom_dilemma_marienburg_2",
        conditional = function(model --:EOM_MODEL
        )
            return model:is_elector_valid("wh_main_emp_marienburg") and model:is_elector_valid("wh_main_emp_middenland") and (cm:get_faction("wh_main_emp_empire"):treasury() > 7000)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_marienburg"):change_loyalty(-10)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(15)
            cm:force_declare_war("wh_main_emp_marienburg", "wh_main_emp_middenland", false, false)
            model:grant_casus_belli("wh_main_emp_marienburg")
            local carroburg_region = cm:get_region("wh_main_middenland_carroburg")

            cm:create_force("wh_main_emp_carroburg",
            "wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_handgunners,wh_main_emp_inf_handgunners,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen",
            "wh_main_middenland_carroburg",
            carroburg_region:settlement():logical_position_x() + 1,
            carroburg_region:settlement():logical_position_y() + 2,
            true,
            function(cqi)

            end)
            cm:callback(function()
                cm:transfer_region_to_faction("wh_main_middenland_carroburg", "wh_main_emp_carroburg")
                cm:treasury_mod("wh_main_emp_carroburg", 3000)
                cm:force_make_vassal("wh_main_emp_marienburg", "wh_main_emp_carroburg")
            end, 0.5)
            
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_marienburg"):change_loyalty(15)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(-25)
            local carroburg_region = cm:get_region("wh_main_middenland_carroburg")

            cm:create_force("wh_main_emp_carroburg",
            "wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_handgunners,wh_main_emp_inf_handgunners,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen",
            "wh_main_middenland_carroburg",
            carroburg_region:settlement():logical_position_x() + 1,
            carroburg_region:settlement():logical_position_y() + 2,
            true,
            function(cqi)

            end)
            cm:callback(function()
                cm:transfer_region_to_faction("wh_main_middenland_carroburg", "wh_main_emp_carroburg")
                cm:treasury_mod("wh_main_emp_carroburg", 3000)
                cm:force_make_vassal("wh_main_emp_marienburg", "wh_main_emp_carroburg")
            end, 0.5)
        end,
            [3] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_marienburg"):change_loyalty(-10)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(15)
            --NOTE: Add treasury cost
        end,
            [4] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_middenland"):change_loyalty(-10)
            cm:force_declare_war("wh_main_emp_marienburg", "wh_main_emp_middenland", false, false)
            local carroburg_region = cm:get_region("wh_main_middenland_carroburg")

            cm:create_force("wh_main_emp_carroburg",
            "wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_handgunners,wh_main_emp_inf_handgunners,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen",
            "wh_main_middenland_carroburg",
            carroburg_region:settlement():logical_position_x() + 1,
            carroburg_region:settlement():logical_position_y() + 2,
            true,
            function(cqi)

            end)
            cm:callback(function()
                cm:transfer_region_to_faction("wh_main_middenland_carroburg", "wh_main_emp_carroburg")
                cm:treasury_mod("wh_main_emp_carroburg", 3000)
                cm:force_make_vassal("wh_main_emp_marienburg", "wh_main_emp_carroburg")
            end, 0.5)
        end
        }
    },
    {
        key = "eom_dilemma_sylvania_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_cult_of_sigmar") and model:is_elector_valid("wh_main_emp_sylvania")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(10)
            model:get_elector("wh_main_emp_sylvania"):change_loyalty(-15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-15)
            model:get_elector("wh_main_emp_sylvania"):change_loyalty(10)
        end
        }
    },
    {
        key = "eom_dilemma_schwartzhafen_2",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_vmp_schwartzhafen") and model:is_elector_valid("wh_main_emp_cult_of_sigmar")
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_vmp_schwartzhafen"):change_loyalty(15)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-20)
            model:change_sigmarite_loyalties(-15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:set_core_data("vlad_civil_war", true)
            model:get_elector("wh_main_vmp_schwartzhafen"):change_loyalty(-20)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(15)
            model:change_sigmarite_loyalties(10)
        end
        }
    },
    {
        key = "eom_dilemma_averland_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_averland") and (model:get_elector("wh_main_emp_averland"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_averland"):change_loyalty(15)
            model:change_loyalty_for_all_except({"wh_main_emp_averland", "wh_main_emp_cult_of_sigmar", "wh_main_emp_cult_of_ulric"}, -15)
            --@sam use all.
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_averland"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_hochland_3",
        conditional = function(model --:EOM_MODEL
        )   
            return model:is_elector_valid("wh_main_emp_hochland") and (model:get_elector("wh_main_emp_hochland"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(15)
            model:change_loyalty_for_all_except({"wh_main_emp_hochland", "wh_main_emp_cult_of_sigmar", "wh_main_emp_cult_of_ulric"}, -15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_hochland"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_ostermark_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_ostermark") and (model:get_elector("wh_main_emp_ostermark"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_middenland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-10)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(25)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_stirland_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_stirland") and (model:get_elector("wh_main_emp_stirland"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:change_loyalty_for_all_except({"wh_main_emp_stirland", "wh_main_emp_cult_of_sigmar", "wh_main_emp_cult_of_ulric"}, -10)
            model:get_elector("wh_main_emp_stirland"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_stirland"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_middenland_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_middenland") and (model:get_elector("wh_main_emp_middenland"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:change_loyalty_for_all_except({"wh_main_emp_middenland", "wh_main_emp_cult_of_sigmar", "wh_main_emp_cult_of_ulric"}, -10)
            model:get_elector("wh_main_emp_middenland"):change_loyalty(10)
            model:set_core_data("middenland_conceded_to", true)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_middenland"):change_loyalty(-20)
            model:set_core_data("middenland_conceded_to", false)
        end
        }
    },
    {
        key = "eom_dilemma_nordland_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_nordland") and (model:get_elector("wh_main_emp_nordland"):loyalty() < 20) and cm:get_region("wh_main_the_wasteland_marienburg"):owning_faction():name() == "wh_main_emp_empire" and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            cm:transfer_region_to_faction("wh_main_the_wasteland_marienburg", "wh_main_emp_nordland")
            model:get_elector("wh_main_emp_nordland"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_nordland"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_ostland_3",
        conditional = function(model --:EOM_MODEL
        )
            return false
           -- return model:is_elector_valid("wh_main_emp_middenland") and (model:get_elector("wh_main_emp_middenland"):loyalty() < 20) and (cm:model():turn_number() > 50) and (cm:get_faction("wh_main_emp_empire"):treasury() > 5000)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            --NOTE: add treasury cost payload
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(15)
            model:get_elector("wh_main_emp_ostland"):change_loyalty(10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_ostland"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_wissenland_3",
        conditional = function(model --:EOM_MODEL
        )
            return model:is_elector_valid("wh_main_emp_wissenland") and (model:get_elector("wh_main_emp_wissenland"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
   
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(15)
            model:change_loyalty_for_all_except({"wh_main_emp_wissenland", "wh_main_emp_cult_of_sigmar"}, -15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_wissenland"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_talabecland_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_talabecland") and (model:get_elector("wh_main_emp_talabecland"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 

            model:get_elector("wh_main_emp_talabecland"):change_loyalty(15)
            model:change_loyalty_for_all_except({"wh_main_emp_talabecland"}, -15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_cult_of_ulric_3",
        conditional = function(model --:EOM_MODEL
        )

        return model:is_elector_valid("wh_main_emp_cult_of_ulric") and (model:get_elector("wh_main_emp_cult_of_ulric"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 

            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(15)
            model:change_ulrican_loyalites(10)
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-20)
            model:change_sigmarite_loyalties(-15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-20)
            model:change_ulrican_loyalites(-10)
        end
        }
    },
    {
        key = "eom_dilemma_cult_of_sigmar_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_cult_of_sigmar") and (model:get_elector("wh_main_emp_cult_of_sigmar"):loyalty() < 20) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(15)
            model:change_ulrican_loyalites(-15)
            model:change_atheist_loyalties(-15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_marienburg_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_marienburg") and (model:get_elector("wh_main_emp_marienburg"):loyalty() < 50) and (cm:model():turn_number() > 30)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
           
            model:get_elector("wh_main_emp_marienburg"):change_loyalty(10)
            model:get_elector("wh_main_emp_nordland"):change_loyalty(-15)
            model:get_elector("wh_main_emp_talabecland"):change_loyalty(-15)
            --@ sam can you add a dummy effect: key: eom_high_elf_trade_restriction, localisation: "Only Marienburg may with the city of Lothern", image: "icon_effects_army.png"
            cm:force_diplomacy("faction:wh_main_emp_empire", "faction:wh2_main_hef_eataine", "trade", false, false, true)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_marienburg"):change_loyalty(-15)
        end
        }
    },
    {
        key = "eom_dilemma_sylvania_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_emp_sylvania") and (model:get_elector("wh_main_emp_sylvania"):loyalty() < 50) and (cm:model():turn_number() > 30)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            
            model:get_elector("wh_main_emp_sylvania"):change_loyalty(10)
            model:get_elector("wh_main_emp_averland"):change_loyalty(-15)
            model:get_elector("wh_main_emp_ostermark"):change_loyalty(-15)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:get_elector("wh_main_emp_sylvania"):change_loyalty(-20)
        end
        }
    },
    {
        key = "eom_dilemma_schwartzhafen_3",
        conditional = function(model --:EOM_MODEL
        )

            return model:is_elector_valid("wh_main_vmp_schwartzhafen") and (model:get_elector("wh_main_vmp_schwartzhafen"):loyalty() < 50) and (cm:model():turn_number() > 50)
        end,
        choices = {
            [1] = function(model --: EOM_MODEL
            ) 
            model:get_elector("wh_main_vmp_schwartzhafen"):change_loyalty(20)
            model:change_loyalty_for_all_except({"wh_main_vmp_schwartzhafen"}, -10)
        end,
            [2] = function(model --:EOM_MODEL
            ) 
            model:set_core_data("vlad_civil_war", true)
            model:get_elector("wh_main_vmp_schwartzhafen"):change_loyalty(-25)
        end
        }
    }, 
}--:vector<EOM_EVENT>
    eom:log("Adding Main Events", "export_helpers__eom_main_events")
    for i = 1, #eom_main_events_table do 
        local current_event = eom_main_events_table[i];
        eom:add_event(current_event)
    end
end

cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context) eom_empire_main_events() end;

--eom_dilemma_ostermark_3



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