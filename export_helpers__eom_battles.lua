cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end
core:add_listener(
    "EOMVampiresDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_vmp_vampire_counts",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(8)
        eom:get_elector("wh_main_emp_stirland"):change_loyalty(4)
    end,
    true);

core:add_listener(
    "EOMVampiresDefeatedYou",
    "DefeatAgainstSubcultureKey_wh_main_sc_vmp_vampire_counts",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(-5)
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_stirland"):change_loyalty(-5)
    end,
    true);
    


core:add_listener(
    "EOMBeastmenDefeated",
    "VictoryAgainstSubcultureKey_wh_dlc03_sc_bst_beastmen",
    true,
    function(context)
        eom:get_elector("wh_main_emp_hochland"):change_loyalty(12)
        eom:get_elector("wh_main_emp_middenland"):change_loyalty(8)
    end,
    true);

core:add_listener(
    "EOMBeastmenDefeatedYou",
    "DefeatAgainstSubcultureKey_wh_dlc03_sc_bst_beastmen",
    true,
    function(context)
        eom:get_elector("wh_main_emp_hochland"):change_loyalty(-15)
        eom:get_elector("wh_main_emp_middenland"):change_loyalty(-10)
    end,
    true)
    



core:add_listener(
    "EOMNorscaDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_nor_norsca",
    true,
    function(context)
        eom:get_elector("wh_main_emp_ostland"):change_loyalty(8)
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(4)
        eom:get_elector("wh_main_emp_nordland"):change_loyalty(8)
        eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(4)
    end,
    true)

core:add_listener(
    "EOMNorscaDefeatedYou",
    "VictoryAgainstSubcultureKey_wh_main_sc_nor_norsca",
    true,
    function(context)
        eom:get_elector("wh_main_emp_ostland"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(-5)
        eom:get_elector("wh_main_emp_nordland"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-5)
    end,
    true)

core:add_listener(
    "EOMBretonniaDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_brt_bretonnia",
    true,
    function(context)
        eom:get_elector("wh_main_emp_marienburg"):change_loyalty(8)
    end,
    true)

core:add_listener(
    "EOMKislevDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_ksl_kislev",
    true,
    function(context)
        eom:get_elector("wh_main_emp_ostland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_ostermark"):change_loyalty(-4)
    end,
    true)

core:add_listener(
    "EOMGreenSkinsDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_grn_greenskins",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(8)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(8)
    end,
    true)

core:add_listener(
    "EOMGreenSkinsDefeatedYou",
    "VictoryAgainstSubcultureKey_wh_main_sc_grn_greenskins",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(-5)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(-10)
    end,
    true)
core:add_listener(
    "EOMGreenSkinsDefeated2",
    "VictoryAgainstSubcultureKey_wh_main_sc_grn_savage_orcs",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(8)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(4)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(8)
    end,
    true)

core:add_listener(
    "EOMGreenSkinsDefeatedYou2",
    "VictoryAgainstSubcultureKey_wh_main_sc_grn_savage_orcs",
    true,
    function(context)
        eom:get_elector("wh_main_emp_averland"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_wissenland"):change_loyalty(-5)
        eom:get_elector("wh_main_emp_sylvania"):change_loyalty(-10)
    end,
    true)

core:add_listener(
    "EOMChaosDefeated",
    "VictoryAgainstSubcultureKey_wh_main_sc_chs_chaos",
    true,
    function(context)
        eom:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(8)
        eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(8)
        eom:get_elector("wh_main_emp_talabecland"):change_loyalty(8)
    end,
    true)

core:add_listener(
    "EOMChaosDefeatedYou",
    "VictoryAgainstSubcultureKey_wh_main_sc_chs_chaos",
    true,
    function(context)
        eom:get_elector("wh_main_emp_cult_of_sigmar"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_cult_of_ulric"):change_loyalty(-10)
        eom:get_elector("wh_main_emp_talabecland"):change_loyalty(-10)
    end,
    true)