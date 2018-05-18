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