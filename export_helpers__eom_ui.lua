cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end

core:add_listener(
    "EOM_UI_CREATION",
    "EomUiCreated",
    true,
    function(context)
        eom:add_view(eom_view.new())
        eom:view():add_model(eom)
        eom:view():set_button_parent()
        local button = eom:view():get_button()
        button:SetVisible(true)
    end,
false)

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