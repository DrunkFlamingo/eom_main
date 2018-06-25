
--[[
--v function(text: string)
function EOM_ERRORS(text)
    ftext = "debugger"
    --sometimes I use ftext as an arg of this function, but for simple mods like this one I don't need it.

    if not EOM_SHOULD_LOG then
        return; --if our bool isn't set true, we don't want to spam the end user with logs. 
    end

    local logText = tostring(text)
    local logContext = tostring(ftext)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("EOM_DEBUGG.txt","a")
    --# assume logTimeStamp: string
    popLog :write("WEC:  "..logText .. "    : [" .. logContext .. "] : [".. logTimeStamp .. "]\n")
    popLog :flush()
    popLog :close()
end

--v [NO_CHECK] function(func: function) --> any
function safeCall(func)
    --RCDEBUG("safeCall start");
    local status, result = pcall(func)
    if not status then
        EOM_ERRORS(tostring(result))
        EOM_ERRORS(debug.traceback());
    end
    --RCDEBUG("safeCall end");
    return result;
end

--local oldTriggerEvent = core.trigger_event;

--v [NO_CHECK] function(...: any)
function pack2(...) return {n=select('#', ...), ...} end
--v [NO_CHECK] function(t: vector<WHATEVER>) --> vector<WHATEVER>
function unpack2(t) return unpack(t, 1, t.n) end

--v [NO_CHECK] function(f: function(), argProcessor: function()) --> function()
function wrapFunction(f, argProcessor)
    return function(...)
        --RCDEBUG("start wrap ");
        local someArguments = pack2(...);
        if argProcessor then
            safeCall(function() argProcessor(someArguments) end)
        end
        local result = pack2(safeCall(function() return f(unpack2( someArguments )) end));
        --for k, v in pairs(result) do
        --    RCDEBUG("Result: " .. tostring(k) .. " value: " .. tostring(v));
        --end
        --RCDEBUG("end wrap ");
        return unpack2(result);
        end
end

-- function myTriggerEvent(event, ...)
--     local someArguments = { ... }
--     safeCall(function() oldTriggerEvent(event, unpack( someArguments )) end);
-- end

--v [NO_CHECK] function(fileName: string)
function tryRequire(fileName)
    local loaded_file = loadfile(fileName);
    if not loaded_file then
        EOM_ERRORS("Failed to find mod file with name " .. fileName)
    else
        EOM_ERRORS("Found mod file with name " .. fileName)
        EOM_ERRORS("Load start")
        local local_env = getfenv(1);
        setfenv(loaded_file, local_env);
        loaded_file();
        EOM_ERRORS("Load end")
    end
end

core:add_listener(
    "LaunchRuntimeScript",
    "ShortcutTriggered",
    function(context) return context.string == "camera_bookmark_view1"; end, --default F10
    function(context)
        tryRequire("test");
    end,
    true
);

--v [NO_CHECK] function(f: function(), name: string)
function logFunctionCall(f, name)
    return function(...)
        EOM_ERRORS("function called: " .. name);
        return f(...);
    end
end

--v [NO_CHECK] function(object: any)
function logAllObjectCalls(object)
    local metatable = getmetatable(object);
    for name,f in pairs(getmetatable(object)) do
        if is_function(f) then
            EOM_ERRORS("Found " .. name);
            if name == "Id" or name == "Parent" or name == "Find" or name == "Position" or name == "CurrentState"  or name == "Visible"  or name == "Priority" or "Bounds" then
                --Skip
            else
                metatable[name] = logFunctionCall(f, name);
            end
        end
        if name == "__index" and not is_function(f) then
            for indexname,indexf in pairs(f) do
                EOM_ERRORS("Found in index " .. indexname);
                if is_function(indexf) then
                    f[indexname] = logFunctionCall(indexf, indexname);
                end
            end
            EOM_ERRORS("Index end");
        end
    end
end

-- logAllObjectCalls(core);
-- logAllObjectCalls(cm);
-- logAllObjectCalls(game_interface);

core.trigger_event = wrapFunction(
    core.trigger_event,
    function(ab)
        --RCDEBUG("trigger_event")
        --for i, v in pairs(ab) do
        --    RCDEBUG("i: " .. tostring(i) .. " v: " .. tostring(v))
        --end
        --RCDEBUG("Trigger event: " .. ab[1])
    end
);

cm.check_callbacks = wrapFunction(
    cm.check_callbacks,
    function(ab)
        --RCDEBUG("check_callbacks")
        --for i, v in pairs(ab) do
        --    RCDEBUG("i: " .. tostring(i) .. " v: " .. tostring(v))
        --end
    end
)

local currentAddListener = core.add_listener;
--v [NO_CHECK] function(core: any, listenerName: any, eventName: any, conditionFunc: any, listenerFunc: any, persistent: any)
function myAddListener(core, listenerName, eventName, conditionFunc, listenerFunc, persistent)
    local wrappedCondition = nil;
    if is_function(conditionFunc) then
        --wrappedCondition =  wrapFunction(conditionFunc, function(arg) RCDEBUG("Callback condition called: " .. listenerName .. ", for event: " .. eventName); end);
        wrappedCondition =  wrapFunction(conditionFunc);
    else
        wrappedCondition = conditionFunc;
    end
    currentAddListener(
        core, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc), persistent
        --core, listenerName, eventName, wrappedCondition, wrapFunction(listenerFunc, function(arg) RCDEBUG("Callback called: " .. listenerName .. ", for event: " .. eventName); end), persistent
    )
end
core.add_listener = myAddListener;
--]]


EOM_SHOULD_LOG = true --:boolean
EOM_LAST_CONTEXT = "no context set" --:string

--v function(text: string, ftext: string?)
function EOMLOG(text, ftext)
    

    if not EOM_SHOULD_LOG then
        return; --if our bool isn't set true, we don't want to spam the end user with logs. 
    end
    if not ftext then
        ftext = EOM_LAST_CONTEXT
    else
        EOM_LAST_CONTEXT = ftext
    end

    local logText = tostring(text)
    local logContext = tostring(ftext)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("EOMLOG.txt","a")
    --# assume logTimeStamp: string
    popLog :write("WEC:  "..logText .. "    : [" .. logContext .. "] : [".. logTimeStamp .. "]\n")
    popLog :flush()
    popLog :close()
end

function EOMNEWLOG()
    if EOM_SHOULD_LOG == false or cm:get_saved_value("eom_new_log") == true then
        return;
    end

    local logTimeStamp = os.date("%d, %m %Y %X")
    --# assume logTimeStamp: string

    local popLog = io.open("EOMLOG.txt","w+")
    popLog :write("NEW LOG ["..logTimeStamp.."] \n")
    popLog :flush()
    popLog :close()
    cm:set_saved_value("eom_new_log", true)
end
EOMNEWLOG()

--v function(msg: string)
function EOM_ERROR(msg)
	local ast_line = "********************";
	
	-- do output
	print(ast_line);
	print("SCRIPT ERROR, timestamp " .. get_timestamp());
	print(msg);
	print("");
	print(debug.traceback("", 2));
	print(ast_line);
	-- assert(false, msg .. "\n" .. debug.traceback());
	
	-- logfile output
		local file = io.open("RCLOG.txt", "a");
		
		if file then
			file:write(ast_line .. "\n");
			file:write("SCRIPT ERROR, timestamp " .. get_timestamp() .. "\n");
			file:write(msg .. "\n");
			file:write("\n");
			file:write(debug.traceback("", 2) .. "\n");
			file:write(ast_line .. "\n");
			file:close();
		end;
end;


--v function(text: string)
function EOM_DEBUG(text)
    ftext = "debugger"
    --sometimes I use ftext as an arg of this function, but for simple mods like this one I don't need it.

    if not EOM_SHOULD_LOG then
        return; --if our bool isn't set true, we don't want to spam the end user with logs. 
    end

    local logText = tostring(text)
    local logContext = tostring(ftext)
    local logTimeStamp = os.date("%d, %m %Y %X")
    local popLog = io.open("RCLOG.txt","a")
    --# assume logTimeStamp: string
    popLog :write("WEC:  "..logText .. "    : [" .. logContext .. "] : [".. logTimeStamp .. "]\n")
    popLog :flush()
    popLog :close()
end










--global variables

--reduce typing
EOM_GLOBAL_EMPIRE_FACTION = "wh_main_emp_empire"
--helper for listeners
EOM_GLOBAL_EMPIRE_REGIONS = {
    ["wh_main_ostland_castle_von_rauken"] = 1,
    ["wh_main_ostland_norden"] = 1,
    ["wh_main_ostland_wolfenburg"] = 2,
    ["wh_main_reikland_altdorf"] = 2,
    ["wh_main_reikland_eilhart"] = 1,
    ["wh_main_reikland_grunburg"] = 1,
    ["wh_main_reikland_helmgart"] = 1,
    ["wh_main_stirland_the_moot"] = 1,
    ["wh_main_stirland_wurtbad"] = 2,
    ["wh_main_talabecland_kemperbad"] = 1,
    ["wh_main_wissenland_nuln"] = 2,
    ["wh_main_wissenland_pfeildorf"] = 1,
    ["wh_main_wissenland_wissenburg"] = 1,
    ["wh_main_hochland_brass_keep"] = 1,
    ["wh_main_hochland_hergig"] = 2,
    ["wh_main_middenland_carroburg"] = 1,
    ["wh_main_middenland_middenheim"] = 2,
    ["wh_main_middenland_weismund"] = 1,
    ["wh_main_nordland_dietershafen"] = 2,
    ["wh_main_nordland_salzenmund"] = 1,
    ["wh_main_talabecland_talabheim"] = 2,
    ["wh_main_averland_averheim"] = 2,
    ["wh_main_averland_grenzstadt"] = 1,
    ["wh_main_ostermark_bechafen"] = 2,
    ["wh_main_ostermark_essen"] = 1,
    ["wh_main_the_wasteland_gorssel"] = 1,
    ["wh_main_the_wasteland_marienburg"] = 2
}--:map<string, number>

