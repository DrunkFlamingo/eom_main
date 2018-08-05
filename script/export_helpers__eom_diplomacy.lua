cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end

--v function(other_party: CA_FACTION, context: WHATEVER)
local function eom_positive_diplomacy(other_party, context)
    if context:is_trade_agreement() then
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(2)
    end

    if other_party:subculture() == "wh_main_sc_dwf_dwarfs" then
        eom:get_elector("wh_main_emp_averland"):change_loyalty(2)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(2)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(2)
    end
    if other_party:subculture() == "wh2_main_sc_hef_high_elves" then
        eom:get_elector("wh_main_emp_nordland"):change_loyalty(2)
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(2)
    end
    if other_party:subculture() ==  "wh_main_sc_ksl_kislev" then
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(4)
    end
end


--v function(other_party: CA_FACTION, context: WHATEVER)
local function eom_negative_diplomacy(other_party, context)
    if context:was_trade_agreement() then
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(-2)
    end

    if other_party:subculture() == "wh_main_sc_dwf_dwarfs" then
        eom:get_elector("wh_main_emp_averland"):change_loyalty(-2)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(-2)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(-2)
    end
    if other_party:subculture() == "wh2_main_sc_hef_high_elves" then
        eom:get_elector("wh_main_emp_nordland"):change_loyalty(-2)
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(-2)
    end
    if other_party:subculture() ==  "wh_main_sc_ksl_kislev" then
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(-2)
    end

    if context:is_war() then
        if other_party:subculture() == "wh_dlc03_sc_bst_beastmen" then
            eom:get_elector("wh_main_emp_hochland"):change_loyalty(3)
        end
        if other_party:subculture() == "wh2_main_sc_def_dark_elves" then
            eom:get_elector("wh_main_emp_nordland"):change_loyalty(2)
            eom:get_elector("wh_main_emp_marienburg"):change_loyalty(2)
        end
        if other_party:subculture() == "wh2_main_sc_skv_skaven" then
            eom:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(2)
            eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(2)
        end
    end

end





core:add_listener(
    "EOMDiplomaticEventsNegative",
    "NegativeDiplomaticEvent",
    function(context)
        return context:recipient():name() == eom:empire() or context:proposer():name() == eom:empire()
    end,
    function(context)
        if context:recipient():name() == eom:empire() then
            eom_negative_diplomacy(context:proposer(), context)
        elseif context:proposer():name() == eom:empire() then
            eom_negative_diplomacy(context:recipient(), context)
        end
    end,
    true)


core:add_listener(
    "EOMDiplomaticEventsNegative",
    "PositiveDiplomaticEvent",
    function(context)
        return context:recipient():name() == eom:empire() or context:proposer():name() == eom:empire()
    end,
    function(context)
        if context:recipient():name() == eom:empire() then
            eom_positive_diplomacy(context:proposer(), context)
        elseif context:proposer():name() == eom:empire() then
            eom_positive_diplomacy(context:recipient(), context)
        end
    end,
    true)