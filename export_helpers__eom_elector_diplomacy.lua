
local function eom_elector_diplomacy()
    local suffix_list = {"_critical", "_good", "_indifferent", "_low", "_loyal", "_very_good", "_very_low"} --:vector<string>
    eom:log("entered", "function eom_model.elector_diplomacy(self)");
    local loyalty_level = "_loyal"
    for key, current_elector in pairs(eom:electors()) do
        local current_loyalty = current_elector:loyalty()
        if current_loyalty > 80 then
            loyalty_level = "_loyal"
        elseif current_loyalty > 65 then
            loyalty_level = "_very_good"
        elseif current_loyalty > 50 then
            loyalty_level = "_good"
        elseif current_loyalty > 40 then
            loyalty_level = "_indifferent"
        elseif current_loyalty > 30 then
            loyalty_level = "_low"
        elseif current_loyalty > 15 then
            loyalty_level = "_very_low"
        else
            loyalty_level = "_critical"
        end

        if not cm:get_faction(eom:empire()):has_effect_bundle("eom_"..current_elector:name()..loyalty_level) then
            eom:log("The bundle does not currently match for ["..current_elector:name().."]")
            for i = 1, #suffix_list do
                if cm:get_faction(eom:empire()):has_effect_bundle("eom_"..current_elector:name()..suffix_list[i]) then
                    cm:remove_effect_bundle("eom_"..current_elector:name()..suffix_list[i], eom:empire())
                    break
                end
            end
            eom:log("Set the diplomacy effect bundle to [eom_"..current_elector:name()..loyalty_level.."] for elector ["..current_elector:name().."]")
            cm:apply_effect_bundle("eom_"..current_elector:name()..loyalty_level, eom:empire(), 0)
        end
    end
end

local function eom_elector_personalities()
    eom:log("Entered", "eom_model.elector_personalities(self)")
    for name, elector in pairs(eom:electors()) do
        if elector:status() == "normal" then
            cm:force_change_cai_faction_personality(name, "eom_normal_elector")
        elseif elector:status() == "civil_war_enemy" or elector:status() == "open_rebellion" then
            cm:force_change_cai_faction_personality(name, "eom_disloyal_elector")
        elseif elector:status() == "civil_war_emperor" then
            cm:force_change_cai_faction_personality(name, "eom_pretender")
        end
    end
end



core:add_listener(
    "EOMElectorDiplomacy",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:name() == eom:empire()
    end,
    function(context)
        eom_elector_diplomacy()
        eom_elector_personalities()
    end,
    true);