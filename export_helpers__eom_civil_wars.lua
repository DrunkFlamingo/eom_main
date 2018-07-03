cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end

--v function(name: string)
local function allow_wars_for_elector(name)
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
    for i = 1, #elector_diplo_list do
        cm:force_diplomacy("faction:"..name, elector_diplo_list[i], "war", true, true, false);
        cm:force_diplomacy("faction:"..name, elector_diplo_list[i], "military alliance", false, false, false);
        cm:force_diplomacy("faction:"..name, elector_diplo_list[i], "defensive alliance", false, false, false);
        cm:force_diplomacy("faction:"..name, elector_diplo_list[i], "form confederation", false, false, false);
        cm:force_diplomacy("faction:"..name, elector_diplo_list[i], "vassal", false, false, false);
    end;
end
--v function(threshold: number)
local function civil_war_loyalists(threshold)
    local elector_list = eom:elector_list()
    for name, elector in pairs(eom:electors()) do
        if (elector:status() == "normal") and elector:loyalty() > threshold and (not cm:get_faction(name):is_dead()) then
            if elector:is_cult() then 
                elector:respawn_at_capital(true)
            end

            for i = 1, #elector_list do
                if elector_list[i]:status() == "civil_war_enemy" or elector_list[i]:status() == "civil_war_emperor" then
                    cm:force_declare_war(elector:name(), elector_list[i]:name(), false, false)
                end
            end
        end
    end
end


local function eom_vlad_civil_war()
    local civil_war_vlad = eom:new_story_chain("civil_war_vlad")
    civil_war_vlad:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        local chaos_invasion_over = eom:get_core_data_with_key("chaos_defeated") --# assume chaos_invasion_over: boolean
        local vlad_will_rebel = model:get_core_data_with_key("vlad_civil_war") --# assume vlad_will_rebel: boolean
        local after_chaos_condition = (chaos_invasion_over and vlad_will_rebel and model:get_elector("wh_main_vmp_schwartzhafen"):status() == "normal")
        local before_chaos_condition = (model:get_elector("wh_main_vmp_schwartzhafen"):loyalty() == 0) and (model:get_elector("wh_main_vmp_schwartzhafen"):status() == "normal")
        return (after_chaos_condition or before_chaos_condition) and not cm:get_faction("wh_main_vmp_schwartzhafen"):is_dead()
    end)
    civil_war_vlad:add_stage_callback(1, function(model--:EOM_MODEL
    )
        if cm:get_faction(model:empire()):is_human() then
            cm:trigger_incident(model:empire(), "eom_main_civil_war_vlad_1", true)
        end
        model:set_core_data("block_events_for_plot", true)
        model:get_elector("wh_main_vmp_schwartzhafen"):set_hidden(true)
        model:get_elector("wh_main_vmp_schwartzhafen"):set_loyalty(0)
        model:get_elector("wh_main_vmp_schwartzhafen"):set_status("civil_war_emperor")
        model:set_core_data("civil_war_vlad_timer", cm:model():turn_number() + 10)
        cm:treasury_mod("wh_main_vmp_schwartzhafen", 20000)
    end)
    civil_war_vlad:add_stage_trigger(2, function(model--:EOM_MODEL
    )
        local turn_timeout = model:get_core_data_with_key("civil_war_vlad_timer") --# assume turn_timeout: number
        return cm:model():turn_number() == turn_timeout
    end)
    civil_war_vlad:add_stage_callback(2, function(model--:EOM_MODEL
    )
    allow_wars_for_elector("wh_main_vmp_schwartzhafen")
    cm:force_declare_war("wh_main_vmp_schwartzhafen", model:empire(), false, false)
    cm:treasury_mod("wh_main_vmp_schwartzhafen", 10000)
    if cm:get_faction(model:empire()):is_human() then
    cm:trigger_incident(model:empire(), "eom_main_civil_war_vlad_2", true)
    end
    model:advance_chaos_to_mid_game()
    model:set_core_data("lategame_chaos_trigger_turn", cm:model():turn_number() + 11)
    local i = 1
    for name, elector in pairs(model:electors()) do
        if elector:status() == "normal" and (elector:loyalty() > 39 or elector:is_cult()) then
        if elector:is_cult() then 
            elector:respawn_at_capital(true)
        end
        cm:callback( function()
            cm:force_declare_war("wh_main_vmp_schwartzhafen", name, false, false)
        end, i/10)
        i = i + 1;
        end
    end
    end)
    civil_war_vlad:add_stage_trigger(3, function(model--:EOM_MODEL
    )
        return cm:get_faction("wh_main_vmp_schwartzhafen"):is_dead()
    end)
    civil_war_vlad:add_stage_callback(3, function(model--:EOM_MODEL
    )
        model:get_story_chain("civil_war_vlad"):finish()
        model:set_core_data("block_events_for_plot", false)
        if not eom:get_core_data_with_key("chaos_defeated") then
            model:advance_chaos_to_late_game()
        end
    end)



