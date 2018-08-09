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
    local is_dead_turns = elector:turns_dead() > 3

    return is_dead and can_revive and is_not_cult and status_normal and is_dead_turns
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
            if is_elector_valid_for_revive(elector) then
                trigger_expedition_for_elector(elector, is_ai)
            end
        end
    end
end


--v function()
local function dwarf_province_refund_check()

    local region_to_elector = {
        ["wh_main_ostland_castle_von_rauken"] = "wh_main_emp_ostland",
        ["wh_main_ostland_norden"] = "wh_main_emp_ostland",
        ["wh_main_ostland_wolfenburg"] = "wh_main_emp_ostland",
        ["wh_main_stirland_the_moot"] = "wh_main_emp_stirland",
        ["wh_main_stirland_wurtbad"] = "wh_main_emp_stirland",
        ["wh_main_talabecland_kemperbad"] = "wh_main_emp_talabecland",
        ["wh_main_wissenland_nuln"] = "wh_main_emp_wissenland",
        ["wh_main_wissenland_pfeildorf"] = "wh_main_emp_wissenland",
        ["wh_main_wissenland_wissenburg"] = "wh_main_emp_wissenland",
        ["wh_main_hochland_brass_keep"] = "wh_main_emp_hochland",
        ["wh_main_hochland_hergig"] = "wh_main_emp_hochland",
        ["wh_main_middenland_carroburg"] = "wh_main_emp_middenland",
        ["wh_main_middenland_middenheim"] = "wh_main_emp_middenland",
        ["wh_main_middenland_weismund"] = "wh_main_emp_middenland",
        ["wh_main_nordland_dietershafen"] = "wh_main_emp_nordland",
        ["wh_main_nordland_salzenmund"] = "wh_main_emp_nordland",
        ["wh_main_talabecland_talabheim"] = "wh_main_emp_talabecland",
        ["wh_main_averland_averheim"] = "wh_main_emp_averland",
        ["wh_main_averland_grenzstadt"] = "wh_main_emp_averland",
        ["wh_main_ostermark_bechafen"] = "wh_main_emp_ostermark",
        ["wh_main_ostermark_essen"] = "wh_main_emp_ostermark",
        ["wh_main_the_wasteland_gorssel"] = "wh_main_emp_marienburg",
        ["wh_main_the_wasteland_marienburg"] = "wh_main_emp_marienburg"
    }--:map<string, ELECTOR_NAME>
    eom:log("Checking dwarf owned empire settlements!")
    for region, faction in pairs(region_to_elector) do
        if cm:get_region(region):owning_faction():subculture() == "wh_main_sc_dwf_dwarfs" and (not cm:get_region(region):owning_faction():is_human()) then
            eom:log(" region ["..region.."] owned by the dwarfs!")
            local elector = eom:get_elector(faction)
            local owner = cm:get_region(region):owning_faction()
            if cm:get_faction(faction):is_dead() and elector:status() == "normal" then
                eom:log("The elector is dead, the dwarfs are reviving them!")
                if not cm:get_saved_value("Spawned"..faction..cm:model():turn_number()) == true then
                    cm:set_saved_value("Spawned"..faction..cm:model():turn_number(), true)
                    cm:create_force_with_general(
                        elector:name(),
                        elector:get_army_list(),
                        region,
                        cm:get_region(region):settlement():logical_position_x() + 2,
                        cm:get_region(region):settlement():logical_position_y() - 1,
                        "general",
                        elector:leader_subtype(),
                        elector:leader_forename(),
                        "",
                        elector:leader_surname(), 
                        "",
                        true,
                        function(cqi)
                            
                        end)
                end
                cm:callback( function()
                    cm:transfer_region_to_faction(region, elector:name())
                    cm:treasury_mod(elector:name(), 5000)
                end, 0.2)

            elseif cm:get_faction(faction):at_war_with(owner) then
                if not cm:get_faction(eom:empire()):at_war_with(owner) then
                    eom:log("the elector is at war with the dwarfs, but the Empire is not. This elector will capitulate!")
                    cm:force_make_peace(owner:name(), faction)
                    cm:transfer_region_to_faction(region, faction)
                    cm:treasury_mod(owner:name(), 4000)
                end

            else
                eom:log("These factions are at peace, giving the region back to its elector")
                cm:transfer_region_to_faction(region, faction)
                cm:treasury_mod(owner:name(), 4000)
            end
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
                dwarf_province_refund_check()
            else
                eom_coup_detat_check(true)
                eom_expedition_check(true)
            end
        end,
        true);
end







events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_add_revive_listener() end;  