EOM_GLOBAL_REGION_TO_ELECTOR = {
    ["wh_main_ostland_castle_von_rauken"] = "wh_main_emp_ostland",
    ["wh_main_ostland_norden"] = "wh_main_emp_ostland",
    ["wh_main_ostland_wolfenburg"] = "wh_main_emp_ostland",
    ["wh_main_stirland_the_moot"] = "wh_main_emp_stirland",
    ["wh_main_stirland_wurtbad"] = "wh_main_emp_stirland",
    ["wh_main_talabecland_kemperbad"] = "wh_main_emp_talabecland",
    ["wh_main_wissenland_nuln"] = "wh_main_emp_wissenland",
    ["wh_main_wissenland_pfeildorf"] = "wh_main_emp_wissenland",
    ["wh_main_wissenland_wissenburg"] = "wh_main_emp_wissenland",
    ["wh_main_hochland_brass_keep"] = "wh_main_emp_hochland",
    ["wh_main_hochland_hergig"] = "wh_main_emp_hochland",
    ["wh_main_middenland_carroburg"] = "wh_main_emp_middenland",
    ["wh_main_middenland_middenheim"] = "wh_main_emp_middenland",
    ["wh_main_middenland_weismund"] = "wh_main_emp_middenland",
    ["wh_main_nordland_dietershafen"] = "wh_main_emp_nordland",
    ["wh_main_nordland_salzenmund"] = "wh_main_emp_nordland",
    ["wh_main_talabecland_talabheim"] = "wh_main_emp_talabecland",
    ["wh_main_averland_averheim"] = "wh_main_emp_averland",
    ["wh_main_averland_grenzstadt"] = "wh_main_emp_averland",
    ["wh_main_ostermark_bechafen"] = "wh_main_emp_ostermark",
    ["wh_main_ostermark_essen"] = "wh_main_emp_ostermark",
    ["wh_main_the_wasteland_gorssel"] = "wh_main_emp_marienburg",
    ["wh_main_the_wasteland_marienburg"] = "wh_main_emp_marienburg"
}--:map<string, ELECTOR_NAME>

--v function() --> string
local function get_default_start_army()
    return "wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_handgunners,wh_main_emp_inf_handgunners,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen"
end

--v function() --> ELECTOR_INFO
function averland_start_pos()
    local sp = {}
    sp._loyalty = 45 --:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 35 --:number
    sp._key = "wh_main_emp_averland" --:ELECTOR_NAME
    sp._uiName = "Averland"
    sp._image =  "ui/flags/wh_main_emp_averland/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal" --:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147343941"
    sp._leaderSurname = "names_name_2147343947"
    sp._capital =  "wh_main_averland_averheim"
    sp._expeditionX = 573 --:number
    sp._expeditionY = 386 --:number
    sp._expeditionRegion = "wh_main_wissenland_pfeildorf"
    sp._turnsDead = 0--:number
    sp._baseRegions = 2 --:number
    sp._isCult = false;
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    sp._homeRegions = {"wh_main_averland_grenzstadt"} --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function hochland_start_pos()
    local sp = {}
    sp._loyalty = 45 --:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 25 --:number
    sp._key = "wh_main_emp_hochland" --:ELECTOR_NAME
    sp._uiName = "Hochland"
    sp._image =  "ui/flags/wh_main_emp_hochland/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal" --:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147344017"
    sp._leaderSurname = "names_name_2147344019"
    sp._capital =  "wh_main_hochland_hergig"
    sp._expeditionX = 540 --:number 
    sp._expeditionY = 503 --:number
    sp._homeRegions = {"wh_main_hochland_brass_keep"} --:vector<string>
    sp._expeditionRegion = "wh_main_middenland_middenheim"
    sp._turnsDead = 0 --:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    return sp
end

--v function() --> ELECTOR_INFO
function ostermark_start_pos()
    local sp = {}
    sp._loyalty = 35 --:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 25 --:number
    sp._key = "wh_main_emp_ostermark" --:ELECTOR_NAME
    sp._uiName = "Ostermark"
    sp._image =  "ui/flags/wh_main_emp_ostermark/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147344036"
    sp._leaderSurname = "names_name_2147344037"
    sp._capital =  "wh_main_ostermark_bechafen"
    sp._expeditionX = 577 --:number
    sp._expeditionY = 497 --:number
    sp._isCult = false;
    sp._expeditionRegion = "wh_main_talabecland_talabheim"
    sp._turnsDead = 0--:number
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    sp._baseRegions = 2--:number
    sp._homeRegions = {"wh_main_ostermark_essen"} --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function stirland_start_pos()
    local sp = {}
    sp._loyalty = 45--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 30--:number
    sp._key = "wh_main_emp_stirland" --:ELECTOR_NAME
    sp._uiName = "Stirland"
    sp._image =  "ui/flags/wh_main_emp_stirland/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147344039"
    sp._leaderSurname = "names_name_2147344048"
    sp._capital =  "wh_main_stirland_wurtbad"
    sp._expeditionX = 515--:number
    sp._expeditionY = 434--:number
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_reikland_grunburg"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._homeRegions = {"wh_main_stirland_the_moot"} --:vector<string>
    return sp
end


--v function() --> ELECTOR_INFO
function middenland_start_pos()
    local sp = {}
    sp._loyalty = 30--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 43--:number
    sp._key = "wh_main_emp_middenland"--:ELECTOR_NAME
    sp._uiName = "Middenland"
    sp._image =  "ui/flags/wh_main_emp_middenland/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147343937"
    sp._leaderSurname = "names_name_2147343940"
    sp._capital =  "wh_main_middenland_middenheim"
    sp._expeditionX = 489--:number
    sp._expeditionY = 469--:number
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_middenland_carroburg"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._homeRegions = {"wh_main_middenland_weismund", "wh_main_middenland_carroburg"} --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function nordland_start_pos()
    local sp = {}
    sp._loyalty = 35--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 30--:number
    sp._key = "wh_main_emp_nordland"--:ELECTOR_NAME
    sp._uiName = "Nordland"
    sp._image =  "ui/flags/wh_main_emp_nordland/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147344022"
    sp._leaderSurname = "names_name_2147344023"
    sp._capital =  "wh_main_nordland_dietershafen"
    sp._expeditionX = 528--:number
    sp._expeditionY = 532--:number
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_middenland_middenheim"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._homeRegions = {"wh_main_nordland_salzenmund"} --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function ostland_start_pos()
    local sp = {}
    sp._loyalty = 40--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 25--:number
    sp._key = "wh_main_emp_ostland"--:ELECTOR_NAME
    sp._uiName = "Ostland"
    sp._image =  "ui/flags/wh_main_emp_ostland/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147344026"
    sp._leaderSurname = "names_name_2147344030"
    sp._capital =  "wh_main_ostland_wolfenburg"
    sp._expeditionX = 586--:number
    sp._expeditionY = 522--:number
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_hochland_hergig"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._homeRegions = {"wh_main_ostland_norden", "wh_main_ostland_castle_von_rauken"} --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function wissenland_start_pos()
    local sp = {}
    sp._loyalty = 60--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 40--:number
    sp._key = "wh_main_emp_wissenland"--:ELECTOR_NAME
    sp._uiName = "Wissenland"
    sp._image =  "ui/flags/wh_main_emp_wissenland/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147344005"
    sp._leaderSurname = "names_name_2147344064"
    sp._capital =  "wh_main_wissenland_nuln"
    sp._expeditionX =515--:number
    sp._expeditionY = 434--:number
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_reikland_grunburg"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._homeRegions = {"wh_main_wissenland_pfeildorf", "wh_main_wissenland_wissenburg"} --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function talabecland_start_pos()
    local sp = {}
    sp._loyalty = 35--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 40--:number
    sp._key = "wh_main_emp_talabecland"--:ELECTOR_NAME
    sp._uiName = "Talabecland"
    sp._image =  "ui/flags/wh_main_emp_talabecland/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147344050"
    sp._leaderSurname = "names_name_2147344053"
    sp._capital =  "wh_main_talabecland_talabheim"
    sp._expeditionX = 515--:number
    sp._expeditionY = 434--:number
    sp._knights = false;
    sp._canRevive = true;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_reikland_grunburg"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._homeRegions = {"wh_main_talabecland_kemperbad"} --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function marienburg_start_pos()
    local sp = {}
    sp._loyalty = 0--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 35--:number
    sp._key = "wh_main_emp_marienburg"--:ELECTOR_NAME
    sp._uiName = "Marienburg"
    sp._image =  "ui/flags/wh_main_emp_marienburg/mon_256.png"
    sp._uiTooltip = "Seceded State"
    sp._state = "seceded"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147355056"
    sp._leaderSurname = "names_name_2147352481" --change these
    sp._capital =  "wh_main_the_wasteland_marienburg"
    sp._expeditionX = 440--:number
    sp._expeditionY = 553--:number
    sp._knights = false;
    sp._canRevive = false;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_reikland_eilhart"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._homeRegions = {"wh_main_the_wasteland_gorssel"} --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function sylvania_start_pos()
    local sp = {}
    sp._loyalty = 45--:number
    sp._fullyLoyal = false
    sp._hideFromUi = true
    sp._power = 25--:number
    sp._key = "wh_main_emp_sylvania"--:ELECTOR_NAME
    sp._uiName = "Sylvania"
    sp._image =  "ui/flags/wh_main_emp_sylvania/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "notyetexisting"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147355363"
    sp._leaderSurname = "names_name_2147354856"
    sp._capital =  "wh_main_western_sylvania_castle_templehof"
    sp._expeditionX = 687--:number
    sp._expeditionY = 460--:number
    sp._knights = false;
    sp._canRevive = false;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_eastern_sylvania_waldenhof"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
    sp._homeRegions = {
        "wh_main_western_sylvania_fort_oberstyre",
        "wh_main_eastern_sylvania_castle_drakenhof",
        "wh_main_eastern_sylvania_eschen",
        "wh_main_western_sylvania_schwartzhafen",
        "wh_main_eastern_sylvania_waldenhof",
        "wh_main_western_sylvania_castle_templehof"
    }--:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function vampire_start_pos()
    local sp = {}
    sp._loyalty = 30--:number
    sp._fullyLoyal = false
    sp._hideFromUi = true
    sp._power = 30--:number
    sp._key = "wh_main_vmp_schwartzhafen"--:ELECTOR_NAME
    sp._uiName = "Sylvania"
    sp._image =  "ui/flags/wh_dlc07_vmp_von_carstein/mon_256.png"
    sp._uiTooltip = "Elector Count"
    sp._state = "notyetexisting"--:ELECTOR_STATUS
    sp._leaderSubtype = "dlc04_vmp_vlad_con_carstein"
    sp._leaderForename = "names_name_2147345130"
    sp._leaderSurname = "names_name_2147343895"
    sp._capital =  "wh_main_eastern_sylvania_castle_drakenhof"
    sp._expeditionX = 677--:number
    sp._expeditionY = 460--:number
    sp._knights = false;
    sp._canRevive = false;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_eastern_sylvania_waldenhof"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 6--:number
    sp._homeRegions = {
        "wh_main_western_sylvania_fort_oberstyre",
        "wh_main_eastern_sylvania_castle_drakenhof",
        "wh_main_eastern_sylvania_eschen",
        "wh_main_western_sylvania_schwartzhafen",
        "wh_main_eastern_sylvania_waldenhof",
        "wh_main_western_sylvania_castle_templehof"
    }--:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function sigmar_start_pos()
    local sp = {}
    sp._loyalty = 65--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 50--:number
    sp._key = "wh_main_emp_cult_of_sigmar"--:ELECTOR_NAME
    sp._uiName = "The Cult of Sigmar"
    sp._image =  "ui/flags/wh_main_emp_cult_of_sigmar/mon_256.png"
    sp._uiTooltip = "Imperial Cult"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "dlc04_emp_volkmar"
    sp._leaderForename = "names_name_2147358013"
    sp._leaderSurname = "names_name_2147358014"
    sp._capital =  "wh_main_wissenland_nuln"
    sp._expeditionX = 581--:number
    sp._expeditionY = 443--:number
    sp._knights = false;
    sp._canRevive = false;
    sp._unitList = get_default_start_army()
    sp._expeditionRegion = "wh_main_stirland_wurtbad"
    sp._turnsDead = 0--:number
    sp._isCult = true;
    sp._baseRegions = 0--:number
    sp._homeRegions = {
        "wh_main_ostland_castle_von_rauken",
        "wh_main_ostland_norden",
        "wh_main_ostland_wolfenburg",
        "wh_main_reikland_altdorf",
        "wh_main_reikland_eilhart",
        "wh_main_reikland_grunburg",
        "wh_main_reikland_helmgart",
        "wh_main_stirland_the_moot",
        "wh_main_stirland_wurtbad",
        "wh_main_talabecland_kemperbad",
        "wh_main_wissenland_nuln",
        "wh_main_wissenland_pfeildorf",
        "wh_main_wissenland_wissenburg"
        } --:vector<string>
    return sp