end



local function eom_sigmar_civil_war()
    local civil_war_sigmar = eom:new_story_chain("civil_war_sigmar")
    civil_war_sigmar:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        return cm:model():turn_number() > 60 and model:get_elector("wh_main_emp_cult_of_sigmar"):loyalty() == 0 and model:get_elector("wh_main_emp_cult_of_sigmar"):status() == "normal"
    end)
    civil_war_sigmar:add_stage_callback(1, function(model--:EOM_MODEL
    )
        if cm:get_faction(model:empire()):is_human() then
            cm:trigger_incident(model:empire(), "eom_main_civil_war_cult_of_sigmar_1", true)
        end
        model:advance_chaos_to_mid_game()
        model:set_core_data("block_events_for_plot", true)
        model:get_elector("wh_main_emp_cult_of_sigmar"):set_hidden(true)
        model:get_elector("wh_main_emp_cult_of_sigmar"):set_loyalty(0)
        model:get_elector("wh_main_emp_cult_of_sigmar"):set_status("civil_war_emperor")



        local sigmar = model:get_elector("wh_main_emp_cult_of_sigmar")
        local wissenland = model:get_elector("wh_main_emp_wissenland")
        local stirland = model:get_elector("wh_main_emp_stirland")
        local ostland = model:get_elector("wh_main_emp_ostland")

        local x, y = sigmar:expedition_coordinates()
        cm:create_force("wh_main_emp_cult_of_sigmar", sigmar:get_army_list(), sigmar:expedition_region(), x, y, true, true, function(cqi) cm:treasury_mod("wh_main_emp_cult_of_sigmar", 20000) end)
        sigmar:respawn_at_capital(wissenland:loyalty() < 80 and (not cm:get_faction(wissenland:name()):is_dead()))
        cm:callback( function()
        cm:force_declare_war("wh_main_emp_cult_of_sigmar", model:empire(), false, false)
        end, 0.1);
        
        if wissenland:loyalty() < 80 and not cm:get_faction(wissenland:name()):is_dead() then 
            cm:force_declare_war(wissenland:name(), model:empire(), false, false)
            wissenland:set_hidden(true)
            wissenland:set_loyalty(0)
            wissenland:set_status("civil_war_enemy")
        end
        
        if stirland:loyalty() < 80 and not cm:get_faction(stirland:name()):is_dead() then 
            cm:force_declare_war(stirland:name(), model:empire(), false, false)
            stirland:set_hidden(true)
            stirland:set_loyalty(0)
            stirland:set_status("civil_war_enemy")
        end
        
        if ostland:loyalty() < 80 and not cm:get_faction(ostland:name()):is_dead() then 
            cm:force_declare_war(ostland:name(), model:empire(), false, false)
            ostland:set_hidden(true)
            ostland:set_loyalty(0)
            ostland:set_status("civil_war_enemy")
        end
        civil_war_loyalists(45)
    end)

    civil_war_sigmar:add_stage_trigger(2, function(model--:EOM_MODEL
    )
        
        local nuln_owner = cm:get_region("wh_main_wissenland_nuln"):owning_faction():name()
        local nuln_held = (nuln_owner == model:empire()) or (nuln_owner == "wh_main_emp_wissenland" and model:get_elector("wh_main_emp_wissenland"):status() ~= "civil_war_enemy")
        return cm:get_faction("wh_main_emp_cult_of_sigmar"):is_dead() and nuln_held
    end)

    civil_war_sigmar:add_stage_callback(2, function(model--:EOM_MODEL
    )
        if cm:get_faction(model:empire()):is_human() then
            cm:trigger_incident(model:empire(), "eom_main_civil_war_cult_of_sigmar_2", true)
        end
        model:get_story_chain("civil_war_sigmar"):finish() 
        if (not cm:get_faction("wh_main_emp_wissenland"):is_dead()) and model:get_elector("wh_main_emp_wissenland"):status() == "civil_war_enemy" then
            cm:force_confederation(model:empire(), "wh_main_emp_wissenland")
            model:elector_fallen("wh_main_emp_wissenland", false)
        end
        if (not cm:get_faction("wh_main_emp_stirland"):is_dead()) and model:get_elector("wh_main_emp_stirland"):status() == "civil_war_enemy" then
            eom:get_elector("wh_main_emp_stirland"):set_status("open_rebellion")
            eom:get_elector("wh_main_emp_stirland"):set_hidden(false)
        end
        if (not cm:get_faction("wh_main_emp_ostland"):is_dead()) and model:get_elector("wh_main_emp_ostland"):status() == "civil_war_enemy" then
            eom:get_elector("wh_main_emp_ostland"):set_status("open_rebellion")
            eom:get_elector("wh_main_emp_ostland"):set_hidden(false)
        end
        model:change_all_loyalties(30)
        model:advance_chaos_to_late_game()
    end)

