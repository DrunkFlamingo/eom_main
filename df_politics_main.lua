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
