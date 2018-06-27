cm = get_cm()
events = get_events()
eom = _G.eom
if not eom then
    script_error("EOM IS NOT FOUND!")
end


core:add_listener(
    "EOMTurnStart",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == eom:empire()
    end,
    function(context)
        if not eom:get_core_data_with_key("chaos_defeated") == true then
            local midgame_turn = eom:get_core_data_with_key("midgame_chaos_trigger_turn") --# assume midgame_turn: number
            local lategame_turn = eom:get_core_data_with_key("lategame_chaos_trigger_turn") --# assume lategame_turn: number
            if midgame_turn <= cm:model():turn_number() then 
                eom:advance_chaos_to_mid_game()
                eom:set_core_data("midgame_chaos_trigger_turn", 999) 
                return
            end
            if lategame_turn <= cm:model():turn_number() then 
                eom:advance_chaos_to_late_game()
                eom:set_core_data("lategame_chaos_trigger_turn", 999) 
                return
            end
        end
    end,
    true)
	core:add_listener(
		"EOM_Chaos_Defeated_Monitor",
		"FactionTurnStart",
		function(context) return context:faction():is_human() and eom:get_core_data_with_key("chaos_end_game_has_started")  == true end,
		function()
			local num_hordes = cm:get_faction("wh_main_chs_chaos"):military_force_list():num_items() + cm:get_faction("wh_dlc03_bst_beastmen_chaos"):military_force_list():num_items(); --TODO: which factions do we check here? all of them?
			
			if num_hordes < 1 then
                eom:set_core_data("chaos_defeated", true)
            end
		end,
        true);

    if not eom:get_core_data_with_key("chaos_end_game_has_started") == true then
        core:add_listener(
            "EOM_Chaos_Started_Monitor",
            "FactionTurnStart",
            function(context) return context:faction():is_human() and cm:model():turn_number() > 5 and (not cm:get_faction("wh_main_chs_chaos"):is_dead()) end,
            function()
                eom:set_core_data("chaos_end_game_has_started", true)
            end,
            false);
    end