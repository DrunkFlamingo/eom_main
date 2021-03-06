cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end


local function eom_starting_settings()
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
            "faction:wh_main_emp_talabecland",
            "faction:wh_main_emp_sylvania",
            "faction:wh_main_vmp_schwartzhafen",
            "faction:wh_main_emp_marienburg"
        }--: vector<string>
        local external_list = {
            "faction:wh_main_ksl_kislev",
            "faction:wh_main_teb_border_princes",
            "faction:wh_main_dwf_karak_kadrin",
            "faction:wh_main_dwf_dwarfs"
        }--:vector< string>

        for i = 1, #elector_diplo_list do
            for j = 1, #elector_diplo_list do
                cm:force_diplomacy(elector_diplo_list[i], elector_diplo_list[j], "defensive alliance", false, false, false);
                cm:force_diplomacy(elector_diplo_list[i], elector_diplo_list[j], "peace", true, true, false);
                cm:force_diplomacy(elector_diplo_list[i], elector_diplo_list[j], "war,join war", false, false, false);
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

        --set marienburg's status to seceded
        cm:force_change_cai_faction_personality("wh_main_emp_marienburg", "wh_main_emp_marienburg")
        if cm:get_faction(eom:empire()):is_human() then

            local vlad_armies = cm:get_faction("wh_main_vmp_schwartzhafen"):character_list()
            for i = 0, vlad_armies:num_items() -1 do
                cm:callback(function()
                    cm:kill_character(vlad_armies:item_at(i):cqi(), true, true)
                end, i+1/10)
            end
    
            local provinces_to_transfer_to_mannfred = {
                "wh_main_eastern_sylvania_eschen",
                "wh_main_eastern_sylvania_waldenhof",
                "wh_main_western_sylvania_schwartzhafen",
                "wh_main_western_sylvania_castle_templehof"
            } --:vector<string>
            
            --give sylvania to mannfred
            
            for i = 1, #provinces_to_transfer_to_mannfred do
                cm:callback( function()
                cm:transfer_region_to_faction(provinces_to_transfer_to_mannfred[i], "wh_main_vmp_vampire_counts");
                end, (i/10));
            end

            --prevent mannfredd from declaring war on the empire until we want him to
            cm:force_diplomacy("all", "faction:wh_main_vmp_vampire_counts", "war,join war", false, false, false)
            cm:force_diplomacy("faction:wh_main_vmp_vampire_counts", "all", "war,join war", false, false, false)
            cm:force_diplomacy("faction:wh_main_vmp_vampire_counts", "subculture:wh_main_sc_emp_empire", "peace", false, false, false)
            cm:force_diplomacy("faction:"..karl, "faction:wh_main_vmp_vampire_counts", "war", true, false, false)

            --force marienburg and bretonnia to peace
            cm:force_make_peace("wh_main_brt_bretonnia", "wh_main_emp_marienburg");
            cm:force_declare_war("wh_main_brt_bretonnia", "wh_dlc05_vmp_mousillon", true, true);
            cm:force_diplomacy("faction:wh_main_emp_marienburg", "faction:wh_main_brt_bretonnia", "war,join war", false, false, false)
      

        --anti beastmen forces
        cm:callback( function() 
            earlyunitlist = "wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_handgunners,wh_main_emp_inf_handgunners,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen"
            --497, 494
            cm:create_force("wh_main_emp_middenland", earlyunitlist, "wh_main_middenland_weismund", 497, 494, true);
            --484, 564
            cm:create_force("wh_main_emp_nordland", earlyunitlist, "wh_main_nordland_salzenmund", 484, 564, true);
            end, 5.0);

        --randomize which plot events happen when
        end

        out("EOM STARTING CHANGES FINISHED")
    end
end




cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context) eom_starting_settings() end;

