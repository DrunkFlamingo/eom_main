cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end


core:add_listener(
    "EOMBattlesCompleted",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character() --:CA_CHAR
        return character:faction():name() == eom:empire() 
    end,
    function (context)
        local character = context:character() --:CA_CHAR
        if character:won_battle() == true and character:faction():subculture() == "wh_main_sc_emp_empire" then
            local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
            
            for i = 1, #enemies do
                local enemy = enemies[i];
                enemy_name = enemy:faction():name() --# assume enemy_name: ELECTOR_NAME
                if enemy ~= nil and enemy:is_null_interface() == false and enemy:is_faction_leader() == true and enemy:faction():subculture() == "wh_main_sc_emp_empire" then				
                    if character:faction():is_human() == true and enemy:faction():is_human() == false and eom:is_elector_valid(enemy_name) and enemy:faction():is_dead() == false then
                        -- Trigger dilemma to offer confederation
                        eom:get_elector(enemy_name):set_should_capitulate(true)
                    elseif character:faction():is_human() == false and enemy:faction():is_human() == false then
                        -- AI trigger
                        cm:force_make_peace(character:faction():name(), enemy:faction():name())
                        eom:get_elector(enemy_name):change_loyalty(20)
                    end
                end
            end
        end
    end,
    true)