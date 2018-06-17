EOM_SHOULD_LOG = true --:boolean
EOM_LAST_CONTEXT = "no context set" --:string

--v function(text: string, ftext: string?)
function EOMLOG(text, ftext)
    

    if not EOM_SHOULD_LOG then
        return; --if our bool isn't set true, we don't want to spam the end user with logs. 
    end
    if not ftext then
        ftext = "no context set"
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
}--:map<EMPIRE_REGION, number>



--v function() --> ELECTOR_INFO
function averland_start_pos()
    local sp = {}
    sp._loyalty = 50 --:number
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

    sp._expeditionRegion = "wh_main_middenland_middenheim"
    sp._turnsDead = 0 --:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_reikland_grunburg"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_middenland_carroburg"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_middenland_middenheim"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_hochland_hergig"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_reikland_grunburg"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_reikland_grunburg"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_reikland_eilhart"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_eastern_sylvania_waldenhof"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 2--:number
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

    sp._expeditionRegion = "wh_main_eastern_sylvania_waldenhof"
    sp._turnsDead = 0--:number
    sp._isCult = false;
    sp._baseRegions = 6--:number
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

    sp._expeditionRegion = "wh_main_stirland_wurtbad"
    sp._turnsDead = 0--:number
    sp._isCult = true;
    sp._baseRegions = 0--:number
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
    return sp
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

local eom_action = {} --# assume eom_action: EOM_ACTION

--v function(key: string, conditional: function() --> boolean, choices: map<number, function()>) --> EOM_ACTION
function eom_action.new(key, conditional, choices)
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

    return self
end


--v function(self: EOM_ACTION) --> string
function eom_action.key(self)
    return self._key
end

--v function(self: EOM_ACTION) --> boolean
function eom_action.allowed(self)
    return self._condition()
end

--v function(self: EOM_ACTION, choice: number)
function eom_action.do_choice(self, choice)
    self._choices[choice]()
end

--v function(self: EOM_ACTION) --> boolean
function eom_action.already_occured(self)
    return self._alreadyOccured
end

--v function(self: EOM_ACTION)
function eom_action.act(self)
    cm:trigger_dilemma(EOM_GLOBAL_EMPIRE_FACTION, self:key(), true)
    cm:set_saved_value("eom_action_"..self:key().."_occured", true)
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
    --ui
    self._hideFromUi = info._hideFromUi
    self._image = info._image
    self._uiName = info._uiName
    self._uiTooltip = info._uiTooltip
    self._isCult = info._isCult
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
    return savetable
end


--keys

--v function(self: EOM_ELECTOR) --> string
function eom_elector.name(self)
    return self._key
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
    if not self:status() == "normal" then
        EOMLOG("Not applying any loyalty change to ["..self:name().."] because the elector has a non-normal status!")
        return
    end
    local ov = self._loyalty;
    local nv = ov + changevalue;
    if nv > 100 then nv = 100 end;
    if nv < 0 then nv = 0 end;
    self._loyalty = nv;
    EOMLOG("changed loyalty for ["..self:name().."] by ["..tostring(changevalue).."] to ["..self:loyalty().."] ")
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


--revival system

--v function(self: EOM_ELECTOR) --> number
function eom_elector.turns_dead(self)
    return self._turnsDead
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

    self._electors = {} --:map<string, EOM_ELECTOR>
    self._civil_war = nil --:EOM_CIVIL_WAR
    self._events = {} --:vector<EOM_ACTION>
    self._civil_war_index = {} --:vector<EOM_CIVIL_WAR>

    self._coredata = {} --:map<string, EOM_CORE_DATA>
    self._view = nil --:EOM_VIEW
    return self
end

--core data
--v function(self: EOM_MODEL) --> map<string, EOM_CORE_DATA>
function eom_model.coredata(self)
    return self._coredata
end

