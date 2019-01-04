cm = get_cm()
events = get_events()
eom = _G.eom


--v function(quantity: number)
local function increase_civil_war_points(quantity)
    local points = eom:get_core_data_with_key("civil_war_points") --# assume points: number
    new_points = points + quantity
    eom:set_core_data("civil_war_points", new_points)
end

--v function(quantity: number)
local function decrease_civil_war_points(quantity)
    local points = eom:get_core_data_with_key("civil_war_points") --# assume points: number
    new_points = points - quantity
    if new_points < 0 then new_points = 0 end
    eom:set_core_data("civil_war_points", new_points)
end

--v function(elector: ELECTOR_NAME, civil_war_emperor: string)
local function apply_loyalist_bundles(elector, civil_war_emperor)
    eom:log(" elector ["..elector.."] joining the civil war on the side of karl franz!  ")
    cm:apply_effect_bundle("eom_civil_war_"..elector.."_loyalist", eom:empire(), 0)
end

--v function(elector: ELECTOR_NAME, civil_war_emperor: string)
local function apply_rebel_bundles(elector, civil_war_emperor)
    eom:log(" elector ["..elector.."] joining the civil war on teh side of the rebels! ")
    cm:apply_effect_bundle("eom_civil_war_"..elector.."_rebel", eom:empire(), 0)
    eom:get_elector(elector):set_status("civil_war_enemy")
    eom:get_elector(elector):set_loyalty(0)
end

--v function()
local function allow_wars()
    local elector_diplo_list = {

        "wh_main_emp_averland",
        "wh_main_emp_hochland",
        "wh_main_emp_ostermark",
        "wh_main_emp_stirland",
        "wh_main_emp_middenland",
        "wh_main_emp_nordland",
        "wh_main_emp_ostland",
        "wh_main_emp_wissenland",
        "wh_main_emp_talabecland",
        "wh_main_emp_sylvania",
        "wh_main_vmp_schwartzhafen",
        "wh_main_emp_marienburg"
    }--: vector<ELECTOR_NAME>
    for i = 1, #elector_diplo_list do
        if eom:get_elector(elector_diplo_list[i]):status() == "civil_war_enemy" or eom:get_elector(elector_diplo_list[i]):status() == "civil_war_emperor" then
            cm:force_diplomacy("faction:"..elector_diplo_list[i], "faction:wh_main_emp_empire", "war,join war", true, true, false);
        end
    end

    for i = 1, #elector_diplo_list do
        for j = 1, #elector_diplo_list do
            if (eom:get_elector(elector_diplo_list[i]):status() == "civil_war_enemy" and eom:get_elector(elector_diplo_list[j]):status() == "normal")
                or (eom:get_elector(elector_diplo_list[i]):status() == "civil_war_emperor" and eom:get_elector(elector_diplo_list[j]):status() == "normal")
                or (eom:get_elector(elector_diplo_list[i]):status() == "normal" and eom:get_elector(elector_diplo_list[j]):status() == "civil_war_enemy")
                or (eom:get_elector(elector_diplo_list[i]):status() == "normal" and eom:get_elector(elector_diplo_list[j]):status() == "civil_war_emperor")
            then
                cm:force_diplomacy("faction:"..elector_diplo_list[i], "faction:"..elector_diplo_list[j], "war,join war", true, true, false);
            end
        end
    end

end



core:add_listener(
    "EOMCivilWarSettlements",
    "GarrisonOccupiedEvent",
    function(context)
        return eom:get_core_data_with_key("civil_war_active") == true
    end,
    function(context)
        if context:character():faction():subculture() == "wh_main_sc_emp_empire" then
            for name, elector in pairs(eom:electors()) do
                if context:garrison_residence():region():name() == elector:capital() then
                    if string.find(elector:status(), "civil_war") then
                        eom:change_all_loyalties(5)
                        increase_civil_war_points(3)
                    else
                        eom:change_all_loyalties(-10)
                        decrease_civil_war_points(3)
                    end
                end
            end
        end
    end,
    true
)