end


local function eom_ulric_civil_war()
    local civil_war_ulric = eom:new_story_chain("civil_war_ulric")
    civil_war_ulric:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        return cm:model():turn_number() > 50 and model:get_elector("wh_main_emp_cult_of_ulric"):loyalty() == 0 and model:get_elector("wh_main_emp_cult_of_ulric"):status() == "normal"
    end)
    civil_war_ulric:add_stage_callback(1, function(model--:EOM_MODEL
    )
        if cm:get_faction(model:empire()):is_human() then
            cm:trigger_incident(model:empire(), "eom_main_civil_war_cult_of_ulric_1", true)
        end
        model:set_core_data("block_events_for_plot", true)
        model:get_elector("wh_main_emp_cult_of_ulric"):set_hidden(true)
        model:get_elector("wh_main_emp_cult_of_ulric"):set_loyalty(0)
        model:get_elector("wh_main_emp_cult_of_ulric"):set_status("civil_war_emperor")
        model:advance_chaos_to_mid_game()


        local ulric = model:get_elector("wh_main_emp_cult_of_ulric")
        local middenland = model:get_elector("wh_main_emp_middenland")
        local nordland = model:get_elector("wh_main_emp_nordland")
        local hochland = model:get_elector("wh_main_emp_hochland")

        local x, y = ulric:expedition_coordinates()
        cm:create_force("wh_main_emp_cult_of_ulric", ulric:get_army_list(), ulric:expedition_region(), x, y, true, true, function(cqi) cm:treasury_mod("wh_main_emp_cult_of_sigmar", 20000) end)
        ulric:respawn_at_capital(middenland:loyalty() < 80 and (not cm:get_faction(middenland:name()):is_dead()))
        cm:callback( function()
        cm:force_declare_war("wh_main_emp_cult_of_ulric", model:empire(), false, false)
        end, 0.1);
        
        if middenland:loyalty() < 80 and not cm:get_faction(middenland:name()):is_dead() then 
            cm:force_declare_war(middenland:name(), model:empire(), false, false)
            middenland:set_hidden(true)
            middenland:set_loyalty(0)
            middenland:set_status("civil_war_enemy")
        end
        
        if nordland:loyalty() < 80 and not cm:get_faction(nordland:name()):is_dead() then 
            cm:force_declare_war(nordland:name(), model:empire(), false, false)
            nordland:set_hidden(true)
            nordland:set_loyalty(0)
            nordland:set_status("civil_war_enemy")
        end
        
        if hochland:loyalty() < 80 and not cm:get_faction(hochland:name()):is_dead() then 
            cm:force_declare_war(hochland:name(), model:empire(), false, false)
            hochland:set_hidden(true)
            hochland:set_loyalty(0)
            hochland:set_status("civil_war_enemy")
        end
        civil_war_loyalists(45)
    end)
    civil_war_ulric:add_stage_trigger(2, function(model--:EOM_MODEL
    )
        
        local nuln_owner = cm:get_region("wh_main_middenland_middenheim"):owning_faction():name()
        local nuln_held = (nuln_owner == model:empire()) or (nuln_owner == "wh_main_emp_middenland" and model:get_elector("wh_main_emp_middenland"):status() ~= "civil_war_enemy")
        return cm:get_faction("wh_main_emp_cult_of_ulric"):is_dead() and nuln_held
    end)

    civil_war_ulric:add_stage_callback(2, function(model--:EOM_MODEL
    )
        if cm:get_faction(model:empire()):is_human() then
            cm:trigger_incident(model:empire(), "eom_main_civil_war_cult_of_ulric_2", true)
        end
        model:get_story_chain("civil_war_ulric"):finish() 
        if (not cm:get_faction("wh_main_emp_middenland"):is_dead()) and model:get_elector("wh_main_emp_middenland"):status() == "civil_war_enemy" then
            cm:force_confederation(model:empire(), "wh_main_emp_middenland")
            model:elector_fallen("wh_main_emp_middenland", false)
        end
        if (not cm:get_faction("wh_main_emp_nordland"):is_dead()) and model:get_elector("wh_main_emp_nordland"):status() == "civil_war_enemy" then
            eom:get_elector("wh_main_emp_nordland"):set_status("open_rebellion")
            eom:get_elector("wh_main_emp_nordland"):set_hidden(false)
        end
        if (not cm:get_faction("wh_main_emp_hochland"):is_dead()) and model:get_elector("wh_main_emp_hochland"):status() == "civil_war_enemy" then
            eom:get_elector("wh_main_emp_hochland"):set_status("open_rebellion")
            eom:get_elector("wh_main_emp_hochland"):set_hidden(false)
        end
        model:change_all_loyalties(30)
        model:advance_chaos_to_late_game()
    end)

