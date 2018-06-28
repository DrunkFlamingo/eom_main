cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end


--v function(elector:EOM_ELECTOR) --> boolean
local function is_elector_valid_for_revive(elector)
    local is_dead = cm:get_faction(elector:name()):is_dead()
    local can_revive = elector:can_revive()
    local is_not_cult = not elector:is_cult()
    local status_normal = (elector:status() == "normal")

    return is_dead and can_revive and is_not_cult and status_normal
end


--v function(elector: EOM_ELECTOR, show_no_event: boolean?)
local function trigger_coup_for_elector(elector, show_no_event)
    EOMLOG("triggering Coup D'etat spawn for elector ["..elector:name().."] ")
    local old_owner = tostring(cm:get_region(elector:capital()):owning_faction():name());
    cm:create_force_with_general(
        elector:name(),
        elector:get_army_list(),
        elector:capital(),
        cm:get_region(elector:capital()):settlement():logical_position_x() + 1,
        cm:get_region(elector:capital()):settlement():logical_position_y() + 1,
        "general",
        elector:leader_subtype(),
        elector:leader_forename(),
        "",
        elector:leader_surname(), 
        "",
        true,
        function(cqi)
            local dx = cm:get_character_by_cqi(cqi):display_position_x()
            local dy = cm:get_character_by_cqi(cqi):display_position_y()
            if not show_no_event then
                cm:show_message_event_located(
                    EOM_GLOBAL_EMPIRE_FACTION,
                    "event_feed_strings_text_coup_detat_title",
                    "event_feed_strings_text_coup_detat_"..elector:name().."_subtitle",
                    "event_feed_strings_text_coup_detat_"..elector:name().."_detail",
                    dx,
                    dy,
                    true,
                    591)
            end
        end)
    cm:callback( function()
        cm:transfer_region_to_faction(elector:capital(), elector:name())
        cm:force_declare_war(elector:name(), old_owner, false, false)
        cm:treasury_mod(elector:name(), 5000)

    end, 0.2)
    elector:set_can_revive(false)
end
    






--v function(elector: EOM_ELECTOR, show_no_event: boolean?)
local function trigger_expedition_for_elector(elector, show_no_event)
    EOMLOG("triggering expedition spawn for elector ["..elector:name().."] ")
    local x, y = elector:expedition_coordinates();
    local old_owner = tostring(cm:get_region(elector:capital()):owning_faction():name());
    cm:create_force_with_general(
        elector:name(),
        elector:get_army_list(),
        elector:expedition_region(),
        x,
        y,
        "general",
        elector:leader_subtype(),
        elector:leader_forename(),
        "",
        elector:leader_surname(), 
        "",
        true,
        function(cqi)
            if not show_no_event then
                local dx = cm:get_character_by_cqi(cqi):display_position_x()
                local dy = cm:get_character_by_cqi(cqi):display_position_y()
                cm:show_message_event_located(
                    EOM_GLOBAL_EMPIRE_FACTION,
                    "event_feed_strings_text_expedition_title",
                    "event_feed_strings_text_expedition_"..elector:name().."_subtitle",
                    "event_feed_strings_text_expedition_"..elector:name().."_detail",
                    dx,
                    dy,
                    true,
                    591)
            end
        end)
    cm:treasury_mod(elector:name(), 10000)
    cm:force_declare_war(elector:name(), old_owner, false, false)
    elector:set_can_revive(false)
end

--v function(is_ai: boolean)
local function eom_coup_detat_check(is_ai)
    for name, elector in pairs(eom:electors()) do
        if (not  cm:get_region(elector:capital()):owning_faction():is_null_interface() ) and (not cm:get_region(elector:capital()):is_abandoned() )  then
            if cm:get_region(elector:capital()):owning_faction():subculture() == "wh_main_sc_emp_empire" then
                if is_elector_valid_for_revive(elector) then
                    trigger_coup_for_elector(elector, is_ai)
                end
            end
        end
    end
end
--v function(is_ai: boolean)
local function eom_expedition_check(is_ai)
    for name, elector in pairs(eom:electors()) do
        if (cm:get_region(elector:capital()):is_abandoned()) or (  cm:get_region(elector:capital()):owning_faction():subculture() ~= "wh_main_sc_emp_empire" ) then
            trigger_expedition_for_elector(elector, is_ai)
        end
    end
end





local function eom_add_revive_listener()
    core:add_listener(
        "EOMTurnStartRevives",
        "FactionTurnStart",
        function(context)
            local faction = context:faction()
            return faction:name() == eom:empire()
        end,
        function(context)
            if cm:get_faction(eom:empire()):is_human() then
                eom_coup_detat_check(false)
                eom_expedition_check(false)
            else
                eom_coup_detat_check(true)
                eom_expedition_check(true)
            end
        end,
        true);
end







events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_add_revive_listener() end;  