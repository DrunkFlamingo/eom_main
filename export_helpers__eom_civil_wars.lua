cm = get_cm(); events = get_events(); eom = _G.eom;

if not eom then 
    script_error("EOM IS NOT FOUND!")
end

local function eom_vlad_civil_war()

end











local function eom_empire_add_civil_wars()
    eom:log("Starting", "export_helpers__eom_civil_wars")
    eom_vlad_civil_war()


end



events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() eom_empire_add_civil_wars() end;
