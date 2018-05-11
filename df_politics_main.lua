
--[[
dev notes:

trying to add two electors of the same faction name causes a crash




]]--


--cmf registry
cm:set_saved_value("df_politics_main", true)

--toggle this to turn logging on or off.
isLogAllowed = true --:boolean

--allows for the logging of the model to a seperate file.
--v function(text: string, ftext: string)
function EOMLOG(text, ftext)

    if not isLogAllowed then
      return;
    end

  local logText = tostring(text)
  local logContext = tostring(ftext)
  local logTimeStamp = os.date("%d, %m %Y %X")
  local popLog = io.open("EOMLOG.txt","a")
  --# assume logTimeStamp: string
  popLog :write("EOM_MAIN:  "..logText .. "    : [" .. logContext .. "] : [".. logTimeStamp .. "]\n")
  popLog :flush()
  popLog :close()
end



EOMLOG("Init Starting", "file.df_politics_main")

--require the objects and the model
eom_elector = require("eom/eom_elector")
eom_cult = require("eom/eom_cult")
eom_civil_war = require("eom/eom_civil_war")
eom_action = require("eom/eom_action")
eom_model = require("eom/eom_model")
require("eom/eom_startpos")
--add eom to the gamespace.
_G.eom_model = eom_model

EOMLOG("Init Complete", "file.df_politics_main")



--main function, called by CMF
function df_politics_main()
  EOMLOG("df_politics_called and starting", "function.df_politics_main()")
  
  --create the model
  eom = eom_model.new()

  if get_faction("wh_main_emp_empire"):is_human() then
    if cm:is_new_game() then
      EOMLOG("ITS A NEW GAME! RUNNING START POSITION", "function.df_politics_main()")
        --run the start pos
        eom_start_pos("wh_main_emp_empire")
        --add the core data to the model
        eom_core_data_start_pos(eom)
        --add the electors to the system
        local electors = return_elector_starts()
        for i = 1, #electors do
          local current_function = electors[i]
          local current_table = current_function()
          local elector = eom_elector.new(current_table)
          eom:add_elector(current_table.faction_name, elector)
        end
        --add the cults to the system
        EOMLOG("about to ask for the cult callbacks", "test")
        local cults = return_cult_starts()
        EOMLOG("successfully got the cult list", "test")
        for i = 1, #cults do
          EOMLOG("successfully started the loop", "test")
          local current_function = cults[i];
          local current_table = current_function()
          EOMLOG("successfully defined the table", "test")
          local cult = eom_cult.new(current_table)
          eom:add_cult(current_table.faction_name, cult)
        end
    else
      EOMLOG("Loading an existing game back into the model", "function.df_politics_main()")
    end
  end
  


  EOMLOG("main function finished", "function.df_politics_main()")
end