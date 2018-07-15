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
        local other_civil_war_condition = model:get_core_data_with_key("civil_war_occured") == true
        return (after_chaos_condition or before_chaos_condition or other_civil_war_condition) and not cm:get_faction("wh_main_vmp_schwartzhafen"):is_dead()
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
    model:set_core_data("midgame_chaos_trigger_turn", cm:model():turn_number() + 11)
    local i = 1
    for name, elector in pairs(model:electors()) do
        if elector:status() == "normal" and (elector:loyalty() > 39 or elector:is_cult()) then
            if elector:is_cult() and cm:get_faction(name):is_dead() then 
                elector:respawn_at_capital(true)
            end
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
        if not eom:get_core_data_with_key("chaos_defeated") then
            model:advance_chaos_to_late_game()
        end
    end)



end
--v function(elector: EOM_ELECTOR)
local function start_civil_war(elector)
    local success_callback = function()

    end

    local mm = mission_manager:new(eom:empire(), "eom_"..elector:name().."_civil_war_mission")


end




local function eom_generic_civil_wars()
    local civil_war_standard = eom:new_story_chain("civil_war_standard")
    civil_war_standard:add_stage_trigger(1, function(model --: EOM_MODEL
    )
    local turn = cm:model():turn_number()
    if turn > 50 then
        for name, elector in pairs(eom:electors()) do
            if name ~= "wh_main_vmp_schwartzhafen" and not elector:is_cult() then
                if elector:loyalty() == 0 then
                    elector:set_status("civil_war_emperor")
                    return true
                end
            end
        end
        return false
    else 
        return false
    end
    end)
    civil_war_standard:add_stage_callback(1, function(model--:EOM_MODEL
    )
    for name, elector in pairs(eom:electors()) do
        if elector:status() == "normal" then


        end
    end

    end)

end






local function eom_empire_add_civil_wars()
    eom:log("Starting", "export_helpers__eom_civil_wars")
    eom_vlad_civil_war()
    eom_generic_civil_wars()
end



events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_empire_add_civil_wars() end;