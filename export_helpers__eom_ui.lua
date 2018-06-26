cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end

if not Util then
    script_error("UIMF IS MISSING")
end

out("EOM UI IS ACTIVE")

core:add_listener(
    "UI_FACTION_TURN_START",
    "FactionTurnStart",
    true,
    function(context)
        if context:faction():name() == eom:empire() and context:faction():is_human() then
            local button = eom:view():get_button()
            button:SetVisible(true)
        elseif context:faction():is_human() then
            local button = eom:view():get_button()
            button:SetVisible(false)
        end
    end,
    true)