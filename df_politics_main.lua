
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

--add eom to the gamespace.
_G.eom_model = eom_model

EOMLOG("Init Complete", "file.df_politics_main")


--main function, called by CMF
function df_politics_main()
  EOMLOG("df_politics_called and starting", "function.df_politics_main()")



  EOMLOG("main function finished", "function.df_politics_main()")
end