end

--v function() --> ELECTOR_INFO
function ulric_start_pos()
    local sp = {}
    sp._loyalty = 35--:number
    sp._fullyLoyal = false
    sp._hideFromUi = false
    sp._power = 45--:number
    sp._key = "wh_main_emp_cult_of_ulric"--:ELECTOR_NAME
    sp._uiName = "The Cult of Ulric"
    sp._image =  "ui/flags/wh_main_emp_cult_of_ulric/mon_256.png"
    sp._uiTooltip = "Imperial Cult"
    sp._state = "normal"--:ELECTOR_STATUS
    sp._leaderSubtype = "emp_lord"
    sp._leaderForename = "names_name_2147344088"
    sp._leaderSurname = "names_name_2147344098"
    sp._capital =  "wh_main_middenland_middenheim"
    sp._expeditionX = 497--:number
    sp._expeditionY = 494--:number
    sp._expeditionRegion = "wh_main_middenland_weismund"
    sp._turnsDead = 0--:number
    sp._isCult = true;
    sp._baseRegions = 0--:number
    sp._knights = false;
    sp._canRevive = false;
    sp._unitList = get_default_start_army()
    sp._homeRegions = {
        "wh_main_hochland_brass_keep",
        "wh_main_hochland_hergig",
        "wh_main_middenland_carroburg",
        "wh_main_middenland_middenheim",
        "wh_main_middenland_weismund",
        "wh_main_nordland_dietershafen",
        "wh_main_nordland_salzenmund"
        } --:vector<string>
    return sp
end

--v function() --> map<string, EOM_CORE_DATA>
function return_starting_core_data()
    local cd = {} --:map<string, EOM_CORE_DATA>
    cd.next_event_turn = 2
    cd.block_events_for_plot = true
    cd.current_plot = "reikland_rebellion"
    cd.last_unjust_war = 0

    return cd
end




--v function() --> vector<function() --> ELECTOR_INFO >
function return_elector_starts()
    local t = {
        averland_start_pos,
        hochland_start_pos,
        ostermark_start_pos,
        stirland_start_pos,
        middenland_start_pos,
        nordland_start_pos,
        ostland_start_pos,
        wissenland_start_pos,
        talabecland_start_pos,
        marienburg_start_pos,
        sylvania_start_pos,
        vampire_start_pos,
        sigmar_start_pos,
        ulric_start_pos
    }

    return t;
end;


local eom_plot = {} --# assume eom_plot: EOM_PLOT

--v function(name: string, model: EOM_MODEL) --> EOM_PLOT
function eom_plot.new(name, model)
local self = {}
setmetatable(self, {
    __index = eom_plot
}) --# assume self: EOM_PLOT

self._name = name
self._model = model 
if cm:get_saved_value("plot_line_stage"..name) then
    self._current_stage = cm:get_saved_value("plot_line_stage"..name) --:int
    EOMLOG("Loaded stage ["..tostring(self._current_stage).."] for plot element ["..name.."]")
else
    self._current_stage = 0
end
self._triggers = {} --:vector<function(eom: EOM_MODEL) --> boolean>
self._callbacks = {} --:vector<function(eom: EOM_MODEL)>
if cm:get_saved_value("plot_line_ended_"..name) == nil then
    cm:set_saved_value("civil_war_ended"..name,false) 
end


return self
end

--v function(self: EOM_PLOT) --> string
function eom_plot.name(self)
    return self._name
end

--v function(self: EOM_PLOT) --> EOM_MODEL
function eom_plot.model(self)
    return self._model
end

--v function(self: EOM_PLOT) --> int
function eom_plot.current_stage(self)
    return self._current_stage
end

--v function(self: EOM_PLOT, stage: int)
function eom_plot.set_stage(self, stage)
    EOMLOG("Advancing stage for civil war ["..self:name().."] to ["..tostring(stage).."] ")
    self._current_stage = stage
    cm:set_saved_value("plot_line_stage"..self:name(), self:current_stage())
end

--v function(self: EOM_PLOT, stage: integer) --> boolean
function eom_plot.has_stage(self, stage)
    return not not self._triggers[stage]
end

--v function(self: EOM_PLOT, stage: integer)
function eom_plot.stage_callback(self, stage)
    if not self._callbacks[stage] then
        EOMLOG("No callbacks for stage ["..tostring(stage).."] in civil war ["..self:name().."] ")
        return
    end
    local stage_callback = self._callbacks[stage]
    stage_callback(self:model())
end


--v function(self: EOM_PLOT, stage: integer) --> boolean
function eom_plot.check_trigger(self, stage)
    local stage_trigger = self._triggers[stage]
    return stage_trigger(self:model())
end



--v function(self: EOM_PLOT) --> boolean
function eom_plot.is_over(self)
    return cm:get_saved_value("plot_line_ended_"..self:name())
end

--v function(self: EOM_PLOT) --> boolean
function eom_plot.is_active(self)
    return (not cm:get_saved_value("plot_line_ended_"..self:name())) and (self:current_stage() > 0)
end


--v [NO_CHECK] function(self: EOM_PLOT)--> boolean
function eom_plot.check_advancement(self) 
    if self:is_over() then
        EOMLOG("Checked advancement for civil war ["..self:name().."] but that civil war is over! ")
        return false
    end
    if self:model():get_core_data_with_key("test_all_plot_events") == true then
        return true
    end
    local c_stage = self:current_stage()
    local n_stage = c_stage + 1;
    if self:has_stage(n_stage) and self:check_trigger(n_stage) then
        return true
    else 
        EOMLOG("Civil war ["..self:name().."] is not advancing")
        return false
    end
end

--v function (self: EOM_PLOT)
function eom_plot.advance(self)
    local c_stage = self:current_stage()
    local n_stage = c_stage + 1;
    self:set_stage(n_stage)
    self:stage_callback(n_stage)
end

--v function(self: EOM_PLOT, stage: int, trigger: function(model: EOM_MODEL) --> boolean)
function eom_plot.add_stage_trigger(self, stage, trigger)
EOMLOG("Added trigger for stage ["..tostring(stage).."] in plot line ["..self:name().."]")
    self._triggers[stage] = trigger
end
--v function(self: EOM_PLOT, stage: int, callback: function(model: EOM_MODEL))
function eom_plot.add_stage_callback(self, stage, callback)
    EOMLOG("Added callback for stage ["..tostring(stage).."] in plot line ["..self:name().."]")
    self._callbacks[stage] = callback
end

--v function(self: EOM_PLOT)
function eom_plot.finish(self)
    cm:set_saved_value("plot_line_ended_"..self:name(), true)
end

--v function(self: EOM_PLOT)
function eom_plot.save(self)
    cm:set_saved_value("plot_line_stage"..self:name(), self:current_stage())
