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
    local volkmar = ll_unlock:new(eom:empire(), "2140784136", "names_name_2147343849", "FactionTurnStart", function(context) return eom:get_elector("wh_main_emp_cult_of_sigmar"):is_loyal() end )
    volkmar:start()
end



events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_volkmar_unlock() end;