--v function(self: EOM_MODEL, key: string) --> EOM_CORE_DATA
function eom_model.get_core_data_with_key(self, key)
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
--v function(self: EOM_MODEL) --> map<string, EOM_ELECTOR>
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




--v function(self: EOM_MODEL, info: ELECTOR_INFO)
function eom_model.add_elector(self, info)
    EOMLOG("entered", "eom_model.add_elector(self, info)")
    local elector = eom_elector.new(info)
    self._electors[elector:name()] = elector
    EOMLOG("Added elector ["..elector:name().."] to the model!")
end



---EBS

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
            EOMLOG("The bundle does not currently match!")
            for i = 1, #suffix_list do
                if cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION):has_effect_bundle("eom_"..current_elector:name()..suffix_list[i]) then
                    cm:remove_effect_bundle("eom_"..current_elector:name()..suffix_list[i], EOM_GLOBAL_EMPIRE_FACTION)
                    break
                end
            end
            cm:apply_effect_bundle("eom_"..current_elector:name()..loyalty_level, EOM_GLOBAL_EMPIRE_FACTION, 0)
        end
    end
end










--saving
--v function(self: EOM_MODEL) --> EOM_MODEL_SAVETABLE
function eom_model.save(self)
    EOMLOG("entered", "eom_model.save(self)")
    local savetable = {} 

    savetable._electors = {}--:map<string, ELECTOR_INFO>
    for k, v in pairs(self:electors()) do
        local info = v:save()
        savetable._electors[k] = info
        EOMLOG("saved Elector ["..k.."]")
    end

    savetable._coredata = self:coredata()
    EOMLOG("Core data saved!")
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
    end
end

--controller methods (assumed)


--v function(self: EOM_VIEW)
function eom_view.close_politics(self)
    EOMLOG("Close button pressed on politics panel", "eom_controller.close_politics(self)")
    self:hide_frame()
    local layout = find_uicomponent(core:get_ui_root(), "layout")
    layout:SetVisible(true)
    local settlement = find_uicomponent(core:get_ui_root(), "settlement_panel")
    if settlement then
     settlement:SetVisible(true)
    end
    local character = find_uicomponent(core:get_ui_root(), "units_panel")
    if character then
        character:SetVisible(true)
    end
end


--v function(self: EOM_VIEW)
function eom_view.docker_button_pressed(self)
    EOMLOG("Docker Button Pressed", "eom_controller.docker_button_pressed(self)")
    self:get_frame()
    self:frame_buttons()
    self:populate_frame()
    local layout = find_uicomponent(core:get_ui_root(), "layout")
    layout:SetVisible(false)
    local settlement = find_uicomponent(core:get_ui_root(), "settlement_panel")
    if settlement then
        EOMLOG("Setting Settlements Panel Invisible")
     settlement:SetVisible(false)
    end
    local character = find_uicomponent(core:get_ui_root(), "units_panel")
    if character then
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
        else
            eom:load(savetable)
        end
    end
)



















--event triggers;


core:add_listener(
    "EOMBattlesCompleted",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character() --:CA_CHAR
        return character:faction():name() == EOM_GLOBAL_EMPIRE_FACTION 
    end,
    function(context)
        local character = context:character() --:CA_CHAR
        local enemies = cm:pending_battle_cache_get_enemies_of_char(character)
        for i = 1, #enemies do
            local enemy = enemies[i]
            local enemy_sub = enemy:faction():subculture()
            if character:won_battle() then 
                EOMLOG("Triggering event VictoryAgainstSubcultureKey_"..enemy_sub, "EOMBattlesCompleted")
                core:trigger_event("VictoryAgainstSubcultureKey_"..enemy_sub)
            else
                core:trigger_event("DefeatAgainstSubcultureKey_"..enemy_sub)
                EOMLOG("Triggering event DeafeatAgainstSubcultureKey_"..enemy_sub, "EOMBattlesCompleted")
            end
        end
    end, 
    true)