end




local eom_action = {} --# assume eom_action: EOM_ACTION

--v function(key: string, conditional: function(eom: EOM_MODEL) --> boolean, choices: map<number, function(eom: EOM_MODEL)>, eom: EOM_MODEL) --> EOM_ACTION
function eom_action.new(key, conditional, choices, eom)
    local self = {}
    setmetatable(
        self, {
            __index = eom_action
        }
    )--# assume self: EOM_ACTION

    self._key = key
    self._condition = conditional
    self._choices = choices
    self._alreadyOccured = cm:get_saved_value("eom_action_"..key.."_occured") or false
    self._eom = eom

    return self
end

--v function(self: EOM_ACTION) --> EOM_MODEL
function eom_action.model(self)
    return self._eom
end


--v function(self: EOM_ACTION) --> string
function eom_action.key(self)
    return self._key
end

--v function(self: EOM_ACTION) --> boolean
function eom_action.allowed(self)
    return self._condition(self:model()) and cm:get_saved_value("eom_action_"..self:key().."_occured") == false
end

--v function(self: EOM_ACTION, choice: number)
function eom_action.do_choice(self, choice)
    EOMLOG("Doing choice callback ["..tostring(choice).."] for event ["..self:key().."] ")
    local choice_callback = self._choices[choice]
    choice_callback(self:model())
end

--v function(self: EOM_ACTION) --> boolean
function eom_action.already_occured(self)
    return self._alreadyOccured
end

--v function(self: EOM_ACTION)
function eom_action.act(self)
    cm:trigger_dilemma(EOM_GLOBAL_EMPIRE_FACTION, self:key(), true)
    cm:set_saved_value("eom_action_"..self:key().."_occured", true)
    core:add_listener(
        self:key(),
        "DilemmaChoiceMadeEvent",
        function(context)
           return context:faction():name() == EOM_GLOBAL_EMPIRE_FACTION
        end,
        function(context)
            self:do_choice((context:choice()+1))
        end,
        false)
end


local eom_elector = {} --# assume eom_elector: EOM_ELECTOR

--v function(info: ELECTOR_INFO) --> EOM_ELECTOR
function eom_elector.new(info)
    local self = {} 
    setmetatable(
        self, {
            __index = eom_elector,
            __tostring = function() return "EOM_ELECTOR" end
        }
    )--# assume self: EOM_ELECTOR

    --central data
    self._key = info._key
    self._loyalty = info._loyalty
    self._power = info._power
    self._state = info._state
    self._fullyLoyal = info._fullyLoyal
    --casus belli 
    self._baseRegions = info._baseRegions
    --revival
    self._turnsDead = info._turnsDead
    self._capital = info._capital
    self._expeditionX = info._expeditionX
    self._expeditionY = info._expeditionY
    self._expeditionRegion = info._expeditionRegion
    self._leaderSubtype = info._leaderSubtype
    self._leaderForename = info._leaderForename
    self._leaderSurname  = info._leaderSurname
    self._homeRegions = info._homeRegions
    --ui
    self._hideFromUi = info._hideFromUi
    self._image = info._image
    self._uiName = info._uiName
    self._uiTooltip = info._uiTooltip
    self._isCult = info._isCult

    self._knights = info._knights
    self._canRevive = info._canRevive
    self._unitList = info._unitList
    self._willCapitulate = info._willCapitulate 
    self._fullLoyaltyCallback = function(model) end --:function(model: EOM_MODEL)
    return self
end

--save
--v function(self: EOM_ELECTOR) --> ELECTOR_INFO
function eom_elector.save(self)

    local savetable = {}
    savetable._key = self._key
    savetable._loyalty = self._loyalty
    savetable._power = self._power
    savetable._state = self._state
    savetable._fullyLoyal = self._fullyLoyal
    --casus belli 
    savetable._baseRegions = self._baseRegions
    --revival
    savetable._turnsDead = self._turnsDead
    savetable._capital = self._capital
    savetable._expeditionX = self._expeditionX
    savetable._expeditionY = self._expeditionY
    savetable._expeditionRegion = self._expeditionRegion
    savetable._leaderSubtype = self._leaderSubtype
    savetable._leaderForename = self._leaderForename
    savetable._leaderSurname  = self._leaderSurname
    --ui
    savetable._hideFromUi = self._hideFromUi
    savetable._image = self._image
    savetable._uiName = self._uiName
    savetable._uiTooltip = self._uiTooltip
    savetable._isCult = self._isCult
    savetable._knights = self._knights
    savetable._unitList = self._unitList
    savetable._canRevive = self._canRevive
    savetable._willCapitulate = self._willCapitulate
    savetable._homeRegions = self._homeRegions
    return savetable
end


--keys

--v function(self: EOM_ELECTOR) --> ELECTOR_NAME
function eom_elector.name(self)
    return self._key
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.capital(self)
    return self._capital
end


--full loyalty

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.is_loyal(self)
    return self._fullyLoyal
end

--v function(self: EOM_ELECTOR) 
function eom_elector.make_fully_loyal(self)
    self._fullyLoyal = true
end


--cultiness

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.is_cult(self)
    return self._isCult
end


--state

--v function(self: EOM_ELECTOR) --> ELECTOR_STATUS
function eom_elector.status(self)
    return self._state
end

--v function(self: EOM_ELECTOR, status: ELECTOR_STATUS)
function eom_elector.set_status(self, status)
    EOMLOG("entered for ["..self:name().."] ", "eom_elector.set_status(self)")
    if self:is_loyal() then
        EOMLOG("this elector is fully loyal, aborting")
        return
    end
    self._state = status
    EOMLOG("set status for ["..self:name().."] to ["..self:status().."]")
end


--loyalty

--v function(self: EOM_ELECTOR) --> number
function eom_elector.loyalty(self)
    return self._loyalty;
end

--v function(self: EOM_ELECTOR, changevalue: number)
function eom_elector.change_loyalty(self, changevalue)
    EOMLOG("entered", "eom_elector.change_loyalty(self, changevalue)")
    if self:is_loyal() then
        EOMLOG("Not applying any loyalty change  to ["..self:name().."] because the elector is fully loyal!")
        return
    end
    

    if self:status() == "normal" then
        local ov = self._loyalty;
        local nv = ov + changevalue;
        if nv > 100 then nv = 100 end;
        if nv < 0 then nv = 0 end;
        self._loyalty = nv;
        EOMLOG("changed loyalty for ["..self:name().."] by ["..tostring(changevalue).."] to ["..self:loyalty().."] ")
    else
        EOMLOG("Not applying any loyalty change to ["..self:name().."] because the elector has a non-normal status!")
        return
    end
end

--v function(self: EOM_ELECTOR, setvalue: number)
function eom_elector.set_loyalty(self, setvalue)
    EOMLOG("entered", "eom_elector.change_loyalty(self, changevalue)")
    if self:is_loyal() then
        EOMLOG("WARNING: setting the loyalty of a fully loyal elector!!!")
    end
    self._loyalty = setvalue
    EOMLOG("set loyalty for ["..self:name().."] to ["..self:loyalty().."] ")
end

--power

--v function(self: EOM_ELECTOR) --> number
function eom_elector.power(self)
    return self._power
end

--v function(self: EOM_ELECTOR, value: number)
function eom_elector.set_power(self, value)
    self._power = value
end

--v function(self: EOM_ELECTOR, value: number)
function eom_elector.change_power(self, value)
    self._power = self._power + value
end

--capitulation

--v function(self: EOM_ELECTOR, should_capitulate: boolean)
function eom_elector.set_should_capitulate(self, should_capitulate)
    self._willCapitulate = should_capitulate
end

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.will_capitulate(self)
    return self._willCapitulate
end





--ui

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.is_hidden(self)
    return self._hideFromUi
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.image(self)
    return self._image
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.ui_name(self)
    return self._uiName
end

--v function(self: EOM_ELECTOR, visible: boolean)
function eom_elector.set_visible(self, visible)
    self._hideFromUi = visible
end

--leadership


--v function(self: EOM_ELECTOR) --> string
function eom_elector.leader_subtype(self)
    return self._leaderSubtype
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.leader_forename(self)
    return self._leaderForename
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.leader_surname(self)
    return self._leaderSurname
end



--v function(self: EOM_ELECTOR, subtype: string)
function eom_elector.set_leader_subtype(self, subtype)
    self._leaderSubtype = subtype
end

--v function(self: EOM_ELECTOR, forename: string)
function eom_elector.set_leader_forename(self, forename)
    self._leaderForename = forename
end

--v function(self: EOM_ELECTOR, surname: string)
function eom_elector.set_leader_surname(self, surname)
    self._leaderSurname = surname
end

--armies

--v function(self: EOM_ELECTOR, army_list: string)
function eom_elector.set_army_list(self, army_list)
    self._unitList = army_list
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.get_army_list(self)
    return self._unitList
end



--base regions

--v function(self: EOM_ELECTOR) --> number
function eom_elector.base_region_count(self)
    return self._baseRegions
end

--v function(self: EOM_ELECTOR, count: number)
function eom_elector.set_base_regions(self, count)
    EOMLOG("Entered", "eom_elector.set_base_regions(self, count)")
    self._baseRegions = count
    EOMLOG("Set base regions for ["..self:name().."] to ["..tostring(self:base_region_count()).."]")
end

--v function(self: EOM_ELECTOR) --> vector<string>
function eom_elector.home_regions(self)
    return self._homeRegions
end



--revival system

--v function(self: EOM_ELECTOR) --> number
function eom_elector.turns_dead(self)
    return self._turnsDead
end

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.can_revive(self)
    return self._canRevive
end

--v function(self: EOM_ELECTOR, can_revive: boolean)
function eom_elector.set_can_revive(self, can_revive)
    self._canRevive = can_revive
end