core:add_listener(
    "EOMCivilWarBattles",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character() --:CA_CHAR
        return eom:get_core_data_with_key("civil_war_active") == true
    end,
    function (context)
        local character = context:character() --:CA_CHAR
        if character:faction():name() == "wh_main_emp_empire" then
            local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
            
            for i = 1, #enemies do
                local enemy = enemies[i];
                local enemy_name = enemy:faction():name() --# assume enemy_name: ELECTOR_NAME
                if eom:has_elector(enemy_name) then
                    if string.find(eom:get_elector(enemy_name):status(),"civil_war") then
                        if character:won_battle() then
                            eom:change_all_loyalties(5)
                            increase_civil_war_points(1)
                        else
                            eom:change_all_loyalties(-10)
                            decrease_civil_war_points(1)
                        end
                    end
                end
            end
        end
    end,
    true)


--v function (eom:EOM_MODEL) --> boolean
local function eom_civil_war_start_check_ulric(eom)
    local middenland_low = eom:get_elector("wh_main_emp_middenland"):loyalty() < 30
    local ulric_low = eom:get_elector("wh_main_emp_cult_of_ulric"):loyalty() < 30
  
    local ulric_minimum = eom:get_elector("wh_main_emp_cult_of_ulric"):loyalty() == 0
    local middenland_minimum = eom:get_elector("wh_main_emp_middenland"):loyalty() == 0

    return (ulric_low and middenland_minimum) or (ulric_minimum and middenland_low)
end

--v function (eom:EOM_MODEL) --> boolean
local function eom_civil_war_start_check_sigmar(eom)
    local sigmar_low = eom:get_elector("wh_main_emp_cult_of_sigmar"):loyalty() < 30
    local wissenland_low = eom:get_elector("wh_main_emp_wissenland"):loyalty() < 30
    local sigmar_minimum = eom:get_elector("wh_main_emp_cult_of_sigmar"):loyalty() == 0
    local wissenland_minimum = eom:get_elector("wh_main_emp_wissenland"):loyalty() == 0

    return (sigmar_low and wissenland_minimum) or (sigmar_minimum and wissenland_low)
end


--v function(eom: EOM_MODEL) 
local function eom_civil_war_start_ulric(eom)
    eom:set_core_data("block_events_for_plot", true)
    eom:set_core_data("civil_war_active", true)
    ulric = eom:get_elector("wh_main_emp_cult_of_ulric")
    ulric:set_status("civil_war_enemy")
    eom:get_elector("wh_main_emp_middenland"):set_status("civil_war_emperor")
    local x, y = ulric:expedition_coordinates()
    cm:create_force("wh_main_emp_cult_of_ulric", ulric:get_army_list(), ulric:expedition_region(), x, y, true, function(cqi) cm:treasury_mod("wh_main_emp_cult_of_sigmar", 20000) end)
    ulric:respawn_at_capital(true)
    cm:callback( function()
        cm:apply_effect_bundle("eom_civil_war_wh_main_emp_cult_of_ulric_rebel", eom:empire(), 0)
        cm:apply_effect_bundle("eom_civil_war_wh_main_emp_middenland_rebel", eom:empire(), 0)
    end, 0.1);

    cm:trigger_incident(eom:empire(), "eom_main_civil_war_middenland_2", true)
    
    local ulric_other_electors = {
        "wh_main_emp_hochland",
        "wh_main_emp_nordland"
    } --:vector<ELECTOR_NAME>
    local neutral_electors = {
        "wh_main_emp_averland",
        "wh_main_emp_marienburg",
        "wh_main_emp_ostermark",
        "wh_main_emp_sylvania"
    }--:vector<ELECTOR_NAME>
    local sigmarite_electors = {
        "wh_main_emp_stirland",
        "wh_main_emp_wissenland",
        "wh_main_emp_ostland",
        "wh_main_emp_cult_of_sigmar"
    }--:vector<ELECTOR_NAME>

    for i = 1, #ulric_other_electors do
        local elector = eom:get_elector(ulric_other_electors[i])
        if not cm:get_faction(elector:name()):is_dead() then
            if elector:loyalty() < 65 then
                apply_rebel_bundles(elector:name(), "wh_main_emp_middenland")
            elseif elector:loyalty() > 80 then
                apply_loyalist_bundles(elector:name(), "wh_main_emp_middenland")
            end
        end
    end

    for i = 1, #neutral_electors do
        local elector = eom:get_elector(neutral_electors[i])
        if not cm:get_faction(elector:name()):is_dead() then
            if elector:loyalty() < 40 then
                apply_rebel_bundles(elector:name(), "wh_main_emp_middenland")
            elseif elector:loyalty() > 60 then
                apply_loyalist_bundles(elector:name(), "wh_main_emp_middenland")
            end
        end
    end
    local sigmar = eom:get_elector("wh_main_emp_cult_of_sigmar")
    if sigmar:loyalty() >= 40 then
        local x, y = sigmar:expedition_coordinates()
        cm:create_force("wh_main_emp_cult_of_sigmar", sigmar:get_army_list(), sigmar:expedition_region(), x, y, true, function(cqi) cm:treasury_mod("wh_main_emp_cult_of_sigmar", 20000) end)
        sigmar:respawn_at_capital(true)
    end
    for i = 1, #sigmarite_electors do
        local elector = eom:get_elector(sigmarite_electors[i])
        if not cm:get_faction(elector:name()):is_dead() then
            if elector:loyalty() < 25 then
                apply_rebel_bundles(elector:name(), "wh_main_emp_middenland")
            elseif elector:loyalty() >= 40 then
                apply_loyalist_bundles(elector:name(), "wh_main_emp_middenland")
            end
        end
    end
    allow_wars()
    eom:grant_casus_belli("wh_main_emp_middenland")
    eom:grant_casus_belli("wh_main_emp_cult_of_ulric")
