EOM_SHOULD_LOG = true --:boolean
EOM_LAST_CONTEXT = "no context set" --:string
EOM_LOG_TURN = "Preload" --:string

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
    popLog :write("WEC:  "..logText .. "    : CONTEXT: [" .. logContext .. "] TIMESTAMP : [".. logTimeStamp .. "] TURN : ["..EOM_LOG_TURN.."] \n")
    popLog :flush()
    popLog :close()
end

function EOMNEWLOG()
    if EOM_SHOULD_LOG == false then
        return;
    end
    if cm:get_saved_value("EOMLOG") == true then
        return;
    end
    cm:set_saved_value("EOMLOG", true)

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








local eom = require("eom/eom_model")