end



local function eom_talabecland_civil_war()
    local civil_war_talabecland = eom:new_story_chain("civil_war_talabecland")
    civil_war_talabecland:add_stage_trigger(1, function(model--:EOM_MODEL
    )
    local loyalty_cnd =  eom:get_elector("wh_main_emp_talabecland"):loyalty() == 0
    local talabec_alive = not cm:get_faction("wh_main_emp_talabecland"):is_dead()
    local civil_war_turn = cm:model():turn_number() > 60
    return loyalty_cnd and talabec_alive and civil_war_turn
    end)
    civil_war_talabecland:add_stage_callback(1, function(model--:EOM_MODEL
    )
        if cm:get_faction("wh_main_emp_hochland"):is_dead() then
            return
        end
        if cm:get_faction(model:empire()):is_human() then
            cm:trigger_incident(model:empire(), "eom_main_civil_war_talabecland_1", true)
        end
        eom:grant_casus_belli("wh_main_emp_talabecland")
        cm:treasury_mod("wh_main_emp_talabecland", 20000)
        cm:force_declare_war("wh_main_emp_talabecland", "wh_main_emp_hochland", false, false)
    end)
    civil_war_talabecland:add_stage_trigger(2, function(model--:EOM_MODEL
    )

    return cm:get_faction("wh_main_emp_hochland"):is_dead() or cm:get_faction(eom:empire()):at_war_with(cm:get_faction("wh_main_emp_talabecland"))
    end)
    civil_war_talabecland:add_stage_callback(2, function(model--:EOM_MODEL
    )

        if cm:get_faction(model:empire()):is_human() then
            cm:trigger_incident(model:empire(), "eom_main_civil_war_talabecland_2", true)
        end
        if not cm:get_faction(eom:empire()):at_war_with(cm:get_faction("wh_main_emp_talabecland")) then 
            cm:force_declare_war("wh_main_emp_talabecland", eom:empire(), false, false)
        end
        model:set_core_data("block_events_for_plot", true)
        model:get_elector("wh_main_emp_talabecland"):set_hidden(true)
        model:get_elector("wh_main_emp_talabecland"):set_loyalty(0)
        model:get_elector("wh_main_emp_talabecland"):set_status("civil_war_emperor")
        model:set_core_data("talabecland_civil_war_turn", cm:model():turn_number() + 3)

        if model:get_elector("wh_main_emp_ostermark"):loyalty() < 50 and not cm:get_faction("wh_main_emp_ostermark"):is_dead() then 
            model:get_elector("wh_main_emp_ostermark"):set_can_revive(false)
            cm:force_confederation("wh_main_emp_talabecland", "wh_main_emp_ostermark")
        end

        if model:get_elector("wh_main_emp_stirland"):loyalty() < 50 and not cm:get_faction("wh_main_emp_stirland"):is_dead() then 
            model:get_elector("wh_main_emp_stirland"):set_can_revive(false)
            cm:force_confederation("wh_main_emp_talabecland", "wh_main_emp_stirland")
        end

        civil_war_loyalists(45)
        
    end)
    civil_war_talabecland:add_stage_trigger(3, function(model--:EOM_MODEL
    )
    local plot_turn = model:get_core_data_with_key("talabecland_civil_war_turn") --# assume plot_turn:number
    return plot_turn <= cm:model():turn_number()
    end)
    civil_war_talabecland:add_stage_callback(3, function(model--:EOM_MODEL
    )
        model:advance_chaos_to_mid_game()
        if cm:get_faction("wh_main_emp_averland"):is_dead() then
            return
        end
        if model:get_elector("wh_main_emp_averland"):loyalty() < 45 then
            cm:force_declare_war("wh_main_emp_averland", "wh_main_emp_empire", false, false)
            if cm:get_faction(model:empire()):is_human() then
                cm:trigger_incident(model:empire(), "eom_main_civil_war_talabecland_3", true)
            end
            model:get_elector("wh_main_emp_averland"):set_status("open_rebellion")
            model:get_elector("wh_main_emp_averland"):set_loyalty(0)
        end
    end)
    civil_war_talabecland:add_stage_trigger(4, function(model--:EOM_MODEL
    )
    local is_dead = cm:get_faction("wh_main_emp_talabecland"):is_dead()
    local is_wounded = cm:get_faction("wh_main_emp_talabecland"):faction_leader():is_wounded()
    local talabecland_owner = cm:get_region("wh_main_talabecland_talabheim"):owning_faction():name()
    --# assume talabecland_owner: ELECTOR_NAME
    local talabheim_owned = talabecland_owner == eom:empire() or model:get_elector(talabecland_owner):status() == "normal"
    return (is_dead or is_wounded) and talabheim_owned
    end)
    civil_war_talabecland:add_stage_callback(4, function(model--:EOM_MODEL
    )
    if cm:get_faction(model:empire()):is_human() then
        cm:trigger_incident(model:empire(), "eom_main_civil_war_talabecland_5", true)
    end

    model:get_story_chain("civil_war_talabecland"):finish() 
    if (not cm:get_faction("wh_main_emp_talabecland"):is_dead()) then
        cm:force_confederation(model:empire(), "wh_main_emp_talabecland")
        
    end
    model:elector_fallen("wh_main_emp_talabecland", false)
    model:change_all_loyalties(30)
    model:advance_chaos_to_late_game()
    model:set_core_data("block_events_for_plot", false)
    end)