end

--v function(eom: EOM_MODEL) 
local function eom_civil_war_start_sigmar(eom)
    eom:set_core_data("block_events_for_plot", true)
    eom:set_core_data("civil_war_active", true)
    local sigmar = eom:get_elector("wh_main_emp_cult_of_sigmar")
    sigmar:set_status("civil_war_enemy")
    eom:get_elector("wh_main_emp_wissenland"):set_status("civil_war_emperor")
    local x, y = sigmar:expedition_coordinates()
    cm:create_force("wh_main_emp_cult_of_sigmar", sigmar:get_army_list(), sigmar:expedition_region(), x, y, true, function(cqi) cm:treasury_mod("wh_main_emp_cult_of_sigmar", 20000) end)
    sigmar:respawn_at_capital(true)
    cm:callback( function()
        cm:apply_effect_bundle("eom_civil_war_wh_main_emp_cult_of_sigmar_rebel", eom:empire(), 0)
        cm:apply_effect_bundle("eom_civil_war_wh_main_emp_wissenland_rebel", eom:empire(), 0)
    end, 0.1);


    cm:trigger_incident(eom:empire(), "eom_main_civil_war_wissenland_2", true)

   
    local sigmar_other_electors = {
        "wh_main_emp_stirland",
        "wh_main_emp_ostland"
    }--:vector<ELECTOR_NAME>
    local neutral_electors = {
        "wh_main_emp_averland",
        "wh_main_emp_marienburg",
        "wh_main_emp_ostermark",
        "wh_main_emp_sylvania"
    }--:vector<ELECTOR_NAME>
    local ulrican_electors = {
        "wh_main_emp_middenland",
        "wh_main_emp_cult_of_ulric",
        "wh_main_emp_hochland",
        "wh_main_emp_nordland"
    }--:vector<ELECTOR_NAME>

    for i = 1, #sigmar_other_electors do
        local elector = eom:get_elector(sigmar_other_electors[i])
        if not cm:get_faction(elector:name()):is_dead() then
            if elector:loyalty() < 65 then
                apply_rebel_bundles(elector:name(), "wh_main_emp_wissenland")
            elseif elector:loyalty() > 80 then
                apply_loyalist_bundles(elector:name(), "wh_main_emp_wissenland")
            end
        end
    end

    for i = 1, #neutral_electors do
        local elector = eom:get_elector(neutral_electors[i])
        if not cm:get_faction(elector:name()):is_dead() then
            if elector:loyalty() < 40 then
                apply_rebel_bundles(elector:name(), "wh_main_emp_wissenland")
            elseif elector:loyalty() > 60 then
                apply_loyalist_bundles(elector:name(), "wh_main_emp_wissenland")
            end
        end
    end
    ulric = eom:get_elector("wh_main_emp_cult_of_ulric")
    if ulric:loyalty() > 45 then
        local x, y = ulric:expedition_coordinates()
        cm:create_force("wh_main_emp_cult_of_ulric", ulric:get_army_list(), ulric:expedition_region(), x, y, true, function(cqi) cm:treasury_mod("wh_main_emp_cult_of_sigmar", 20000) end)
        ulric:respawn_at_capital(true)
    end
    for i = 1, #ulrican_electors do
        local elector = eom:get_elector(ulrican_electors[i])
        if not cm:get_faction(elector:name()):is_dead() then
            if elector:loyalty() < 25 then
                apply_rebel_bundles(elector:name(), "wh_main_emp_wissenland")
            elseif elector:loyalty() >= 40 then
                apply_loyalist_bundles(elector:name(), "wh_main_emp_wissenland")
            end
        end
    end
    allow_wars()
    eom:grant_casus_belli("wh_main_emp_cult_of_sigmar")
    eom:grant_casus_belli("wh_main_emp_wissenland")
