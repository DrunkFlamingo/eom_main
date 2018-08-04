cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end


local elector_tax_value = {
	["wh_main_emp_averland"] = {150, 300, 450, 600},
	["wh_main_emp_hochland"] = {100, 200, 300, 400},
	["wh_main_emp_ostermark"] = {100, 200, 300, 400},
	["wh_main_emp_stirland"] = {100, 200, 300, 400},
	["wh_main_emp_middenland"] = {150, 300, 450, 600},
	["wh_main_emp_nordland"] = {100, 200, 300, 400},
	["wh_main_emp_ostland"] = {100, 200, 300, 400},
	["wh_main_emp_wissenland"] = {150, 300, 450, 600},
	["wh_main_emp_talabecland"] = {150, 300, 450, 600},
	["wh_main_emp_cult_of_ulric"] = {0, 0, 0, 0},
	["wh_main_emp_cult_of_sigmar"] = {0, 0, 0, 0},
	["wh_main_emp_marienburg"] = {300, 600, 900, 1200},
	["wh_main_emp_sylvania"] = {100, 200, 300, 400},
	["wh_main_vmp_schwartzhafen"] = {100, 200, 300, 400} 
	} --:map<ELECTOR_NAME, {number, number, number, number}>
	




--v function (name:ELECTOR_NAME)
local function remove_taxation_bundles(name)
    
    local empire = cm:get_faction(eom:empire())
    for i = 1, 4 do 
        if empire:has_effect_bundle("eom_"..name.."_taxation_"..i) then
            cm:remove_effect_bundle(tostring("eom_"..name.."_taxation_"..i), eom:empire())
        end
    end
    eom:log("Removing all tax bundles for ["..name.."] ")
end

core:add_listener(
    "EOMTurnStart",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == eom:empire()
    end,
    function(context)
    local last_total_bundle = cm:get_saved_value("eom_last_tax_bundle") --# assume last_bundle: string
    if cm:get_faction(eom:empire()):has_effect_bundle(last_total_bundle) then
        cm:remove_effect_bundle(last_total_bundle, eom:empire())
    end
    local total_value = 0 --:number
    eom:log("Entered", "eom_model.elector_taxation(self)")
    local empire = cm:get_faction(eom:empire())
        for name, elector in pairs(eom:electors()) do
            if (not elector:is_cult()) and eom:is_elector_valid_for_taxes(name) then
                if elector:loyalty() <= 25 then
                    if not empire:has_effect_bundle("eom_"..name.."_taxation_1") then
                        remove_taxation_bundles(name)
                        cm:apply_effect_bundle("eom_"..name.."_taxation_1", eom:empire(), 0)
                        eom:log("Assigning tax level 1 to ["..name.."] ")
                        
                    end
                    local value_to_add = elector_tax_value[name][1]
                    total_value = total_value + value_to_add
                elseif elector:loyalty() > 25 and elector:loyalty() <= 50 then
                    if not empire:has_effect_bundle("eom_"..name.."_taxation_2") then
                        remove_taxation_bundles(name)
                        cm:apply_effect_bundle("eom_"..name.."_taxation_2", eom:empire(), 0)
                        eom:log("Assigning tax level 2 to ["..name.."] ")
                    end
                    local value_to_add = elector_tax_value[name][2]
                    total_value = total_value + value_to_add
                elseif elector:loyalty() > 50 and elector:loyalty() <= 75 then
                    if not empire:has_effect_bundle("eom_"..name.."_taxation_3") then
                        remove_taxation_bundles(name)
                        cm:apply_effect_bundle("eom_"..name.."_taxation_3", eom:empire(), 0)
                        eom:log("Assigning tax level 3 to ["..name.."] ")
                    end
                    local value_to_add = elector_tax_value[name][3]
                    total_value = total_value + value_to_add
                else
                    if not empire:has_effect_bundle("eom_"..name.."_taxation_4") then
                        remove_taxation_bundles(name)
                        cm:apply_effect_bundle("eom_"..name.."_taxation_4", eom:empire(), 0)
                        eom:log("Assigning tax level 4 to ["..name.."] ")
                    end
                    local value_to_add = elector_tax_value[name][4]
                    total_value = total_value + value_to_add
                end
            elseif (not elector:is_cult()) then
                remove_taxation_bundles(name)
            end
        end
        local new_tax_bundle = "eom_taxation_bundle_quantity_"..total_value
        eom:log("summed total taxes as ["..tostring(total_value).."] and the bundle is ["..new_tax_bundle.."]")
        cm:set_saved_value("eom_last_tax_bundle", new_tax_bundle)
        cm:apply_effect_bundle(new_tax_bundle, eom:empire(), 0)
    end,
    true)