end

--# assume ci_get_army_string: function(race: string, stage: number) --> string
local function eom_hochland_civil_war()
    local civil_war_hochland = eom:new_story_chain("civil_war_hochland")
    civil_war_hochland:add_stage_trigger(1, function(model--:EOM_MODEL
    )
    is_alive = not cm:get_faction("wh_main_emp_hochland"):is_dead()
    is_mad = model:get_elector("wh_main_emp_hochland"):loyalty() == 0 
    owns_brass_keep = cm:get_region("wh_main_hochland_brass_keep"):owning_faction():name() == "wh_main_emp_hochland"
    return is_alive and is_mad and owns_brass_keep
    end)
    civil_war_hochland:add_stage_callback(2, function(model--:EOM_MODEL
    )
    if cm:get_faction(model:empire()):is_human() then
        cm:trigger_incident(model:empire(), "eom_main_civil_war_hochland_1", true)
    end
    eom:advance_chaos_to_mid_game()
    cm:create_force(
        "wh_main_chs_chaos",
        ci_get_army_string("chaos", 2),
        "wh_main_hochland_brass_keep",
        cm:get_region("wh_main_hochland_brass_keep"):settlement():logical_position_x() + 1,
        cm:get_region("wh_main_hochland_brass_keep"):settlement():logical_position_y() - 1,
        true,
        true)
    cm:create_force(
        "wh_main_chs_chaos",
        ci_get_army_string("chaos", 2),
        "wh_main_hochland_brass_keep",
        cm:get_region("wh_main_hochland_brass_keep"):settlement():logical_position_x() + 1,
        cm:get_region("wh_main_hochland_brass_keep"):settlement():logical_position_y() - 1,
        true,
        true)


    end)
    civil_war_hochland:add_stage_trigger(2, function(model--:EOM_MODEL
    )
    is_dead = cm:get_faction("wh_main_emp_hochland"):is_dead()
    return is_dead
    end)
    civil_war_hochland:add_stage_callback(2, function(model--:EOM_MODEL
    )
    if cm:get_faction(model:empire()):is_human() then
        cm:trigger_incident(model:empire(), "eom_main_civil_war_hochland_2", true)
    end
    model:elector_fallen("wh_main_emp_hochland")
    model:get_story_chain("civil_war_hochland"):finish()

    end)