--v function(self: EOM_ELECTOR) 
function eom_elector.dead_for_turn(self)
    EOMLOG("entered", "eom_elector.dead_for_turn(self)")
    self._turnsDead = self._turnsDead + 1;
    EOMLOG(" ["..self:name().."] is dead this turn, incrementing their dead counter to ["..tostring(self:turns_dead()).."] ")
end

--v function(self: EOM_ELECTOR) --> (number, number)
function eom_elector.expedition_coordinates(self)
    return self._expeditionX, self._expeditionY
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.expedition_region(self)
    return self._expeditionRegion
end

--v function(self: EOM_ELECTOR)
function eom_elector.trigger_coup(self)
    local old_owner = tostring(cm:get_region(self:capital()):owning_faction():name());
    cm:create_force_with_general(
        self:name(),
        self:get_army_list(),
        self:capital(),
        cm:get_region(self:capital()):settlement():logical_position_x() + 1,
        cm:get_region(self:capital()):settlement():logical_position_y() + 1,
        "general",
        self:leader_subtype(),
        self:leader_forename(),
        "",
        self:leader_surname(), 
        "",
        true,
        function(cqi)
            local dx = cm:get_character_by_cqi(cqi):display_position_x()
            local dy = cm:get_character_by_cqi(cqi):display_position_y()
            cm:show_message_event_located(
                EOM_GLOBAL_EMPIRE_FACTION,
                "event_feed_strings_text_coup_detat_title",
                "event_feed_strings_text_coup_detat_"..self:name().."_subtitle",
                "event_feed_strings_text_coup_detat_"..self:name().."_detail",
                dx,
                dy,
                true,
                591)
        end)
    cm:callback( function()
        cm:transfer_region_to_faction(self:capital(), self:name())
        cm:force_declare_war(self:name(), old_owner, false, false)
        cm:treasury_mod(self:name(), 5000)

    end, 0.2)
    self:set_can_revive(false)
end

--v function(self: EOM_ELECTOR, transfer_no_region: boolean?)
function eom_elector.respawn_at_capital(self, transfer_no_region)
    cm:create_force_with_general(
        self:name(),
        self:get_army_list(),
        self:capital(),
        cm:get_region(self:capital()):settlement():logical_position_x() + 1,
        cm:get_region(self:capital()):settlement():logical_position_y() + 1,
        "general",
        self:leader_subtype(),
        self:leader_forename(),
        "",
        self:leader_surname(), 
        "",
        true,
        function(cqi)

        end)
    if not transfer_no_region then
        cm:callback( function()
            cm:transfer_region_to_faction(self:capital(), self:name())
            cm:treasury_mod(self:name(), 5000)
        end, 0.2)
    end
end

--v function(self: EOM_ELECTOR)
function eom_elector.trigger_expedition(self)
    local x, y = self:expedition_coordinates();
    local old_owner = tostring(cm:get_region(self:capital()):owning_faction():name());
    cm:create_force_with_general(
        self:name(),
        self:get_army_list(),
        self:expedition_region(),
        x,
        y,
        "general",
        self:leader_subtype(),
        self:leader_forename(),
        "",
        self:leader_surname(), 
        "",
        true,
        function(cqi)
            local dx = cm:get_character_by_cqi(cqi):display_position_x()
            local dy = cm:get_character_by_cqi(cqi):display_position_y()
            cm:show_message_event_located(
                EOM_GLOBAL_EMPIRE_FACTION,
                "event_feed_strings_text_expedition_title",
                "event_feed_strings_text_expedition_"..self:name().."_subtitle",
                "event_feed_strings_text_expedition_"..self:name().."_detail",
                dx,
                dy,
                true,
                591)
        end)
    cm:treasury_mod(self:name(), 10000)
    cm:force_declare_war(self:name(), old_owner, false, false)
    self:set_can_revive(false)
end

--v function(self: EOM_ELECTOR, callback: function(model: EOM_MODEL))
function eom_elector.set_full_loyalty_callback(self, callback)
    self._fullLoyaltyCallback = callback
end



--v function(self: EOM_ELECTOR, model: EOM_MODEL)
function eom_elector.set_fully_loyal(self, model)
    self:set_status("loyal")
    self:make_fully_loyal()
    self._fullLoyaltyCallback(model)
    cm:trigger_incident(EOM_GLOBAL_EMPIRE_FACTION, "eom_full_loyalty_"..self:name(), true)
    cm:force_confederation(EOM_GLOBAL_EMPIRE_FACTION, self:name())
end


local eom_model = {} --# assume eom_model: EOM_MODEL




--v function() --> EOM_MODEL
function eom_model.init()
    local self = {}
    setmetatable(
        self, {
            __index = eom_model,
            __tostring = function() return "EOM_MODEL.3.0_BETA" end
        }
    ) --# assume self: EOM_MODEL

    self._electors = {} --:map<ELECTOR_NAME, EOM_ELECTOR>
    self._events = {} --:map<string, EOM_ACTION>
    self._plot = {} --:map<string, EOM_PLOT>

    self._coredata = {} --:map<string, EOM_CORE_DATA>
    self._view = nil --:EOM_VIEW
    return self
end
--v function(self: EOM_MODEL) --> string
function eom_model.empire(self)
    return "wh_main_emp_empire"
end


--core data
--v function(self: EOM_MODEL) --> map<string, EOM_CORE_DATA>
function eom_model.coredata(self)
    return self._coredata
end

--v function(self: EOM_MODEL, key: string) --> EOM_CORE_DATA
function eom_model.get_core_data_with_key(self, key)
    if self._coredata[key] == nil then
        return false
    end
    return self._coredata[key]
end

--v function(self: EOM_MODEL, key: string, new_value: EOM_CORE_DATA)
function eom_model.set_core_data(self, key, new_value)
    self._coredata[key] = new_value
    EOMLOG("Set core data at key ["..key.."] to ["..tostring(new_value).."] ")
end

--v function(self: EOM_MODEL, key: string)
function eom_model.remove_core_data(self, key)
    self._coredata[key] = nil
    EOMLOG("Erased core data at key ["..key.."] ")
end


--electors

--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> boolean
function eom_model.has_elector(self, name)
    return not not self._electors[name]
end

--v function(self: EOM_MODEL) --> map<ELECTOR_NAME, EOM_ELECTOR>
function eom_model.electors(self)
    return self._electors
end

--v function(self: EOM_MODEL) --> vector<EOM_ELECTOR>
function eom_model.elector_list(self)
    local elector_list = {} --:vector<EOM_ELECTOR>
    for k, v in pairs(self:electors()) do
        table.insert(elector_list, v)
    end
    return elector_list
end


--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> EOM_ELECTOR
function eom_model.get_elector(self, name)
    return self._electors[name]
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> CA_FACTION
function eom_model.get_elector_faction(self, name)
    return cm:get_faction(self:get_elector(name):name())
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> boolean
function eom_model.is_elector_valid(self, name)
    local elector_active = (self:get_elector(name):status() == "normal")
    local capital_owned = (cm:get_region(self:get_elector(name):capital()):owning_faction():name() == name)
    local living = (not self:get_elector_faction(name):is_dead()) 
    if self:get_elector(name):is_cult() then
        living = true 
        capital_owned = true
    end
    local first_dilemma_triggered =  cm:get_saved_value("eom_action_eom_dilemma_nordland_2_occured") or false
    EOMLOG("is Elector Valid returning ["..tostring(elector_active and capital_owned and living and first_dilemma_triggered).."] ")
    return elector_active and capital_owned and living and first_dilemma_triggered
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> boolean
function eom_model.is_elector_valid_for_taxes(self, name)
    local elector_active = (self:get_elector(name):status() == "normal")
    local capital_owned = (cm:get_region(self:get_elector(name):capital()):owning_faction():name() == name)
    local living = (not self:get_elector_faction(name):is_dead()) 
    return elector_active and capital_owned and living
end


--v function(self: EOM_MODEL, name: ELECTOR_NAME) --> boolean
function eom_model.is_elector_rebelling(self, name)
    return self:get_elector(name):status() == "normal" or self:get_elector(name):status() == "fully_loyal"
end


--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_all_loyalties(self, quantity)
    EOMLOG("called for an all loyalties change of ["..tostring(quantity).."]")
    for key, elector in pairs(self:electors()) do
        elector:change_loyalty(quantity)
    end
end

--v function(self: EOM_MODEL, exception: vector<ELECTOR_NAME>, quantity: number)
function eom_model.change_loyalty_for_all_except(self, exception, quantity)    
    local reverse_quantity = -(quantity)
    self:change_all_loyalties(quantity)
    for i = 1, #exception do
        self:get_elector(exception[i]):change_loyalty(reverse_quantity)
    end
end


--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_sigmarite_loyalties(self, quantity)
    EOMLOG("called for a change in sigmarite loyalties of ["..tostring(quantity).."]")
    self:get_elector("wh_main_emp_wissenland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_stirland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_ostland"):change_loyalty(quantity)
end

--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_ulrican_loyalites(self, quantity)
    EOMLOG("called for a change in ulrican loyalties of ["..tostring(quantity).."]")
    self:get_elector("wh_main_emp_middenland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_hochland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_nordland"):change_loyalty(quantity)
end

