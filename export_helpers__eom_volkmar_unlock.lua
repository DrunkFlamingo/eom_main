cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end

local function eom_volkmar_unlock()

    if cm:get_saved_value("2140784136_unlocked") then
		eom:log("volkmar already unlocked!")
		return;
	end;
	
    eom:log("removing the vanilla volkmar listener")
    core:remove_listener("2140784136_listener")
    if eom:get_elector("wh_main_emp_cult_of_sigmar"):loyalty() == 100 then
        cm:unlock_starting_general_recruitment("2140784136", "wh_main_emp_empire");
        cm:set_saved_value("2140784136" .. "_unlocked", true);
    end

end



core:add_listener(
    "EOMVOLKMAR",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == eom:empire()
    end,
    function(context)
        if cm:get_faction(eom:empire()):is_human() then
        eom_volkmar_unlock()
        end
    end,
    true);