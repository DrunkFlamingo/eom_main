cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end

local function eom_vlad_civil_war()
    local civil_war_vlad = eom:new_story_chain("civil_war_vlad")
    civil_war_vlad:add_stage_trigger(1, function(model--:EOM_MODEL
    )
        local chaos_invasion_over = true --NOTE: figure out a way to know this.
        
        return false
    end)


end











local function eom_empire_add_civil_wars()
    eom:log("Starting", "export_helpers__eom_civil_wars")
    eom_vlad_civil_war()


end



events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_empire_add_civil_wars() end;
