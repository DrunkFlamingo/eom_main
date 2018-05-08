


isLogAllowed = true --:boolean
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
  popLog :write(logText .. " : " .. logContext .. " : ".. logTimeStamp .. "\n")
  popLog :flush()
  popLog :close()
end


local eom = require("eom/eom_model")

EOMLOG("Init Complete", "file.df_politics_main")

function df_politics_main()
EOMLOG("df_politics_called and starting", "function.df_politics_main()")



EOMLOG("main function finished", "function.df_politics_main()")
end