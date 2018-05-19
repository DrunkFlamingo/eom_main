--functions for creating non-saved objects on each time the game loads.

--template for dilemmas
--[[


        {
            ["dilemma_key"] = "df_politics_dilemma_01",
            ["first"] = function() end,
            ["second"] = function () end,
            ["third"] = function() end,
            ["fourth"] = function() end
        },
]]










--v function(eom: EOM_MODEL)
function add_dilemma_data(eom)
    local dilemma_data = {
        {
            ["dilemma_key"] = "df_politics_dilemma_01",
            ["first"] = function() end,
            ["second"] = function () end,
            ["third"] = function() end,
            ["fourth"] = function() end
        }
    }--:vector<map<string, WHATEVER>>

    for i = 1, #dilemma_data do
        local current_dilemma = dilemma_data[i]
        eom:add_dilemma_to_model(current_dilemma.dilemma_key, current_dilemma.first, current_dilemma.second, current_dilemma.third, current_dilemma.fourth)
    end
end


--action template
--[[

        {
            ["religious"] = true,
            ["name"] = "placeholder",
            ["condition"] = function(eom --: EOM_MODEL
            ) 
            
            end,
            ["callback"] = function(eom --:EOM_MODEL
            ) 
            
            end
        },
]]







--v function(eom: EOM_MODEL)
function add_actions_data(eom)
    local actions_data = {
        {
            ["religious"] = true,
            ["name"] = "placeholder",
            ["condition"] = function(eom --: EOM_MODEL
            ) 
            
            end,
            ["callback"] = function(eom --:EOM_MODEL
            ) 
            
            end
        }
    }--:vector<map<string,WHATEVER>>

    
    for i = 1, #actions_data do
        local current = actions_data[i]
        local action = eom_action.new(current.name, current.condition, current.callback)
        if current.religious == true then
            eom:add_cult_action(action)
        elseif current.religious == false then
            eom:add_elector_action(action)
        end
    end 
end


--template for trait
--[[

        {
            ["name"] = "middenland_battles_beastmen",
            ["isCult"] = false,
            ["key"] = "wh_main_emp_middenland",
            ["event"] = "CharacterCompletedBattle",
            ["conditional"] = function(context --:WHATEVER
            )

        end,
            ["loyaltychange"] = tonumber(8)
        },

]]





--v  [NO_CHECK] function (eom: EOM_MODEL)
function add_traits_data(eom)
    local traits_data = {
        {
            ["name"] = "middenland_battles_beastmen_victory",
            ["isCult"] = false,
            ["key"] = "wh_main_emp_middenland",
            ["event"] = "EmpireDefeatsBeastmen",
            ["conditional"] = function(context --:WHATEVER
            )

            end,
            ["loyaltyChange"] = tonumber(8)
        },
        {
            ["name"] = "middenland_battles_beastmen_defeat",
            ["isCult"] = false,
            ["key"] = "wh_main_emp_middenland",
            ["event"] = "BeastmenDefeatEmpire",
            ["conditional"] = function(context --:WHATEVER
            )

            end,
            ["loyaltyChange"] = tonumber(-10)
        }
    } --:vector<map<string, WHATEVER>>

    for i = 1, #traits_data do
        local current = traits_data[i]
        if current.isCult == true then
            local trait = eom_trait.new(current.name, eom:get_cult(current.key), current.event, current.conditional, current.loyaltyChange)
            eom:add_trait(trait)
        elseif current.isCult == false then
            local trait = eom_trait.new(current.name, eom:get_elector(current.key), current.event, current.conditional, current.loyaltyChange)
            eom:add_trait(trait)
        end
    end

end


function add_utlity_listeners()

    --defeated beastmen
    core:add_listener(
        "EmpireDefeatedBeastmenListener",
        "CharacterCompletedBattle",
        function(context)
            if context:character():faction():name() == "wh_main_emp_empire" then
                if Get_Character_Side_In_Last_Battle(context:character()) == "Attacker" then
                    local echar_cqi, emf_cqi, efaction_name = cm:pending_battle_cache_get_defender(1);
                    if get_faction(efaction_name):subculture() == "wh_dlc03_sc_bst_beastmen" and context:character():won_battle() == true then
                        return true
                    end
                else
                    local echar_cqi, emf_cqi, efaction_name = cm:pending_battle_cache_get_attacker(1);
                    if get_faction(efaction_name):subculture() == "wh_dlc03_sc_bst_beastmen" and context:character():won_battle() == true then
                        return true
                    end
                end
            end
            return false
        end,
        function(context)
            EOMLOG("The Empire defeated a beastmen warherd, triggering a custom event", "listener.EmpireDefeatedBeastmenListener")
            core:trigger_event("EmpireDefeatsBeastmen")
        end,
        true)

    --defeated by beastmen
    core:add_listener(
        "BeastmenDefeatedEmpireListener",
        "CharacterCompletedBattle",
        function(context)
            if context:character():faction():name() == "wh_main_emp_empire" then
                if Get_Character_Side_In_Last_Battle(context:character()) == "Attacker" then
                    local echar_cqi, emf_cqi, efaction_name = cm:pending_battle_cache_get_defender(1);
                    if get_faction(efaction_name):subculture() == "wh_dlc03_sc_bst_beastmen" and context:character():won_battle() == false then
                        return true
                    end
                else
                    local echar_cqi, emf_cqi, efaction_name = cm:pending_battle_cache_get_attacker(1);
                    if get_faction(efaction_name):subculture() == "wh_dlc03_sc_bst_beastmen" and context:character():won_battle() == false then
                        return true
                    end
                end
            end
            return false
        end,
        function(context)
            EOMLOG("A Beastmen Warherd Defeated the Empire! Triggering a custom event.", "listener.EmpireDefeatedBeastmenListener")
            core:trigger_event("BeastmenDefeatEmpire")
        end,
        true)



end



--v function(eom: EOM_MODEL)
function add_plot_listeners(eom)
    --starting rebellion plot
    if eom:get_core_data("rebellion_plot_active") == true then
        if eom:get_core_data("won_grunburg") == false then
            core:add_listener(
                "GrunburgArmyDefeated",
                "CharacterCompletedBattle",
                function(context)
                    if Get_Character_Side_In_Last_Battle(context:character()) == "Attacker" then
                        local echar_cqi, emf_cqi, efaction_name = cm:pending_battle_cache_get_defender(1);
                        return  context:character():faction():name() == "wh_main_emp_empire" and get_faction(efaction_name):subculture() == "wh_main_sc_emp_empire" and context:character():won_battle() and context:character():region():name() == "wh_main_reikland_grunburg"
                    else
                        local echar_cqi, emf_cqi, efaction_name = cm:pending_battle_cache_get_attacker(1);
                        return  context:character():faction():name() == "wh_main_emp_empire" and get_faction(efaction_name):subculture() == "wh_main_sc_emp_empire" and context:character():won_battle() and context:character():region():name() == "wh_main_reikland_grunburg"
                    end
                end,
                function(context)
                    eom:add_core_data("won_grunburg", true)
                end,
                false);
        end
        core:add_listener(
            "helmgart_lost_listener",
            "GarrisonOccupiedEvent",
            function(context)
                return context:garrison_residence():region():name() == "wh_main_reikland_helmgart"
            end,
            function(context)
                eom:add_core_data("helmgart_defended", false)
            end,
            false);
    end
    
end