cm = get_cm()
events = get_events()
eom = _G.eom
if not eom then
    script_error("EOM IS NOT FOUND!")
end

--v function(list: vector<string>, findable_item: string) --> boolean
local function eom_is_religious_settlement(list, findable_item)
    for i = 1, #list do
        if list[i] == findable_item then
            return true
        end
    end

    return false
end
--v function(region_name: string, religion_name: ELECTOR_NAME)
local function eom_remove_religious_bundles_from_major_region(region_name, religion_name)
    cm:remove_effect_bundle_from_region("eom_" .. religion_name .. "_happiness_level_1", region_name)
    cm:remove_effect_bundle_from_region("eom_" .. religion_name .. "_happiness_level_2", region_name)
    cm:remove_effect_bundle_from_region("eom_" .. religion_name .. "_happiness_level_3", region_name)
    cm:remove_effect_bundle_from_region("eom_" .. religion_name .. "_happiness_level_4", region_name)
end

--v function(region_name: string, religion_name: ELECTOR_NAME)
local function eom_remove_religious_bundles_from_minor_region(region_name, religion_name)
    cm:remove_effect_bundle_from_region("eom_" .. religion_name .. "_happiness_level_1_minor", region_name)
    cm:remove_effect_bundle_from_region("eom_" .. religion_name .. "_happiness_level_2_minor", region_name)
    cm:remove_effect_bundle_from_region("eom_" .. religion_name .. "_happiness_level_3_minor", region_name)
    cm:remove_effect_bundle_from_region("eom_" .. religion_name .. "_happiness_level_4_minor", region_name)
end

--v function(context: WHATEVER)
local function eom_religion_bundles(context)
    local current_ulric_bundle = ""
    local ulric_loyalty = eom:get_elector("wh_main_emp_cult_of_ulric"):loyalty()
    if ulric_loyalty < 25 then
        current_ulric_bundle = "eom_wh_main_emp_cult_of_ulric_happiness_level_1"
    elseif ulric_loyalty >= 25 and ulric_loyalty < 50 then
        current_ulric_bundle = "eom_wh_main_emp_cult_of_ulric_happiness_level_2"
    elseif ulric_loyalty >= 50 and ulric_loyalty < 75 then
        current_ulric_bundle = "eom_wh_main_emp_cult_of_ulric_happiness_level_3"
    elseif ulric_loyalty >= 75 then
        current_ulric_bundle = "eom_wh_main_emp_cult_of_ulric_happiness_level_4"
    end
    local current_sigmar_bundle = ""
    local sigmar_loyalty = eom:get_elector("wh_main_emp_cult_of_sigmar"):loyalty()
    if sigmar_loyalty < 25 then
        current_sigmar_bundle = "eom_wh_main_emp_cult_of_sigmar_happiness_level_1"
    elseif sigmar_loyalty >= 25 and sigmar_loyalty < 50 then
        current_sigmar_bundle = "eom_wh_main_emp_cult_of_sigmar_happiness_level_2"
    elseif sigmar_loyalty >= 50 and sigmar_loyalty < 75 then
        current_sigmar_bundle = "eom_wh_main_emp_cult_of_sigmar_happiness_level_3"
    elseif sigmar_loyalty >= 75 then
        current_sigmar_bundle = "eom_wh_main_emp_cult_of_sigmar_happiness_level_4"
    end

    local empire = context:faction() --:CA_FACTION
    local empire_region_list = empire:region_list()
    for i = 0, empire_region_list:num_items() - 1 do
        local current = empire_region_list:item_at(i)
        if current:owning_faction():name() == eom:empire() then
            if current:is_province_capital()  then
                if eom_is_religious_settlement(eom:get_elector("wh_main_emp_cult_of_sigmar"):home_regions(), current:name()) then
                    eom_remove_religious_bundles_from_major_region(current:name(), "wh_main_emp_cult_of_sigmar")
                    cm:apply_effect_bundle_to_region(current_sigmar_bundle, current:name(), 0)
                elseif eom_is_religious_settlement(eom:get_elector("wh_main_emp_cult_of_ulric"):home_regions(), current:name()) then
                    eom_remove_religious_bundles_from_major_region(current:name(), "wh_main_emp_cult_of_ulric")
                    cm:apply_effect_bundle_to_region(current_ulric_bundle, current:name(), 0)
                end
            else
                if eom_is_religious_settlement(eom:get_elector("wh_main_emp_cult_of_sigmar"):home_regions(), current:name()) then
                    eom_remove_religious_bundles_from_minor_region(current:name(), "wh_main_emp_cult_of_sigmar")
                    cm:apply_effect_bundle_to_region(current_sigmar_bundle.."_minor", current:name(), 0)
                elseif eom_is_religious_settlement(eom:get_elector("wh_main_emp_cult_of_ulric"):home_regions(), current:name()) then
                    eom_remove_religious_bundles_from_minor_region(current:name(), "wh_main_emp_cult_of_ulric")
                    cm:apply_effect_bundle_to_region(current_ulric_bundle.."_minor", current:name(), 0)
                end
            end
        end
    end
end

core:add_listener(
    "EomCultHappiness",
    "FactionTurnStart",
    function(context)
        return context:faction():name() == eom:empire() and context:faction():is_human()
    end,
    function(context)
        eom_religion_bundles(context)
    end,
    true
)
