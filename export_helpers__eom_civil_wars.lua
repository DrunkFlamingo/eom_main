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
        model:set_core_data("midgame_chaos_trigger_turn", cm:model():turn_number() + 1)
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
        local elector_list = model:elector_list()
        for name, elector in pairs(model:electors()) do
            if (elector:status() == "normal") and elector:loyalty() > 45 and (not cm:get_faction(name):is_dead()) then
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
        end
        if (not cm:get_faction("wh_main_emp_ostland"):is_dead()) and model:get_elector("wh_main_emp_ostland"):status() == "civil_war_enemy" then
            eom:get_elector("wh_main_emp_ostland"):set_status("open_rebellion")
        end
        model:change_all_loyalties(30)
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
        model:set_core_data("midgame_chaos_trigger_turn", cm:model():turn_number() + 1)
        model:set_core_data("block_events_for_plot", true)
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
        local elector_list = model:elector_list()
        for name, elector in pairs(model:electors()) do
            if (elector:status() == "normal") and elector:loyalty() > 45 and (not cm:get_faction(name):is_dead()) then
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
        end
        if (not cm:get_faction("wh_main_emp_hochland"):is_dead()) and model:get_elector("wh_main_emp_hochland"):status() == "civil_war_enemy" then
            eom:get_elector("wh_main_emp_hochland"):set_status("open_rebellion")
        end
        model:change_all_loyalties(30)
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
    civil_war_talabecland:add_stage_trigger(1, function(model--:EOM_MODEL
    )

    return cm:get_faction("wh_main_emp_hochland"):is_dead() or cm:get_faction(eom:empire()):at_war_with(cm:get_faction("wh_main_emp_talabecland"))
    end)


end


local function eom_hochland_civil_war()


end

local function eom_stirland_civil_war()


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
