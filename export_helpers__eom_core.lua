cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
    return
end
core:add_listener(
    "EOMTurnStart",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == "wh_main_emp_empire"
    end,
    function(context)
        eom:event_and_plot_check()
        eom:elector_diplomacy()
        eom:elector_personalities()
    end,
    true);