end



--v function (eom:EOM_MODEL) --> boolean
local function eom_civil_war_end_check(eom)
    local points = eom:get_core_data_with_key("civil_war_points") --# assume points: number
    return points > 14
end

--v function (eom: EOM_MODEL)
local function eom_civil_war_ender(eom)
    for name, elector in pairs(eom:electors()) do
        if cm:get_faction(name):is_dead() then
            elector:set_hidden(true)
            elector:set_status("fallen")
        else
            if elector:status() == "civil_war_enemy" then
                elector:set_status("open_rebellion")
                if cm:get_region(elector:capital()):owning_faction():name() == eom:empire() then
                    cm:force_confederation(eom:empire(), name)
                    elector:set_hidden(true)
                    elector:set_status("fallen")
                end
            elseif elector:status() == "civil_war_emperor" then
                elector:set_status("fallen")
                elector:set_hidden(true)
                cm:force_confederation(eom:empire(), name)
                if elector:name() == "wh_main_emp_wissenland" then
                    cm:trigger_incident(eom:empire(), "eom_main_civil_war_wissenland_5", true)
                elseif elector:name() == "wh_main_emp_middenland" then
                    cm:trigger_incident(eom:empire(), "eom_main_civil_war_middenland_5", true)
                end
                eom:set_core_data("midgame_chaos_trigger_turn", cm:model():turn_number() + 5)
                eom:set_core_data("lategame_chaos_trigger_turn", cm:model():turn_number() + 35)
            end
        end
    end
    eom:set_core_data("block_events_for_plot", false)
    eom:set_core_data("civil_war_active", false)
    eom:change_all_loyalties(30)
end




local function eom_civil_war()

    if cm:is_new_game() then
        eom:set_core_data("civil_war_points", 0)
        eom:set_core_data("civil_war_active", false)
    end

    local civil_war_ulric = eom:new_story_chain("civil_war_ulric")

    civil_war_ulric:add_stage_trigger(1, function(model --:EOM_MODEL
    )
        return eom_civil_war_start_check_ulric(model)
    end)

    civil_war_ulric:add_stage_callback(1, function(model --:EOM_MODEL
    )
        eom_civil_war_start_ulric(model)
    end)

    civil_war_ulric:add_stage_trigger(2, function(model --:EOM_MODEL
    )
        return eom_civil_war_end_check(model)
    end)

    civil_war_ulric:add_stage_callback(2, function(model --:EOM_MODEL
    )
        eom_civil_war_ender(model)
        model:get_story_chain("civil_war_ulric"):finish()
    end)
    local civil_war_sigmar = eom:new_story_chain("civil_war_sigmar")

    civil_war_sigmar:add_stage_trigger(1, function(model --:EOM_MODEL
    )
        return eom_civil_war_start_check_sigmar(model)
    end)

    civil_war_sigmar:add_stage_callback(1, function(model --:EOM_MODEL
    )
        eom_civil_war_start_sigmar(model)
    end)

    civil_war_sigmar:add_stage_trigger(2, function(model --:EOM_MODEL
    )
        return eom_civil_war_end_check(model)
    end)

    civil_war_sigmar:add_stage_callback(2, function(model --:EOM_MODEL
    )
        eom_civil_war_ender(model)
        model:get_story_chain("civil_war_sigmar"):finish()
    end)

end












cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function(context)
    if cm:get_faction(eom:empire()):is_human() then
        eom_civil_war()
    end 
end;

