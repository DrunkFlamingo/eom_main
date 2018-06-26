cm = get_cm(); events = get_events(); eom = _G.eom;
if not eom then 
    script_error("EOM IS NOT FOUND!")
end


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
                elseif elector:loyalty() > 25 and elector:loyalty() <= 50 then
                    if not empire:has_effect_bundle("eom_"..name.."_taxation_2") then
                        remove_taxation_bundles(name)
                        cm:apply_effect_bundle("eom_"..name.."_taxation_2", eom:empire(), 0)
                        eom:log("Assigning tax level 2 to ["..name.."] ")
                    end
                elseif elector:loyalty() > 50 and elector:loyalty() <= 75 then
                    if not empire:has_effect_bundle("eom_"..name.."_taxation_3") then
                        remove_taxation_bundles(name)
                        cm:apply_effect_bundle("eom_"..name.."_taxation_3", eom:empire(), 0)
                        eom:log("Assigning tax level 3 to ["..name.."] ")
                    end
                else
                    if not empire:has_effect_bundle("eom_"..name.."_taxation_4") then
                        remove_taxation_bundles(name)
                        cm:apply_effect_bundle("eom_"..name.."_taxation_4", eom:empire(), 0)
                        eom:log("Assigning tax level 4 to ["..name.."] ")
                    end
                end
            elseif (not elector:is_cult()) then
                remove_taxation_bundles(name)
            end
        end
    end,
    true)


