local eom_civil_war = {} --# assume eom_civil_war: EOM_CIVIL_WAR 
EOMLOG("Loading object eom_civil_war", "file.eom_civil_war")


--v function(info: map<string, WHATEVER>) --> EOM_CIVIL_WAR
function eom_civil_war.new(info)
local self = {}
setmetatable(self, {
    __index = eom_civil_war
})
--# assume self: EOM_CIVIL_WAR

self.eom = nil --:EOM_MODEL
self.start_condition = info.start_condition --: function(eom: EOM_MODEL) --> boolean
self.listeners = info.listeners --: function(self: EOM_CIVIL_WAR)
self.win_conditions = info.win_conditions --:map<string, boolean>
self.start_callback = info.start_callback --: function(eom: EOM_MODEL)
self.end_condition = info.end_condition --:function(self: EOM_CIVIL_WAR, eom: EOM_MODEL) --> boolean
self.end_callback = info.end_callback --:function(eom: EOM_MODEL)


return self

end



return {
    new = eom_civil_war.new
}