end

local function eom_stirland_civil_war()

    local civil_war_stirland = eom:new_story_chain("civil_war_stirland")

    civil_war_stirland:add_stage_trigger(1, function(model --:EOM_MODEL
    )
    is_alive = not cm:get_faction("wh_main_emp_stirland"):is_dead()
    is_mad = eom:get_elector("wh_main_emp_stirland"):loyalty() == 0
    not_both_cults_loyal = not (model:get_elector("wh_main_emp_cult_of_sigmar"):loyalty() == 100 and model:get_elector("wh_main_emp_cult_of_ulric"):loyalty() == 100)
    return is_alive and is_mad
    end)
    civil_war_stirland:add_stage_callback(1, function(model --:EOM_MODEL
    )
    if cm:get_faction(model:empire()):is_human() then
        cm:trigger_incident(model:empire(), "eom_main_civil_war_stirland_1", true)
    end
    model:set_core_data("civil_war_stirland_timer", cm:model():turn_number() + 2)
    model:set_core_data("block_events_for_plot", true)
    end)

    civil_war_stirland:add_stage_trigger(2, function(model --:EOM_MODEL
    )
    local progress_turn = model:get_core_data_with_key("civil_war_stirland_timer") --# assume progress_turn: number
    return progress_turn <= cm:model():turn_number()
    end)

    civil_war_stirland:add_stage_callback(2, function(model --:EOM_MODEL
    )
        local stirland = eom:get_elector("wh_main_emp_stirland")
        stirland:set_loyalty(0)
        stirland:set_status("seceded")
        stirland:set_hidden(true)
        local cult_of_sigmar_loyalty = model:get_elector("wh_main_emp_cult_of_sigmar"):loyalty()
        local cult_of_ulric_loyalty = model:get_elector("wh_main_emp_cult_of_ulric"):loyalty()
        if cult_of_sigmar_loyalty > cult_of_ulric_loyalty then
            model:set_core_data("civil_war_stirland_rebel", "wh_main_emp_cult_of_ulric")
            if cm:get_faction(model:empire()):is_human() then
                cm:trigger_incident(model:empire(), "eom_main_civil_war_stirland_2a", true)
                model:advance_chaos_to_mid_game()
            end
            model:get_elector("wh_main_emp_cult_of_ulric"):set_hidden(true)
            model:get_elector("wh_main_emp_cult_of_ulric"):set_loyalty(0)
            model:get_elector("wh_main_emp_cult_of_ulric"):set_status("civil_war_emperor")
            
    
    
            local ulric = model:get_elector("wh_main_emp_cult_of_ulric")
            local middenland = model:get_elector("wh_main_emp_middenland")
            local nordland = model:get_elector("wh_main_emp_nordland")
            local hochland = model:get_elector("wh_main_emp_hochland")
    
            local x, y = ulric:expedition_coordinates()
            cm:create_force("wh_main_emp_cult_of_ulric", ulric:get_army_list(), ulric:expedition_region(), x, y, true, true, function(cqi) cm:treasury_mod("wh_main_emp_cult_of_sigmar", 20000) end)
            ulric:respawn_at_capital(middenland:loyalty() < 80 and (not cm:get_faction(middenland:name()):is_dead()))
            cm:callback( function()
            cm:force_declare_war("wh_main_emp_cult_of_ulric", model:empire(), false, false)
            end, 0.1);
            
            if middenland:loyalty() < 80 and not cm:get_faction(middenland:name()):is_dead() then 
                cm:force_declare_war(middenland:name(), model:empire(), false, false)
                middenland:set_hidden(true)
                middenland:set_loyalty(0)
                middenland:set_status("civil_war_enemy")
            end
            
            if nordland:loyalty() < 80 and not cm:get_faction(nordland:name()):is_dead() then 
                cm:force_declare_war(nordland:name(), model:empire(), false, false)
                nordland:set_hidden(true)
                nordland:set_loyalty(0)
                nordland:set_status("civil_war_enemy")
            end
            
            if hochland:loyalty() < 80 and not cm:get_faction(hochland:name()):is_dead() then 
                cm:force_declare_war(hochland:name(), model:empire(), false, false)
                hochland:set_hidden(true)
                hochland:set_loyalty(0)
                hochland:set_status("civil_war_enemy")
            end
            civil_war_loyalists(45)

        else
            model:set_core_data("civil_war_stirland_rebel", "wh_main_emp_cult_of_sigmar")
            if cm:get_faction(model:empire()):is_human() then
                cm:trigger_incident(model:empire(), "eom_main_civil_war_stirland_2b", true)
                model:advance_chaos_to_mid_game()
            end
            model:get_elector("wh_main_emp_cult_of_sigmar"):set_hidden(true)
            model:get_elector("wh_main_emp_cult_of_sigmar"):set_loyalty(0)
            model:get_elector("wh_main_emp_cult_of_sigmar"):set_status("civil_war_emperor")
    
    
    
            local sigmar = model:get_elector("wh_main_emp_cult_of_sigmar")
            local wissenland = model:get_elector("wh_main_emp_wissenland")
            local stirland = model:get_elector("wh_main_emp_stirland")
            local ostland = model:get_elector("wh_main_emp_ostland")
    
            local x, y = sigmar:expedition_coordinates()
            cm:create_force("wh_main_emp_cult_of_sigmar", sigmar:get_army_list(), sigmar:expedition_region(), x, y, true, true, function(cqi) cm:treasury_mod("wh_main_emp_cult_of_sigmar", 20000) end)
            sigmar:respawn_at_capital(wissenland:loyalty() < 80 and (not cm:get_faction(wissenland:name()):is_dead()))
            cm:callback( function()
            cm:force_declare_war("wh_main_emp_cult_of_sigmar", model:empire(), false, false)
            end, 0.1);
            
            if wissenland:loyalty() < 80 and not cm:get_faction(wissenland:name()):is_dead() then 
                cm:force_declare_war(wissenland:name(), model:empire(), false, false)
                wissenland:set_hidden(true)
                wissenland:set_loyalty(0)
                wissenland:set_status("civil_war_enemy")
            end
            
            if stirland:loyalty() < 80 and not cm:get_faction(stirland:name()):is_dead() then 
                cm:force_declare_war(stirland:name(), model:empire(), false, false)
                stirland:set_hidden(true)
                stirland:set_loyalty(0)
                stirland:set_status("civil_war_enemy")
            end
            
            if ostland:loyalty() < 80 and not cm:get_faction(ostland:name()):is_dead() then 
                cm:force_declare_war(ostland:name(), model:empire(), false, false)
                ostland:set_hidden(true)
                ostland:set_loyalty(0)
                ostland:set_status("civil_war_enemy")
            end
            civil_war_loyalists(45)
        end
    end)



    civil_war_stirland:add_stage_trigger(3, function(model--:EOM_MODEL
    )
        if model:get_core_data_with_key("civil_war_stirland_rebel") == "wh_main_cult_of_ulric" then
            local nuln_owner = cm:get_region("wh_main_middenland_middenheim"):owning_faction():name()
            local nuln_held = (nuln_owner == model:empire()) or (nuln_owner == "wh_main_emp_middenland" and model:get_elector("wh_main_emp_middenland"):status() ~= "civil_war_enemy")
            return cm:get_faction("wh_main_emp_cult_of_ulric"):is_dead() and nuln_held
        else
            local nuln_owner = cm:get_region("wh_main_wissenland_nuln"):owning_faction():name()
            local nuln_held = (nuln_owner == model:empire()) or (nuln_owner == "wh_main_emp_wissenland" and model:get_elector("wh_main_emp_wissenland"):status() ~= "civil_war_enemy")
            return cm:get_faction("wh_main_emp_cult_of_sigmar"):is_dead() and nuln_held
        end
    end)

    civil_war_stirland:add_stage_callback(3, function(model--:EOM_MODEL
    )
        model:get_story_chain("civil_war_stirland"):finish()
        model:set_core_data("block_events_for_plot", false)
        model:grant_casus_belli("wh_main_emp_stirland")
        if model:get_core_data_with_key("civil_war_stirland_rebel") == "wh_main_cult_of_ulric" then
            if cm:get_faction(model:empire()):is_human() then
                cm:trigger_incident(model:empire(), "eom_main_civil_war_stirland_3a", true)
            end
            model:get_story_chain("civil_war_ulric"):finish() 
            if (not cm:get_faction("wh_main_emp_middenland"):is_dead()) and model:get_elector("wh_main_emp_middenland"):status() == "civil_war_enemy" then
                cm:force_confederation(model:empire(), "wh_main_emp_middenland")
                model:elector_fallen("wh_main_emp_middenland", false)
            end
            if (not cm:get_faction("wh_main_emp_nordland"):is_dead()) and model:get_elector("wh_main_emp_nordland"):status() == "civil_war_enemy" then
                eom:get_elector("wh_main_emp_nordland"):set_status("open_rebellion")
                eom:get_elector("wh_main_emp_nordland"):set_hidden(false)
            end
            if (not cm:get_faction("wh_main_emp_hochland"):is_dead()) and model:get_elector("wh_main_emp_hochland"):status() == "civil_war_enemy" then
                eom:get_elector("wh_main_emp_hochland"):set_status("open_rebellion")
                eom:get_elector("wh_main_emp_hochland"):set_hidden(false)
            end
            model:change_all_loyalties(30)
            model:advance_chaos_to_late_game()
        else
            if cm:get_faction(model:empire()):is_human() then
                cm:trigger_incident(model:empire(), "eom_main_civil_war_stirland_3b", true)
            end
            model:get_story_chain("civil_war_sigmar"):finish() 
            if (not cm:get_faction("wh_main_emp_wissenland"):is_dead()) and model:get_elector("wh_main_emp_wissenland"):status() == "civil_war_enemy" then
                cm:force_confederation(model:empire(), "wh_main_emp_wissenland")
                model:elector_fallen("wh_main_emp_wissenland", false)
            end
            if (not cm:get_faction("wh_main_emp_stirland"):is_dead()) and model:get_elector("wh_main_emp_stirland"):status() == "civil_war_enemy" then
                eom:get_elector("wh_main_emp_stirland"):set_status("open_rebellion")
                eom:get_elector("wh_main_emp_stirland"):set_hidden(false)
            end
            if (not cm:get_faction("wh_main_emp_ostland"):is_dead()) and model:get_elector("wh_main_emp_ostland"):status() == "civil_war_enemy" then
                eom:get_elector("wh_main_emp_ostland"):set_status("open_rebellion")
                eom:get_elector("wh_main_emp_ostland"):set_hidden(false)
            end
            model:change_all_loyalties(30)
            model:advance_chaos_to_late_game()
        end
    end)


end





local function eom_empire_add_civil_wars()
    eom:log("Starting", "export_helpers__eom_civil_wars")
    eom_vlad_civil_war()
    eom_sigmar_civil_war()
    eom_ulric_civil_war()
    eom_talabecland_civil_war()
    eom_hochland_civil_war()
    eom_stirland_civil_war()
end



events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_empire_add_civil_wars() end;
