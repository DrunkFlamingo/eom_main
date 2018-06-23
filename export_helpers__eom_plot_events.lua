cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
    return
end



function eom_plot_events()

local reikland_rebellion = eom:new_story_chain("reikland_rebellion")
reikland_rebellion:add_stage_trigger(1, function(model--:EOM_MODEL
)
    return true 
end)
reikland_rebellion:add_stage_trigger(2, function(model--:EOM_MODEL
)
    return cm:get_faction("wh_main_emp_empire_separatists"):is_dead()
end)



reikland_rebellion:add_stage_callback(2, function(model--:EOM_MODEL
)
    model:change_all_loyalties(5)
    cm:trigger_incident(model:empire(), "eom_reikland_rebellion_1", true)
    model:get_story_chain("reikland_rebellion"):finish()
    model:set_core_data("block_events_for_plot", false)
end)

end



events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_plot_events() end;