--v function(self: EOM_MODEL, quantity: number)
function eom_model.change_atheist_loyalties(self, quantity)
    EOMLOG("called for a change in sigmarite loyalties of ["..tostring(quantity).."]")
    self:get_elector("wh_main_emp_averland"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_ostermark"):change_loyalty(quantity)
    self:get_elector("wh_main_emp_marienburg"):change_loyalty(quantity)
end




--v function(self: EOM_MODEL, info: ELECTOR_INFO)
function eom_model.add_elector(self, info)
    EOMLOG("entered", "eom_model.add_elector(self, info)")
    local elector = eom_elector.new(info)
    self._electors[elector:name()] = elector
    EOMLOG("Added elector ["..elector:name().."] to the model!")
end



    




--events 
--@name: add_event
--@description: creates a new event from a table template.
--v function(self: EOM_MODEL)
function eom_model.event_and_plot_check(self)
    EOMLOG("Entered", "eom_model.event_and_plot_check(self)")
    --capitulation
    EOMLOG("Checking for Electors willing to capitulate")
    for name, elector in pairs(self:electors()) do
        if elector:will_capitulate() and (not elector:is_cult()) then
            self:offer_capitulation(name)
            elector:set_should_capitulate(false)
            return
        end
    end
    --full loyalty
    if not self:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        EOMLOG("Checking for fully loyal electors")
        for name, elector in pairs(self:electors()) do
            if elector:loyalty() > 99 and elector:status() == "normal" then
                elector:set_fully_loyal(self)
            end
        end
    end
    --plot check
    EOMLOG("Core event and plot check function checking story events")
    for key, story in pairs(self:get_story()) do
        if story:check_advancement() == true then
            story:advance()
            return
        end
    end
    --open rebellions
    if not self:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        EOMLOG("Core event and plot check function checking open rebellion opportunities")
        for name, elector in pairs(self:electors()) do
            if (elector:loyalty() == 0) and elector:status() == "normal" then
                
                EOMLOG("Elector ["..name.."] can rebel!")
                self:elector_rebellion_start(name)
            end
        end
    end


    --player restore opportunity.
    EOMLOG("Core event and plot check function checking player restoration opportunities")
    for name, elector in pairs(self:electors()) do
        if not elector:is_cult() then
            if cm:get_region(elector:capital()):owning_faction():name() == EOM_GLOBAL_EMPIRE_FACTION and cm:get_faction(name):is_dead() then
                if elector:status() == "normal" or elector:status() == "open_rebellion" then
                    self:trigger_restoration_dilemma(name)
                end
            end
        end
    end

    --events
    EOMLOG("Core event and plot check function checking political events")
    local next_event = self:get_core_data_with_key("next_event_turn") --# assume next_event: number
    if cm:model():turn_number() >= next_event and (not self:get_core_data_with_key("block_events_for_plot") == true) then
        for key, event in pairs(self:events()) do
            if event:allowed() then
                event:act()
                self:set_core_data("next_event_turn", cm:model():turn_number() + 5) 
                return
            end
        end
    end

    --revival events.
    EOMLOG("Core event and plot check function checking revivification events")
    for name, elector in pairs(self:electors()) do
        if self:get_elector_faction(name):is_dead() and elector:turns_dead() > 4 and elector:can_revive() and (not elector:is_cult()) then
        if cm:get_region(elector:capital()):owning_faction():subculture() == "wh_main_sc_emp_empire" then
            elector:trigger_coup()
            return
        else
            elector:trigger_expedition() 
            return
        end
        end
    end
    --elector falls
    EOMLOG("Core event and plot check function checking elector fallen events.")
    for name, elector in pairs(self:electors()) do
        if elector:turns_dead() > 20 and elector:can_revive() == false and (not elector:is_cult()) then
            self:elector_fallen(name, true)
        end
    end
end

--plot events

--v function(self: EOM_MODEL, name: string) --> EOM_PLOT
function eom_model.new_story_chain(self, name)
    local event = eom_plot.new(name, self)
    self._plot[name] = event
    return event
end

--v function(self: EOM_MODEL) --> map<string, EOM_PLOT>
function eom_model.get_story(self)
    return self._plot
end

--v function(self: EOM_MODEL, name: string) --> EOM_PLOT
function eom_model.get_story_chain(self, name)
    return self._plot[name]
end

--rebellion
--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.elector_rebellion_end(self, name)
    self:get_elector(name):set_status("normal")
    self:get_elector(name):change_loyalty(20)
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.elector_rebellion_start(self, name)
    if name == "wh_main_vmp_schwartzhafen" then
        EOMLOG("Vlad can't rebel!")
        return 
    end


    EOMLOG("triggering rebellion for ["..name.."] ")
    local elector = self:get_elector(name)
    elector:set_status("open_rebellion")
    cm:trigger_incident(EOM_GLOBAL_EMPIRE_FACTION, "eom_"..name.."_open_rebellion", true)
    if elector:is_cult() then
        local x, y = elector:expedition_coordinates()
        cm:create_force(name, elector:get_army_list(), elector:expedition_region(), x, y, true, true)
        core:add_listener(
            "rebellion_ender"..name,
            "FactionTurnStart",
            function(context)
                return cm:get_faction(name):is_dead()
            end,
            function(context)
                self:elector_rebellion_end(name)
            end,
            false)
    end
end


--radiant revival
--v function (self: EOM_MODEL)
function eom_model.check_dead(self)
    EOMLOG("Checking for dead electors!")
    for name, elector in pairs(self:electors()) do
        if self:get_elector_faction(name):is_dead() then
            elector:dead_for_turn()
        end
    end
end

--v function(self: EOM_MODEL, name:ELECTOR_NAME, show_message_event: boolean?)
function eom_model.elector_fallen(self, name, show_message_event)
    local elector = self:get_elector(name)
    self:change_all_loyalties(-10)
    --NOTE: trigger elector fallen event.
    elector:set_status("fallen")
    elector:set_visible(false)
    if show_message_event then
        cm:show_message_event(
            self:empire(),
            "event_feed_strings_text_elector_fallen_title",
            "event_feed_strings_text_elector_fallen_subtitle",
            "event_feed_strings_text_elector_"..name.."_fallen_detail",
            true,
            591
        )
    end
end

    
--v function (self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.trigger_restoration_dilemma(self, name)
    local elector = self:get_elector(name)
    cm:trigger_dilemma(EOM_GLOBAL_EMPIRE_FACTION, "eom_"..name.."_restoration", true)
    core:add_listener(
        "restoration_"..name,
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 1 then
                self:elector_fallen(name)
            elseif context:choice() == 0 then
                if self:get_elector(name):status() == "open_rebellion" then
                    self:elector_rebellion_end(name)
                    self:get_elector(name):respawn_at_capital()
                    local home_regions = self:get_elector(name):home_regions()
                    for i = 1, #home_regions do
                        local current_region = home_regions[i]
                        if cm:get_region(current_region):owning_faction():subculture() == "wh_main_emp_sc_empire" then
                            cm:callback(function()
                                cm:transfer_region_to_faction(current_region, name)
                            end, i/10)
                        end
                    end
                else
                    self:get_elector(name):respawn_at_capital()
                    self:get_elector(name):change_loyalty(20)
                    local home_regions = self:get_elector(name):home_regions()
                    for i = 1, #home_regions do
                        local current_region = home_regions[i]
                        if cm:get_region(current_region):owning_faction():subculture() == "wh_main_emp_sc_empire" then
                            cm:callback(function()
                                cm:transfer_region_to_faction(current_region, name)
                            end, i/10)
                        end
                    end
                end
            end
        end,
        false)
end

--war systems
--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.grant_casus_belli(self, name)
    cm:apply_effect_bundle("eom_"..name.."_casus_belli", EOM_GLOBAL_EMPIRE_FACTION, 8)
end

--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.check_unjust_war(self, name)
    EOMLOG("Entered", "eom_model.check_unjust_war(self, name)")
    if cm:get_faction(self:empire()):has_effect_bundle("eom_"..name.."_casus_belli") then
        EOMLOG("Casus Belli possessed, doing nothing!")
    else
        EOMLOG("Checking unjust war!")
        local last_unjust = self:get_core_data_with_key("last_unjust_war") --# assume last_unjust:number
        if last_unjust == nil then self:set_core_data("last_unjust_war", cm:model():turn_number()) end
        if last_unjust ~= cm:model():turn_number() then
            EOMLOG("triggering unjust war")
            self:change_all_loyalties(-10)
            self:set_core_data("last_unjust_war", cm:model():turn_number())
            cm:show_message_event(
                self:empire(),
                "event_feed_strings_text_unjust_war_title",
                "event_feed_strings_text_unjust_war_subtitle",
                "event_feed_strings_text_unjust_war_detail",
                true,
                591)
        else
            EOMLOG("Unjust war already triggered this turn!")
        end
    end
end



--v function(self: EOM_MODEL, name: ELECTOR_NAME)
function eom_model.offer_capitulation(self, name)
    EOMLOG("Offering capitulation for ["..name.."] ")
    --needs filling
    cm:trigger_dilemma(EOM_GLOBAL_EMPIRE_FACTION, "eom_"..name.."_capitulation", true)
    core:add_listener(
        "capitulation_"..name,
        "DilemmaChoiceMadeEvent",
        true,
        function(context)
            if context:choice() == 0 then
                cm:force_make_peace(name, EOM_GLOBAL_EMPIRE_FACTION)
                self:elector_rebellion_end(name)
                if cm:get_region(self:get_elector(name):capital()):owning_faction() == EOM_GLOBAL_EMPIRE_FACTION then
                    cm:transfer_region_to_faction(self:get_elector(name):capital(), name)
                end
            else
                self:change_all_loyalties(-5)
            end
        end,
        false
    )
end

---EBS

--@name: event_and_plot_check
--@description: causes all events on a prioritized basis.
--v function(self: EOM_MODEL)
function eom_model.event_and_plot_check(self)
    EOMLOG("Entered", "eom_model.event_and_plot_check(self)")
    --capitulation
    EOMLOG("Checking for Electors willing to capitulate")
    for name, elector in pairs(self:electors()) do
        if elector:will_capitulate() and (not elector:is_cult()) then
            self:offer_capitulation(name)
            elector:set_should_capitulate(false)
            return
        end
    end
    --full loyalty
    if not self:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        EOMLOG("Checking for fully loyal electors")
        for name, elector in pairs(self:electors()) do
            if elector:loyalty() > 99 and elector:status() == "normal" then
                elector:set_fully_loyal(self)
            end
        end
    end
    --plot check
    EOMLOG("Core event and plot check function checking story events")
    for key, story in pairs(self:get_story()) do
       if story:check_advancement() == true then
            story:advance()
            return
       end
    end
    --open rebellions
    if not self:get_core_data_with_key("tweaker_no_full_loyalty_events") == true then
        EOMLOG("Core event and plot check function checking open rebellion opportunities")
        for name, elector in pairs(self:electors()) do
            if (elector:loyalty() == 0) and elector:status() == "normal" then
                
                EOMLOG("Elector ["..name.."] can rebel!")
                self:elector_rebellion_start(name)
            end
        end
    end


    --player restore opportunity.
    EOMLOG("Core event and plot check function checking player restoration opportunities")
    for name, elector in pairs(self:electors()) do
        if not elector:is_cult() then
            if cm:get_region(elector:capital()):owning_faction():name() == EOM_GLOBAL_EMPIRE_FACTION and cm:get_faction(name):is_dead() then
                if elector:status() == "normal" or elector:status() == "open_rebellion" then
                    self:trigger_restoration_dilemma(name)
                end
            end
        end
    end

    --events
    EOMLOG("Core event and plot check function checking political events")
    local next_event = self:get_core_data_with_key("next_event_turn") --# assume next_event: number
    if cm:model():turn_number() >= next_event and (not self:get_core_data_with_key("block_events_for_plot") == true) then
        for key, event in pairs(self:events()) do
            if event:allowed() then
                event:act()
                return
            end
        end
    end

    --revival events.
    EOMLOG("Core event and plot check function checking revivification events")
    for name, elector in pairs(self:electors()) do
        if self:get_elector_faction(name):is_dead() and elector:turns_dead() > 4 and elector:can_revive() and (not elector:is_cult()) then
        if cm:get_region(elector:capital()):owning_faction():subculture() == "wh_main_sc_emp_empire" then
            elector:trigger_coup()
            return
        else
            elector:trigger_expedition() 
            return
        end
        end
    end
    --elector falls
    EOMLOG("Core event and plot check function checking elector fallen events.")
    for name, elector in pairs(self:electors()) do
        if elector:turns_dead() > 20 and elector:can_revive() == false and (not elector:is_cult()) then
            self:elector_fallen(name, true)
        end
    end
end



--v function(self: EOM_MODEL)
function eom_model.elector_diplomacy(self)
    local suffix_list = {"_critical", "_good", "_indifferent", "_low", "_loyal", "_very_good", "_very_low"} --:vector<string>
    EOMLOG("entered", "function eom_model.elector_diplomacy(self)");
    local loyalty_level = "_loyal"
    for key, current_elector in pairs(self:electors()) do
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

        if not cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION):has_effect_bundle("eom_"..current_elector:name()..loyalty_level) then
            EOMLOG("The bundle does not currently match for ["..current_elector:name().."]")
            for i = 1, #suffix_list do
                if cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION):has_effect_bundle("eom_"..current_elector:name()..suffix_list[i]) then
                    cm:remove_effect_bundle("eom_"..current_elector:name()..suffix_list[i], EOM_GLOBAL_EMPIRE_FACTION)
                    break
                end
            end
            EOMLOG("Set the diplomacy effect bundle to [eom_"..current_elector:name()..loyalty_level.."] for elector ["..current_elector:name().."]")
            cm:apply_effect_bundle("eom_"..current_elector:name()..loyalty_level, EOM_GLOBAL_EMPIRE_FACTION, 0)
        end
    end
