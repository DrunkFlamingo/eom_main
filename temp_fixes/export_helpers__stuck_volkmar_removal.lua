
local function eom_get_out_of_nuln_you_cunt()
    local character_list = cm:get_faction("wh_main_emp_cult_of_sigmar"):character_list()
    for i = 0, character_list:num_items() - 1 do
        local character = character_list:item_at(i)
        cm:kill_character(character:command_queue_index(), true, true)  
    end
end












events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_get_out_of_nuln_you_cunt() end;