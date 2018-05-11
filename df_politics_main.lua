
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
  popLog :write("df_politics_main:  "..logText .. "    : [" .. logContext .. "] : [".. logTimeStamp .. "]\n")
  popLog :flush()
  popLog :close()
end

--v function()
function REFRESHLOG()
  if not isLogAllowed then
    return;
  end

  local logTimeStamp = os.date("%d, %m %Y %X")
  --# assume logTimeStamp: string

  local popLog = io.open("EOMLOG.txt","w+")
  popLog :write("NEW LOG ["..logTimeStamp.."] \n")
  popLog :flush()
  popLog :close()
end



EOMLOG("Init Starting", "file.df_politics_main")

--require the objects and the model
eom_elector = require("eom/eom_elector")
eom_cult = require("eom/eom_cult")
eom_civil_war = require("eom/eom_civil_war")
eom_action = require("eom/eom_action")
eom_trait = require("eom/eom_trait")
eom_model = require("eom/eom_model")

require("eom/eom_startpos")
--add eom to the gamespace.
_G.eom_model = eom_model

--create the model
eom = eom_model.new()
_G.eom = eom

cm:add_loading_game_callback(
  function(context)
  eom_save_table = cm:load_named_value("eom_save_table", {}, context)

  end
)

cm:add_saving_game_callback(
  function(context)
    local eom_new_save = eom:save()
    cm:save_named_value("eom_save_table", eom_new_save, context)
  end
)







EOMLOG("Init Complete", "file.df_politics_main")



--main function, called by CMF
--v function()
function df_politics_main()
  EOMLOG("df_politics_main called and starting", "function.df_politics_main()")
  
  if get_faction("wh_main_emp_empire"):is_human() then
    if cm:is_new_game() then
      REFRESHLOG()
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
        local cults = return_cult_starts()
        for i = 1, #cults do
          local current_function = cults[i];
          local current_table = current_function()
          local cult = eom_cult.new(current_table)
          eom:add_cult(current_table.faction_name, cult)
        end
    else
      EOMLOG("Loading an existing game back into the model", "function.df_politics_main()")
      if eom_save_table == {} then
        EOMLOG("ERROR: We tried to load the game but the save table was missing! something has gone terribly wrong", "function.df_politics_main()")
        else
          for i = 1, #eom_save_table.electors do
            local info = eom_save_table.electors[i]
            local elector = eom_elector.new(info)
            eom:add_elector(info.faction_name, elector)
          end
          for i = 1, #eom_save_table.cults do
            local info = eom_save_table.cults[i]
            local cult = eom_cult.new(info)
            eom:add_cult(info.faction_name, cult)
          end
          for key, value in pairs (eom_save_table.core_data) do
            eom:add_core_data(key, value)
          end
        end
    end
  end
  


  EOMLOG("main function finished", "function.df_politics_main()")
end