end

--v function(self: EOM_MODEL)
function eom_model.elector_personalities(self)
    EOMLOG("Entered", "eom_model.elector_personalities(self)")
    for name, elector in pairs(self:electors()) do
        if elector:status() == "normal" then
            cm:force_change_cai_faction_personality(name, "eom_normal_elector")
        elseif elector:status() == "civil_war_enemy" or elector:status() == "open_rebellion" then
            cm:force_change_cai_faction_personality(name, "eom_disloyal_elector")
        elseif elector:status() == "civil_war_emperor" then
            cm:force_change_cai_faction_personality(name, "eom_pretender")
        end
    end
end

--v function (name:ELECTOR_NAME)
local function remove_taxation_bundles(name)
    
    local empire = cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION)
    for i = 1, 4 do 
        if empire:has_effect_bundle("eom_"..name.."_taxation_"..i) then
            cm:remove_effect_bundle(tostring("eom_"..name.."_taxation_"..i), EOM_GLOBAL_EMPIRE_FACTION)
        end
    end
    EOMLOG("Removing all tax bundles for ["..name.."] ")
end


--v function(self: EOM_MODEL)
function eom_model.elector_taxation(self)
    EOMLOG("Entered", "eom_model.elector_taxation(self)")
    local empire = cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION)
    for name, elector in pairs(self:electors()) do
        if (not elector:is_cult()) and self:is_elector_valid_for_taxes(name) then
            if elector:loyalty() <= 25 then
                if not empire:has_effect_bundle("eom_"..name.."_taxation_1") then
                    remove_taxation_bundles(name)
                    cm:apply_effect_bundle("eom_"..name.."_taxation_1", EOM_GLOBAL_EMPIRE_FACTION, 0)
                    EOMLOG("Assigning tax level 1 to ["..name.."] ")
                end
            elseif elector:loyalty() > 25 and elector:loyalty() <= 50 then
                if not empire:has_effect_bundle("eom_"..name.."_taxation_2") then
                    remove_taxation_bundles(name)
                    cm:apply_effect_bundle("eom_"..name.."_taxation_2", EOM_GLOBAL_EMPIRE_FACTION, 0)
                    EOMLOG("Assigning tax level 2 to ["..name.."] ")
                end
            elseif elector:loyalty() > 50 and elector:loyalty() <= 75 then
                if not empire:has_effect_bundle("eom_"..name.."_taxation_3") then
                    remove_taxation_bundles(name)
                    cm:apply_effect_bundle("eom_"..name.."_taxation_3", EOM_GLOBAL_EMPIRE_FACTION, 0)
                    EOMLOG("Assigning tax level 3 to ["..name.."] ")
                end
            else
                if not empire:has_effect_bundle("eom_"..name.."_taxation_4") then
                    remove_taxation_bundles(name)
                    cm:apply_effect_bundle("eom_"..name.."_taxation_4", EOM_GLOBAL_EMPIRE_FACTION, 0)
                    EOMLOG("Assigning tax level 4 to ["..name.."] ")
                end
            end
        elseif (not elector:is_cult()) then
            remove_taxation_bundles(name)
        end
    end
end





--saving
--v function(self: EOM_MODEL) --> EOM_MODEL_SAVETABLE
function eom_model.save(self)
    EOMLOG("entered", "eom_model.save(self)")
    local savetable = {} 
    --electors
    savetable._electors = {}--:map<string, ELECTOR_INFO>
    for k, v in pairs(self:electors()) do
        local info = v:save()
        savetable._electors[k] = info
        EOMLOG("saved Elector ["..k.."] with loyalty ["..tostring(v:loyalty()).."], status ["..v:status().."], UI visibility: ["..tostring(v:is_hidden()).."] and capitulation flag ["..tostring(v:will_capitulate()).."] ")
    end
    --core data
    savetable._coredata = self:coredata()
    EOMLOG("Core data saved!")

    for k, v in pairs(self:get_story()) do
        v:save()
    end

    return savetable
end

--loading
--v function(self: EOM_MODEL, savetable: EOM_MODEL_SAVETABLE)
function eom_model.load(self, savetable)
    EOMLOG("entered", "eom_model.load(self, savetable)")

    --electors
    for k, v in pairs(savetable._electors) do
        self:add_elector(v)
        EOMLOG("Loaded Elector ["..k.."]")
    end
    --coredata
    self._coredata = savetable._coredata
    EOMLOG("Loaded core data!")
end

--ui
--v function(self: EOM_MODEL, view: EOM_VIEW)
function eom_model.add_view(self, view)
    EOMLOG("initializing the view", "eom_model.add_view(self, view)")
    self._view = view
end

--v function(self: EOM_MODEL) --> EOM_VIEW
function eom_model.view(self)
    return self._view
end



-- ui view

local eom_view = {} --# assume eom_view: EOM_VIEW

--controller functions
--# assume EOM_VIEW.docker_button_pressed: method()
--# assume EOM_VIEW.close_politics: method()



--v function() --> EOM_VIEW
function eom_view.new()
    local self = {}
    setmetatable(self, {
        __index = eom_view
    })
    --# assume self: EOM_VIEW
    self.game_model = nil --:EOM_MODEL
    self.button = nil --:BUTTON
    self.button_name = "PoliticsButton"
    self.button_parent = nil --:CA_UIC
    self.frame = nil --:FRAME
    self.frame_name = "PoliticsFrame"
    self.list_electors = nil --:LIST_VIEW
    self.list_name_electors = "ElectorsListView"

    return self

end

--v function(self: EOM_VIEW, model: EOM_MODEL)
function eom_view.add_model(self, model)
    self.game_model = model
end




--v function(self: EOM_VIEW)
function eom_view.set_button_parent(self)
    local component = find_uicomponent(core:get_ui_root(), "button_group_management")
    if not not component then
        EOMLOG("Set the button parent", "eom_view.set_button_parent(self)")
        self.button_parent = component
    else
        EOMLOG("ERROR?: Failed to set the button component!", "eom_view.set_button_parent(self)")
    end
end

--# assume EOM_CONTROLLER.docker_button_pressed: method()
--v function(self: EOM_VIEW) --> BUTTON
function eom_view.get_button(self)

    if self.button_parent == nil then
        EOMLOG("ERROR: get button called but the button parent is not set!", "eom_view.get_button(self)")
        return nil
    end

    local existingButton = Util.getComponentWithName(self.button_name)
    if not not existingButton then
        --# assume existingButton: BUTTON
        self.button = existingButton
        return self.button
    else
        local PoliticsButton = Button.new(self.button_name, self.button_parent, "CIRCULAR", "ui/skins/default/icon_capture_point.png")
        PoliticsButton:RegisterForClick(function(context) self:docker_button_pressed() end);
        PoliticsButton:Resize(69, 69)
        return PoliticsButton
    end  

