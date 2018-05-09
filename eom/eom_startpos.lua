

--contains starting position data for all cults, electors, etc. 

--game


--v function(faction_key: string)
function eom_start_pos(faction_key)

	---diplomacy setup time

	--list of all the elector counts, we could get this from the main list to save space, but this is easier.
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
    }--:vector<string>

--list of all the factions within the empire, including the player	

    local diplomacy_list = {
        "faction:wh_main_emp_averland",
        "faction:wh_main_emp_hochland",
        "faction:wh_main_emp_ostermark",
        "faction:wh_main_emp_stirland",
        "faction:wh_main_emp_middenland",
        "faction:wh_main_emp_nordland",
        "faction:wh_main_emp_ostland",
        "faction:wh_main_emp_wissenland",
        "faction:wh_main_emp_talabecland",
        "faction:wh_main_emp_empire"
    }--:vector<string>
    --list of external human factions
    local external_list = {
        "faction:wh_main_ksl_kislev",
        "faction:wh_main_teb_border_princes"
    }--:vector<string>

    --first, disable anyone in the empire from declaring war on anyone else.
    for i = 1, #elector_diplo_list do
        for j = 1, #elector_diplo_list do
            cm:add_default_diplomacy_record(elector_diplo_list[i], elector_diplo_list[j], "defensive alliance", false, false, false);
            cm:add_default_diplomacy_record(elector_diplo_list[i], elector_diplo_list[j], "peace", true, true, false);
            cm:add_default_diplomacy_record(elector_diplo_list[i], elector_diplo_list[j], "war", false, false, false);
            cm:add_default_diplomacy_record(elector_diplo_list[i], elector_diplo_list[j], "form confederation", false, false, false);
            cm:add_default_diplomacy_record(elector_diplo_list[i], elector_diplo_list[j], "military alliance", false, false, false);
        end
    end


    --second, disable the elector counts from declaring war on Karl Franz

    for i = 1, #elector_diplo_list do
        cm:add_default_diplomacy_record(elector_diplo_list[i], "faction:"..faction_key, "war", false, false, false);
    end

    --next, disable the ability for elector counts to declare war on external factions.
    for i = 1, #elector_diplo_list do
        for j = 1, #external_list do
        cm:add_default_diplomacy_record(elector_diplo_list[i], external_list[j], "war", false, false, false);
        end
    end

    ---now, allow the emperor to declare war on anyone.
    for i = 1, #elector_diplo_list do
        cm:add_default_diplomacy_record("faction:"..faction_key, elector_diplo_list[i], "war", true, true, false);
        cm:add_default_diplomacy_record("faction:"..faction_key, elector_diplo_list[i], "military alliance", true, true, false);
        cm:add_default_diplomacy_record("faction:"..faction_key, elector_diplo_list[i], "defensive alliance", true, true, false);
        cm:add_default_diplomacy_record("faction:"..faction_key, elector_diplo_list[i], "form confederation", true, true, false);
        cm:add_default_diplomacy_record("faction:"..faction_key, elector_diplo_list[i], "vassal", true, true, false);
    end;

    --make some changes to the diplomatic start position.
    cm:force_make_peace("wh_main_brt_bretonnia", "wh_main_emp_marienburg");
    cm:force_declare_war("wh_main_brt_bretonnia", "wh_dlc05_vmp_mousillon", true, true);

end;


--cults

--v function() --> map<string,WHATEVER>
function sigmar_start_pos()
    local sp = {}
    sp.faction_name = "wh_main_emp_cult_of_sigmar"
    sp.ui_name = "Cult of Sigmar"
    sp.loyalty = 65
    sp.spawn_x = 523
    sp.spawn_y = 409
    sp.second_spawn_x = 581 
    sp.second_spawn_y = 443
    sp.leader_forename = "names_name_2147358013"
    sp.leader_subtype = "dlc04_emp_volkmar"
    sp.leader_surname = "names_name_2147358014"
    sp.second_forename = "names_name_2147343993"
    sp.second_subtype = "dlc04_emp_arch_lector"
    sp.second_surname = "names_name_2147344000"
    sp.leader_region = "wh_main_wissenland_nuln"
    sp.second_region = "wh_main_stirland_wurtbad"
    return sp
end


--v function() --> map<string, WHATEVER>
function ulric_start_pos()
    local sp = {}
    sp.faction_name = "wh_main_emp_cult_of_ulric"
    sp.ui_name = "Cult of Ulric"
    sp.loyalty = 65
    sp.spawn_x = 523
    sp.spawn_y = 409
    sp.second_spawn_x = 497
    sp.second_spawn_y = 494
    sp.leader_forename = "names_name_2147344088"
    sp.leader_subtype = "emp_lord"
    sp.leader_surname = "names_name_2147344098"
    sp.second_forename = "names_name_2147343937"
    sp.second_subtype = "emp_lord"
    sp.second_surname = "names_name_2147344030"
    sp.leader_region = "wh_main_middenland_middenheim"
    sp.second_region = "wh_main_middenland_weismund"
    return sp
end


--v function(eom: EOM_MODEL)
function eom_core_data_start_pos(eom)
    eom:add_core_data("marienburg_taken", false)
    eom:add_core_data("drakenhof_taken", false)
    eom:add_core_data("marienburg_will_rebel", false)
    eom:add_core_data("marienburg_rebellion_happened", true)
    eom:add_core_data("marienburg_invaded", false)
    eom:add_core_data("marienburg_defended", false)
    eom:add_core_data("marienburg_fallen", false)
    eom:add_core_data("version", "3 alpha")
end







--electors

--v function() --> map<string, WHATEVER>
function averland_start_pos()
    local sp = {}
    sp.loyalty = 50
    sp.fully_loyal = false
    sp.hidden = false
    sp.base_power = 35
    sp.faction_name = "wh_main_emp_averland"
    sp.ui_name = "Averland"
    sp.image =  "ui/flags/wh_main_emp_averland/mon_rotated.png"
    sp.tooltip = "Elector Count"
    sp.status = 1
    sp.leader_subtype = "emp_lord"
    sp.leader_forename = "names_name_2147343941"
    sp.leader_surname = "names_name_2147343947"
    sp.capital =  "wh_main_averland_averheim"
    sp.expedition_x = 573
    sp.expedition_y = 386
    sp.traits = {} --to be filled in later
    sp.expedition_region = "wh_main_wissenland_pfeildorf"
    sp.turns_dead = 0
    sp.revive_happened = false
    sp.base_regions = 2
    return sp
end






--civil_wars


--v function() --> map<string, WHATEVER>
function summon_the_electors()
    local start_pos = {}

    --electors
    start_pos.electors = {}
    local electors = start_pos.electors

    --averland
    local averland = averland_start_pos()
    electors["wh_main_emp_averland"] = averland




    --cults 
    start_pos.cults = {}
    local cults = start_pos.cults

    --sigmar
    local sigmar = sigmar_start_pos()
    cults["wh_main_emp_cult_of_sigmar"] = sigmar
    --ulric
    local ulric = ulric_start_pos()
    cults["wh_main_emp_cult_of_ulric"] = ulric


    return start_pos

end