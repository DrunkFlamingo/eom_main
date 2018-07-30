cm = get_cm()
events = get_events()
eom = _G.eom


--v function(quantity: number)
local function increase_civil_war_points(quantity)
    local points = eom:get_core_data_with_key("civil_war_points")
    new_points = points + quantity
    eom:set_core_data("civil_war_points", new_points)
end

--v function(quantity: number)
local function decrease_civil_war_points(quantity)
    local points = eom:get_core_data_with_key("civil_war_points")
    new_points = points - quantity
    eom:set_core_data("civil_war_points", new_points)
end


core:add_listener(
    "EOMCivilWarSettlements",
    "GarrisonOccupiedEvent",
    function(context)
        return eom:get_core_data_with_key("civil_war_active") == true
    end,
    function(context)
        if context:character():faction():subculture() == "wh_main_sc_emp_empire" then
            for name, elector in pairs(eom:electors()) do
                if context:garrison_residence():region():name() == elector:capital() then
                    if string.find(elector:status(), "civil_war") then
                        eom:change_all_loyalties(5)
                        increase_civil_war_points(3)
                    else
                        eom:change_all_loyalties(-5)
                        decrease_civil_war_points(3)
                    end
                end
            end
        end
    end,
    true
)








core:add_listener(
    "EOMCivilWarBattles",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character() --:CA_CHAR
        return eom:get_core_data_with_key("civil_war_active") == true
    end,
    function (context)
        local character = context:character() --:CA_CHAR
        if character:faction():name() == "wh_main_emp_empire" then
            local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
            
            for i = 1, #enemies do
                local enemy = enemies[i];
                if eom:has_elector(enemy:faction():name()) then
                    if string.find(eom:get_elector(enemy:faction():name()):status(),"civil_war") then
                        if character:won_battle() then
                            eom:change_all_loyalties(5)
                            increase_civil_war_points(1)
                        else
                            eom:change_all_loyalties(-5)
                            decrease_civil_war_points(1)
                        end
                    end
                end
            end
        end
    end,
    true)


--v function (eom:EOM_MODEL) --> boolean
local function eom_civil_war_start_check(eom)


end

--v function (eom: EOM_MODEL)
local function eom_civil_war_starter(eom)


end

--v function (eom:EOM_MODEL) --> boolean
local function eom_civil_war_mid_check(eom)

end

--v function (eom: EOM_MODEL)
local function eom_civil_war_mid(eom)

end

--v function (eom:EOM_MODEL) --> boolean
local function eom_civil_war_end_check(eom)


end

--v function (eom: EOM_MODEL)
local function eom_civil_war_ender(eom)


end




local function eom_civil_war()

    if cm:is_new_game() then
        eom:set_core_data("civil_war_points", 0)
        eom:set_core_data("civil_war_active", false)
    end

    local civil_war = eom:new_story_chain("civil_war")

    civil_war:add_stage_trigger(1, function(model --:EOM_MODEL
    )
        return eom_civil_war_start_check(eom)
    end)

    civil_war:add_stage_callback(1, function(model --:EOM_MODEL
    )
        eom_civil_war_starter(eom)
    end)

    civil_war:add_stage_trigger(2, function(model --:EOM_MODEL
    )
        return eom_civil_war_mid_check(eom)
    end)

    civil_war:add_stage_callback(2, function(model --:EOM_MODEL
    )
        
    end)

    civil_war:add_stage_trigger(3, function(model --:EOM_MODEL
    )
        return eom_civil_war_end_check(eom)
    end)

    civil_war:add_stage_callback(3, function(model --:EOM_MODEL
    )
        return eom_civil_war_ender(eom)
    end)

end












events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_civil_war() end;