end

--you can find the button and set it visible using the component command but this provides a shorthand method

--v function(self: EOM_VIEW, visible: boolean)
function eom_view.set_button_visible(self, visible)
    self.get_button(self)
    self.button:SetVisible(visible)
end


--FRAME


--v function(self: EOM_VIEW) --> FRAME
function eom_view.get_frame(self)

    EOMLOG("Getting the politics frame!", "eom_view.get_frame(self)")
    local existingFrame = Util.getComponentWithName(self.frame_name)
    if not not existingFrame then
        --# assume existingFrame: FRAME
        existingFrame:SetVisible(true)
        self.frame = existingFrame
        return existingFrame
    else
        PoliticsFrame = Frame.new(self.frame_name)
        PoliticsFrame:Scale(1.70)
        Util.centreComponentOnScreen(PoliticsFrame)
        self.frame = PoliticsFrame
        PoliticsFrame:SetTitle("Imperial Politics")
        local parchment = PoliticsFrame:GetContentPanel()
       -- parchment:SetImage("ui/skins/default/politics_panel.png")
        local parchmentX, parchmentY = parchment:Bounds()
       -- local background = Image.new("PoliticsBackground", parchment, "ui/skins/default/panel_leather_frame_red.png")
       -- background:Resize(parchmentX, parchmentY)
        return PoliticsFrame
    end
end

--v function(self: EOM_VIEW)
function eom_view.hide_frame(self)
    self.frame:SetVisible(false)
end

--v function(self: EOM_VIEW)
function eom_view.frame_buttons(self)
    if self.frame == nil then
        EOMLOG("ERROR: frame buttons called but the button parent is not set!", "eom_view.frame_buttons(self)")
        return
    end
    local existingCloseButton = Util.getComponentWithName(self.frame_name.."close")
    if not not existingCloseButton then
        --# assume existingCloseButton: BUTTON
        existingCloseButton:SetVisible(true)
    else
    local CloseButton = Button.new(self.frame_name.."close", self.frame, "CIRCULAR", "ui/skins/default/icon_check.png");
    local frameWidth, frameHeight = self.frame:Bounds()
    local buttonWidth, buttonHeight = CloseButton:Bounds()
    CloseButton:PositionRelativeTo(self.frame, (frameWidth/2) - (buttonWidth/2), frameHeight - (buttonHeight*2) )
    CloseButton:RegisterForClick(function(context) self:close_politics() end)
    end

end


--v function(self: EOM_VIEW)
function eom_view.populate_frame(self)

    local existingView = Util.getComponentWithName(self.list_name_electors)
    if not existingView then
        local frameContainer = Container.new(FlowLayout.VERTICAL)
        local fX, fY = self.frame:Bounds()
        local cultTitleContainer = Container.new(FlowLayout.HORIZONTAL)
        
        local cultsTitle = Image.new(self.list_name_electors.."_title", self.frame, "ui/custom/cults_banner.png")
        cultsTitle:Resize(fX*(1/3), fX*(1/3)/3.34)
        local ctX, ctY = cultsTitle:Bounds()
        cultTitleContainer:AddGap(fX/2 - ctX)
        cultTitleContainer:AddComponent(cultsTitle)
        frameContainer:AddComponent(cultTitleContainer)
       -- local firstDivider = Image.new(self.list_name_electors.."divider", self.frame, "ui/skins/default/candidate_divider.png")
       -- firstDivider:Resize(fX*(2/3), 3)
      --  frameContainer:AddComponent(firstDivider)
        local cultContainer = Container.new(FlowLayout.HORIZONTAL)
        cultContainer:AddGap(fX/2 - 352)

        for k, v in pairs(self.game_model:electors()) do
            if v:is_cult() and (not v:is_hidden()) then
                local currentContainer = Container.new(FlowLayout.VERTICAL)
                local cultButton = Button.new(k.."cult_button", self.frame, "SQUARE", v:image())
                cultButton:Scale(1.75)
                local dy_loyalty = Text.new(k.."_dy_loyalty", self.frame, "TITLE", "[[col:dark_g]]"..tostring(v:loyalty()).."[[/col]]")
                local bX, bY = cultButton:Bounds()
                local tX, tY = dy_loyalty:Bounds()
                dy_loyalty:Resize(bX, tY)
                currentContainer:AddComponent(cultButton)
                currentContainer:AddComponent(dy_loyalty)
                cultContainer:AddGap(5)
                cultContainer:AddComponent(currentContainer)
            end
        end
        frameContainer:AddComponent(cultContainer)
       -- local SecondDivider = Image.new(self.list_name_electors.."divider2", self.frame, "ui/skins/default/candidate_divider.png")
        --SecondDivider:Resize(fX*(2/3), 3)
        --frameContainer:AddComponent(SecondDivider)
        local electorTitleContainer = Container.new(FlowLayout.HORIZONTAL)
        electorTitleContainer:AddGap(fX/2 - ctX)
        local electorTitle = Image.new(self.list_name_electors.."_title2", self.frame, "ui/custom/electorcounts_banner.png")
        electorTitle:Resize(fX*(1/3), fX*(1/3)/3.67)
        electorTitleContainer:AddComponent(electorTitle)
        frameContainer:AddComponent(electorTitleContainer)
        local electorListView = ListView.new(self.list_name_electors, self.frame, "HORIZONTAL")
        electorListView:Resize(fX*(2/3), fY/4)
        local electorContainer = Container.new(FlowLayout.HORIZONTAL)
        electorContainer:AddGap(10)
        electorListView:AddComponent(electorContainer)
        for k, v in pairs(self.game_model:electors()) do
            if (not v:is_hidden()) and (not v:is_cult()) then
                local currentContainer = Container.new(FlowLayout.VERTICAL)
                local electorButton = Button.new(k.."elector_button", self.frame, "SQUARE", v:image())
                electorButton:Scale(1.75)
                local dy_loyalty = Text.new(k.."_dy_loyalty", self.frame, "TITLE", "[[col:dark_g]]"..tostring(v:loyalty()).."[[/col]]")
                if v:status() == "seceded" then 
                    dy_loyalty:SetText("[[col:red]]Seceded[[/col]]")
                end
                local bX, bY = electorButton:Bounds()
                local tX, tY = dy_loyalty:Bounds()
                dy_loyalty:Resize(bX, tY)
                currentContainer:AddComponent(electorButton)
                currentContainer:AddComponent(dy_loyalty)
                electorListView:AddComponent(currentContainer)
            end
        end
        frameContainer:AddComponent(electorListView)
        Util.centreComponentOnComponent(frameContainer, self.frame)
        local fcX, fcY = frameContainer:Position()
        frameContainer:MoveTo(fcX, fcY - 15)

    else
        for k, v in pairs(self.game_model:electors()) do
            local dy_loyalty = Util.getComponentWithName(k.."_dy_loyalty")
            --# assume dy_loyalty: TEXT
            dy_loyalty:SetText("[[col:dark_g]]"..tostring(v:loyalty()).."[[/col]]")
            if v:status() == "seceded" then 
                dy_loyalty:SetText("[[col:red]]Seceded[[/col]]")
            end
        end
        EOMLOG("Updated Loyalties", "UI")
    end
    EOMLOG("Populate frame completed with no errors")
end

--controller methods (assumed)


--v function(self: EOM_VIEW)
function eom_view.close_politics(self)
    EOMLOG("Close button pressed on politics panel", "eom_controller.close_politics(self)")
    self:hide_frame()
    local layout = find_uicomponent(core:get_ui_root(), "layout")
    if not not layout then
        layout:SetVisible(true)
        EOMLOG("Showing the layout!")
    else
        EOMLOG("Could not find the layout?!?")
    end
    local settlement = find_uicomponent(core:get_ui_root(), "settlement_panel")
    if not not settlement then
     settlement:SetVisible(true)
    end
    local character = find_uicomponent(core:get_ui_root(), "units_panel")
    if not not character then
        character:SetVisible(true)
    end
end


--v function(self: EOM_VIEW)
function eom_view.docker_button_pressed(self)
    EOMLOG("Docker Button Pressed", "eom_controller.docker_button_pressed(self)")
    self:get_frame()
    self:frame_buttons()
    local ok, err = pcall( function() self:populate_frame() end)
    if not ok then
        --# assume err: string
        EOM_ERROR(err)
    end
    local layout = find_uicomponent(core:get_ui_root(), "layout")
    if not not layout then
        layout:SetVisible(false)
    end
    local settlement = find_uicomponent(core:get_ui_root(), "settlement_panel")
    if not not settlement then
        EOMLOG("Setting Settlements Panel Invisible")
     settlement:SetVisible(false)
    end
    local character = find_uicomponent(core:get_ui_root(), "units_panel")
    if not not character then
        EOMLOG("Setting Character Panel Invisible")
        character:SetVisible(false)
    end
end



--CORE
eom = eom_model.init()
_G.eom = eom
--link the model to the view and vice versa
core:add_ui_created_callback(function()
    eom:add_view(eom_view.new())
    eom:view():add_model(eom)
    eom:view():set_button_parent()
    local button = eom:view():get_button()
    button:SetVisible(true)
end);

cm:add_saving_game_callback(
    function(context)
        local eom = _G.eom
        local save_table = eom:save()
        cm:save_named_value("eom_core", save_table, context)
    end
)

cm:add_loading_game_callback(
    function(context)
        local eom = _G.eom
        local savetable = cm:load_named_value("eom_core", {}, context)
        if cm:is_new_game() then
            local electors_to_load = return_elector_starts()
            for i = 1, #electors_to_load do
                local elector_to_load = electors_to_load[i]()
                eom:add_elector(elector_to_load)
            end
            local core_data_to_load = return_starting_core_data()
            for key, data in pairs(core_data_to_load) do
                eom:set_core_data(key, data)
            end
            --randomize which plot events happen when
        else
            eom:load(savetable)
        end
    end
)


