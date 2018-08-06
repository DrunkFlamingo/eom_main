eom = _G.eom

core:add_listener(
    "EOMREGION_TRADING",
    "UITriggerScriptEvent",
    function(context)
        return context:trigger():starts_with("REGION_TRADING")
    end,
    function(context)
        eom:log("REGION TRADING OCCURED")
        local SEPARATOR = "|";
        local tableString = string.sub(context:trigger(), string.len("REGION_TRADING") + string.len(SEPARATOR) + 1)
        local tableFunc = loadstring(tableString) --# assume tableFunc: (function() --> map<string, string>)
        local purchaseTable = tableFunc();
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
        } --:map<string, string>
        local purchase = purchaseTable["purchase"] == "true";
        local selectedRegion = purchaseTable["selectedRegion"];
        local selectedFaction = purchaseTable["selectedFaction"];
        local targetFaction = purchaseTable["targetFaction"];
        eom:log("The traded region is ["..selectedRegion.."]")
        eom:log("The faction traded with is ["..selectedFaction.."], the trading faction is ["..targetFaction.."] ")

        if purchase then
            --we dont care about purchases
        end
        if purchase == false then
            if not not region_to_elector[selectedRegion] then
                --# assume selectedFaction: ELECTOR_NAME
                if selectedFaction == region_to_elector[selectedRegion] and targetFaction == "wh_main_emp_empire" then
                    eom:log("the region is in the empire and is being traded to its rightful elector!")
                    eom:get_elector(selectedFaction):change_loyalty(10)
                    cm:show_message_event(
                        "wh_main_emp_empire",
                        "event_feed_strings_text_land_returned_title",
                        "event_feed_strings_text_land_returned_subtitle",
                        "event_feed_strings_text_land_returned_detail",
                        true, 
                        591)
                end
            end
        end
    end,
    true
);