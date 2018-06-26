cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end

core:add_listener(
    "EOMUnjustWar",
    "NegativeDiplomaticEvent",
    function(context)
        return context:is_war() and context:proposer():name() == eom:empire() and eom:has_elector(context:recipient():name())
    end,
    function(context)
        eom:check_unjust_war(context:recipient():name())
    end,
    true)

core:add_listener(
    "AggressiveExpansionCasusBelli",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == eom:empire()
    end,
    function(context)
        eom:log("Entered")
        for name, elector in pairs(eom:electors()) do
            if cm:get_faction(name):region_list():num_items() > (elector:base_regions() + 1) then
                if not eom:has_casus_belli_against(name) then
                    eom:grant_casus_belli(name)
                    
                    if cm:get_faction(eom:empire()):is_human() then
                        cm:show_message_event(
                            eom:empire(),
                            "event_feed_strings_text_casus_belli_earned_title",
                            "event_feed_strings_text_casus_belli_unjust_occupation",
                            "event_feed_strings_text_casus_belli_"..name.."_earned_detail",
                            true,
                            591)
                    end
                    break
                end
            end
        end
    end,
    true)