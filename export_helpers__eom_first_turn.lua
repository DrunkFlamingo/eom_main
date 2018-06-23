cm = get_cm(); events = get_events(); eom = _G.eom;

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

