cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end


core:add_listener(
    "UI_FACTION_TURN_START",
    "FactionTurnStart",
    true,
    function(context)
        if context:faction():name() == eom:empire() and context:faction():is_human() then
            eom:view():set_button_visible(true)
        elseif faction:is_human() then
            eom:view():set_button_visible(false)
        end
    end,
    true)